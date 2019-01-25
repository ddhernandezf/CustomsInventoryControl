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
using System.Web;
using System.IO;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class ClienteController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Informacion(Int32? IdCustomer)
        {
            Customer model = new Customer();
            if (IdCustomer != null && IdCustomer != 0)
            {
                model = GetCustomer((Int32)IdCustomer);
            }

            return View(model);
        }
        
        [HttpPost]
        public ActionResult Informacion(Customer model)
        {
            if (!String.IsNullOrEmpty(model.Nit) && !String.IsNullOrWhiteSpace(model.Nit))
            {
                if (!Functionalities.General.Validate.Nit(model.Nit))
                {
                    ModelState.AddModelError("Nit", "NIT inválido.");
                }
            }

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR;
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                if (model.Id == 0)
                {
                    WSR = Task.Run(() => apiClient.postObject("Cliente/Nuevo", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
                else
                {
                    WSR = Task.Run(() => apiClient.postObject("Cliente/Modificar", model)).Result;
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
                        ViewBag.CallWizzard = true;
                    }
                    else
                    {
                        ViewBag.CallWizzard = false;
                    }
                }

                return View(model);
            }
            else
            {
                return View(model);
            }
        }

        public ActionResult InformacionCuenta(Int32 IdCustomer, Int32 IdAccount)
        {
            CustomerAccountData model = new CustomerAccountData();
            if (IdCustomer > 0 && IdAccount > 0)
            {
                model = GetCustomerAccountData(IdCustomer, IdAccount).FirstOrDefault();
            }

            return View(model);
        }

        [HttpPost]
        public ActionResult InformacionCuenta(CustomerAccountData model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Cuentas/ActualizarInformacion", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }

                if (ModelState.IsValid)
                {
                    ViewBag.Success = true;
                }

                return View(model);
            }
            else
            {
                return View(model);
            }
        }

        public ActionResult Router(Int32 IdCustomer, String Option)
        {
            TempData["IDCUSTOMER"] = IdCustomer;

            switch (Option)
            {
                case "NUEVO":
                    return RedirectToAction("Alta");
                case "MODIFICAR":
                    List<CustomerDischarged> data = new List<CustomerDischarged>();
                     
                    IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarAltas", "IdCustomer=" + IdCustomer)).Result;
                    if (WSR.StatusCode == HttpStatusCode.OK)
                    {
                        data = JArray.Parse(WSR.Content).ToObject<List<CustomerDischarged>>();
                    }
                    TempData["DISCHARGED"] = data.FirstOrDefault();

                    return RedirectToAction("ModificarAlta");
                case "ELIMINAR":
                    return RedirectToAction("EliminarAlta");
                default:
                    return RedirectToAction("Index");
            }
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar", "IdCustomer=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Customer>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Customer model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult ReadByDischarged([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarPorAltas", "IdCustomer=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Customer>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadByUser([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarPorUsuarios", "IdCustomer=null&UserName=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Customer>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadAccounts([DataSourceRequest] DataSourceRequest request)
        {
            Commons.User user = (Commons.User)Session["USERINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar/Cuentas", "UserName=" + user.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Account>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CreateAccount([DataSourceRequest] DataSourceRequest request, Commons.CustomerAccount model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Cuentas/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(true);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteAccount([DataSourceRequest] DataSourceRequest request, Commons.CustomerAccount model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Cuentas/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(true);
        }

        public ActionResult AsignarCuenta(Int32 IdCustomer)
        {
            ViewBag.idperson = IdCustomer;

            return View();
        }

        public ActionResult ReadAsignarCuenta([DataSourceRequest] DataSourceRequest request, Int32 IdCustomer)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar/CuentasAsignadas", "IdCustomer=" + IdCustomer)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<AccountToAssign>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult AsignarTelefono(Int32 IdPerson)
        {
            ViewBag.IdPerson = IdPerson;
            Session["IdPerson"] = IdPerson;
            return View();
        }

        public ActionResult AsignarEmail(Int32 IdPerson)
        {
            ViewBag.IdPerson = IdPerson;
            Session["IdPerson"] = IdPerson;
            return View();
        }

        public ActionResult AsignarDireccion(Int32 IdPerson)
        {
            ViewBag.IdPerson = IdPerson;
            Session["IdPerson"] = IdPerson;
            return View();
        }

        public ActionResult Alta(Int32 IdPerson, Int32 IdCustomerType)
        {
            List<Account> assgined = new List<Account>(), accounts = new List<Account>();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar/Cuentas", "IdPerson=" + IdPerson + "&IdCustomerType=" + IdCustomerType)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                assgined = JArray.Parse(WSR.Content).ToObject<List<Account>>();
            }

            IRestResponse wsrAssigned = Task.Run(() => apiClient.getJArray("Cuenta/Listar", "IdAccount=null")).Result;
            if (wsrAssigned.StatusCode == HttpStatusCode.OK)
            {
                accounts = JArray.Parse(wsrAssigned.Content).ToObject<List<Account>>();
            }
            assgined.ForEach(x => {
                if (accounts.Count(y => y.Id == x.Id) > 0)
                {
                    Account r = accounts.FirstOrDefault(z => z.Id == x.Id);
                    accounts.Remove(r);
                }
            });

            ViewBag.assigned = assgined;
            ViewBag.accounts = accounts;
            ViewBag.idperson = IdPerson;
            ViewBag.idcustomertype = IdCustomerType;

            return View();
        }

        public Customer GetCustomer(Int32 IdCustomer)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar", "IdCustomer=" + IdCustomer)).Result;
            Customer data = new Customer();
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Customer>>().FirstOrDefault();
            }

            return data;
        }

        public List<CustomerAccountData> GetCustomerAccountData(Int32 IdCustomer, Int32 IdAccount)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Cuentas/Informacion", "IdCustomer=" + IdCustomer 
                                                                                                + "&IdAccount=" + IdAccount)).Result;
            List<CustomerAccountData> data = new List<CustomerAccountData>();
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<CustomerAccountData>>().ToList();
            }

            return data;
        }
    }
}