using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Dashboard")]
    public class DashboardController : ApiController
    {
        [Route("Cliente")]
        [HttpGet]
        public HttpResponseMessage GetCustomer(Int32 IdCustomer)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.Dashboard.Customer result = Dal.Dashboard.GetCustomer(IdCustomer);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Expirados")]
        [HttpGet]
        public HttpResponseMessage GetExpired(Int32 IdCustomer, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.Dashboard.Expired result = Dal.Dashboard.GetExpired(IdCustomer, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Expirados/Detalle")]
        [HttpGet]
        public HttpResponseMessage GetExpiredDetail(Int32 IdCustomer, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Dashboard.ExpiredDetail> result = Dal.Dashboard.GetExpiredDetail(IdCustomer, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Transmitidos")]
        [HttpGet]
        public HttpResponseMessage GetTransmited(Int32 IdCustomer, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Commons.Dashboard.Transmited result = Dal.Dashboard.GetTransmited(IdCustomer, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Transmitidos/Detalle")]
        [HttpGet]
        public HttpResponseMessage GetTransmitedDetail(Int32 IdCustomer, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Dashboard.TransmitedDetail> result = Dal.Dashboard.GetTransmitedDetail(IdCustomer, IdAccount);
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
