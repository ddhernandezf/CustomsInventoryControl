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
    public class DescargoController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index(Int32 IdFileDetail)
        {
            ViewBag.IdFileDetail = IdFileDetail;
            
            return View();
        }

        public ActionResult RawMaterialRead([DataSourceRequest] DataSourceRequest request, Int32 IdFileDetail, Int32 IdCustomer, Int32 IdItem, Boolean UseFormula)
        {
            Account Cuenta = (Account)Session["ACCOUNTINFO"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/Listar/Materias", "IdFileDetail=" + IdFileDetail
                                                                        + "&IdAccount=" + Cuenta.Id
                                                                        + "&IdCustomer=" + IdCustomer
                                                                        + "&IdItem=" + IdItem
                                                                        + "&UseFormula=" + UseFormula)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<DischargeRawMaterial>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult TransactionsRead([DataSourceRequest] DataSourceRequest request, Int32 IdFileDetail, Int32 IdItem)
        {
            Account Cuenta = (Account)Session["ACCOUNTINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/Listar/Transacciones", "IdFileDetail=" + IdFileDetail
                                                                        + "&IdItem=" + IdItem
                                                                        + "&IdAccount=" +Cuenta.Id )).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<DischargeTransaction>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public JsonResult GetParameters(Int32 IdFileDetail)
        {
            DischargeParameters data = new DischargeParameters();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/Listar/Parametros", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JObject.Parse(WSR.Content).ToObject<DischargeParameters>();
            }

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, DischargeTransaction model, Int32 IdDetailSubstract, Boolean UseFormula)
        {
            ModelState.Clear();
            if (model != null && ModelState.IsValid)
            {
                FileItemDischarge filedischarge = new FileItemDischarge();
                filedischarge.IdFileDetailSubstract = IdDetailSubstract;
                filedischarge.IdFileDetailStock = model.IdFileDetail;
                filedischarge.Quantity = (Decimal)model.Quantity;
                filedischarge.Decrease = (Decimal)model.Decrease;
                filedischarge.UseFormula = UseFormula;

                filedischarge.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Descargo/Operar", filedischarge)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, DischargeTransaction model, Int32 IdDetailSubstract)
        {
            FileItemDischarge filedischarge = new FileItemDischarge();
            filedischarge.IdFileDetailSubstract = IdDetailSubstract;
            filedischarge.IdFileDetailStock = model.IdFileDetail;

            IRestResponse WSR = Task.Run(() => apiClient.postObject("Descargo/Eliminar", filedischarge)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public JsonResult DeleteTransmited(Int32 IdFileItemDischarge)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Descargo/EliminarTransmitido", "IdFileItemDischarge=" + IdFileItemDischarge)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }
    }
}