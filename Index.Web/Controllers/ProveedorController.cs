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
    public class ProveedorController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Proveedor/Listar", "IdPerson=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Supplier>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Supplier model)
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
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Proveedor/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Supplier model)
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
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Proveedor/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Supplier model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Proveedor/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Proveedor/Listar", "IdPerson=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Supplier>>().Select(x => new { Id = x.IdPerson, Name = (String.IsNullOrEmpty(x.LastName)) ? x.FirstName : x.FirstName + ' ' + x.LastName }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }
    }
}