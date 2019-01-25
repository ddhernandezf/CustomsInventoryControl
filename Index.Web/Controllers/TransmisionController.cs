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
    public class TransmisionController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Nuevo()
        {
            return View();
        }

        public ActionResult Cola()
        {
            return View();
        }

        public ActionResult Transmitido()
        {
            return View();
        }

        public ActionResult DetalleRespuesta(Int32 IdOpaDetail)
        {
            ViewBag.IdOpaDetail = IdOpaDetail;
            return View();
        }

        public ActionResult ReadFilteredData([DataSourceRequest] DataSourceRequest request, Boolean UseRegisterDate, DateTime StartDate, DateTime EndDate, Boolean? IsValid)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/FiltrarData", "IdCustomer=" + CustomerInfo.Id 
                                                                    + "&IdAccount=" + AccountInfo.Id 
                                                                    + "&UseRegisterDate=" + UseRegisterDate 
                                                                    + "&StartDate=" + StartDate.ToString("yyyy-MM-dd")
                                                                    + "&EndDate=" + EndDate.ToString("yyyy-MM-dd"))).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Commons.Transmition.OpaDetail> data = JArray.Parse(WSR.Content).ToObject<List<Commons.Transmition.OpaDetail>>();
                if (IsValid != null)
                {
                    data = data.Where(x => x.IsValid == IsValid).ToList();
                }

                return Json(data.ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadQueue([DataSourceRequest] DataSourceRequest request)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            Commons.User UserInfo = (Commons.User)Session["USERINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/FiltrarCola", "IdCustomer=" + CustomerInfo.Id
                                                                    + "&IdAccount=" + AccountInfo.Id
                                                                    + "&UserName=" + UserInfo.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Commons.Transmition.OpaHeader> data = JArray.Parse(WSR.Content).ToObject<List<Commons.Transmition.OpaHeader>>();

                return Json(data.ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadDetail([DataSourceRequest] DataSourceRequest request, Int32 IdOpaHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/Detalle", "IdOpaHeader=" + IdOpaHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Commons.Transmition.OpaDetail> data = JArray.Parse(WSR.Content).ToObject<List<Commons.Transmition.OpaDetail>>();

                return Json(data.ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult ReadResponseDetail([DataSourceRequest] DataSourceRequest request, Int32 IdOpaDetail)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/DetalleMensajes", "IdOpaDetail=" + IdOpaDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Commons.Transmition.OpaMessageDetail> data = JArray.Parse(WSR.Content).ToObject<List<Commons.Transmition.OpaMessageDetail>>();

                return Json(data.ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public JsonResult ReproccessItem(Int32 IdOpaDetail)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/ReEncolarItem", "IdOpaDetail=" + IdOpaDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult ReproccessBatch(Int32 IdOpaHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/ReEncolarBatch", "IdOpaHeader=" + IdOpaHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(true, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message, JsonRequestBehavior.AllowGet);
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DeleteQueue([DataSourceRequest] DataSourceRequest request, Commons.Transmition.OpaHeader model)
        {
            IRestResponse WSR = Task.Run(() => apiClient.postObject("Transmision/Eliminar", model)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public JsonResult DeleteItem(Int32 IdOpaDetail)
        {
            Boolean result = true;
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/EliminarItem", "IdOpaDetail=" + IdOpaDetail)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                result = Convert.ToBoolean(WSR.Content.ToString());
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public JsonResult DeleteWithErrors(Int32 IdOpaHeader)
        {
            Boolean result = true;
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/EliminarErroneos", "IdOpaHeader=" + IdOpaHeader)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                result = Convert.ToBoolean(WSR.Content.ToString());
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ReadTransmited([DataSourceRequest] DataSourceRequest request)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            Commons.User UserInfo = (Commons.User)Session["USERINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/FiltrarTransmitido", "IdCustomer=" + CustomerInfo.Id
                                                                    + "&IdAccount=" + AccountInfo.Id
                                                                    + "&UserName=" + UserInfo.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Commons.Transmition.OpaHeader> data = JArray.Parse(WSR.Content).ToObject<List<Commons.Transmition.OpaHeader>>();

                return Json(data.ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [HttpPost]
        public JsonResult SaveToQueue(Int32 IdPriority, DateTime StartDate, DateTime EndDate, String FileItemDischargeIds)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            Account AccountInfo = (Account)Session["ACCOUNTINFO"];
            Commons.User UserInfo = (Commons.User)Session["USERINFO"];
            Commons.Transmition.OpaQueue model = new Commons.Transmition.OpaQueue();
            model.data = new List<Commons.Transmition.OpaDetail>();
            model.IdCustomer = CustomerInfo.Id;
            model.IdAccount = AccountInfo.Id;
            model.UserName = UserInfo.UserName;
            model.IdPriority = IdPriority;
            model.StartDate = StartDate;
            model.EndDate = EndDate;
            model.data = new List<Commons.Transmition.OpaDetail>();
            
            if (!string.IsNullOrEmpty(FileItemDischargeIds) && !string.IsNullOrWhiteSpace(FileItemDischargeIds))
            {
                List<String> data = FileItemDischargeIds.Split(',').ToList();
                IRestResponse WSRDATA = Task.Run(() => apiClient.postObject("Transmision/FiltrarDataPorIds", data)).Result;
                if (WSRDATA.StatusCode == HttpStatusCode.OK)
                {
                    model.data = JArray.Parse(WSRDATA.Content).ToObject<List<Commons.Transmition.OpaDetail>>();
                }
                else
                {
                    return Json(JObject.Parse(WSRDATA.Content).ToObject<Error>().Message.ToString(), JsonRequestBehavior.AllowGet);
                }
            }
            
            if (model.data.Count == 0)
            {
                return Json("Debe seleccionar un registro por lo menos.", JsonRequestBehavior.AllowGet);
            }
            else
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Transmision/GuardarEnCola", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(true, JsonRequestBehavior.AllowGet);
                }
            }
        }

        public JsonResult ValidateEmail()
        {
            Commons.User UserInfo = (Commons.User)Session["USERINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Transmision/ValidarEmail", "UserName=" + UserInfo.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                Commons.Transmition.EmailResponse data = JObject.Parse(WSR.Content).ToObject<Commons.Transmition.EmailResponse>();

                return Json(data,JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString(), JsonRequestBehavior.AllowGet);
            }
        }
    }
}