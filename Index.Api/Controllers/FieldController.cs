using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Campo")]
    public class FieldController : ApiController
    {
        [Route("Maestro/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddMaster(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.AddMaster(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Maestro/Modificar")]
        [HttpPost]
        public HttpResponseMessage UpdateMaster(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.UpdateMaster(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Maestro/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteMaster(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.DeleteMaster(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Maestro/Listar")]
        [HttpGet]
        public HttpResponseMessage GetMaster(Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Field> result = Dal.Field.GetMaster(IdFileInfoConfig);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Detalle/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddDetail(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.AddDetail(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Detalle/Modificar")]
        [HttpPost]
        public HttpResponseMessage UpdateDetail(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.UpdateDetail(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Detalle/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteDetail(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.DeleteDetail(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Detalle/Listar")]
        [HttpGet]
        public HttpResponseMessage GetDetail(Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Field> result = Dal.Field.GetDetail(IdFileInfoConfig);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Adjunto/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddAttached(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.AddAttached(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Adjunto/Modificar")]
        [HttpPost]
        public HttpResponseMessage UpdateAttached(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.UpdateAttached(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Adjunto/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteAttached(Commons.Field model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Field.DeleteAttached(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Adjunto/Listar")]
        [HttpGet]
        public HttpResponseMessage GetAttached(Int32? IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Field> result = Dal.Field.GetAttached(IdFileInfoConfig);
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
