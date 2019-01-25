using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Linq;

namespace Index.Api.Controllers
{
    [RoutePrefix("Documento")]
    public class FileInfoController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.FileInfo model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.Add(model);
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
        public HttpResponseMessage Update(Commons.FileInfo model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.Update(model);
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
        public HttpResponseMessage Delete(Commons.FileInfo model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.Delete(model);
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
        public HttpResponseMessage Get(Int32? IdFileInfo)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileInfo> result = Dal.FileInfo.Get(IdFileInfo);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/TiposDocumento")]
        [HttpGet]
        public HttpResponseMessage GetFileInfoType()
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileInfoType> result = Dal.FileInfo.GetFileTypes();

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Configuracion/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddConfig(Commons.FileInfoConfig model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.AddConfig(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Configuracion/Modificar")]
        [HttpPost]
        public HttpResponseMessage UpdateConfig(Commons.FileInfoConfig model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.UpdateConfig(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Configuracion/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteConfig(Commons.FileInfoConfig model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.DeleteConfig(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Configuracion/Listar")]
        [HttpGet]
        public HttpResponseMessage GetConfig(Int32? IdFileInfoConfig, Int32? IdFileInfo, Int32? IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileInfoConfig> result = Dal.FileInfo.GetConfig(IdFileInfoConfig, IdFileInfo, IdAccount);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Configuracion/ValidarActivo")]
        [HttpGet]
        public HttpResponseMessage ValidateConfigActive(Int32 IdFileInfoConfig)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.FileInfo.ValidateConfigActive(IdFileInfoConfig);

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
