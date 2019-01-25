
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Descargo")]
    public class FileItemDischargeController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.FileItemDischarge model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileItemDischarge.Add(model);
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
        public HttpResponseMessage Update(Commons.FileItemDischarge model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileItemDischarge.Update(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Operar")]
        [HttpPost]
        public HttpResponseMessage Operate(Commons.FileItemDischarge model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileItemDischarge.Operate(model);
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
        public HttpResponseMessage Delete(Commons.FileItemDischarge model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileItemDischarge.Delete(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("EliminarTransmitido")]
        [HttpGet]
        public HttpResponseMessage DeleteTransmited(Int32 IdFileItemDischarge)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileItemDischarge.DeleteTransmited(IdFileItemDischarge);
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
