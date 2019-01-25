using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Congelar")]
    public class FreezeController : ApiController
    {
        [Route("CongelarDocumento")]
        [HttpGet]
        public HttpResponseMessage FreezeDocument(Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Freeze.FreezeDocument(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DesongelarDocumento")]
        [HttpGet]
        public HttpResponseMessage UnfreezeDocument(Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Freeze.UnfreezeDocument(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarDocumento")]
        [HttpGet]
        public HttpResponseMessage GetDocument(Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Freeze> result = Dal.Freeze.GetDocument(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("CongelarRegistro")]
        [HttpGet]
        public HttpResponseMessage FreezeDocument(Int32 IdFileDetail, Decimal Discharge)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Freeze.FreezeSingle(IdFileDetail, Discharge);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DesongelarRegistro")]
        [HttpGet]
        public HttpResponseMessage UnfreezeSingle(Int32 IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Freeze.UnfreezeSingle(IdFileDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarRegistro")]
        [HttpGet]
        public HttpResponseMessage GetSingle(Int32 IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Freeze> result = Dal.Freeze.GetSingle(IdFileDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result.FirstOrDefault());
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }
    }
}
