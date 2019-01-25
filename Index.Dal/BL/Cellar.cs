using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Cellar
    {
        public static Boolean Add(Commons.Cellar model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Cellar(model.Name, model.Address, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Cellar model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Cellar(model.Id, model.Name, model.Address, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Cellar model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Cellar(model.Id);
            }

            return true;
        }

        public static List<Commons.Cellar> Get(Int32? IdCellar)
        {
            List<Commons.Cellar> obj = new List<Commons.Cellar>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Cellar_Result> result = db.spg_Cellar(IdCellar).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Cellar()
                    {
                        Id = x.Id,
                        Address = x.Address,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }
    }
}
