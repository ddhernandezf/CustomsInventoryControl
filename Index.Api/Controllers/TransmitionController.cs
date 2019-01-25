using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Index.Commons.Transmition;

namespace Index.Api.Controllers
{
    [RoutePrefix("Transmision")]
    public class TransmitionController : ApiController
    {
        [Route("FiltrarData")]
        [HttpGet]
        public HttpResponseMessage GetData(Int32 IdCustomer, Int32 IdAccount, Boolean UseRegisterDate, DateTime StartDate, DateTime EndDate)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<OpaDetail> result = Dal.TRANSMITION.Detail.GetData(IdCustomer, IdAccount, UseRegisterDate, StartDate, EndDate);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("FiltrarDataPorIds")]
        [HttpPost]
        public HttpResponseMessage GetDataByIds(List<String> data)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                String FileItemDischargeIds = "";
                foreach (String item in data)
                {
                    FileItemDischargeIds = FileItemDischargeIds + item + ",";
                }

                List<OpaDetail> result = Dal.TRANSMITION.Detail.GetDataByIds(FileItemDischargeIds);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("FiltrarCola")]
        [HttpGet]
        public HttpResponseMessage GetDataQueue(Int32? IdCustomer, Int32? IdAccount, String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<OpaHeader> result = Dal.TRANSMITION.Detail.GetOpaHeader(IdCustomer, IdAccount, null, null, UserName);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("FiltrarTransmitido")]
        [HttpGet]
        public HttpResponseMessage GetDataTransmited(Int32? IdCustomer, Int32? IdAccount, String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<OpaHeader> result = Dal.TRANSMITION.Detail.GetOpaHeader(IdCustomer, IdAccount, null, 10, UserName);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Detalle")]
        [HttpGet]
        public HttpResponseMessage GetDataTransmited(Int32 IdOpaHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<OpaDetail> result = Dal.TRANSMITION.Detail.GetOpaDetail(IdOpaHeader);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("GuardarEnCola")]
        [HttpPost]
        public HttpResponseMessage SaveToQueue(OpaQueue model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.SaveToQueue(model.IdCustomer, model.IdAccount, model.IdPriority, model.StartDate, model.EndDate,
                    model.UserName, model.data);
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
        public HttpResponseMessage Delete(OpaHeader model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.Delete(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("EliminarItem")]
        [HttpGet]
        public HttpResponseMessage DeleteItem(Int32 IdOpaDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.DeleteItem(IdOpaDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("EliminarErroneos")]
        [HttpGet]
        public HttpResponseMessage DeleteWithErrors(Int32 IdOpaHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.DeleteWithErrors(IdOpaHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ReEncolarItem")]
        [HttpGet]
        public HttpResponseMessage ReproccessItem(Int32 IdOpaDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.ReproccessItem(IdOpaDetail);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ReEncolarBatch")]
        [HttpGet]
        public HttpResponseMessage ReproccessBatch(Int32 IdOpaHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.TRANSMITION.Detail.ReproccessBatch(IdOpaHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ValidarEmail")]
        [HttpGet]
        public HttpResponseMessage ValidateEmail(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                EmailResponse result = Dal.TRANSMITION.Detail.ValidateEmail(UserName);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DetalleMensajes")]
        [HttpGet]
        public HttpResponseMessage GetMessageDetail(Int32 IdOpaDetail)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<OpaMessageDetail> result = Dal.TRANSMITION.Detail.GetMessageDetail(IdOpaDetail);

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
