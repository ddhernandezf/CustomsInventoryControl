using Index.Commons;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using Newtonsoft.Json;
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
    public class TransaccionController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult Index()
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Role role = (Commons.Role)Session["ROLEINFO"];
            ViewBag.Freeze = new PermisosController().Validate(user.UserName, role.Name, "Congelar Saldos");

            if (TempData["ITSOK"] != null)
            {
                Boolean ExecResult = Convert.ToBoolean(TempData["ITSOK"]);
                ViewBag.ItsOk = ExecResult;

                if (!ExecResult)
                {
                    ViewBag.ErrorMsg = TempData["ERRORMSG"].ToString();
                    ViewBag.DataModel = (FileHeader)TempData["DATA"];
                }
            }

            return View();
        }

        public ActionResult Nuevo(Int32 IdFileInfoConfig)
        {
            ViewBag.IdFileInfoConfig = IdFileInfoConfig;
            return View();
        }

        public ActionResult Actualizar(Int32 IdFileHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/Listar", "IdFileHeader=" + IdFileHeader 
                                                                    + "&IdCustomer=null&IdAccount=null&IdFileInfoConfig=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                ViewBag.data = JsonConvert.SerializeObject(JArray.Parse(WSR.Content).ToObject<List<FileHeader>>().FirstOrDefault());
            }

            return View();
        }

        public ActionResult Lista()
        {
            return View();
        }

        public ActionResult Detalle()
        {
            if (Session["IDFILEHEADER"] == null)
            {
                return RedirectToAction("Index", "Transaccion");
            }
            else
            {
                FileHeader data = new FileHeader();
                Customer cliente = (Customer)Session["CUSTOMERINFO"];
                Account cuenta = (Account)Session["ACCOUNTINFO"];
                Int32 IdFileHeader = Convert.ToInt32(Session["IDFILEHEADER"].ToString());
                ViewBag.IdFileHeader = IdFileHeader;
                Commons.User user = (Commons.User)Session["USERINFO"];
                Commons.Role role = (Commons.Role)Session["ROLEINFO"];

                IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/Encabezado", "IdFileHeader=" + IdFileHeader
                                                                        + "&IdFileInfoConfig=null")).Result;
                if (WSR.StatusCode == HttpStatusCode.OK)
                {
                    ViewBag.Header = JArray.Parse(WSR.Content).ToObject<List<FileHeaderDetail>>();
                }

                IRestResponse WSRPARAMS = Task.Run(() => apiClient.getJArray("Encabezado/Listar", "IdFileHeader=" + IdFileHeader
                                                                        + "&IdCustomer=null&IdAccount=null&IdFileInfoConfig=null")).Result;
                if (WSRPARAMS.StatusCode == HttpStatusCode.OK)
                {
                    data = JArray.Parse(WSRPARAMS.Content).ToObject<List<FileHeader>>().FirstOrDefault();
                    ViewBag.HeaderParams = data;
                }

                ViewBag.AdjustmentPremission = new PermisosController().Validate(user.UserName, role.Name, "Eliminar Transmitidos");
                ViewBag.Freeze = new PermisosController().Validate(user.UserName, role.Name, "Congelar Saldos");

                List<Field> fields = getDetailObj(data.IdFileInfoConfig);
                ViewBag.Fields = fields;
                Session["FIELDS"] = fields;

                return View();
            }
        }

        public ActionResult Adjunto(Int32 IdFileHeader, Int32 IdFileInfoConfig, Boolean IsSubstract)
        {
            Session["IDFILEHEADER"] = IdFileHeader;
            Session["ISSUBSTRACT"] = IsSubstract;
            ViewBag.IdFileHeader = IdFileHeader;
            ViewBag.IdFileInfoConfig = IdFileInfoConfig;
            ViewBag.IsSubstract = IsSubstract;
            List<Field> fields = getAttachedObj(IdFileInfoConfig);
            ViewBag.Fields = fields;
            Session["FIELDS"] = fields;

            return View();
        }

        public JsonResult Create(FormCollection frmCol)
        {
            FileHeader data = new FileHeader(), result = new FileHeader();
            try
            {
                Customer cliente = (Customer)Session["CUSTOMERINFO"];
                Account cuenta = (Account)Session["ACCOUNTINFO"];
                data.IdCustomer = cliente.Id;
                data.IdAccount = cuenta.Id;

                foreach (var item in frmCol)
                {
                    String key = item.ToString();
                    var value = frmCol[key];

                    if (value != null)
                    {
                        switch (key)
                        {
                            case "IdFileInfoConfig":
                                data.IdFileInfoConfig = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdDocument":
                                data.IdDocument = frmCol[key].ToString();
                                break;
                            case "AuthorizationDate":
                                data.AuthorizationDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExpantionDate":
                                data.ExpantionDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExpirationDate":
                                data.ExpirationDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "DocumentDate":
                                data.DocumentDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExchangeRate":
                                data.ExchangeRate = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "Insurance":
                                data.Insurance = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "Cargo":
                                data.Cargo = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "IdCountry":
                                data.IdCountry = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCustom":
                                data.IdCustom = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdWarranty":
                                data.IdWarranty = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCurrency":
                                data.IdCurrency = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdResolution":
                                data.IdResolution = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCellar":
                                data.IdCellar = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "ArrivalDAte":
                                data.ArrivalDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "CIFTotal":
                                data.CifTotal = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "LinesTotal":
                                data.LinesTotal = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "Factura":
                                data.Facturas = frmCol[key].ToString();
                                break;
                        }
                    }
                }

                if (data != null && ModelState.IsValid)
                {
                    data.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Encabezado/Nuevo", data)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        result = JObject.Parse(WSR.Content).ToObject<FileHeader>();
                        
                        return Json(result.Id, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(ModelState.Values.SelectMany(x => x.Errors), JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult Update(FormCollection frmCol)
        {
            FileHeader data = new FileHeader(), result = new FileHeader();
            try
            {
                Customer cliente = (Customer)Session["CUSTOMERINFO"];
                Account cuenta = (Account)Session["ACCOUNTINFO"];
                data.IdCustomer = cliente.Id;
                data.IdAccount = cuenta.Id;

                foreach (var item in frmCol)
                {
                    String key = item.ToString();
                    var value = frmCol[key];

                    if (value != null)
                    {
                        switch (key)
                        {
                            case "Id":
                                data.Id = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdFileInfoUpdate":
                                data.IdFileInfoConfig = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdDocument":
                                data.IdDocument = frmCol[key].ToString();
                                break;
                            case "AuthorizationDate":
                                data.AuthorizationDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExpantionDate":
                                data.ExpantionDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExpirationDate":
                                data.ExpirationDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "DocumentDate":
                                data.DocumentDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "ExchangeRate":
                                data.ExchangeRate = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "Insurance":
                                data.Insurance = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "Cargo":
                                data.Cargo = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "IdCountry":
                                data.IdCountry = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCustom":
                                data.IdCustom = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdWarranty":
                                data.IdWarranty = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCurrency":
                                data.IdCurrency = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdResolution":
                                data.IdResolution = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "IdCellar":
                                data.IdCellar = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "ArrivalDAte":
                                data.ArrivalDate = Convert.ToDateTime(frmCol[key].ToString());
                                break;
                            case "CIFTotal":
                                data.CifTotal = Convert.ToDecimal(frmCol[key].ToString());
                                break;
                            case "LinesTotal":
                                data.LinesTotal = Convert.ToInt32(frmCol[key].ToString());
                                break;
                            case "Factura":
                                data.Facturas = frmCol[key].ToString();
                                break;
                        }
                    }
                }

                if (data != null && ModelState.IsValid)
                {
                    data.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Encabezado/Modificar", data)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message, JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(true, JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json(ModelState.Values.SelectMany(x => x.Errors), JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                return Json(ex.Message, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult Delete(Int32 IdFileHeader)
        {
            try
            {
                if (IdFileHeader != 0)
                {
                    FileHeader model = new FileHeader();
                    model.Id = IdFileHeader;
                    IRestResponse WSR = Task.Run(() => apiClient.postObject("Encabezado/Eliminar", model)).Result;
                    if (WSR.StatusCode != HttpStatusCode.OK)
                    {
                        return Json(JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString(), JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json("TRUE", JsonRequestBehavior.AllowGet);
                    }
                }
                else
                {
                    return Json("Registro inválido.", JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                return Json((ex.InnerException == null) ? ex.Message.ToString() : ex.InnerException.Message.ToString(), JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Read([DataSourceRequest] DataSourceRequest request, Int32? IdFileInfoConfig, String IdDocument, DateTime? CreateDate, DateTime? ExpirationDate, DateTime? AuthorizationDate, Boolean GetAll)
        {
            Customer cliente = (Customer)Session["CUSTOMERINFO"];
            Account cuenta = (Account)Session["ACCOUNTINFO"];
            IRestResponse WSR = null;

            if ((IdFileInfoConfig == null || IdFileInfoConfig == 0) &&
                (String.IsNullOrEmpty(IdDocument) || String.IsNullOrWhiteSpace(IdDocument)) &&
                CreateDate == null && ExpirationDate == null && AuthorizationDate == null && GetAll == false)
            {
                WSR = Task.Run(() => apiClient.getJArray("Encabezado/ListarMesActual", "IdFileHeader=null&IdCustomer=" + cliente.Id
                                                                    + "&IdAccount=" + cuenta.Id
                                                                    + "&IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            }
            else if ((IdFileInfoConfig == null || IdFileInfoConfig == 0) &&
            (String.IsNullOrEmpty(IdDocument) || String.IsNullOrWhiteSpace(IdDocument)) &&
            CreateDate == null && ExpirationDate == null && AuthorizationDate == null && GetAll == true)
            {
                WSR = Task.Run(() => apiClient.getJArray("Encabezado/Listar", "IdFileHeader=null&IdCustomer=" + cliente.Id
                                                                    + "&IdAccount=" + cuenta.Id
                                                                    + "&IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            }
            else
            {
                if (IdFileInfoConfig > 0 &&
                    (String.IsNullOrEmpty(IdDocument) || String.IsNullOrWhiteSpace(IdDocument)) &&
                    CreateDate == null && ExpirationDate == null && AuthorizationDate == null && GetAll == false)
                {
                    WSR = Task.Run(() => apiClient.getJArray("Encabezado/ListarMesActual", "IdFileHeader=null&IdCustomer=" + cliente.Id
                                                                    + "&IdAccount=" + cuenta.Id
                                                                    + "&IdFileInfoConfig=" + IdFileInfoConfig)).Result;
                }
                else
                {
                    WSR = Task.Run(() => apiClient.getJArray("Encabezado/ListarFiltrado", "IdFileHeader=null&IdCustomer=" + cliente.Id
                                                                    + "&IdAccount=" + cuenta.Id
                                                                    + "&IdFileInfoConfig=" + IdFileInfoConfig
                                                                    + "&IdDocument=" + IdDocument
                                                                    + "&CreateDate=" + ((CreateDate == null) ? null : Convert.ToDateTime(CreateDate).ToString("yyyy-MM-dd"))
                                                                    + "&ExpirationDate=" + ((ExpirationDate == null) ? null : Convert.ToDateTime(ExpirationDate).ToString("yyyy-MM-dd"))
                                                                    + "&AuthorizationDate=" + ((AuthorizationDate == null) ? null : Convert.ToDateTime(AuthorizationDate).ToString("yyyy-MM-dd")))).Result;
                }
            }

            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<FileHeader> data = JArray.Parse(WSR.Content).ToObject<List<FileHeader>>();

                return Json(data.ToDataSourceResult(request), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        public ActionResult DetalleRead([DataSourceRequest] DataSourceRequest request)
        {
            Int32 IdFileHeader = Convert.ToInt32(Session["IDFILEHEADER"].ToString());

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/Listar", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileDetail>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DetalleCreate([DataSourceRequest] DataSourceRequest request, FileDetail model, FormCollection frmcol)
        {
            model.IdFileHeader = Convert.ToInt32(Session["IDFILEHEADER"].ToString());
            List<Field> fields = (List<Field>)Session["FIELDS"];
            fields.ForEach(x => {
                if (x.IsRequeried)
                {
                    switch (x.DataBaseName)
                    {
                        case "TransactionLine":
                            if (model.TransactionLine == null)
                            {
                                ModelState.AddModelError("TransactionLine", "*");
                            }
                            break;
                        case "IdItem":
                            if (model.IdItem == 0)
                            {
                                ModelState.AddModelError("IdItem", "*");
                            }
                            break;
                        case "ItemQuantity":
                            if (model.Quantity == null)
                            {
                                ModelState.AddModelError("Quantity", "*");
                            }
                            break;
                        case "CIFcostQuetzal":
                            if (model.CIFQ == null)
                            {
                                ModelState.AddModelError("CIFQ", "*");
                            }
                            break;
                        case "FOcostQuetzal":
                            if (model.FOQ == null)
                            {
                                ModelState.AddModelError("FOQ", "*");
                            }
                            break;
                        case "CIFcostDollar":
                            if (model.CIFD == null)
                            {
                                ModelState.AddModelError("CIFD", "*");
                            }
                            break;
                        case "FOcostDollar":
                            if (model.FOD == null)
                            {
                                ModelState.AddModelError("FOD", "*");
                            }
                            break;
                        case "CustomDuties":
                            if (model.CustomDuties == null)
                            {
                                ModelState.AddModelError("CustomDuties", "*");
                            }
                            break;
                        case "Iva":
                            if (model.IVA == null)
                            {
                                ModelState.AddModelError("IVA", "*");
                            }
                            break;
                        case "TaxableBase":
                            if (model.TaxableBase == null)
                            {
                                ModelState.AddModelError("TaxableBase", "*");
                            }
                            break;
                        case "TaxRate":
                            if (model.TaxRate == null)
                            {
                                ModelState.AddModelError("TaxRate", "*");
                            }
                            break;
                        case "NetWeight":
                            if (model.NetWeight == null)
                            {
                                ModelState.AddModelError("NetWeight", "*");
                            }
                            break;
                        case "GrossWeight":
                            if (model.GrossWeight == null)
                            {
                                ModelState.AddModelError("GrossWeight", "*");
                            }
                            break;
                    }
                }
            });

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Detalle/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DetalleUpdate([DataSourceRequest] DataSourceRequest request, FileDetail model)
        {
            model.IdFileHeader = Convert.ToInt32(Session["IDFILEHEADER"].ToString());
            List<Field> fields = (List<Field>)Session["FIELDS"];
            fields.ForEach(x => {
                if (x.IsRequeried)
                {
                    switch (x.DataBaseName)
                    {
                        case "TransactionLine":
                            if (model.TransactionLine == null)
                            {
                                ModelState.AddModelError("TransactionLine", "*");
                            }
                            break;
                        case "IdItem":
                            if (model.IdItem == 0)
                            {
                                ModelState.AddModelError("IdItem", "*");
                            }
                            break;
                        case "ItemQuantity":
                            if (model.Quantity == null)
                            {
                                ModelState.AddModelError("Quantity", "*");
                            }
                            break;
                        case "CIFcostQuetzal":
                            if (model.CIFQ == null)
                            {
                                ModelState.AddModelError("CIFQ", "*");
                            }
                            break;
                        case "FOcostQuetzal":
                            if (model.FOQ == null)
                            {
                                ModelState.AddModelError("FOQ", "*");
                            }
                            break;
                        case "CIFcostDollar":
                            if (model.CIFD == null)
                            {
                                ModelState.AddModelError("CIFD", "*");
                            }
                            break;
                        case "FOcostDollar":
                            if (model.FOD == null)
                            {
                                ModelState.AddModelError("FOD", "*");
                            }
                            break;
                        case "CustomDuties":
                            if (model.CustomDuties == null)
                            {
                                ModelState.AddModelError("CustomDuties", "*");
                            }
                            break;
                        case "Iva":
                            if (model.IVA == null)
                            {
                                ModelState.AddModelError("IVA", "*");
                            }
                            break;
                        case "TaxableBase":
                            if (model.TaxableBase == null)
                            {
                                ModelState.AddModelError("TaxableBase", "*");
                            }
                            break;
                        case "TaxRate":
                            if (model.TaxRate == null)
                            {
                                ModelState.AddModelError("TaxRate", "*");
                            }
                            break;
                        case "NetWeight":
                            if (model.NetWeight == null)
                            {
                                ModelState.AddModelError("NetWeight", "*");
                            }
                            break;
                        case "GrossWeight":
                            if (model.GrossWeight == null)
                            {
                                ModelState.AddModelError("GrossWeight", "*");
                            }
                            break;
                    }
                }
            });

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Detalle/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult DetalleDelete([DataSourceRequest] DataSourceRequest request, FileDetail model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Detalle/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult AdjuntoRead([DataSourceRequest] DataSourceRequest request)
        {
            Int32 IdFileHeader = (Int32)Session["IDFILEHEADER"];

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Adjunto/Listar", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<FileAttached>>().ToDataSourceResult(request));
            }
            else
            {
                return Json(new DataSourceResult { Errors = JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString() });
            }
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AdjuntoCreate([DataSourceRequest] DataSourceRequest request, FileAttached model, FormCollection frmcol)
        {
            List<Field> fields = (List<Field>)Session["FIELDS"];
            
            fields.ForEach(x => {
                if (x.IsRequeried)
                {
                    switch (x.DataBaseName)
                    {
                        case "Description":
                            if (String.IsNullOrEmpty(model.Description) || String.IsNullOrWhiteSpace(model.Description))
                            {
                                ModelState.AddModelError("Description", "*");
                            }
                            break;
                        case "AttachedNumber":
                            if (String.IsNullOrEmpty(model.AttachedNumber) || String.IsNullOrWhiteSpace(model.AttachedNumber))
                            {
                                ModelState.AddModelError("AttachedNumber", "*");
                            }
                            break;
                        case "AttachedDate":
                            if (String.IsNullOrEmpty(frmcol["AttachedDate"].ToString()) || String.IsNullOrWhiteSpace(frmcol["AttachedDate"].ToString()))
                            {
                                ModelState.AddModelError("AttachedDate", "*");
                            }
                            else
                            {
                                model.AttachedDate = Convert.ToDateTime(frmcol["AttachedDate"].ToString().Substring(0, 10));
                                ModelState.Clear();
                            }

                            if (model.AttachedDate == null)
                            {
                                ModelState.AddModelError("AttachedDate", "*");
                            }
                            break;
                        case "IdSupplier":
                            if (model.IdSupplier == null)
                            {
                                ModelState.AddModelError("IdSupplier", "*");
                            }
                            break;
                    }
                }
            });

            model.IdFileHeader = (Int32)Session["IDFILEHEADER"];
            model.IdSupplier = (model.IdSupplier == null) ? Convert.ToInt32(frmcol["IdSupplierOrDestiny.Id"]) : ((model.IdSupplier == 0) ? Convert.ToInt32(frmcol["IdSupplierOrDestiny.Id"]) : model.IdSupplier);

            //if (model.IdSupplier == 0 || model.IdSupplier == null) {
            //    ModelState.AddModelError("IdSupplier", "*");
            //}
            
            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Adjunto/Nuevo", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AdjuntoUpdate([DataSourceRequest] DataSourceRequest request, FileAttached model, FormCollection frmcol)
        {
            List<Field> fields = (List<Field>)Session["FIELDS"];

            if (String.IsNullOrEmpty(frmcol["AttachedDate"].ToString()) || String.IsNullOrWhiteSpace(frmcol["AttachedDate"].ToString()))
            {
                ModelState.AddModelError("RateDate", "Formato de fecha incorrecta");
            }
            else
            {
                model.AttachedDate = Convert.ToDateTime(frmcol["AttachedDate"].ToString().Substring(0, 10));
                ModelState.Clear();
            }

            fields.ForEach(x => {
                if (x.IsRequeried)
                {
                    switch (x.DataBaseName)
                    {
                        case "Description":
                            if (String.IsNullOrEmpty(model.Description) || String.IsNullOrWhiteSpace(model.Description))
                            {
                                ModelState.AddModelError("Description", "*");
                            }
                            break;
                        case "AttachedNumber":
                            if (String.IsNullOrEmpty(model.AttachedNumber) || String.IsNullOrWhiteSpace(model.AttachedNumber))
                            {
                                ModelState.AddModelError("AttachedNumber", "*");
                            }
                            break;
                        case "AttachedDate":
                            if (model.AttachedDate == null)
                            {
                                ModelState.AddModelError("AttachedDate", "*");
                            }
                            break;
                    }
                }
            });

            model.IdFileHeader = (Int32)Session["IDFILEHEADER"];
            model.IdSupplier = (model.IdSupplier == null) ? Convert.ToInt32(frmcol["IdSupplierOrDestiny.Id"]) : ((model.IdSupplier == 0) ? Convert.ToInt32(frmcol["IdSupplierOrDestiny.Id"]) : model.IdSupplier);

            if (model.IdSupplier == 0 || model.IdSupplier == null)
            {
                ModelState.AddModelError("IdSupplier", "*");
            }

            if (model != null && ModelState.IsValid)
            {
                model.RegisterUser = ((Commons.User)Session["USERINFO"]).UserName;
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Adjunto/Modificar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult AdjuntoDelete([DataSourceRequest] DataSourceRequest request, FileAttached model)
        {
            if (model != null && ModelState.IsValid)
            {
                IRestResponse WSR = Task.Run(() => apiClient.postObject("Adjunto/Eliminar", model)).Result;
                if (WSR.StatusCode != HttpStatusCode.OK)
                {
                    ModelState.AddModelError("errorGeneral", JObject.Parse(WSR.Content).ToObject<Error>().Message.ToString());
                }
            }

            return Json(new[] { model }.ToDataSourceResult(request, ModelState));
        }

        public JsonResult getMaster(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Maestro/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Field> data = JArray.Parse(WSR.Content).ToObject<List<Field>>().ToList();
                if (data.Where(y => y.IdMaster != 0).ToList().Count == 0)
                {
                    return Json(data.Where(y => y.IdMaster != 0).Select(x => new {
                        Id = x.Id,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdMaster = x.IdMaster,
                        DataBaseName = x.DataBaseName,
                        Label = (String.IsNullOrEmpty(x.Label)) ? x.FieldName : x.Label,
                        IsUsed = (x.IsRequeriedInternal == true) ? true : x.IsUsed,
                        IsRequeried = (x.IsRequeriedInternal == true) ? true : x.IsRequeried,
                        ObjectHtml = x.HtmlObject
                    }).ToList(), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(data.Where(y => y.IdMaster != 0 || y.IsRequeriedInternal == true).Select(x => new {
                        Id = x.Id,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdMaster = x.IdMaster,
                        DataBaseName = x.DataBaseName,
                        Label = (String.IsNullOrEmpty(x.Label)) ? x.FieldName : x.Label,
                        IsUsed = (x.IsRequeriedInternal == true) ? true : x.IsUsed,
                        IsRequeried = (x.IsRequeriedInternal == true) ? true : x.IsRequeried,
                        ObjectHtml = x.HtmlObject
                    }).ToList(), JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return null;
            }
        }

        public JsonResult getDetail(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Detalle/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Field>>().Where(y => y.IdMaster != 0).Select(x => new {
                    Id = x.Id,
                    IdFileInfoConfig = x.IdFileInfoConfig,
                    IdMaster = x.IdMaster,
                    DataBaseName = x.DataBaseName,
                    Label = (String.IsNullOrEmpty(x.Label)) ? x.FieldName : x.Label,
                    IsUsed = (x.IsRequeriedInternal == true) ? true : x.IsUsed,
                    IsRequeried = (x.IsRequeriedInternal == true) ? true : x.IsRequeried,
                    ObjectHtml = x.HtmlObject
                }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public JsonResult getAttached(Int32 IdFileInfoConfig)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Adjunto/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Field>>().Where(y => y.IdMaster != 0).Select(x => new {
                    Id = x.Id,
                    IdFileInfoConfig = x.IdFileInfoConfig,
                    IdMaster = x.IdMaster,
                    DataBaseName = x.DataBaseName,
                    Label = (String.IsNullOrEmpty(x.Label)) ? x.FieldName : x.Label,
                    IsUsed = x.IsUsed,
                    IsRequeried = x.IsRequeried,
                    ObjectHtml = x.HtmlObject
                }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public JsonResult getJsonDetail(Int32 IdFileHeader)
        {
            List<FileDetail> data = new List<FileDetail>();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/Listar", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<FileDetail>>();
            }

            return Json(data, JsonRequestBehavior.AllowGet);
        }

        public List<Field> getDetailObj(Int32 IdFileInfoConfig)
        {
            List<Field> data = new List<Field>();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Detalle/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Field>>().Where(y => y.IdMaster != 0 || y.IsRequeriedInternal == true).ToList();
            }

            return data;
        }

        public List<Field> getAttachedObj(Int32 IdFileInfoConfig)
        {
            List<Field> data = new List<Field>();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Campo/Adjunto/Listar", "IdFileInfoConfig=" + IdFileInfoConfig)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Field>>();
            }

            return data;
        }

        public ActionResult Router(Int32 IdFileHeader)
        {
            Session["IDFILEHEADER"] = IdFileHeader;

            return RedirectToAction("Detalle");
        }

        public FileHeader getFileHeader(Int32 IdFileHeader)
        {
            FileHeader result = new FileHeader();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/Listar", "IdFileHeader=" + IdFileHeader 
                                                                    + "&IdCustomer=null&IdAccount=null&IdFileInfoConfig=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = JArray.Parse(WSR.Content).ToObject<List<FileHeader>>().FirstOrDefault();
            }

            return result;
        }

        public JsonResult getFileHeaderJson(Int32 IdFileHeader)
        {
            FileHeader result = new FileHeader();
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/Listar", "IdFileHeader=" + IdFileHeader
                                                                    + "&IdCustomer=null&IdAccount=null&IdFileInfoConfig=null")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                result = JArray.Parse(WSR.Content).ToObject<List<FileHeader>>().FirstOrDefault();
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult getSupplierCombo(Boolean IsDestinyCustomer)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Adjunto/Listar/Proveedor", "IsDestinyCustomer=" + IsDestinyCustomer)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<Supplier>>().Select(x => new { Id = x.IdPerson, Name = x.FirstName }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public JsonResult getHeaderValidationDataJson(Int32 IdFileHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/ParametrosValidacion", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                FileHeaderValidationData data = new FileHeaderValidationData();
                data = JObject.Parse(WSR.Content).ToObject<FileHeaderValidationData>();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public FileHeaderValidationData getHeaderValidationData(Int32 IdFileHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/ParametrosValidacion", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                FileHeaderValidationData data = new FileHeaderValidationData();
                data = JObject.Parse(WSR.Content).ToObject<FileHeaderValidationData>();
                return data;
            }
            else
            {
                return null;
            }
        }

        public JsonResult getDetailValidationDataJson(Int32 IdFileDetail)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/ParametrosValidacion", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                FileDetailValidationData data = new FileDetailValidationData();
                data = JObject.Parse(WSR.Content).ToObject<FileDetailValidationData>();
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public JsonResult FileHeaderUseAttached(Int32 IdFileHeader)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Encabezado/UsaAdjuntos", "IdFileHeader=" + IdFileHeader)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                Boolean data = Convert.ToBoolean(WSR.Content.ToString());
                return Json(data, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        public FileDetailValidationData getDetailValidationData(Int32 IdFileDetail)
        {
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Detalle/ParametrosValidacion", "IdFileDetail=" + IdFileDetail)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                FileDetailValidationData data = new FileDetailValidationData();
                data = JObject.Parse(WSR.Content).ToObject<FileDetailValidationData>();
                return data;
            }
            else
            {
                return null;
            }
        }
    }
}