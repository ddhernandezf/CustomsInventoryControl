using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal.REPORTS
{
    public static class DischargeDetail
    {
        public static List<Commons.Reports.DischargeDetail> Get(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList)
        {
            List<Commons.Reports.DischargeDetail> obj = new List<Commons.Reports.DischargeDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_DischargeDetail_Result> result = db.spg_Report_DischargeDetail(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Reports.DischargeDetail()
                    {
                       Id_Cabecera_Importacion = x.Id_Cabecera_Importacion,
                       Poliza_Importacion = x.Poliza_Importacion,
                       Fecha_Autorizacion = x.Fecha_Autorizacion,
                       Fecha_Vencimiento = x.Fecha_Vencimiento,
                       Tipo_Cambio = x.Tipo_Cambio,
                       Aduana_Importacion = x.Aduana_Importacion,
                       Fecha_Sistema = x.Fecha_Sistema,
                       Seguro = x.Seguro,
                       Flete = x.Flete,
                       Numero_Factura = x.Numero_Factura,
                       Numero_Resolucion = x.Numero_Resolucion,
                       Des_Garantia = x.Des_Garantia,
                       Des_Aduana = x.Des_Aduana,
                       Des_Pais = x.Des_Pais, 
                       Id_Detalle_Importacion = x.Id_Detalle_Importacion,
                       Linea_Importacion = x.Linea_Importacion,
                       Cantidad = x.Cantidad, 
                       Costo_Cif_Quetzales = x.Costo_Cif_Quetzales,
                       Costo_Fob_Quetzales = x.Costo_Fob_Quetzales,
                       Derechos_Suspenso = x.Derechos_Suspenso,
                       Iva_Suspenso = x.Iva_Suspenso,
                       Id_Cliente = x.Id_Cliente,
                       Nombre_Cliente = x.Nombre_Cliente,
                       Nit_Cliente = x.Nit_Cliente,
                       Direccion_Cliente = x.Direccion_Cliente,
                       Telefono_Cliente = x.Telefono_Cliente,
                       Codigo_Cliente = x.Codigo_Cliente,
                       Codigo_Importador_Exportador = x.Codigo_Importador_Exportador,
                       Resolucion_Calificacion = x.Resolucion_Calificacion,
                       Fecha_Resolucion = x.Fecha_Resolucion,
                       C_Vencimiento = x.C_Vencimiento,
                       Nombre_Proveedor = x.Nombre_Proveedor,
                       Nit_Proveedor = x.Nit_Proveedor,
                       Direccion_Proveedor = x.Direccion_Proveedor,
                       Telefono_Proveedor = x.Telefono_Proveedor,
                       Des_Materia_Prima= x.Des_Materia_Prima,
                       Codigo_Materia_Prima = x.Codigo_Materia_Prima,
                       Partida_Materia = x.Partida_Materia,
                       Des_UM_Materia = x.Des_UM_Materia,
                       Des_Resolucion = x.Des_Resolucion,
                       Cantidad_Formula = x.Cantidad_Formula,
                       Cantidad_Merma_Formula = x.Cantidad_Merma_Formula,
                       Costo_Cif_Formula = x.Costo_Cif_Formula,
                       Costo_Fob_Formula = x.Costo_Fob_Formula,
                       Suspenso_Formula = x.Suspenso_Formula,
                       Iva_Formula = x.Iva_Formula,
                       Fecha_Formula = x.Fecha_Formula,
                       Id_Detalle_Exportacion = x.Id_Detalle_Exportacion,
                       Linea_Exportacion = x.Linea_Exportacion,
                       Cantidad_Exp = x.Cantidad_Exp,
                       Cif_Exp = x.Cif_Exp,
                       Suspenso_Exp = x.Suspenso_Exp,
                       IVA_Exp = x.IVA_Exp,
                       Poliza_Exportacion = x.Poliza_Exportacion,
                       Tipo_Documento = x.Tipo_Documento,
                       Fecha_Documento = x.Fecha_Documento,
                       Factura_Exp = x.Factura_Exp,
                       Aduana_Exportacion = x.Aduana_Exportacion,
                       Des_Producto = x.Des_Producto,
                       Codigo_Producto = x.Codigo_Producto,
                       Partida_Producto = x.Partida_Producto,
                       Des_UM_Producto = x.Des_UM_Producto,
                       Cantidad_A = x.Cantidad_A,
                       Costo_Cif_A = x.Costo_Cif_A,
                       Suspenso_A = x.Suspenso_A,
                       IVA_A = x.IVA_A,
                       Cantidad_Transmitido = x.Cantidad_Transmitido,
                       CIF_Transmitido = x.CIF_Transmitido,
                       Suspenso_Iva_Transmitido = x.Suspenso_Iva_Transmitido,
                       Numero_Transmision = x.Numero_Transmision 
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileHeader> GetHeader(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String IdDocument)
        {
            List<Commons.FileHeader> obj = new List<Commons.FileHeader>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_DischargeDetail_FilteredHeader_Result> result = db.spg_Report_DischargeDetail_FilteredHeader(GetTransmited, StartDate, EndDate, IdCustomer, IdAccount, IdDocument).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileHeader()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        FileInfoName = x.FileInfoName,
                        Operation = x.Operation,
                        LoadRawMaterial = x.LoadRawMaterial,
                        IsSubstract = x.IsSubstract,
                        IdDocument = x.IdDocument,
                        AuthorizationDate = x.AuthorizationDate,
                        ExpantionDate = x.ExpantionDate,
                        ExpirationDate = x.ExpirationDate,
                        DocumentDate = x.DocumentDate,
                        ArrivalDate = x.ArrivalDate,
                        ExchangeRate = x.ExchangeRate,
                        Insurance = x.Insurance,
                        Cargo = x.Cargo,
                        IdCustom = x.IdCustom,
                        CustomName = x.CustomName,
                        IdCountry = x.IdCountry,
                        CountryName = x.CountryName,
                        IdWarranty = x.IdWarranty,
                        WarrantyName = x.WarrantyName,
                        IdCellar = x.IdCellar,
                        CellarName = x.CellarName,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        IdCurrency = x.IdCurrency,
                        CurrencyName = x.CurrencyName,
                        IdResolution = x.IdResolution,
                        ResolutionName = x.ResolutionName,
                        IdAccount = x.IdAccount,
                        AccounName = x.AccountName,
                        Reviewed = x.Reviewed,
                        RegisterUser = x.RegisterUser,
                        CreateDate = x.CreateDate,
                        UpdateDate = x.UpdateDate,
                        CifTotal = x.CIFTotal,
                        LinesTotal = x.LinesTotal,
                        UseAttached = x.UseAttached,
                        StrArrivalDate = (x.ArrivalDate == null) ? null : x.ArrivalDate.Value.ToString("dd/MM/yyyy"),
                        StrAuthorizationDate = (x.AuthorizationDate == null) ? null : x.AuthorizationDate.Value.ToString("dd/MM/yyyy"),
                        StrDocumentDate = (x.DocumentDate == null) ? null : x.DocumentDate.Value.ToString("dd/MM/yyyy"),
                        StrExpantionDate = (x.ExpantionDate == null) ? null : x.ExpantionDate.Value.ToString("dd/MM/yyyy"),
                        StrExpirationDate = (x.ExpirationDate == null) ? null : x.ExpirationDate.Value.ToString("dd/MM/yyyy"),
                        StrCreateDate = (x.CreateDate == null) ? null : x.CreateDate.ToString("dd/MM/yyyy")
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileDetail> GetDetail(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, Int32 IdFileHeader)
        {
            List<Commons.FileDetail> obj = new List<Commons.FileDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_DischargeDetail_FilteredDetail_Result> result = db.spg_Report_DischargeDetail_FilteredDetail(GetTransmited, StartDate, EndDate, IdCustomer, IdAccount, IdFileHeader).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileDetail()
                    {
                        Id = x.IdFileDetail,
                        IdFileHeader = x.IdFileHeader,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        TransactionLine = x.TransactionLine,
                        IdItem = x.IdItem,
                        ItemName = x.ItemName,
                        Quantity = x.ItemQuantity,
                        CIFQ = x.CIFCotQuetzal,
                        FOQ = x.FOCostQuetzal,
                        CIFD = x.CIFCotDollar,
                        FOD = x.FOCostDollar,
                        CustomDuties = x.CustomDuties,
                        IVA = x.Iva,
                        TaxableBase = x.TaxableBase,
                        TaxRate = x.TaxRate,
                        NetWeight = x.NetWeight,
                        GrossWeight = x.GrossWeight,
                        DisplayItemName = x.DisplayItemName,
                        DisplayAccountingItem = x.DisplayAccountingItem,
                        AccountingItem = x.AccountingItem
                    });
                });
            }

            return obj;
        }
    }
}
