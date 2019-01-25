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
    public class CongelarController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Documento(Int32 IdFileHeader, String Document)
        {
            ViewBag.IdFileHeader = IdFileHeader;
            ViewBag.Document = Document;

            return View();
        }

        public ActionResult Registro(Int32 IdFileDetail, Int32 TransactionLine)
        {
            ViewBag.IdFileDetail = IdFileDetail;
            ViewBag.TransactionLine = TransactionLine;
            Freeze model = new Freeze();

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/ListarRegistro", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                model = JObject.Parse(WSR.Content).ToObject<Freeze>();
                model.Discharge = (model.Discharge == 0) ? model.Stock : model.Discharge;
            }

            return View(model);
        }

        public ActionResult ReadDocument([DataSourceRequest] DataSourceRequest request, Int32 IdFileHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/ListarDocumento", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Freeze>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public JsonResult CongelarDocumento(Int32 IdFileHeader)
        {
            Boolean result = false;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/CongelarDocumento", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = true;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DescongelarDocumento(Int32 IdFileHeader)
        {
            Boolean result = false;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/DesongelarDocumento", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = true;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult CongelarRegistro(Int32 IdFileDetail, Decimal Discharge)
        {
            Boolean result = false;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/CongelarRegistro", "IdFileDetail=" + IdFileDetail 
                                                                                                + "&Discharge=" + Discharge)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = true;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DescongelarRegistro(Int32 IdFileDetail)
        {
            Boolean result = false;

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Congelar/DesongelarRegistro", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = true;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}