using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Adjustment
    {
        public static Boolean Operate(Commons.Adjustment model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spo_Adjustment(model.IdFileItemDischarge, model.IdFileDetailSubstract, model.IdFileDetailStock, model.Quantity,
                    model.Decrease, false, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Adjustment model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Adjustment(model.IdFileItemDischarge);
            }

            return true;
        }

        public static List<Commons.Adjustment> Get(Int32 IdFileDetailStock, Int32 IdFileDetailSubstract)
        {
            List<Commons.Adjustment> obj = new List<Commons.Adjustment>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Adjustment_Result> result = db.spg_Adjustment(IdFileDetailStock, IdFileDetailSubstract).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Adjustment()
                    {
                        IdFileItemDischarge = x.IdFileItemDischarge,
                        IdFileDetailSubstract = x.IdFileDetailSubstract,
                        IdFileDetailStock = x.IdFileDetailStock,
                        IdItem = x.IdItem,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        Quantity = x.Quantity,
                        Decrease = x.Decrease,
                        RegisterDate = x.RegisterDate
                    });
                });
            }

            return obj;
        }
    }
}
