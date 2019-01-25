using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Country
    {
        public static Boolean Add(Commons.Country model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Country(model.Name, model.IdParent, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Country model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Country(model.Id, model.Name, model.IdParent, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Country model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Country(model.Id);
            }

            return true;
        }

        public static List<Commons.Country> Get(Int32? IdCountry)
        {
            List<Commons.Country> obj = new List<Commons.Country>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Country_Result> result = db.spg_Country(IdCountry).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Country()
                    {
                        Id = x.Id,
                        IdParent = x.IdParent,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }
    }
}
