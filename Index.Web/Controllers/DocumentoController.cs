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
    public class DocumentoController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Configuracion(Int32 IdFileInfo)
        {
            Session["IDFILEINFO"] = IdFileInfo;
            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Listar", "IdFileInfo=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileInfo>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, FileInfo model)
        {
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
            
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, FileInfo model)
        {
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
            
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, FileInfo model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult getCombo()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Listar", "IdFileInfo=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileInfo>>().Select(x => new { Id = x.Id, Name = x.Name }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public ActionResult ReadConfig([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Configuracion/Listar",
                "IdFileInfoConfig=null&IdFileInfo=" + Convert.ToInt32(Session["IDFILEINFO"]) + "&IdAccount=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileInfoConfig>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CreateConfig([DataSourceRequest] DataSourceRequest request, FileInfoConfig model)
        {
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
            model.IdFileInfo = Convert.ToInt32(Session["IDFILEINFO"]);

            if (model.Addition == model.Substraction)
            {
                ModelState.AddModelError("Addition", "Los valores de suma y resta no pueden contener el mismo valo.");
            }

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Configuracion/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateConfig([DataSourceRequest] DataSourceRequest request, FileInfoConfig model)
        {
            model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
            model.IdFileInfo = Convert.ToInt32(Session["IDFILEINFO"]);

            if (model.Addition == model.Substraction)
            {
                ModelState.AddModelError("Addition", "Los valores de suma y resta no pueden contener el mismo valo.");
            }

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Configuracion/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteConfig([DataSourceRequest] DataSourceRequest request, FileInfoConfig model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Documento/Configuracion/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public JsonResult ConfigActiveValidate(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Configuracion/ValidarActivo","IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(Convert.ToBoolean(WSR.Content), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult getComboConfig()
        {
            Account cuenta = (Account)Session["ACCOUNTINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Configuracion/Listar", 
                "IdFileInfoConfig=null&IdFileInfo=null&IdAccount=" + cuenta.Id)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileInfoConfig>>().Select(x => new { Id = x.Id, Name = x.DropDownName }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public ActionResult getComboFileType()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Listar/TiposDocumento", null)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileInfoType>>().Select(x => new { Id = x.Id, Name = x.Name }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public JsonResult ValidateToFieldAssign(Int32 IdFileInfoConfig)
        {
            Account cuenta = (Account)Session["ACCOUNTINFO"];
            
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Configuracion/Listar",
                "IdFileInfoConfig=" + IdFileInfoConfig + "&IdFileInfo=null&IdAccount=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                FileInfoConfig item = JArray.Parse(WSR.Content).ToObject<List<FileInfoConfig>>().FirstOrDefault();
                if (item == null)
                {
                    return Json("Error desconocido.", JsonRequestBehavior.AllowGet);
                }
                else
                {
                    if (item.IdAccount == cuenta.Id)
                    {
                        return Json(true, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json("Debe cambiar a la cuenta: " + item.AccountName + " para poder asignar los campos a la configuración.", JsonRequestBehavior.AllowGet);
                    }
                }
            }
            else
            {
                return Json("Error desconocido.", JsonRequestBehavior.AllowGet);
            }
        }
    }
}