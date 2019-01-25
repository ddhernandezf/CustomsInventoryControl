using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal
{
    public static class FileMasterDisplay
    {
        public static Boolean Add(Commons.FileMasterDisplay.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileMasterDisplay(model.IdFileInfoConfig, model.IdField, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.FileMasterDisplay.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileMasterDisplay(model.Id, model.IdFileInfoConfig, model.IdField, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.FileMasterDisplay.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileMasterDisplay(model.Id);
            }

            return true;
        }

        public static List<Commons.FileMasterDisplay.Field> Get(Int32? IdFile)
        {
            List<Commons.FileMasterDisplay.Field> obj = new List<Commons.FileMasterDisplay.Field>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileMasterDisplay_Result> result = db.spg_FileMasterDisplay(IdFile).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileMasterDisplay.Field()
                    {
                        Id = x.Id,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdField = x.IdField,
                        DatabaseName = x.DataBaseName,
                        Label = x.Label,
                        Name = x.Name,
                        IsRequeried = x.IsRequeried,
                        IsUsed = x.IsUsed
                    });
                });
            }

            return obj;
        }
    }
}
