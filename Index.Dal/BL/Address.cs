using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Address
    {
        public static Boolean Add(Commons.Address model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_Address(model.AddressValue, model.IdPerson, model.IdAddressType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.Address model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_Address(model.Id, model.AddressValue, model.IdPerson, model.IdAddressType, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Address model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_Address(model.Id);
            }

            return true;
        }

        public static List<Commons.Address> Get(Int32? IdPerson, Int32? IdAddressType)
        {
            List<Commons.Address> obj = new List<Commons.Address>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Address_Result> result = db.spg_Address(IdPerson, IdAddressType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Address()
                    {
                        Id = x.Id,
                        IdPerson = x.IdPerson,
                        IdAddressType = x.IdAddressType,
                        AddressTypeDescription = x.AddressTypeDesc,
                        AddressValue = x.Address
                    });
                });
            }

            return obj;
        }
    }
}
