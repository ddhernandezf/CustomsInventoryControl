using System;
using System.Collections.Generic;
using System.Linq;


namespace Index.Dal
{
    public static class Warranty
    {
        public static Boolean Add(Commons.Warranty model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Warranty(model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Warranty model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Warranty(model.Id, model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Warranty model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Warranty(model.Id);
            }

            return true;
        }

        public static List<Commons.Warranty> Get(Int32? IdWarrabty)
        {
            List<Commons.Warranty> obj = new List<Commons.Warranty>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Warranty_Result> result = db.spg_Warranty(IdWarrabty).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Warranty()
                    {
                        Id = x.Id,
                        Description = x.Description,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }
    }
}
