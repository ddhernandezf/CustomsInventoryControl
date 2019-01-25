using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class ItemDischarge
    {
        public static Commons.DischargeParameters GetParameters(Int32 IdFileDetail)
        {
            Commons.DischargeParameters obj = new Commons.DischargeParameters();
            using (IndexEntities db = new IndexEntities())
            {
                spg_DischargeParameters_Result result = db.spg_DischargeParameters(IdFileDetail).FirstOrDefault();
                if (result != null)
                {
                    obj = new Commons.DischargeParameters()
                    {
                        IdFileDetail = result.IdFileDetail,
                        TransactionLine = result.TransactionLine,
                        IdFileInfoConfig = result.IdFileInfoConfig,
                        IdFileHeader = result.IdFileHeader,
                        IdDocument = result.IdDocument,
                        DocumentName = result.DocumentName,
                        IdCustomer = result.IdCustomer,
                        CustomerName = result.CustomerName,
                        AccountingItem = result.AccountingItem,
                        IdItem = result.IdItem,
                        Code = result.Code,
                        ItemName = result.ItemName,
                        IdAccount = result.IdAccount,
                        AccountName = result.AccountName,
                        UseFormula = result.UseFormula,
                        IsSubstract = result.IsSubstract,
                        LoadRawMaterial = result.LoadRawMaterial
                    };
                }
            }

            return obj;
        }

        public static List<Commons.DischargeRawMaterial> GetRawMaterials(Int32 IdFileDetail, Int32 IdAccount, Int32 IdCustomer, Int32 IdItem, Boolean UseFormula)
        {
            List<Commons.DischargeRawMaterial> obj = new List<Commons.DischargeRawMaterial>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DischargeRawMaterial_Result> result = db.spg_DischargeRawMaterial(IdFileDetail, IdAccount, IdCustomer, IdItem, UseFormula).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.DischargeRawMaterial()
                    {
                        IdFileDetail = x.IdFileDetail,
                        IdFormula = x.IdFormula,
                        IdParentItem = x.IdParentItem,
                        IdItem = x.IdItem,
                        AccountingItem = x.AccountingItem,
                        ItemName = x.ItemName,
                        Quantity = x.Quantity,
                        Decrease = x.Decrease,
                        UseFormula = x.UseFormula,
                        CurrentQuantity = x.CurrentQuantity,
                        CurrentDecrease = x.CurrentDecrease,
                        QuantityLabel = (x.UseFormula == true) ? FormatDecimal(x.CurrentQuantity, "#.000") + "/" + FormatDecimal(x.Quantity, "#.000") : FormatDecimal(x.CurrentQuantity, "#.000"),
                        DecreaseLabel = (x.UseFormula == true) ? FormatDecimal(x.CurrentDecrease, "#.000") + "/" + FormatDecimal(x.Decrease, "#.000") : FormatDecimal(x.CurrentDecrease, "#.000"),
                        DisplayAccountingItem = x.DisplayAccountingItem,
                        DisplayItemName = x.DisplayItemName
                    });
                });
            }

            return obj;
        }

        public static List<Commons.DischargeTransaction> GetTransactions(Int32 IdFileDetail, Int32 IdItem, Int32 IdAccount)
        {
            List<Commons.DischargeTransaction> obj = new List<Commons.DischargeTransaction>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DischargeTransactions_Result> result = db.spg_DischargeTransactions(IdFileDetail, IdItem, IdAccount).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.DischargeTransaction()
                    {
                        IdCustomer = x.IdCustomer,
                        IdAccount = x.IdAccount,
                        AccountName = x.AccountName,
                        IdFileDetail = x.IdFileDetail,
                        IdDocument = x.IdDocument,
                        IdFileHeader = x.IdFileHeader,
                        DocumentName = x.DocumentName,
                        IdItem = x.IdItem,
                        Original = x.Original,
                        Stock = x.Stock,
                        TransactionDate = x.TransactionDate,
                        Quantity = x.Quantity,
                        Decrease = x.Decrease,
                        CIFcost = x.CIFcost,
                        FOcost = x.FOcost,
                        CustomDuties = x.CustomDuties,
                        Iva = x.Iva,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        DisplayDocument = x.DisplayDocument,
                        IsExpired = (Boolean)x.IsExpired,
                        TransactionLine = (Int32)x.TransactionLine
                    });
                });
            }

            return obj;
        }

        public static List<Commons.DischargeResume> GetResume(Int32 IdFileDetail)
        {
            List<Commons.DischargeResume> obj = new List<Commons.DischargeResume>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DischargeDetailResume_Result> result = db.spg_DischargeDetailResume(IdFileDetail).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.DischargeResume()
                    {
                        Id = x.Id,
                        IdFileHeader = x.IdFileHeader,
                        IdFileDetailSubstract = x.IdFileDetailSubstract,
                        IdFileDetailStock = x.IdFileDetailStock,
                        IdState = x.IdState,
                        IdItem = x.IdItem,
                        TransactionLine = (Int32)x.TransactionLine,
                        DocumentName = x.DocumentName,
                        InventoryQuantity = x.InventoryQuantity,
                        Stock = x.Stock,
                        Quantity = x.Quantity,
                        Decrease = x.Decrease,
                        ItemName = x.ItemName,
                        AccountingItem = x.AccountingItem,
                        Cif = x.CIFcost,
                        Dai = (Decimal)x.CustomDuties,
                        Iva = x.Iva,
                        StateName = x.StateName,
                        TransactionDate = x.TransactionDate
                    });
                });
            }

            return obj;
        }

        public static Int32 GetResumeCounter(Int32 IdFileDetail)
        {
            Int32 result = 0;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_DischargeDetailResumeCounter(IdFileDetail).FirstOrDefault().Value;
            }

            return result;
        }

        private static String FormatDecimal(Decimal? value, String format)
        {
            Decimal newval = (Decimal)value;
            String result = newval.ToString(format);

            if (newval == 0)
            {
                result = "0";
            }

            return result;
        }
    }
}
