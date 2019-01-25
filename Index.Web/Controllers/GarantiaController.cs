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
    public class GarantiaController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Garantia/Listar", "IdWarranty=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Warranty>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Warranty model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Garantia/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Warranty model)
        {
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Garantia/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Warranty model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Garantia/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Garantia/Listar", "IdWarranty=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Warranty>>().Select(x => new { Id = x.Id, Name = x.Name }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }
    }
}