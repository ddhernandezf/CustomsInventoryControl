using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Collections.Generic;
using System.Linq;

namespace Index.Api.Controllers
{
    [RoutePrefix("Rol")]
    public class RoleController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.Role model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Role.Add(model);
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
        public HttpResponseMessage Update(Commons.Role model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Role.Update(model);
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
        public HttpResponseMessage Delete(Commons.Role model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Role.Delete(model);
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
        public HttpResponseMessage NewAssignment(Commons.RoleAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Role.AddUserToRole(model.UserName, model.IdRole,model.RegisterUser);
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
        public HttpResponseMessage DeleteAssignment(Commons.RoleAssignment model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Role.DeleteUserToRole(model.UserName, model.IdRole);
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
        public HttpResponseMessage Get(Int32? IdRole)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Role> result = Dal.Role.Get(IdRole);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarPorUsuario")]
        [HttpGet]
        public HttpResponseMessage GetByUser(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.UserByRole> result = Dal.Role.Get(UserName);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarPorUsuarioParaAsignar")]
        [HttpGet]
        public HttpResponseMessage GetByUserToAssign(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.UserByRole> result = Dal.Role.GetToAssign(UserName);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarAsignados")]
        [HttpGet]
        public HttpResponseMessage GetAssigned(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.UserByRole> result = Dal.Role.Get(UserName).Where(x=>x.RoleAssigned == true).ToList();
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
