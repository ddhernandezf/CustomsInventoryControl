using System;
using System.Collections.Generic;
using System.Linq;
using Index.Commons.Reports;

namespace Index.Dal.REPORTS
{
    public static class SwornDeclaration
    {
        public static List<SwornDeclarationOne> GetOne(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean? UseFreeze)
        {
            List<SwornDeclarationOne> obj = new List<SwornDeclarationOne>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_SwornDeclaration_One_Result> result = db.spg_Report_SwornDeclaration_One(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited, FileHeaderList, FileDetailList, UseFreeze).ToList();
                result.ForEach(x => {
                    obj.Add(new SwornDeclarationOne()
                    {
                        Id_Cabecera_Importacion = x.Id_Cabecera_Importacion,
                        Poliza_Importacion = x.Poliza_Importacion,
                        Fecha_Autorizacion = x.Fecha_Autorizacion,
                        Fecha_Vencimiento = x.Fecha_Vencimiento,
                        Tipo_Cambio = x.Tipo_Cambio,
                        Id_Aduana = x.Id_Aduana,
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
                        Des_Unidad_Medida = x.Des_Unidad_Medida,
                        Des_Resolucion = x.Des_Resolucion,
                        Suspenso_Formula = x.Suspenso_Formula,
                        IVA_Formula = x.IVA_Formula,
                        Cantidad_Formula = x.Cantidad_Formula,
                        Costo_Cif_Formula = x.Costo_Cif_Formula,
                        V_Suspenso_Formula = x.V_Suspenso_Formula,
                        V_IVA_Formula = x.V_IVA_Formula,
                        V_Cantidad_Formula = x.V_Cantidad_Formula,
                        V_Costo_Cif_Formula = x.V_Costo_Cif_Formula,
                        IsFrozen = x.IsFrozen
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
                List<spg_Report_SwornDeclaration_One_FilteredHeader_Result> result = db.spg_Report_SwornDeclaration_One_FilteredHeader(GetTransmited, StartDate, EndDate,IdCustomer, IdAccount, IdDocument).ToList();
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
                List<spg_Report_SwornDeclaration_One_FilteredDetail_Result> result = db.spg_Report_SwornDeclaration_One_FilteredDetail(GetTransmited, StartDate, EndDate, IdCustomer, IdAccount, IdFileHeader).ToList();
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
