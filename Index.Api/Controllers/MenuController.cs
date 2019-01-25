using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Menu")]
    public class MenuController : ApiController
    {
        [Route("Listar")]
        [HttpGet]
        public HttpResponseMessage GetMenu(String RoleName, String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Menu> result = Dal.Menu.Get(RoleName, UserName);
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
