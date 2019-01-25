using System;
using System.Collections.Generic;
using System.Linq;


namespace Index.Dal
{
    public static class Resolution
    {
        public static Boolean Add(Commons.Resolution model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Resolution(model.IdCustomer, model.IdAccount, model.Name, model.Description, model.RateDate, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Resolution model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Resolution(model.Id, model.IdCustomer, model.IdAccount, model.Name, model.Description, model.RateDate, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Resolution model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Resolution(model.Id);
            }

            return true;
        }

        public static List<Commons.Resolution> Get(Int32? IdResolution, Int32? IdCustomer, Int32? IdAccount)
        {
            List<Commons.Resolution> obj = new List<Commons.Resolution>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Resolution_Result> result = db.spg_Resolution(IdResolution).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Resolution()
                    {
                        Id = x.Id,
                        IdCustomer = x.IdCustomer,
                        IdAccount = x.IdAccount,
                        Name = x.Name,
                        Description = x.Description,
                        RateDate = x.RateDate
                    });
                });
            }

            if (IdCustomer != null)
            {
                obj = obj.Where(x => x.IdCustomer == IdCustomer).ToList();
            }

            if (IdAccount != null)
            {
                obj = obj.Where(x => x.IdAccount == x.IdAccount).ToList();
            }

            return obj;
        }
    }
}
