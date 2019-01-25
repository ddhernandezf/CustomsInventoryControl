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
    public class DashboardController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);
        
        public ActionResult ReadExpiredDetail([DataSourceRequest] DataSourceRequest request, Int32 IdCustomer, Int32 IdAccount)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Dashboard/Expirados/Detalle", "IdCustomer=" + IdCustomer 
                                                                            + "&IdAccount=" + IdAccount)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Commons.Dashboard.ExpiredDetail>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadTransmitedDetail([DataSourceRequest] DataSourceRequest request, Int32 IdCustomer, Int32 IdAccount)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Dashboard/Transmitidos/Detalle", "IdCustomer=" + IdCustomer
                                                                            + "&IdAccount=" + IdAccount)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Commons.Dashboard.TransmitedDetail>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public Commons.Dashboard.Customer GetCustomer(Int32 IdCustomer)
        {
            Commons.Dashboard.Customer data = new Commons.Dashboard.Customer();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Dashboard/Cliente", "IdCustomer=" + IdCustomer)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JObject.Parse(WSR.Content).ToObject<Commons.Dashboard.Customer>();
            }

            return data;
        }

        public Commons.Dashboard.Expired GetExpired(Int32 IdCustomer, Int32 IdAccount)
        {
            Commons.Dashboard.Expired data = new Commons.Dashboard.Expired();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Dashboard/Expirados", "IdCustomer=" + IdCustomer
                                                                            + "&IdAccount=" + IdAccount)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JObject.Parse(WSR.Content).ToObject<Commons.Dashboard.Expired>();
            }

            return data;
        }

        public Commons.Dashboard.Transmited GetTransmited(Int32 IdCustomer, Int32 IdAccount)
        {
            Commons.Dashboard.Transmited data = new Commons.Dashboard.Transmited();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Dashboard/Transmitidos", "IdCustomer=" + IdCustomer
                                                                            + "&IdAccount=" + IdAccount)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JObject.Parse(WSR.Content).ToObject<Commons.Dashboard.Transmited>();
            }

            return data;
        }
    }
}