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
    public class MenuController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public List<Commons.Menu> Get(String RoleName, String UserName)
        {
            List<Commons.Menu> result = new List<Commons.Menu>();

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Menu/Listar", "RoleName=" + RoleName + "&UserName=" + UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = JArray.Parse(WSR.Content).ToObject<List<Commons.Menu>>();
            }

            return result;
        }

        public JsonResult GetRequestCustomerCredentials(String ControllerName, String ActionName)
        {
            Boolean result = false;

            if (Session["MENUINFO"] != null)
            {
                Commons.Menu item = ((List<Commons.Menu>)Session["MENUINFO"]).Where(x => x.Controller == ControllerName && x.Action == ActionName).FirstOrDefault();
                result = (item == null) ? true : item.HasCredentials;
            }
            else
            {
                result = true;
            }


            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}