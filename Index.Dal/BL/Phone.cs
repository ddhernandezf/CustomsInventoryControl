using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Phone
    {
        public static Boolean Add(Commons.Phone model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Phone(model.Number, model.IdPerson, model.IdPhoneType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Phone model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Phone(model.Id, model.Number, model.IdPerson, model.IdPhoneType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Phone model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Phone(model.Id);
            }

            return true;
        }

        public static List<Commons.Phone> Get(Int32? IdPerson, Int32? IdPhoneType)
        {
            List<Commons.Phone> obj = new List<Commons.Phone>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Phone_Result> result = db.spg_Phone(IdPerson,IdPhoneType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Phone()
                    {
                        Id = x.Id,
                        IdPerson = x.IdPerson,
                        IdPhoneType = x.IdPhoneType,
                        PhoneTypeDescription = x.PhoneTypeDesc,
                        Number = x.Number
                    });
                });
            }

            return obj;
        }
    }
}
