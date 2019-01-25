using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class AddressType
    {
        public static List<Commons.AddressType> Get(Int32? IdAddressType)
        {
            List<Commons.AddressType> obj = new List<Commons.AddressType>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_AddressType_Result> result = db.spg_AddressType(IdAddressType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.AddressType()
                    {
                        Id = x.Id,
                        Description = x.Description
                    });
                });
            }

            return obj;
        }
    }
}
