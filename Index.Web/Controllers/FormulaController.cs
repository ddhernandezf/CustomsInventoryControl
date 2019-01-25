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
    public class FormulaController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            if (CustomerInfo != null)
            {
                Int32 IdMainItem = Convert.ToInt32(TempData["IDMAINITEM"].ToString());
                String MainItem = TempData["MAINITEM"].ToString();
                TempData["IDMAINITEM"] = IdMainItem;
                TempData["MAINITEM"] = MainItem;
                ViewBag.MainItem = MainItem;

                return View();
            }
            else
            {
                TempData["ERRORMESSAGE"] = "Su usuario o cuenta con clientes asignados. Comuniquese con el administrador del sistema para solicitar los mismos.";
                return RedirectToAction("Index", "Error");
            }
        }

        public ActionResult Router(Int32 IdMainItem, String MainItem)
        {
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            if (CustomerInfo != null)
            {
                TempData["IDMAINITEM"] = IdMainItem;
                TempData["MAINITEM"] = MainItem;

                return RedirectToAction("Index");
            }
            else
            {
                TempData["ERRORMESSAGE"] = "Su usuario o cuenta con clientes asignados. Comuniquese con el administrador del sistema para solicitar los mismos.";
                return RedirectToAction("Index", "Error");
            }
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request)
        {
            Int32 IdMainItem = Convert.ToInt32(TempData["IDMAINITEM"].ToString());
            String MainItem = TempData["MAINITEM"].ToString();
            TempData["IDMAINITEM"] = IdMainItem;
            TempData["MAINITEM"] = MainItem;
            ViewBag.MainItem = MainItem;
            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];

            if (CustomerInfo != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Formula/Listar", "IdFormula=null&IdCustomer=" + CustomerInfo.Id 
                                                                        + "&IdMainItem=" + IdMainItem)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return Json(JArray.Parse(WSR.Content).ToObject<List<Formula>>().ToDataSourceResult(request), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() }, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Formula model)
        {
            Int32 IdMainItem = Convert.ToInt32(TempData["IDMAINITEM"].ToString());
            String MainItem = TempData["MAINITEM"].ToString();
            TempData["IDMAINITEM"] = IdMainItem;
            TempData["MAINITEM"] = MainItem;
            ViewBag.MainItem = MainItem;

            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            model.IdCustomer = CustomerInfo.Id;
            model.IdMainItem = IdMainItem;

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Formula/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Formula model)
        {
            Int32 IdMainItem = Convert.ToInt32(TempData["IDMAINITEM"].ToString());
            String MainItem = TempData["MAINITEM"].ToString();
            TempData["IDMAINITEM"] = IdMainItem;
            TempData["MAINITEM"] = MainItem;
            ViewBag.MainItem = MainItem;

            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            model.IdCustomer = CustomerInfo.Id;
            model.IdMainItem = IdMainItem;

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Formula/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Formula model)
        {
            Int32 IdMainItem = Convert.ToInt32(TempData["IDMAINITEM"].ToString());
            String MainItem = TempData["MAINITEM"].ToString();
            TempData["IDMAINITEM"] = IdMainItem;
            TempData["MAINITEM"] = MainItem;
            ViewBag.MainItem = MainItem;

            Customer CustomerInfo = (Customer)Session["CUSTOMERINFO"];
            model.IdCustomer = CustomerInfo.Id;
            model.IdMainItem = IdMainItem;

            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Formula/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }
    }
}