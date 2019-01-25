using Index.Commons;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class ReportesController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult BlankReport()
        {
            return View();
        }

        public ActionResult DeclaracionConstancia()
        {
            return View();
        }

        public JsonResult DeclaracionConstanciaData(DateTime StartDate, DateTime EndDate, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.SwornDeclarationOne data = new Functionalities.Reportes.SwornDeclarationOne(Server.MapPath("~\\CRfiles\\DeclaracionConstancia.rpt"),
                            Server.MapPath("~\\ReportFiles\\DeclaracionConstancia"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DeclaracionConstancia"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, null, null, GetImpExpCode(customer), customer.Nit, customer.LegalRepresentative,
                            cadata.ResolutionRate, cadata.ResolutionStartDate, cadata.ResolutionEndDate, null, FileHeaderList, FileDetailList, UseFreeze);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeclaracionJuradaUno()
        {
            return View();
        }

        public JsonResult DeclaracionJuradaUnoData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.SwornDeclarationOne data = new Functionalities.Reportes.SwornDeclarationOne(Server.MapPath("~\\CRfiles\\DeclaracionJurada1.rpt"),
                            Server.MapPath("~\\ReportFiles\\DeclaracionJuradaUno"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DeclaracionJuradaUno"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, null, null, GetImpExpCode(customer), customer.Nit, customer.LegalRepresentative,
                            cadata.ResolutionRate, cadata.ResolutionStartDate, cadata.ResolutionEndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeclaracionJuradaDos()
        {
            return View();
        }

        public JsonResult DeclaracionJuradaDosData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.SwornDeclarationTwo data = new Functionalities.Reportes.SwornDeclarationTwo(Server.MapPath("~\\CRfiles\\DeclaracionJurada2.rpt"),
                            Server.MapPath("~\\ReportFiles\\DeclaracionJuradaDos"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DeclaracionJuradaDos"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, null, null, GetImpExpCode(customer), customer.Nit,
                            cadata.ResolutionRate, cadata.ResolutionStartDate, cadata.ResolutionEndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeclaracionJuradaGerencial()
        {
            return View();
        }

        public JsonResult DeclaracionJuradaGerencialData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.SwornDeclarationTwo data = new Functionalities.Reportes.SwornDeclarationTwo(Server.MapPath("~\\CRfiles\\DeclaracionJuradaGerencial.rpt"),
                            Server.MapPath("~\\ReportFiles\\DeclaracionJuradaGerencial"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DeclaracionJuradaGerencial"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, null, null, GetImpExpCode(customer), customer.Nit,
                            cadata.ResolutionRate, cadata.ResolutionStartDate, cadata.ResolutionEndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DeclaracionesFiltro(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited)
        {
            ViewBag.StarDate = StartDate.ToString("yyyy-MM-dd");
            ViewBag.EndDate = EndDate.ToString("yyyy-MM-dd");
            ViewBag.GetTransmited = GetTransmited;

            Session["StarDate"] = StartDate.ToString("yyyy-MM-dd");
            Session["EndDate"] = EndDate.ToString("yyyy-MM-dd");
            Session["GetTransmited"] = GetTransmited;

            return View();
        }
        
        public ActionResult DeclaracionesFiltroReadDetail([DataSourceRequest] DataSourceRequest request, Int32 IdFileHeader)
        {
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            if (customer != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/Declaraciones/Detalle", "IdCustomer=" + customer.Id
                                                                                                        + "&IdAccount=" + cuenta.Id
                                                                                                        + "&StartDate=" + Session["StarDate"]
                                                                                                        + "&EndDate=" + Session["EndDate"]
                                                                                                        + "&GetTransmited=" + Session["GetTransmited"]
                                                                                                        + "&IdFileHeader=" + IdFileHeader)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return new JsonResult()
                    {
                        Data = JArray.Parse(WSR.Content).ToObject<List<FileDetail>>().ToDataSourceResult(request),
                        ContentType = "json",
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                        MaxJsonLength = Int32.MaxValue
                    };
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public JsonResult JsonDeclaracionesFiltroHeader(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String IdDocument)
        {
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            if (customer != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/Declaraciones/Documento", "IdCustomer=" + customer.Id
                                                                                                        + "&IdAccount=" + cuenta.Id
                                                                                                        + "&StartDate=" + StartDate.ToString("yyyy-MM-dd")
                                                                                                        + "&EndDate=" + EndDate.ToString("yyyy-MM-dd")
                                                                                                        + "&GetTransmited=" + GetTransmited
                                                                                                        + "&IdDocument=" + IdDocument)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return new JsonResult()
                    {
                        Data = JArray.Parse(WSR.Content).ToObject<List<FileHeader>>(),
                        ContentType = "json",
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                        MaxJsonLength = Int32.MaxValue
                    };
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public ActionResult DescargosFiltro(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited)
        {
            ViewBag.StarDate = StartDate.ToString("yyyy-MM-dd");
            ViewBag.EndDate = EndDate.ToString("yyyy-MM-dd");
            ViewBag.GetTransmited = GetTransmited;

            Session["StarDate"] = StartDate.ToString("yyyy-MM-dd");
            Session["EndDate"] = EndDate.ToString("yyyy-MM-dd");
            Session["GetTransmited"] = GetTransmited;

            return View();
        }

        public JsonResult JsonDescargosFiltroHeader(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String IdDocument)
        {
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            if (customer != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/Descargo/Documento", "IdCustomer=" + customer.Id
                                                                                                        + "&IdAccount=" + cuenta.Id
                                                                                                        + "&StartDate=" + StartDate.ToString("yyyy-MM-dd")
                                                                                                        + "&EndDate=" + EndDate.ToString("yyyy-MM-dd")
                                                                                                        + "&GetTransmited=" + GetTransmited
                                                                                                        + "&IdDocument=" + IdDocument)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return new JsonResult()
                    {
                        Data = JArray.Parse(WSR.Content).ToObject<List<FileHeader>>(),
                        ContentType = "json",
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                        MaxJsonLength = Int32.MaxValue
                    };
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public ActionResult DescargosFiltroReadDetail([DataSourceRequest] DataSourceRequest request, Int32 IdFileHeader)
        {
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            if (customer != null)
            {
                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/Descargo/Detalle", "IdCustomer=" + customer.Id
                                                                                                        + "&IdAccount=" + cuenta.Id
                                                                                                        + "&StartDate=" + Session["StarDate"]
                                                                                                        + "&EndDate=" + Session["EndDate"]
                                                                                                        + "&GetTransmited=" + Session["GetTransmited"]
                                                                                                        + "&IdFileHeader=" + IdFileHeader)).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    return new JsonResult()
                    {
                        Data = JArray.Parse(WSR.Content).ToObject<List<FileDetail>>().ToDataSourceResult(request),
                        ContentType = "json",
                        JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                        MaxJsonLength = Int32.MaxValue
                    };
                }
                else
                {
                    return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
                }
            }
            else
            {
                return Json(new DataSourceResult { Errors = "No cuenta con clientes asignados" });
            }
        }

        public ActionResult ListaExportacion()
        {
            return View();
        }

        public JsonResult ListaExportacionData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.ExportList data = new Functionalities.Reportes.ExportList(Server.MapPath("~\\CRfiles\\ListaExportacion.rpt"),
                            Server.MapPath("~\\ReportFiles\\ListaExportacion"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\ListaExportacion"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, GetTransmited);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListaImportacion()
        {
            return View();
        }

        public JsonResult ListaImportacionData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            String response = null;
            Commons.Customer customer = new ClienteController().GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];

            Functionalities.Reportes.ImportationList data = new Functionalities.Reportes.ImportationList(Server.MapPath("~\\CRfiles\\ListaImportacion.rpt"),
                            Server.MapPath("~\\ReportFiles\\ListaImportacion"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\ListaImportacion"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, GetTransmited, FileHeaderList,FileDetailList);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Formulas()
        {
            return View();
        }

        public JsonResult FormulasData(Int32? IdProduct)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.FormulaReport data = new Functionalities.Reportes.FormulaReport(Server.MapPath("~\\CRfiles\\Formulas.rpt"),
                            Server.MapPath("~\\ReportFiles\\Formulas"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\Formulas"));
            response = data.Generate(customer.Id, cuenta.Id, IdProduct);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListaItem()
        {
            return View();
        }

        public JsonResult ListaItemData(Boolean? IsProduct)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = customerController.GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.ItemReport data = new Functionalities.Reportes.ItemReport(Server.MapPath("~\\CRfiles\\ListaItem.rpt"),
                            Server.MapPath("~\\ReportFiles\\ListaItem"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\ListaItem"));
            response = data.Generate(customer.Id, cuenta.Id, IsProduct);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DetalleDescargo()
        {
            return View();
        }

        public JsonResult DetalleDescargoData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            String response = null;
            Commons.Customer customer = new ClienteController().GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];

            Functionalities.Reportes.DischargeDetail data = new Functionalities.Reportes.DischargeDetail(Server.MapPath("~\\CRfiles\\DetalleDescargos.rpt"),
                            Server.MapPath("~\\ReportFiles\\DetalleDescargos"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DetalleDescargos"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DetalleConstancias()
        {
            return View();
        }

        public JsonResult DetalleConstanciasData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            String response = null;
            Commons.Customer customer = new ClienteController().GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];

            Functionalities.Reportes.DischargeDetail data = new Functionalities.Reportes.DischargeDetail(Server.MapPath("~\\CRfiles\\DetalleConstancias.rpt"),
                            Server.MapPath("~\\ReportFiles\\DetalleConstancias"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DetalleConstancias"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DetalleExportacion()
        {
            return View();
        }

        public JsonResult DetalleExportacionData(DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            String response = null;
            Commons.Customer customer = new ClienteController().GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];

            Functionalities.Reportes.ExportationDetail data = new Functionalities.Reportes.ExportationDetail(Server.MapPath("~\\CRfiles\\DetalleExportacion.rpt"),
                            Server.MapPath("~\\ReportFiles\\DetalleExportacion"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\DetalleExportacion"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListaCongelados()
        {
            return View();
        }

        public JsonResult ListaCongeladosData(DateTime? StartDate, DateTime? EndDate)
        {
            String response = null;
            ClienteController customerController = new ClienteController();
            Commons.Customer customer = new ClienteController().GetCustomer(((Commons.Customer)Session["CUSTOMERINFO"]).Id);
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account cuenta = (Commons.Account)Session["ACCOUNTINFO"];
            Commons.CustomerAccountData cadata = customerController.GetCustomerAccountData(((Commons.Customer)Session["CUSTOMERINFO"]).Id, cuenta.Id).FirstOrDefault();

            Functionalities.Reportes.FrozenReport data = new Functionalities.Reportes.FrozenReport(Server.MapPath("~\\CRfiles\\ListaCongelados.rpt"),
                            Server.MapPath("~\\ReportFiles\\ListaCongelados"), user.UserName, customer.EnterpriseName, Url.Content("~\\ReportFiles\\ListaCongelados"));
            response = data.Generate(customer.Id, cuenta.Id, StartDate, EndDate, null, null, GetImpExpCode(customer), customer.Nit, customer.LegalRepresentative,
                           cadata.ResolutionRate, cadata.ResolutionStartDate, cadata.ResolutionEndDate);

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public ActionResult rptViewer()
        {
            return View();
        }

        public ActionResult Prueba()
        {
            return View();
        }

        private String GetImpExpCode(Commons.Customer model)
        {
            String result = null;

            if (!String.IsNullOrEmpty(model.ExporterCode) && !String.IsNullOrWhiteSpace(model.ExporterCode))
            {
                result = model.ExporterCode;
            }
            else if (!String.IsNullOrEmpty(model.ImporterCode) && !String.IsNullOrWhiteSpace(model.ImporterCode))
            {
                result = model.ImporterCode;
            }
            else
            {
                result = model.PersonCode;
            }

            return result;
        }
    }
}