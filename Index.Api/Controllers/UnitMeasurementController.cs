using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("UnidadMedida")]
    public class UnitMeasurementController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.UnitMeasurement model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.UnitMeasurement.Add(model);
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
        public HttpResponseMessage Update(Commons.UnitMeasurement model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.UnitMeasurement.Update(model);
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
        public HttpResponseMessage Delete(Commons.UnitMeasurement model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.UnitMeasurement.Delete(model);
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
        public HttpResponseMessage Get(Int32? IdUnitMeasurement)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.UnitMeasurement> result = Dal.UnitMeasurement.Get(IdUnitMeasurement);
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
