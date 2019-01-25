using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Field
    {
        public static Boolean AddMaster(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileMasterDisplay(model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean UpdateMaster(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileMasterDisplay(model.IdMaster, model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteMaster(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileMasterDisplay(model.IdMaster);
            }

            return true;
        }

        public static List<Commons.Field> GetMaster(Int32? IdFileInfoConfig)
        {
            List<Commons.Field> obj = new List<Commons.Field>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FieldsMasterDisplay_Result> result = db.spg_FieldsMasterDisplay(IdFileInfoConfig).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Field()
                    {
                        Id = x.IdField,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdMaster = x.IdMaster,
                        IdTable = x.IdTable,
                        DataBaseName = x.DataBaseName,
                        FieldName = x.FieldName,
                        HtmlObject = x.ObjectHtml,
                        IsRequeried = x.IsRequeried,
                        IsRequeriedInternal = x.IsRequiredInternal,
                        IsUsed = x.IsUsed,
                        Label = x.Label,
                        TableName = x.TableName
                    });
                });
            }

            return obj;
        }

        public static Boolean AddDetail(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileDetailDisplay(model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean UpdateDetail(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileDetailDisplay(model.IdMaster, model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteDetail(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileDetailDisplay(model.IdMaster);
            }

            return true;
        }

        public static List<Commons.Field> GetDetail(Int32? IdFileInfo)
        {
            List<Commons.Field> obj = new List<Commons.Field>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FieldsDetailDisplay_Result> result = db.spg_FieldsDetailDisplay(IdFileInfo).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Field()
                    {
                        Id = x.IdField,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdMaster = x.IdMaster,
                        IdTable = x.IdTable,
                        DataBaseName = x.DataBaseName,
                        FieldName = x.FieldName,
                        HtmlObject = x.ObjectHtml,
                        IsRequeried = x.IsRequeried,
                        IsRequeriedInternal = x.IsRequiredInternal,
                        IsUsed = x.IsUsed,
                        Label = x.Label,
                        TableName = x.TableName
                    });
                });
            }

            return obj;
        }

        public static Boolean AddAttached(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileAttachedDisplay(model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean UpdateAttached(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileAttachedDisplay(model.IdMaster, model.IdFileInfoConfig, model.Id, model.Label, model.IsUsed, model.IsRequeried, model.RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteAttached(Commons.Field model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileAttachedDisplay(model.IdMaster);
            }

            return true;
        }

        public static List<Commons.Field> GetAttached(Int32? IdFileInfo)
        {
            List<Commons.Field> obj = new List<Commons.Field>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FieldsAttachedDisplay_Result> result = db.spg_FieldsAttachedDisplay(IdFileInfo).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Field()
                    {
                        Id = x.IdField,
                        IdFileInfoConfig = x.IdFileInfoConfig,
                        IdMaster = x.IdMaster,
                        IdTable = x.IdTable,
                        DataBaseName = x.DataBaseName,
                        FieldName = x.FieldName,
                        IsRequeried = x.IsRequeried,
                        IsRequeriedInternal = x.IsRequiredInternal,
                        IsUsed = x.IsUsed,
                        Label = x.Label,
                        TableName = x.TableName
                    });
                });
            }

            return obj;
        }
    }
}
