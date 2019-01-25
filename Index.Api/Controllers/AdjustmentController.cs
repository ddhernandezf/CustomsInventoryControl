using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Ajuste")]
    public class AdjustmentController : ApiController
    {
        [Route("Operar")]
        [HttpPost]
        public HttpResponseMessage Operate(Commons.Adjustment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Adjustment.Operate(model);
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
        public HttpResponseMessage Delete(Commons.Adjustment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Adjustment.Delete(model);
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
        public HttpResponseMessage GetAccount(Int32 IdFileDetailStock, Int32 IdFileDetailSubstract)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Adjustment> result = Dal.Adjustment.Get(IdFileDetailStock, IdFileDetailSubstract);
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
