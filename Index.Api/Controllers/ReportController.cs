using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Index.Commons.Reports;
using Index.Dal.REPORTS;
namespace Index.Api.Controllers
{
    [RoutePrefix("Reporte")]
    public class ReportController : ApiController
    {
        [Route("DeclaracionJuradaUno")]
        [HttpGet]
        public HttpResponseMessage GetSwornDeclarationOne(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<SwornDeclarationOne> result = SwornDeclaration.GetOne(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DeclaracionJuradaGerencial")]
        [HttpGet]
        public HttpResponseMessage GetSwornDeclarationTwo(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<SwornDeclarationOne> result = SwornDeclaration.GetOne(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Declaraciones/Documento")]
        [HttpGet]
        public HttpResponseMessage GetSwornDeclarationHeader(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String IdDocument)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeader> result = SwornDeclaration.GetHeader(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, IdDocument);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Declaraciones/Detalle")]
        [HttpGet]
        public HttpResponseMessage GetSwornDeclarationDetail(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileDetail> result = SwornDeclaration.GetDetail(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited,IdFileHeader);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DetalleDescargo")]
        [HttpGet]
        public HttpResponseMessage GetDischargeDetail(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.DischargeDetail> result = Index.Dal.REPORTS.DischargeDetail.Get(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("DetalleExportacion")]
        [HttpGet]
        public HttpResponseMessage GetExportationDetail(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.DischargeDetail> result = Index.Dal.REPORTS.DischargeDetail.Get(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListaImportacion")]
        [HttpGet]
        public HttpResponseMessage GetImportationList(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.DischargeDetail> result = Index.Dal.REPORTS.DischargeDetail.Get(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Descargo/Documento")]
        [HttpGet]
        public HttpResponseMessage GetDischargeHeader(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String IdDocument)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileHeader> result = Index.Dal.REPORTS.DischargeDetail.GetHeader(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, IdDocument);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Descargo/Detalle")]
        [HttpGet]
        public HttpResponseMessage GetDischargeDetail(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, Int32 IdFileHeader)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Commons.FileDetail> result = Index.Dal.REPORTS.DischargeDetail.GetDetail(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, IdFileHeader);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("Formula")]
        [HttpGet]
        public HttpResponseMessage GetFormula(Int32 IdCustomer, Int32 IdAccount, Int32? IdMainItem)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.FormulaReport> result = Index.Dal.REPORTS.FormulaReport.Get(IdCustomer, IdAccount, IdMainItem);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListaItem")]
        [HttpGet]
        public HttpResponseMessage GetItem(Int32 IdCustomer, Int32 IdAccount, Boolean? Product)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.ItemReport> result = Index.Dal.REPORTS.ItemReport.Get(IdCustomer, IdAccount, Product);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListaExportacion")]
        [HttpGet]
        public HttpResponseMessage GetExportList(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.ExportList> result = Index.Dal.REPORTS.ExportList.Get(IdCustomer, IdAccount, StartDate, EndDate,GetTransmited);

                respuesta = Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                respuesta = Request.CreateErrorResponse(HttpStatusCode.Conflict, (ex.InnerException == null) ? ex.Message : ex.InnerException.Message);
            }
            return respuesta;
        }

        [Route("ListaCongelado")]
        [HttpGet]
        public HttpResponseMessage GetFrozenList(Int32 IdCustomer, Int32 IdAccount, DateTime? StartDate, DateTime? EndDate)
        {
            HttpResponseMessage respuesta = null;
            try
            {
                List<Index.Commons.Reports.FrozenList> result = Index.Dal.REPORTS.FrozenList.Get(IdCustomer, IdAccount, StartDate, EndDate);

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
