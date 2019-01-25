using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Permisos")]
    public class PremissionController : ApiController
    {
        [Route("Listar")]
        [HttpGet]
        public HttpResponseMessage Get(Int32 IdRole)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Premission> result = Dal.Premission.Get(IdRole);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Asignacion/Nuevo")]
        [HttpPost]
        public HttpResponseMessage NewAssignment(Commons.PremissionAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Premission.AddRoleToPremission(model.IdRole, model.IdPremission, model.RegisterUser);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Asignacion/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteAssignment(Commons.PremissionAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Premission.DeleteRoleToPremision(model.IdRole, model.IdPremission);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarPorRol")]
        [HttpGet]
        public HttpResponseMessage GetByRole(Int32 IdRole)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.PremissionTree> result = Dal.Premission.getTree(IdRole);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Validar")]
        [HttpGet]
        public HttpResponseMessage Validate(String UserName, String RoleName, String PremissionName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean? result = Dal.Premission.Validate(UserName, RoleName, PremissionName);
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
