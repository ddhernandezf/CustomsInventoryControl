using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Email")]
    public class EmailController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.Email model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Email.Add(model);
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
        public HttpResponseMessage Update(Commons.Email model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Email.Update(model);
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
        public HttpResponseMessage Delete(Commons.Email model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Email.Delete(model);
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
        public HttpResponseMessage GetPhone(Int32? IdPerson, Int32? IdEmailType)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Email> result = Dal.Email.Get(IdPerson, IdEmailType);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Tipos")]
        [HttpGet]
        public HttpResponseMessage GetPhoneType(Int32? IdEmailType)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.EmailType> result = Dal.EmailType.Get(IdEmailType);
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
