using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Encabezado")]
    public class FileHeaderController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.FileHeader model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.FileHeader result = Dal.FileHeader.Add(model);
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
        public HttpResponseMessage Update(Commons.FileHeader model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.FileHeader result = Dal.FileHeader.Update(model);
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
        public HttpResponseMessage Delete(Commons.FileHeader model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileHeader.Delete(model);
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
                Boolean result = Dal.FileHeader.IsFieldsExists(IdFileInfoConfig);
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
        public HttpResponseMessage Get(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeader> result = Dal.FileHeader.Get(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarMesActual")]
        [HttpGet]
        public HttpResponseMessage GetCurrentMonth(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeader> result = Dal.FileHeader.GetCurrentMonth(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarFiltrado")]
        [HttpGet]
        public HttpResponseMessage GetFiltered(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig, String IdDocument, DateTime? CreateDate, DateTime? ExpirationDate, DateTime? AuthorizationDate)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeader> result = Dal.FileHeader.GetFiltered(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig, IdDocument, CreateDate, ExpirationDate, AuthorizationDate);
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
        public HttpResponseMessage GetValidationData(Int32? IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.FileHeaderValidationData result = Dal.FileHeader.GetValidationData(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("UsaAdjuntos")]
        [HttpGet]
        public HttpResponseMessage UsedAttached(Int32? IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileHeader.UseAttached(IdFileHeader);
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
