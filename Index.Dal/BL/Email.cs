using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Email
    {
        public static Boolean Add(Commons.Email model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Email(model.EmailAddress, model.IdPerson, model.IdEmailType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Email model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Email(model.Id, model.EmailAddress, model.IdPerson, model.IdEmailType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Email model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Email(model.Id);
            }

            return true;
        }

        public static List<Commons.Email> Get(Int32? IdPerson, Int32? IdEmailType)
        {
            List<Commons.Email> obj = new List<Commons.Email>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Email_Result> result = db.spg_Email(IdPerson,IdEmailType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Email()
                    {
                        Id = x.Id,
                        IdPerson = x.IdPerson,
                        IdEmailType = x.IdEmailType,
                        EmailTypeDescription = x.PhoneTypeDesc,
                        EmailAddress = x.Email
                    });
                });
            }

            return obj;
        }
    }
}
