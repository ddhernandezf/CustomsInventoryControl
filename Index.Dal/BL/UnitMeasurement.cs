using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class UnitMeasurement
    {
        public static Boolean Add(Commons.UnitMeasurement model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_UnitMeasurement(model.Name, model.Description, model.Symbol, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.UnitMeasurement model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_UnitMeasurement(model.Id, model.Name, model.Description, model.Symbol, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.UnitMeasurement model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_UnitMeasurement(model.Id);
            }

            return true;
        }

        public static List<Commons.UnitMeasurement> Get(Int32? IdUnitMeasurement)
        {
            List<Commons.UnitMeasurement> obj = new List<Commons.UnitMeasurement>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_UnitMeasurement_Result> result = db.spg_UnitMeasurement(IdUnitMeasurement).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.UnitMeasurement()
                    {
                        Id = x.Id,
                        Symbol = x.Symbol,
                        Description = x.Description,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }
    }
}
