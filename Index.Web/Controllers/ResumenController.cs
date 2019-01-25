using Index.Commons;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class ResumenController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index(Int32 IdFileDetail)
        {
            ViewBag.IdFileDetail = IdFileDetail;

            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request, Int32 IdFileDetail)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/Listar/Resumen", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<DischargeResume>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public JsonResult JsonCounter(Int32 IdFileDetail)
        {
            Int32 counter = 0;
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/Contador/Resumen", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                counter = Convert.ToInt32(WSR.Content);
            }

            return Json(counter, JsonRequestBehavior.AllowGet);
        }
    }
}