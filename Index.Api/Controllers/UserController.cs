using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Collections.Generic;

namespace Index.Api.Controllers
{
    [RoutePrefix("Usuario")]
    public class UserController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.User model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                model.MobilePassword = Functionalities.Security.Cryptography.Encrypt(model.MobilePassword);
                model.SitePassword = Functionalities.Security.Cryptography.Encrypt(model.SitePassword);
                Boolean result = Dal.User.Add(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Modificar")]
        [HttpPost]
        public HttpResponseMessage Update(Commons.User model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                model.MobilePassword = Functionalities.Security.Cryptography.Encrypt(model.MobilePassword);
                model.SitePassword = Functionalities.Security.Cryptography.Encrypt(model.SitePassword);
                Boolean result = Dal.User.Update(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Eliminar")]
        [HttpPost]
        public HttpResponseMessage Delete(Commons.User model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.User.Delete(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar")]
        [HttpGet]
        public HttpResponseMessage Get(String UserName)
        {
            HttpResponseMessage respuesta = null;
            UserName = (UserName == "null") ? null : UserName;

            try
            {
                List<Commons.User> result = Dal.User.Get(UserName);

                result.ForEach(x =>
                {
                    x.CompleteName = x.FirstName + ((x.LastName == null) ? "" : " " + x.LastName);
                });

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("CambiarPassword")]
        [HttpGet]
        public HttpResponseMessage ChangeSitePassword(String UserName, String Password)
        {
            Commons.UserLogin model = new Commons.UserLogin() {
                Username = UserName,
                Password = Password
            };

            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.User.SiteChangePassword(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }
    }
}
