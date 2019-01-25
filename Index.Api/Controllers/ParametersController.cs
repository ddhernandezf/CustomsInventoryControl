using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Parametros")]
    public class ParametersController : ApiController
    {
        [Route("Listar")]
        [HttpGet]
        public HttpResponseMessage Get()
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.Parameters result = Dal.Parameters.Get();
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
