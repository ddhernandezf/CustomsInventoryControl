using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class EmailType
    {
        public static List<Commons.EmailType> Get(Int32? IdEmailType)
        {
            List<Commons.EmailType> obj = new List<Commons.EmailType>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_EmailType_Result> result = db.spg_EmailType(IdEmailType).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.EmailType()
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
