﻿using System;
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
    public class EmailController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);
        
        public ActionResult Read([DataSourceRequest] DataSourceRequest request, Int32 IdPerson)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Email/Listar", "IdPerson=" + IdPerson + "&IdEmailType=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Email>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Create([DataSourceRequest] DataSourceRequest request, Email model, Int32 IdPerson)
        {
            model.IdPerson = Convert.ToInt32(Session["IdPerson"]);
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Email/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Update([DataSourceRequest] DataSourceRequest request, Email model, Int32 IdPerson)
        {
            model.IdPerson = Convert.ToInt32(Session["IdPerson"]);
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Email/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Delete([DataSourceRequest] DataSourceRequest request, Email model, Int32 IdPerson)
        {
            model.IdPerson = Convert.ToInt32(Session["IdPerson"]);
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Email/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult ReadType([DataSourceRequest] DataSourceRequest request)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Email/Listar/Tipos", "IdEmailType=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<EmailType>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult getComboEmailType()
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Email/Listar/Tipos", "IdEmailType=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<EmailType>>().Select(x => new { Id = x.Id, Name = x.Description }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }
    }
}