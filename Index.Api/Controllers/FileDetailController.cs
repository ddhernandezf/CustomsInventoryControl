using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Detalle")]
    public class FileDetailController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddImports(Commons.FileDetail model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileDetail.Add(model);
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
        public HttpResponseMessage UpdateImports(Commons.FileDetail model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileDetail.Update(model);
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
        public HttpResponseMessage DeleteImports(Commons.FileDetail model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileDetail.Delete(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ValidarCampos")]
        [HttpGet]
        public HttpResponseMessage FieldsValid(Int32 IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileDetail.IsFieldsExists(IdFileInfoConfig);
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
        public HttpResponseMessage Get(Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileDetail> result = Dal.FileDetail.Get(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Encabezado")]
        [HttpGet]
        public HttpResponseMessage GetHeader(Int32? IdFileHeader, Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeaderDetail> result = Dal.FileDetail.GetHeader(IdFileHeader, IdFileInfoConfig);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ParametrosValidacion")]
        [HttpGet]
        public HttpResponseMessage GetValidationData(Int32? IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.FileDetailValidationData result = Dal.FileDetail.GetValidationData(IdFileDetail);
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
