using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Supplier
    {
        public static Boolean Add(Commons.Supplier model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Supplier(model.FirstName, model.LastName, model.Nit, model.Observations, model.RegisterUser, model.IsDestinySupplier);
            }

            return true;
        }

        public static Boolean Update(Commons.Supplier model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Supplier(model.IdPerson, model.FirstName, model.LastName, model.Nit, model.Observations, model.RegisterUser, model.IsDestinySupplier);
            }

            return true;
        }

        public static Boolean Delete(Commons.Supplier model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Supplier(model.IdPerson);
            }

            return true;
        }

        public static List<Commons.Supplier> Get(Int32? IdPerson, Boolean? IsDestinySupplier)
        {
            List<Commons.Supplier> obj = new List<Commons.Supplier>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Supplier_Result> result = db.spg_Supplier(IdPerson, IsDestinySupplier).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Supplier()
                    {
                        IdPerson = x.IdPerson,
                        FirstName = x.FirstName,
                        LastName = x.LastName,
                        Nit = x.Nit,
                        Observations = x.Observations,
                        IsDestinySupplier = x.IsDestinySupplier
                    });
                });
            }

            return obj;
        }
    }
}
