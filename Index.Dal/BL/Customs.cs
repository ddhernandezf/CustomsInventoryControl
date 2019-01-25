using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Customs
    {
        public static Boolean Add(Commons.Customs model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Customs(model.IdCountry, model.Name, model.Address, model.Code, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Customs model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Customs(model.Id, model.IdCountry, model.Name, model.Address, model.Code, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Customs model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Customs(model.Id);
            }

            return true;
        }

        public static List<Commons.Customs> Get(Int32? IdCustoms, Int32? IdCountry)
        {
            List<Commons.Customs> obj = new List<Commons.Customs>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Customs_Result> result = db.spg_Customs(IdCustoms, IdCountry).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Customs()
                    {
                        Id = x.Id,
                        IdCountry = x.IdCountry,
                        CountryName = x.CountryName,
                        Name = x.Name,
                        Address = x.Address,
                        Code = x.Code
                    });
                });
            }

            return obj;
        }
    }
}
