using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;

namespace Index.Dal
{
    public static class Formula
    {
        public static Boolean Add(Commons.Formula model)
        {
            ObjectParameter pId = new ObjectParameter("IdFormula", typeof(int));
            using (IndexEntities db = new IndexEntities())
            {
                var result = db.spi_Formula(model.IdMainItem, model.IdDetailItem, model.Quantity, model.Decrease, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Formula model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Formula(model.Id, model.IdMainItem, model.IdDetailItem, model.Quantity, model.Decrease, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Formula model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Formula(model.Id);
            }

            return true;
        }

        public static List<Commons.Formula> Get(Int32? IdFormula, Int32? IdCustomer, Int32? IdMainItem)
        {
            List<Commons.Formula> obj = new List<Commons.Formula>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Formula_Result> result = db.spg_Formula(IdFormula, IdCustomer, IdMainItem).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Formula()
                    {
                        Id = x.Id,
                        IdMainItem = x.IdMainItem,
                        MainItem = x.MainItem,
                        IdDetailItem = x.IdDetailItem,
                        DetailItem = x.DetailItem,
                        Quantity = x.Quantity,
                        Decrease = x.Decrease,
                        IdCustomer = x.IdCustomer,
                        DisplayDetailItem= x.DisplayDetailItem,
                        DetailAccountingItem = x.DetailAccountingItem,
                        DisplayDetailAccountingItem = (x.DetailAccountingItem == null) ? "" : x.DisplauDetailAccountingItem,
                        Active = x.Active
                    });
                });
            }

            return obj;
        }
    }
}
