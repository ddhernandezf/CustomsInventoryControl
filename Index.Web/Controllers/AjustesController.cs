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
    public class AjustesController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index(Int32 IdFileDetailStock, Int32 IdFileDetailSubstract, Decimal Stock)
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Role role = (Commons.Role)Session["ROLEINFO"];

            Session["IdFileDetailStock"] = IdFileDetailStock;
            Session["IdFileDetailSubstract"] = IdFileDetailSubstract;
            ViewBag.Stock = Stock;
            ViewBag.DeleteTransmitedPremission = new PermisosController().Validate(user.UserName, role.Name, "Ajustes");

            return View();
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Ajuste/Listar", "IdFileDetailStock=" + Convert.ToInt32(Session["IdFileDetailStock"]) 
                                                                                + "&IdFileDetailSubstract=" + Convert.ToInt32(Session["IdFileDetailSubstract"]))).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Adjustment>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Adjustment model)
        {
            ModelState.Clear();

            model.IdFileDetailSubstract = Convert.ToInt32(Session["IdFileDetailSubstract"]);
            model.IdFileDetailStock = Convert.ToInt32(Session["IdFileDetailStock"]);

            if (model.Decrease < 0)
            {
                ModelState.AddModelError("Decrease", "La cantidad no debe ser menor a cero.");
            }
            if (model.Quantity <= 0)
            {
                ModelState.AddModelError("Quantity", "La cantidad no debe ser menor o igual a cero.");
            }

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Ajuste/Operar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Adjustment model)
        {
            IRestResponse WSR = Task.Run(() => apiClient.postObject("Ajuste/Eliminar", model)).Result;
            if (WSR.StatusCode != HttpStatusCode.OK)
            {
                ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }
    }
}