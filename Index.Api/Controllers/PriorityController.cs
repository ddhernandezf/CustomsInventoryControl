using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Prioridad")]
    public class PriorityController : ApiController
    {
        [Route("Listar")]
        [HttpGet]
        public HttpResponseMessage Get()
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Transmition.Priority> result = Dal.TRANSMITION.Priority.Get();
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
