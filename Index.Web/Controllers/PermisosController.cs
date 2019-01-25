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
    public class PermisosController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/Listar", "IdRole=null")).Result;
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
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Int32? IdRole, Int32? IdPremission)
        {
            /*if (model != null && ModelState.IsValid)
            {*/
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/Asignacion/Nuevo", "IdRole=" + IdRole + "&IdPremission=" + IdPremission)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            //}

            return Json(true);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Int32? IdRole, Int32? IdPremission)
        {
            /*if (model != null && ModelState.IsValid)
            {*/
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/Asignacion/Eliminar", "IdRole=" + IdRole + "&IdPremission=" + IdPremission)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            //}

            return Json(true);
        }

        public ActionResult ReadByRole([DataSourceRequest] DataSourceRequest request, Int32? IdRole)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/ListarPorRol", "IdRole=" + IdRole)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<PremissionTree> data = JArray.Parse(WSR.Content).ToObject<List<PremissionTree>>();
                return Json(data,JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public Boolean Validate(String UserName, String RoleName, String PremissionName)
        {
            Boolean result = false;
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/Validar", "UserName=" + UserName 
                                                                                    + "&RoleName=" + RoleName 
                                                                                    + "&PremissionName=" + PremissionName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = Convert.ToBoolean(WSR.Content);
            }
            else
            {
                result = false;
            }

            return result;
        }

        public JsonResult JsonValidate(String UserName, String RoleName, String PremissionName)
        {
            Boolean result = false;
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Permisos/Validar", "UserName=" + UserName
                                                                                    + "&RoleName=" + RoleName
                                                                                    + "&PremissionName=" + PremissionName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = (Boolean)JObject.Parse(WSR.Content).ToObject<Boolean?>();
            }
            else
            {
                result = false;
            }

            return Json(result, JsonRequestBehavior.AllowGet);

        }
    }
}