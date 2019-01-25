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
    public class ParametrosController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public JsonResult ListarJson()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Parametros/Listar", "")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JObject.Parse(WSR.Content).ToObject<Parameters>(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(null, JsonRequestBehavior.AllowGet);
            }
        }

        public Parameters Listar()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Parametros/Listar", "")).Result;
            Parameters result = new Parameters();

            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = JObject.Parse(WSR.Content).ToObject<Parameters>();
            }

            return result;
        }
    }
}