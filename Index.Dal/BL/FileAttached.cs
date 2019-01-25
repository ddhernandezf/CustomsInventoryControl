using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class FileAttached
    {
        public static Boolean Add(Commons.FileAttached model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                model.IdSupplier = (model.IdSupplier == 0) ? null : model.IdSupplier;

                db.spi_FileAttached(model.IdFileHeader, model.IdSupplier, model.Description, model.AttachedNumber, model.AttachedDate, 
                    model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.FileAttached model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileAttached(model.Id, model.IdFileHeader, model.IdSupplier, model.Description, model.AttachedNumber, model.AttachedDate,
                    model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.FileAttached model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileAttached(model.Id);
            }

            return true;
        }

        public static Boolean IsFieldsExists(Int32 IdFileInfoConfig)
        {
            Boolean result = false;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_FileAttachedIsFieldsSeted(IdFileInfoConfig).FirstOrDefault().Value;
            }

            return result;
        }

        public static List<Commons.FileAttached> Get(Int32? IdFileHeader)
        {
            List<Commons.FileAttached> obj = new List<Commons.FileAttached>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileAttached_Result> result = db.spg_FileAttached(IdFileHeader).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.FileAttached()
                    {
                        Id = x.IdFileAttached,
                        IdFileHeader = x.IdFileHeader,
                        IdSupplier = x.IdSupplier,
                        SupplierName = x.SupplierName,
                        Description = x.Description,
                        AttachedNumber = x.AttachedNumber,
                        AttachedDate = x.AttachedDate
                    });
                });
            }

            return obj;
        }
    }
}
