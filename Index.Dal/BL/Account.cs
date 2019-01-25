using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Account
    {
        public static Boolean Add(Commons.Account model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Account(model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Account model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Account(model.Id, model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Account model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Account(model.Id);
            }

            return true;
        }

        public static List<Commons.Account> Get(Int32? IdAccount)
        {
            List<Commons.Account> obj = new List<Commons.Account>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Account_Result> result = db.spg_Account(IdAccount).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Account()
                    {
                        Id = x.Id,
                        Description = x.Description,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Account> GetAccountsByCustomer(Int32? IdPerson)
        {
            List<Commons.Account> obj = new List<Commons.Account>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_AccountByCustomer_Result> result = db.spg_AccountByCustomer(IdPerson).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Account()
                    {
                        Id = x.IdAccount,
                        Description = x.Description,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }
    }
}
