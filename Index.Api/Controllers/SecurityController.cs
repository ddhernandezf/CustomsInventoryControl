using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Seguridad")]
    public class SecurityController : ApiController
    {
        [Route("Autenticar/Web")]
        [HttpGet]
        public HttpResponseMessage SiteLogin(String UserName, String Password)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.UserLogin model = new Commons.UserLogin() { Username = UserName, Password = Functionalities.Security.Cryptography.Decrypt(Password)};
                Commons.User user = Dal.User.SiteLogin(model);

                if (user != null)
                {
                    respuesta = Request.CreateResponse(HttpStatusCode.OK, user);
                }
                else
                {
                    respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, "Credenciales incorrectas");
                }
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Autenticar/Movil")]
        [HttpGet]
        public HttpResponseMessage MobileLogin(String UserName, String Password)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.UserLogin model = new Commons.UserLogin() { Username = UserName, Password = Functionalities.Security.Cryptography.Decrypt(Password) };
                Commons.User user = Dal.User.MobileLogin(model);

                if (user != null)
                {
                    respuesta = Request.CreateResponse(HttpStatusCode.OK, user);
                }
                else
                {
                    respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, "Credenciales incorrectas");
                }
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Reset/Password/Movil")]
        [HttpGet]
        public HttpResponseMessage MobileResetPasswor(String UserName, String Password)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.UserLogin model = new Commons.UserLogin() { Username = UserName, Password = Functionalities.Security.Cryptography.Decrypt(Password) };
                Boolean result = Dal.User.PasswordResetMobile(model);

                if (result)
                {
                    respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
                }
                else
                {
                    respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, "Error desconocido");
                }
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Reset/Password/Web")]
        [HttpGet]
        public HttpResponseMessage SiteResetPasswor(String UserName, String Password)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.UserLogin model = new Commons.UserLogin() { Username = UserName, Password = Functionalities.Security.Cryptography.Decrypt(Password) };
                Boolean result = Dal.User.PasswordResetSite(model);

                if (result)
                {
                    respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
                }
                else
                {
                    respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, "Error desconocido");
                }
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }
    }
}
