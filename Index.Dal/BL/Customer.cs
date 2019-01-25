using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Customer
    {
        public static Boolean Add(Commons.Customer model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Customer(model.EnterpriseName, model.Nit, model.LegalRepresentative, model.PersonCode, model.ImporterCode, model.ExporterCode,
                    model.BondEndDate, model.Observations, model.RegisterUser);
            }

            return true;
        }
        public static Boolean AddCustomerUser(Commons.CustomerUser model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_CustomerUser(model.IdCustomer, model.UserName, model.RegisterUser);
            }

            return true;
        }
        
        public static Boolean Update(Commons.Customer model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Customer(model.Id, model.EnterpriseName, model.Nit, model.LegalRepresentative, model.PersonCode, model.ImporterCode, model.ExporterCode,
                    model.BondEndDate, model.Observations, model.RegisterUser);
            }

            return true;
        }
        public static Boolean DeleteCustomerUser(Commons.CustomerUser model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_CustomerUser2(model.IdCustomer, model.UserName);
            }

            return true;
        }

        public static Boolean Delete(Commons.Customer model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Customer(model.Id);
            }

            return true;
        }

        public static List<Commons.Customer> Get(Int32? IdCustomer)
        {
            List<Commons.Customer> obj = new List<Commons.Customer>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Customer_Result> result = db.spg_Customer(IdCustomer, true).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Customer()
                    {
                        Id = x.IdPerson,
                        EnterpriseName = x.Name,
                        Nit = x.Nit,
                        LegalRepresentative = x.LegalRepresentative,
                        PersonCode = x.PersonCode,
                        ImporterCode = x.ImporterCode,
                        ExporterCode = x.ExporterCode,
                        BondEndDate = x.BondEndDate,
                        Observations = x.Observations
                    });
                });
            }

            return obj;
        }

        public static Boolean AddCustomerAccount(Int32? IdCustomer, Int32? IdAccount, String RegisterUser)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_CustomerAccount(IdCustomer, IdAccount, RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteCustomerAccount(Int32? IdCustomer, Int32? IdAccount)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_CustomerAccount(IdCustomer, IdAccount);
            }

            return true;
        }

        public static List<Commons.Account> GetCustomerAccount(String UserName)
        {
            List<Commons.Account> obj = new List<Commons.Account>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerAccount_Result> result = db.spg_CustomerAccount(UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Account()
                    {
                        Id = x.IdAccount,
                        Name = x.Account
                    });
                });
            }

            return obj;
        }

        public static List<Commons.AccountToAssign> GetCustomerAccountAssigned(Int32 IdCustomer)
        {
            List<Commons.AccountToAssign> obj = new List<Commons.AccountToAssign>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerAccountToAssing_Result> result = db.spg_CustomerAccountToAssing(IdCustomer).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.AccountToAssign()
                    {
                        Id = x.IdAccount,
                        Name = x.Name,
                        IsAssigned = x.IsAssigned
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Customer> GetCustomerByUser(Int32? IdCustomer, String UserName)
        {
            List<Commons.Customer> obj = new List<Commons.Customer>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerByUser_Result> result = db.spg_CustomerByUser(IdCustomer, UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Customer()
                    {
                        Id = x.IdPerson,
                        EnterpriseName = x.EnterpriseName,
                        //LastName = x.LastName,
                        Nit = x.Nit,
                        LegalRepresentative = x.LegalRepresentative,
                        PersonCode = x.PersonCode,
                        ImporterCode = x.ImporterCode,
                        ExporterCode = x.ExporterCode,
                        BondEndDate = x.BondEndDate,
                        Observations = x.Observations
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Customer> GetCustomerAssigned(String UserName, Int32? IdAccount)
        {
            List<Commons.Customer> obj = new List<Commons.Customer>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerAssignedByUser_Result> result = db.spg_CustomerAssignedByUser(UserName, IdAccount).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Customer()
                    {
                        Id = x.IdPerson,
                        EnterpriseName = x.EnterpriseName
                    });
                });
            }

            return obj;
        }

        public static List<Commons.CustomerToAssign> GetCustomerToAssign(String UserName)
        {
            List<Commons.CustomerToAssign> obj = new List<Commons.CustomerToAssign>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerToAssignUser_Result> result = db.spg_CustomerToAssignUser(UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.CustomerToAssign()
                    {
                        Id = x.IdCustomer,
                        EnterpriseName = x.Name,
                        IsAssigned = x.IsAssigned
                    });
                });
            }

            return obj;
        }

        public static List<Commons.CustomerAccountData> GetCustomerAccountData(Int32 IdCustomer, Int32 IdAccount)
        {
            List<Commons.CustomerAccountData> obj = new List<Commons.CustomerAccountData>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_CustomerAccountData_Result> result = db.spg_CustomerAccountData(IdCustomer, IdAccount).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.CustomerAccountData()
                    {
                        IdCustomer = x.IdCustomer,
                        IdAccount = x.IdAccount,
                        ResolutionRate = x.ResolutionRate,
                        RegimeRate = x.RegimeRate,
                        ResolutionStartDate = x.ResolutionStartDate,
                        ResolutionEndDate = x.ResolutionEndDate,
                        FiscalPeriodStartDate = x.FiscalPeriodStartDate,
                        FiscalPeriodEndDate = x.FiscalPeriodEndDate
                    });
                });
            }

            return obj;
        }

        public static Boolean UpdateCustomerAccountData(Commons.CustomerAccountData model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_CustomerAccountData(model.IdCustomer, model.IdAccount, model.ResolutionRate, model.RegimeRate,
                    model.ResolutionStartDate, model.ResolutionEndDate, model.FiscalPeriodStartDate, model.FiscalPeriodEndDate);
            }

            return true;
        }
    }
}
