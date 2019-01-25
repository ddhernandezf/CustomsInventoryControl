using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class PhoneType
    {
        public static List<Commons.PhoneType> Get(Int32? IdPhoneType)
        {
            List<Commons.PhoneType> obj = new List<Commons.PhoneType>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_PhoneType_Result> result = db.spg_PhoneType(IdPhoneType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.PhoneType()
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
