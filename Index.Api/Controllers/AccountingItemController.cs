using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Partida")]
    public class AccountingItemController : ApiController
    {
        [Route("Asignar")]
        [HttpPost]
        public HttpResponseMessage Assign(Commons.AccountingItemAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.AccountingItem.Assign(model.IdResolution, model.IdAccountingItem);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }
        
        [Route("Desasignar")]
        [HttpPost]
        public HttpResponseMessage Unassign(Commons.AccountingItemAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.AccountingItem.Unassign(model.IdResolution, model.IdAccountingItem);
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
        public HttpResponseMessage Get(Int32? IdAccountingItem, Int32? IdResolution)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.AccountingItem> result = Dal.AccountingItem.Get(IdAccountingItem, IdResolution);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Arbol")]
        [HttpGet]
        public HttpResponseMessage Get(Int32? IdResolution)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.AccountingItemTree> result = Dal.AccountingItem.getTree(IdResolution);

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
