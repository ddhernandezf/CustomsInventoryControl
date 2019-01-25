using System;
using System.Collections.Generic;
using System.Linq;
using Index.Commons.Reports;

namespace Index.Dal.REPORTS
{
    public static class ItemReport
    {
        public static List<Commons.Reports.ItemReport> Get(Int32 IdCustomer, Int32 IdAccount, Boolean? Product)
        {
            List<Commons.Reports.ItemReport> obj = new List<Commons.Reports.ItemReport>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_Item_Result> result = db.spg_Report_Item(IdCustomer, IdAccount, Product).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Reports.ItemReport()
                    {
                        IdCustomer = x.IdCustomer,
                        IdAccount = x.IdAccount,
                        IdItem = x.IdItem,
                        ItemName = x.ItemName,
                        ItemDescription = x.ItemDescription,
                        ItemCode = x.ItemCode,
                        ItemBarCode = x.ItemBarCode,
                        AccountingItem = x.AccountingItem,
                        UM_Name = x.UM_Name,
                        IsProduct = x.IsProduct,
                        Formula = x.Formula,
                        CustomerName = x.CustomerName,
                        ImporterCode = x.ImporterCode,
                        Nit = x.Nit,
                        PersonCode = x.PersonCode,
                        Address = x.Address,
                        PhoneNumber = x.PhoneNumber
                    });
                });
            }
            return obj;
        }
    }
}
