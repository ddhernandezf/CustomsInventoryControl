using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Currency
    {
        public static Boolean Add(Commons.Currency model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Currency(model.IdCountry, model.Name, model.Description, model.Symbol, model.ExchangeRate, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Currency model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Currency(model.Id, model.IdCountry, model.Name, model.Description, model.Symbol, model.ExchangeRate, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Currency model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Currency(model.Id);
            }

            return true;
        }

        public static List<Commons.Currency> Get(Int32? IdCurrency, Int32? IdCountry)
        {
            List<Commons.Currency> obj = new List<Commons.Currency>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Currency_Result> result = db.spg_Currency(IdCurrency, IdCountry).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Currency()
                    {
                        Id = x.Id,
                        IdCountry = x.IdCountry,
                        CountryName = x.CountryName,
                        Description = x.Description,
                        Name = x.Name,
                        Symbol = x.Symbol,
                        ExchangeRate = x.ExchangeRate
                    });
                });
            }

            return obj;
        }
    }
}
