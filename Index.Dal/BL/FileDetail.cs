using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Index.Dal
{
    public static class FileDetail
    {
        public static Boolean Add(Commons.FileDetail model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileDetail(model.IdFileHeader,model.TransactionLine, model.IdItem, model.Quantity, model.CIFQ, model.FOQ,model.CIFD, 
                                    model.FOD, model.CustomDuties, model.IVA, model.TaxableBase, model.TaxRate, model.NetWeight, model.GrossWeight,
                                    model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.FileDetail model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileDetail(model.Id, model.IdFileHeader, model.TransactionLine, model.IdItem, model.Quantity, model.CIFQ, model.FOQ, 
                                    model.CIFD, model.FOD,  model.CustomDuties, model.IVA, model.TaxableBase, model.TaxRate, model.NetWeight, 
                                    model.GrossWeight, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.FileDetail model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileDetail(model.Id);
            }

            return true;
        }

        public static Boolean IsFieldsExists(Int32 IdFileInfoConfig)
        {
            Boolean result = false;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_FileDetailIsFieldsSeted(IdFileInfoConfig).FirstOrDefault().Value;
            }

            return result;
        }

        public static List<Commons.FileDetail> Get(Int32 IdFileHeader)
        {
            List<Commons.FileDetail> obj = new List<Commons.FileDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileDetail_Result> result = db.spg_FileDetail(IdFileHeader).ToList();
                result.ForEach(x =>
                {
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
                        AccountingItem = x.AccountingItem,
                        IsFrozen = (x.IsFrozen == null) ? false : (Boolean)x.IsFrozen
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileHeaderDetail> GetHeader(Int32? IdFileHeader, Int32? IdFileInfoConfig)
        {
            List<Commons.FileHeaderDetail> obj = new List<Commons.FileHeaderDetail>();

            using (IndexEntities db = new IndexEntities())
            {
                spg_FileHeader_Result fileHeader = db.spg_FileHeader(IdFileHeader, null, null, IdFileInfoConfig).FirstOrDefault();
                List<spg_FieldsMasterDisplay_Result> fields = db.spg_FieldsMasterDisplay(fileHeader.IdFileInfoConfig).Where(x => x.IsUsed == true || x.IsRequiredInternal == true).ToList();
                obj.Add(new Commons.FileHeaderDetail()
                {
                    Label = "Tipo de documento",
                    Value = fileHeader.FileName
                });

                fields.ForEach(x => {
                    String value = null;

                    switch (x.DataBaseName)
                    {
                        case "IdDocument":
                            value = fileHeader.IdDocument;
                            break;
                        case "AuthorizationDate":
                            if (fileHeader.AuthorizationDate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                DateTime auth = (DateTime)fileHeader.AuthorizationDate;
                                value = auth.ToString("dd/MM/yyyy");
                            }
                            break;
                        case "ExpantionDate":
                            if (fileHeader.ExpantionDate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                DateTime exp = (DateTime)fileHeader.ExpantionDate;
                                value = exp.ToString("dd/MM/yyyy");
                            }
                            break;
                        case "ExpirationDate":
                            if (fileHeader.ExpirationDate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                DateTime expr = (DateTime)fileHeader.ExpirationDate;
                                value = expr.ToString("dd/MM/yyyy");
                            }
                            break;
                        case "DocumentDate":
                            if (fileHeader.DocumentDate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                DateTime doc = (DateTime)fileHeader.DocumentDate;
                                value = doc.ToString("dd/MM/yyyy");
                            }
                            break;
                        case "ExchangeRate":
                            if (fileHeader.ExchangeRate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                Decimal exch = (Decimal)fileHeader.ExchangeRate;
                                value = String.Format("{0:C3}", exch);
                            }
                            break;
                        case "Insurance":
                            if (fileHeader.Insurance == null)
                            {
                                value = "";
                            }
                            else
                            {
                                Decimal ins = (Decimal)fileHeader.Insurance;
                                value = ins.ToString("C3", CultureInfo.GetCultureInfo("en-US"));
                            }
                            break;
                        case "Cargo":
                            if (fileHeader.Cargo == null)
                            {
                                value = "";
                            }
                            else
                            {
                                Decimal cargo = (Decimal)fileHeader.Cargo;
                                value = cargo.ToString("C3", CultureInfo.GetCultureInfo("en-US"));
                            }
                            break;
                        case "IdCountry":
                            value = fileHeader.CountryName;
                            break;
                        case "IdCustom":
                            value = fileHeader.CustomName;
                            break;
                        case "IdWarranty":
                            value = fileHeader.WarrantyName;
                            break;
                        case "IdCurrency":
                            value = fileHeader.CurrencyName;
                            break;
                        case "IdResolution":
                            value = fileHeader.ResolutionName;
                            break;
                        case "IdCellar":
                            value = fileHeader.CellarName;
                            break;
                        case "ArrivalDAte":
                            if (fileHeader.ArrivalDate == null)
                            {
                                value = "";
                            }
                            else
                            {
                                DateTime arri = (DateTime)fileHeader.ArrivalDate;
                                value = arri.ToString("dd/MM/yyyy");
                            }
                            break;
                        case "CIFTotal":
                            if (fileHeader.CIFTotal == null)
                            {
                                value = "";
                            }
                            else
                            {
                                Decimal cift = (Decimal)fileHeader.CIFTotal;
                                value = String.Format("{0:C3}", cift);
                            }
                            break;
                        case "LinesTotal":
                            if (fileHeader.LinesTotal == null)
                            {
                                value = "";
                            }
                            else
                            {
                                Int32 lines = (Int32)fileHeader.LinesTotal;
                                value = lines.ToString();
                            }
                            break;
                        case "Factura":
                            value = fileHeader.Facturas;
                            break;
                    }

                    obj.Add(new Commons.FileHeaderDetail()
                    {
                        Label = (x.IsRequiredInternal == true) ? ((x.Label == null) ? x.FieldName : x.Label) : x.Label,
                        Value = value
                    });
                });
            }

            return obj;
        }

        public static Commons.FileDetailValidationData GetValidationData(Int32? IdFileDetail)
        {
            Commons.FileDetailValidationData obj = new Commons.FileDetailValidationData();
            using (IndexEntities db = new IndexEntities())
            {
                spg_FileDetailValidationData_Result x = db.spg_FileDetailValidationData(IdFileDetail).FirstOrDefault();
                obj.HasMove = x.HasMove;
                obj.IdState = x.IdState;
                obj.StateName = x.StateName;
            }

            return obj;
        }
    }
}
