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
    public class PartidaController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request, Int32? IdResolution)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Partida/Listar", "IdAccountingItem=null&IdResolution=" + IdResolution)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<AccountingItem>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, AccountingItem model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.IdResolution = Convert.ToInt32(Session["IdResolution"].ToString());
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Partida/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, AccountingItem model)
        {
            if (model != null && ModelState.IsValid)
            {
                model.IdResolution = Convert.ToInt32(Session["IdResolution"].ToString());
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Partida/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, AccountingItem model)
        {            
            if (model != null && ModelState.IsValid)
            {
                model.IdResolution = Convert.ToInt32(Session["IdResolution"].ToString());
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Partida/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo(Int32? IdResolution)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Partida/Listar", "IdAccountingItem=null&IdResolution=" + IdResolution)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<AccountingItem>>().Select(x => new { Id = x.Id,
                        Name = x.AccountingItemDisplay,
                        Parent = x.ParentAccountingItem
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