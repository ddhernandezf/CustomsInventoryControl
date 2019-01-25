using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Freeze
    {
        public static Boolean FreezeDocument(Int32 IdFileHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FreezeDocument(IdFileHeader);
            }

            return true;
        }

        public static Boolean UnfreezeDocument(Int32 IdFileHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_UnfreezeDocument(IdFileHeader);
            }

            return true;
        }

        public static List<Commons.Freeze> GetDocument(Int32 IdFileHeader)
        {
            List<Commons.Freeze> obj = new List<Commons.Freeze>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FreezeDocument_Result> result = db.spg_FreezeDocument(IdFileHeader).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Freeze()
                    {
                        Id = x.IdFileHeader,
                        ItemName = x.ItemName,
                        TransactionLine = x.TransactionLine,
                        Quantity= x.Quantity,
                        Stock = (Decimal)x.Stock,
                        Discharge = x.Discharge,
                        Balance = (x.Balance == null) ? 0 : (Decimal)x.Balance,
                        IsFrozen = (Boolean)x.IsFrozen
                    });
                });
            }

            return obj;
        }

        public static Boolean FreezeSingle(Int32 IdFileDetail, Decimal Discharge)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FreezeRegister(IdFileDetail, Discharge);
            }

            return true;
        }

        public static Boolean UnfreezeSingle(Int32 IdFileDetail)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_UnfreezeRegister(IdFileDetail);
            }

            return true;
        }

        public static List<Commons.Freeze> GetSingle(Int32 IdFileDetail)
        {
            List<Commons.Freeze> obj = new List<Commons.Freeze>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FreezeRegister_Result> result = db.spg_FreezeRegister(IdFileDetail).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Freeze()
                    {
                        Id = x.IdFileDetail,
                        ItemName = x.ItemName,
                        TransactionLine =  x.TransactionLine,
                        Quantity = x.Quantity,
                        Stock = (Decimal)x.Stock,
                        Discharge = x.Discharge,
                        Balance = (x.Balance == null) ? 0 : (Decimal)x.Balance,
                        IsFrozen = (Boolean)x.IsFrozen
                    });
                });
            }

            return obj;
        }
    }
}
