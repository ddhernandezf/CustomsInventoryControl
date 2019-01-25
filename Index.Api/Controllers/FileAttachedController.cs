using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Adjunto")]
    public class FileAttachedController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.FileAttached model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileAttached.Add(model);
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
        public HttpResponseMessage Update(Commons.FileAttached model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileAttached.Update(model);
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
        public HttpResponseMessage Delete(Commons.FileAttached model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileAttached.Delete(model);
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
                Boolean result = Dal.FileAttached.IsFieldsExists(IdFileInfoConfig);
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
        public HttpResponseMessage Get(Int32? IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileAttached> result = Dal.FileAttached.Get(IdFileHeader);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Proveedor")]
        [HttpGet]
        public HttpResponseMessage GetSupplier(Boolean IsDestinyCustomer)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Supplier> result = Dal.Supplier.Get(null, IsDestinyCustomer);

                result.ForEach(x =>
                {
                    x.CompleteName = x.FirstName + ((x.LastName == null) ? "" : " " + x.LastName);
                });

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
