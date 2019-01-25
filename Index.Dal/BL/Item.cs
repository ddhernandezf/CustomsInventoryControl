using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Item
    {

        public static Boolean Add(Commons.Item model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Item(model.IdCustomer, model.IdAccount, model.IdUnitMeasurement, model.IdResolucion, model.IdAccountingItem, model.Code, model.Name, 
                            model.Description, model.Barcode,model.IsProduct, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Item model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Item(model.Id, model.IdCustomer, model.IdAccount, model.IdUnitMeasurement, model.IdResolucion, model.IdAccountingItem, model.Code, model.Name,
                            model.Description, model.Barcode, model.IsProduct, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Item model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Item(model.Id);
            }

            return true;
        }

        public static List<Commons.Item> Get(Int32? IdCustomer, Int32? IdAccount, Int32? IdItem, Boolean? isProduct)
        {
            List<Commons.Item> obj = new List<Commons.Item>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Item_Result> result = db.spg_Item(IdCustomer, IdAccount, IdItem, isProduct).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Item()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdResolucion = x.IdResolution,
                        IdAccountingItem = x.IdAccountingItem,
                        IdUnitMeasurement = x.IdUnitMeasurement,
                        Description = x.Description,
                        Name = x.Name,
                        IsProduct = x.IsProduct,
                        Code = x.Code,
                        Barcode = x.Barcode,
                        UnitMeasurementName = x.UnitMeasurementName,
                        UnitMeasurementSymbol = x.UnitMeasurementSymbol,
                        AccountingItem = x.AccountingItem,
                        AccountingItemParent = x.Parent,
                        AccountingItemParentName = x.ParentName,
                        DisplayProductName = x.DisplayProductName,
                        AccountingItemName = x.AccountingItemName,
                        DisplayAccountingItemName = (x.IdResolution == null) ? "" : x.DisplayAccountingItem,
                        HasFormula = x.HasFormula,
                        Active = x.Active
                    });
                });
            }

            return obj;
        }

        public static Decimal GetGlobalStock(Int32? IdItem)
        {
            Decimal result = 0;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_ItemGlobalStock(IdItem).FirstOrDefault().Value;
            }

            return result;
        }

        public static String GetItemFormula(Int32? IdItem)
        {
            String result = null;
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_ItemFormula_Result> data = db.spg_ItemFormula(IdItem).ToList();
                data.ForEach(x => {
                    result = result + x.ItemName + ", ";
                });

                result = (data.Count == 0) ? null : result.Substring(0, result.Length-2);
            }

            return result;
        }
    }
}
