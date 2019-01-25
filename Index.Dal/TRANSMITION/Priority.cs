using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal.TRANSMITION
{
    public static class Priority
    {
        public static List<Commons.Transmition.Priority> Get()
        {
            List<Commons.Transmition.Priority> obj = new List<Commons.Transmition.Priority>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Priority_Result> result = db.spg_Priority().ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Transmition.Priority()
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Number = x.Number
                    });
                });
            }

            return obj;
        }
    }
}
