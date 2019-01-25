using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Descargo")]
    public class ItemDischargeController : ApiController
    {
        [Route("Listar/Parametros")]
        [HttpGet]
        public HttpResponseMessage GetParameters(Int32 IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.DischargeParameters result = Dal.ItemDischarge.GetParameters(IdFileDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Materias")]
        [HttpGet]
        public HttpResponseMessage GetRawMaterial(Int32 IdFileDetail, Int32 IdAccount, Int32 IdCustomer, Int32 IdItem, Boolean UseFormula)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.DischargeRawMaterial> result = Dal.ItemDischarge.GetRawMaterials(IdFileDetail, IdAccount, IdCustomer, IdItem, UseFormula);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Transacciones")]
        [HttpGet]
        public HttpResponseMessage GetTransactions(Int32 IdFileDetail, Int32 IdItem, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.DischargeTransaction> result = Dal.ItemDischarge.GetTransactions(IdFileDetail, IdItem, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Resumen")]
        [HttpGet]
        public HttpResponseMessage GetResume(Int32 IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.DischargeResume> result = Dal.ItemDischarge.GetResume(IdFileDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Contador/Resumen")]
        [HttpGet]
        public HttpResponseMessage GetResumeCounter(Int32 IdFileDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Int32 result = Dal.ItemDischarge.GetResumeCounter(IdFileDetail);
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
