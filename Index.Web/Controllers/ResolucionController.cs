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
    public class ResolucionController : Controller
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
                TempData["ERRORMESSAGE"] = "Su usuario o cuenta con clientes asignados. Comuniquese con el administrador del sistema para solicitar los mismos.";
                return RedirectToAction("Index", "Error");
            }
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Resolucion/Listar", "IdResolution=null&IdCustomer=" + CustomerInfo.Id
                                                                        + "&IdAccount=" + AccountInfo.Id)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<Resolution>>().ToDataSourceResult(request));
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
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Resolution model, FormCollection frmcol)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            model.IdCustomer = CustomerInfo.Id;
            model.IdAccount = AccountInfo.Id;
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;

            if (String.IsNullOrEmpty(frmcol["RateDate"].ToString()) || String.IsNullOrWhiteSpace(frmcol["RateDate"].ToString()))
            {
                ModelState.AddModelError("RateDate", "Formato de fecha incorrecta");
            }
            else
            {
                model.RateDate = Convert.ToDateTime(frmcol["RateDate"].ToString().Substring(0, 10));
                ModelState.Clear();
            }
            
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Resolucion/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Resolution model, FormCollection frmcol)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            model.IdCustomer = CustomerInfo.Id;
            model.IdAccount = AccountInfo.Id;
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;

            if (String.IsNullOrEmpty(frmcol["RateDate"].ToString()) || String.IsNullOrWhiteSpace(frmcol["RateDate"].ToString()))
            {
                ModelState.AddModelError("RateDate", "Formato de fecha incorrecta");
            }
            else
            {
                model.RateDate = Convert.ToDateTime(frmcol["RateDate"].ToString().Substring(0, 10));
                ModelState.Clear();
            }

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Resolucion/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Resolution model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Resolucion/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult asignarPartidas(Int32 IdResolution)
        {
            ViewBag.IdResolution = IdResolution;
            //IRestResponse WSR = Task.Run(() => apiClient.getJArray("Partida/Arbol", "IdResolution=" + IdResolution)).Result;
            //if (WSR.StatusCode == HttpStatusCode.OK)
            //{
            //    List<AccountingItemTree> data = JArray.Parse(WSR.Content).ToObject<List<AccountingItemTree>>();
            //    ViewBag.data = data;
            //    ViewBag.JsonData = Newtonsoft.Json.JsonConvert.SerializeObject(data);
            //    ViewBag.idresolution = IdResolution;
            //}

            return View();
        }

        public JsonResult GetAccountingItemTreeJson(Int32 IdResolution)
        {
            List<AccountingItemTree> data = new List<AccountingItemTree>();

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Partida/Arbol", "IdResolution=" + IdResolution)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<AccountingItemTree>>();
            }

            //return Json(data, JsonRequestBehavior.AllowGet);
            return new JsonResult() { Data = data, MaxJsonLength = Int32.MaxValue, JsonRequestBehavior = JsonRequestBehavior.AllowGet };
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Assign([DataSourceRequest] DataSourceRequest request, AccountingItemAssignment model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Partida/Asignar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UnAssign([DataSourceRequest] DataSourceRequest request, AccountingItemAssignment model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Partida/Desasignar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo()
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Resolucion/Listar", "IdResolution=null&IdCustomer=" + CustomerInfo.Id
                                                                        + "&IdAccount=" + AccountInfo.Id)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<Resolution>>().Select(x => new { Id = x.Id,
                        Name = (x.Description == null) ? x.Name : ((x.Description == "") ? x.Name : x.Name + " - " + x.Description)
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
    }
}