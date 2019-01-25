using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Index.Api.Controllers
{
    [RoutePrefix("Cliente")]
    public class CustomerController : ApiController
    {
        [Route("Nuevo")]
        [HttpPost]
        public HttpResponseMessage Add(Commons.Customer model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.Add(model);
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
        public HttpResponseMessage Update(Commons.Customer model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.Update(model);
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
        public HttpResponseMessage Delete(Commons.Customer model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.Delete(model);
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
        public HttpResponseMessage GetCustomer(Int32? IdCustomer)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Customer> result = Dal.Customer.Get(IdCustomer);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListarPorUsuarios")]
        [HttpGet]
        public HttpResponseMessage GetCustomerByUser(Int32? IdCustomer, String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Customer> result = Dal.Customer.GetCustomerByUser(IdCustomer, UserName);
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
        public HttpResponseMessage GetCustomerAssigned(String UserName, Int32? IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Customer> result = Dal.Customer.GetCustomerAssigned(UserName, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Asignar")]
        [HttpGet]
        public HttpResponseMessage GetCustomerToAssign(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.CustomerToAssign> result = Dal.Customer.GetCustomerToAssign(UserName);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/Cuentas")]
        [HttpGet]
        public HttpResponseMessage GetCustomerAccount(String UserName)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.Account> result = Dal.Customer.GetCustomerAccount(UserName);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Listar/CuentasAsignadas")]
        [HttpGet]
        public HttpResponseMessage GetCustomerAccountAssigned(Int32 IdCustomer)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.AccountToAssign> result = Dal.Customer.GetCustomerAccountAssigned(IdCustomer);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Cuentas/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddCustomerAccount(Commons.CustomerAccount model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.AddCustomerAccount(model.IdCustomer, model.IdAccount, model.RegisterUser);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Cuentas/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteCustomerAccount(Commons.CustomerAccount model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.DeleteCustomerAccount(model.IdCustomer, model.IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Cuentas/Informacion")]
        [HttpGet]
        public HttpResponseMessage GetCustomerAccountData(Int32 IdCustomer, Int32 IdAccount)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.CustomerAccountData> result = Dal.Customer.GetCustomerAccountData(IdCustomer, IdAccount);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Cuentas/ActualizarInformacion")]
        [HttpPost]
        public HttpResponseMessage UpdateCustomerAccountData(Commons.CustomerAccountData model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.UpdateCustomerAccountData(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Usuarios/Nuevo")]
        [HttpPost]
        public HttpResponseMessage AddCustomerUser(Commons.CustomerUser model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.AddCustomerUser(model);
                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Usuarios/Eliminar")]
        [HttpPost]
        public HttpResponseMessage DeleteCustomerUser(Commons.CustomerUser model)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                Boolean result = Dal.Customer.DeleteCustomerUser(model);
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
