using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class FileHeader
    {
        public static Commons.FileHeader Add(Commons.FileHeader model)
        {
            Commons.FileHeader result = new Commons.FileHeader();
            using (IndexEntities db = new IndexEntities())
            {
                spi_FileHeader_Result data = db.spi_FileHeader(model.IdCustomer, model.IdFileInfoConfig, model.IdDocument, model.AuthorizationDate,
                                  model.ExpantionDate, model.ExpirationDate, model.ArrivalDate, model.DocumentDate, model.ExchangeRate, model.Insurance,
                                  model.Cargo, model.IdCustom, model.IdCountry, model.IdWarranty, model.IdCellar, model.IdCurrency,
                                  model.IdResolution, model.IdAccount, model.CifTotal,model.LinesTotal, model.Facturas, model.RegisterUser).FirstOrDefault();

                result = FileHeader.Tranform(data);
            }

            return result;
        }

        public static Commons.FileHeader Update(Commons.FileHeader model)
        {
            Commons.FileHeader result = new Commons.FileHeader();
            using (IndexEntities db = new IndexEntities())
            {
                spu_FileHeader_Result data = db.spu_FileHeader(model.Id, model.IdCustomer, model.IdFileInfoConfig, model.IdDocument, model.AuthorizationDate,
                                  model.ExpantionDate, model.ExpirationDate, model.DocumentDate, model.ArrivalDate, model.ExchangeRate, model.Insurance,
                                  model.Cargo, model.IdCustom, model.IdCountry, model.IdWarranty, model.IdCellar, model.IdCurrency,
                                  model.IdResolution, model.IdAccount, model.CifTotal, model.LinesTotal,model.Facturas, model.RegisterUser).FirstOrDefault();

                result = FileHeader.Tranform(data);
            }

            return result;
        }

        public static Boolean Delete(Commons.FileHeader model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileHeader(model.Id);
            }

            return true;
        }

        public static Boolean IsFieldsExists(Int32 IdFileInfoConfig)
        {
            Boolean result = false;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_FileMasterIsFieldsSeted(IdFileInfoConfig).FirstOrDefault().Value;
            }

            return result;
        }

        public static List<Commons.FileHeader> Get(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig)
        {
            List<Commons.FileHeader> obj = new List<Commons.FileHeader>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileHeader_Result> result = db.spg_FileHeader(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.FileHeader()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        FileInfoName = x.FileName,
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
                        Facturas = x.Facturas,
                        ConfigActive = x.ConfigActive
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileHeader> GetCurrentMonth(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig)
        {
            List<Commons.FileHeader> obj = new List<Commons.FileHeader>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileHeaderCurrentMonth_Result> result = db.spg_FileHeaderCurrentMonth(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.FileHeader()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        FileInfoName = x.FileName,
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
                        Facturas = x.Facturas,
                        ConfigActive = x.ConfigActive
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileHeader> GetFiltered(Int32? IdFileHeader, Int32? IdCustomer, Int32? IdAccount, Int32? IdFileInfoConfig, String IdDocument, DateTime? CreateDate, DateTime? ExpirationDate, DateTime? AuthorizationDate)
        {
            List<Commons.FileHeader> obj = new List<Commons.FileHeader>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileHeaderFiltered_Result> result = db.spg_FileHeaderFiltered(IdFileHeader, IdCustomer, IdAccount, IdFileInfoConfig, IdDocument, CreateDate, ExpirationDate, AuthorizationDate).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.FileHeader()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        FileInfoName = x.FileName,
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
                        Facturas = x.Facturas,
                        ConfigActive = x.ConfigActive
                    });
                });
            }

            return obj;
        }

        public static Commons.FileHeaderValidationData GetValidationData(Int32? IdFileHeader)
        {
            Commons.FileHeaderValidationData obj = new Commons.FileHeaderValidationData();
            using (IndexEntities db = new IndexEntities())
            {
                spg_FileHeaderValidationData_Result x = db.spg_FileHeaderValidationData(IdFileHeader).FirstOrDefault();
                obj.HasAttached = x.HasAttached;
                obj.HasDetail = x.HasDetail;
                obj.IdState = x.IdState;
                obj.StateName = x.StateName;
            }

            return obj;
        }

        public static Boolean UseAttached(Int32? IdFileHeader)
        {
            Boolean result = false;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_FileHeaderUsAttached(IdFileHeader).FirstOrDefault().Value;
            }

            return result;
        }

        private static Commons.FileHeader Tranform(spi_FileHeader_Result data)
        {
            Commons.FileHeader result = new Commons.FileHeader()
            {
                AccounName = data.AccountName,
                ArrivalDate = data.ArrivalDate,
                AuthorizationDate = data.AuthorizationDate,
                Cargo = data.Cargo,
                CellarName = data.CellarName,
                CifTotal = data.CIFTotal,
                CountryName = data.CountryName,
                CreateDate = data.CreateDate,
                CurrencyName = data.CurrencyName,
                CustomName = data.CustomName,
                DocumentDate = data.DocumentDate,
                ExchangeRate = data.ExchangeRate,
                ExpantionDate = data.ExpantionDate,
                ExpirationDate = data.ExpirationDate,
                Facturas = data.Facturas,
                FileInfoName = data.FileName,
                Id = data.Id,
                IdAccount = data.IdAccount,
                IdCellar = data.IdCellar,
                IdCountry = data.IdCountry,
                IdCurrency = data.IdCurrency,
                IdCustom = data.IdCustom,
                IdCustomer = data.IdCustomer,
                IdDocument = data.IdDocument,
                IdFileInfoConfig = data.IdFileInfoConfig,
                IdResolution = data.IdResolution,
                IdState = data.IdState,
                IdWarranty = data.IdWarranty,
                Insurance = data.Insurance,
                IsSubstract = data.IsSubstract,
                LinesTotal = data.LinesTotal,
                LoadRawMaterial = data.LoadRawMaterial,
                Operation = data.Operation,
                ResolutionName = data.ResolutionName,
                Reviewed = data.Reviewed,
                StateName = data.StateName,
                UseAttached = data.UseAttached,
                WarrantyName = data.WarrantyName,
                UpdateDate = data.UpdateDate
            };

            return result;
        }

        private static Commons.FileHeader Tranform(spu_FileHeader_Result data)
        {
            Commons.FileHeader result = new Commons.FileHeader()
            {
                AccounName = data.AccountName,
                ArrivalDate = data.ArrivalDate,
                AuthorizationDate = data.AuthorizationDate,
                Cargo = data.Cargo,
                CellarName = data.CellarName,
                CifTotal = data.CIFTotal,
                CountryName = data.CountryName,
                CreateDate = data.CreateDate,
                CurrencyName = data.CurrencyName,
                CustomName = data.CustomName,
                DocumentDate = data.DocumentDate,
                ExchangeRate = data.ExchangeRate,
                ExpantionDate = data.ExpantionDate,
                ExpirationDate = data.ExpirationDate,
                Facturas = data.Facturas,
                FileInfoName = data.FileName,
                Id = data.Id,
                IdAccount = data.IdAccount,
                IdCellar = data.IdCellar,
                IdCountry = data.IdCountry,
                IdCurrency = data.IdCurrency,
                IdCustom = data.IdCustom,
                IdCustomer = data.IdCustomer,
                IdDocument = data.IdDocument,
                IdFileInfoConfig = data.IdFileInfoConfig,
                IdResolution = data.IdResolution,
                IdState = data.IdState,
                IdWarranty = data.IdWarranty,
                Insurance = data.Insurance,
                IsSubstract = data.IsSubstract,
                LinesTotal = data.LinesTotal,
                LoadRawMaterial = data.LoadRawMaterial,
                Operation = data.Operation,
                ResolutionName = data.ResolutionName,
                Reviewed = data.Reviewed,
                StateName = data.StateName,
                UseAttached = data.UseAttached,
                WarrantyName = data.WarrantyName,
                UpdateDate = data.UpdateDate
            };

            return result;
        }
    }
}
