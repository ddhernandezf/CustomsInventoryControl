using Index.Commons;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class CampoController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        // GET: Campo
        public ActionResult Index()
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;
            
            ViewBag.FileInfoConfig = config;
            
            return View();
        }

        public ActionResult Router(Int32 IdFileInfoConfig)
        {
            List<FileInfoConfig> data = new List<FileInfoConfig>();

            Account cuenta = (Account)Session["ACCOUNTINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Documento/Configuracion/Listar", "IdFileInfoConfig=" + IdFileInfoConfig + "&IdFileInfo=null&IdAccount=" + cuenta.Id)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<FileInfoConfig>>();
            }

            if (data == null)
            {
                return RedirectToAction("Index", "Error");
            }
            else
            {
                TempData["FILEINFOCONFIG"] = data.FirstOrDefault();

                return RedirectToAction("Index");
            }
        }

        public ActionResult FieldMaster(Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;
            ViewBag.FileInfoConfig = config;

            return View();
        }

        public ActionResult ReadMaster([DataSourceRequest] DataSourceRequest request, Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Maestro/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Field>>().ToDataSourceResult(request),JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateMaster([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                model.IsRequeried = (model.IsRequeriedInternal == true) ? true : model.IsRequeried;
                model.IsUsed = (model.IsRequeriedInternal == true) ? true : model.IsUsed;
                model.Label = (String.IsNullOrEmpty(model.Label)) ? model.FieldName : model.Label;
                if (model.IdMaster == 0)
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Maestro/Nuevo", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
                else
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Maestro/Modificar", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteMaster([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Maestro/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult FieldDetail(Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;
            ViewBag.FileInfoConfig = config;

            return View();
        }

        public ActionResult ReadDetail([DataSourceRequest] DataSourceRequest request, Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Detalle/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Field>>().ToDataSourceResult(request), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }
        
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateDetail([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                model.IsRequeried = (model.IsRequeriedInternal == true) ? true : model.IsRequeried;
                model.IsUsed = (model.IsRequeriedInternal == true) ? true : model.IsUsed;
                model.Label = (String.IsNullOrEmpty(model.Label)) ? model.FieldName : model.Label;
                if (model.IdMaster == 0)
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Detalle/Nuevo", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
                else
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Detalle/Modificar", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteDetail([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Detalle/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult FieldAttached(Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;
            ViewBag.FileInfoConfig = config;

            return View();
        }

        public ActionResult ReadAttached([DataSourceRequest] DataSourceRequest request, Int32 IdFileInfoConfig)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Adjunto/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Field>>().ToDataSourceResult(request), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }
        
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateAttached([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                model.IsRequeried = (model.IsRequeriedInternal == true) ? true : model.IsRequeried;
                model.IsUsed = (model.IsRequeriedInternal == true) ? true : model.IsUsed;
                model.Label = (String.IsNullOrEmpty(model.Label)) ? model.FieldName : model.Label;
                if (model.IdMaster == 0)
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Adjunto/Nuevo", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
                else
                {
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Adjunto/Modificar", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                    }
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteAttached([DataSourceRequest] DataSourceRequest request, Field model)
        {
            FileInfoConfig config = (FileInfoConfig)TempData["FILEINFOCONFIG"];
            TempData["FILEINFOCONFIG"] = config;

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Campo/Adjunto/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public JsonResult x(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/ValidarCampos", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(Convert.ToBoolean(WSR.Content), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult DetailFieldsExists(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/ValidarCampos", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(Convert.ToBoolean(WSR.Content), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult AttachedFieldsExists(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Adjunto/ValidarCampos", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(Convert.ToBoolean(WSR.Content), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult FileSelectDestroy()
        {
            try
            {
                TempData.Remove("FILEINFOCONFIG");
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }
    }
}