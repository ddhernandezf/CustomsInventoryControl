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
    public class UsuarioController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Usuario/Listar", "UserName=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<User>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, User model)
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
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Usuario/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, User model)
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
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Usuario/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, User model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Usuario/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }
        
        public ActionResult AsignarlRol(String UserName)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Rol/ListarPorUsuarioParaAsignar", "UserName=" + UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                ViewBag.data  = JArray.Parse(WSR.Content).ToObject<List<UserByRole>>();
            }

            ViewBag.UserName = UserName;
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddRoleAsignment([DataSourceRequest] DataSourceRequest request, RoleAssignment model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Rol/Asignacion/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RemoveRoleAssignment([DataSourceRequest] DataSourceRequest request, RoleAssignment model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Rol/Asignacion/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult AsignarlCliente(String UserName)
        {

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar/Asignar", "UserName=" + UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                ViewBag.data = JArray.Parse(WSR.Content).ToObject<List<CustomerToAssign>>();
            }

            ViewBag.UserName = UserName;
            return View();
        }

        public ActionResult ReadByAssignment([DataSourceRequest] DataSourceRequest request)
        {
            Commons.Account AccountInfo = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.User user = (Commons.User)Session["USERINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarAsignados", "UserName=" + user.UserName + "&IdAccount=" + AccountInfo.Id)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Customer>>().ToList().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public Boolean GotUserAssigned(String UserName)
        {
            List<CustomerAssigned> data = new List<CustomerAssigned>();

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarAsignados", "UserName=" + UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<CustomerAssigned>>().Where(x => x.Assigned == true).ToList();
            }

            if (data.Count > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AddCustomerAsignment([DataSourceRequest] DataSourceRequest request, CustomerUser model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Usuarios/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            Commons.User user = (Commons.User)Session["USERINFO"];
            Session["GOTCUSTOMER"] = GotUserAssigned(user.UserName);

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult RemoveCustomerAssignment([DataSourceRequest] DataSourceRequest request, CustomerUser model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Cliente/Usuarios/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            Commons.User user = (Commons.User)Session["USERINFO"];
            Session["GOTCUSTOMER"] = GotUserAssigned(user.UserName);

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }
    }
}