using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using Index.Commons;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using RestSharp;
using System.Net;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class MateriaPrimaController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];

            if (CustomerInfo != null)
            {
                return View();
            }
            else
            {
                TempData["ERRORMESSAGE"] = "Su usuario no cuenta con clientes asignados. Comuniquese con el administrador del sistema para solicitar los mismos.";
                return RedirectToAction("Index", "Error");
            }
        }

        public ActionResult Template(Int32 IdRawMaterial)
        {
            Item model = new Item();
            if (IdRawMaterial != 0)
            {
                model = GetItem(IdRawMaterial);
            }
            else {
                model.Active = true;
                model.Id = 0;
            }

            return View(model);
        }

        [HttpPost]
        public ActionResult Template(Item model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR;
                Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
                Account Cuenta = (Account)Session["ACCOUNTINFO"];
                model.IdCustomer = CustomerInfo.Id;
                model.IdAccount = Cuenta.Id;
                model.IsProduct = false;
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;

                if (model.Id == 0)
                {
                    WSR = Task.Run(() => apiClient.postObject("MateriaPrima/Nuevo", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
                else
                {
                    model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                    WSR = Task.Run(() => apiClient.postObject("MateriaPrima/Modificar", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }

                if (ModelState.IsValid)
                {
                    ViewBag.Success = true;
                    if (model.Id == 0)
                    {
                        ViewBag.IsNew = true;
                    }
                    else
                    {
                        ViewBag.IsNew = false;
                    }
                }
            }

            return View(model);
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account Cuenta = (Account)Session["ACCOUNTINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Listar", "IdItem=null&IdCustomer=" + CustomerInfo.Id 
                                                                                            + "&IdAccount=" + Cuenta.Id)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<Item>>().ToDataSourceResult(request));
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Item model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("MateriaPrima/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo(String filter, Boolean? active)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account Cuenta = (Account)Session["ACCOUNTINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Listar", "IdItem=null&IdCustomer=" + CustomerInfo.Id
                                                                                            + "&IdAccount=" + Cuenta.Id)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    List<Item> dbData = JArray.Parse(WSR.Content).ToObject<List<Item>>(), data = new List<Item>();
                    if (!string.IsNullOrEmpty(filter))
                    {
                        List<Item> codeResult = new List<Item>(), accResult = new List<Item>(), descResult = new List<Item>();
                        codeResult = dbData.Where(x => x.Code == filter).ToList();
                        accResult = dbData.Where(x => x.AccountingItem == filter).ToList();
                        descResult = dbData.Where(x => x.Name.ToUpper().Contains(filter.ToUpper())).ToList();

                        data = data.Concat(codeResult).Concat(accResult).Concat(descResult).ToList();
                    }
                    else
                    {
                        data = dbData;
                    }

                    if (active == true)
                    {
                        data = data.Where(x => x.Active == true).ToList();
                    }

                    return Json(data.Select(x => new
                    {
                        Id = x.Id,
                        Name = x.DisplayProductName,
                        Parent = x.DisplayAccountingItemName
                    }).ToList(), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public JsonResult jsonSingle([DataSourceRequest] DataSourceRequest request)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account Cuenta = (Account)Session["ACCOUNTINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Listar", "IdItem=null&IdCustomer=" + CustomerInfo.Id
                                                                                            + "&IdAccount=" + Cuenta.Id)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<Item>>().ToDataSourceResult(request));
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public Item GetItem(Int32 IdItem)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account Cuenta = (Account)Session["ACCOUNTINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Listar", "IdItem=" + IdItem + "&IdCustomer=" + CustomerInfo.Id
                                                                                            + "&IdAccount=" + Cuenta.Id)).Result;
            Item data = new Item();
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Item>>().FirstOrDefault();
            }

            return data;
        }

        public JsonResult Existencia(Int32 IdItem)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Existencia", "IdItem=" + IdItem)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(Convert.ToDecimal(WSR.Content), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(0, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult Formula(Int32 IdItem)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("MateriaPrima/Formula", "IdItem=" + IdItem)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(WSR.Content, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(null, JsonRequestBehavior.AllowGet);
            }
        }
    }
}