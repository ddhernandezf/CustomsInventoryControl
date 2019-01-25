using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal
{
    public static class FileInfo
    {
        public static Boolean Add(Commons.FileInfo model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileInfo(model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.FileInfo model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileInfo(model.Id, model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.FileInfo model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileInfo(model.Id);
            }

            return true;
        }

        public static List<Commons.FileInfo> Get(Int32? IdFileInfo)
        {
            List<Commons.FileInfo> obj = new List<Commons.FileInfo>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileInfo_Result> result = db.spg_FileInfo(IdFileInfo).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileInfo()
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Description = x.Description
                    });
                });
            }

            return obj;
        }

        public static List<Commons.FileInfoType> GetFileTypes()
        {
            List<Commons.FileInfoType> obj = new List<Commons.FileInfoType>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileInfoType_Result> result = db.spg_FileInfoType().ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileInfoType()
                    {
                        Id = x.Id,
                        Name = x.Name
                    });
                });
            }

            return obj;
        }

        public static Boolean AddConfig(Commons.FileInfoConfig model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                Boolean? IsSubstrac = (model.Addition == true) ? ((model.Substraction == true) ? true : false) : true;
                db.spi_FileInfoConfig(model.IdFileInfo, model.IdFileInfoType, model.IdAccount, model.UseAttached, 
                                        IsSubstrac, model.UseRawMaterial,model.Transmissible, model.UseExpired, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean UpdateConfig(Commons.FileInfoConfig model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                Boolean? IsSubstrac = (model.Addition == true) ? ((model.Substraction == true) ? true : false) : true;
                db.spu_FileInfoConfig(model.Id, model.IdFileInfo, model.IdFileInfoType, model.IdAccount, model.UseAttached,
                                        IsSubstrac, model.UseRawMaterial, model.Transmissible, model.UseExpired, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteConfig(Commons.FileInfoConfig model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileInfoConfig(model.Id);
            }

            return true;
        }

        public static List<Commons.FileInfoConfig> GetConfig(Int32? IdFileInfoConfig, Int32? IdFileInfo, Int32? IdAccount)
        {
            List<Commons.FileInfoConfig> obj = new List<Commons.FileInfoConfig>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_FileInfoConfig_Result> result = db.spg_FileInfoConfig(IdFileInfoConfig, IdFileInfo, IdAccount).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.FileInfoConfig()
                    {
                        Id = x.IdFileInfoConfig,
                        IdFileInfo = x.IdFileInfo,
                        FileInfoName = x.FileInfoName,
                        IdFileInfoType = x.IdFileType,
                        FileInfoTypeName = x.FileTypeName,
                        IdAccount = x.IdAccount,
                        AccountName = x.AccountName,
                        DropDownName = x.DropDownListName,
                        Addition = (x.IsSubstract == true) ? false : true,
                        Substraction = (x.IsSubstract == true) ? true : false,
                        UseAttached = x.UseAttached,
                        UseRawMaterial = x.LoadRawMaterial,
                        Transmissible = x.Transmissible,
                        UseExpired = x.UseExpired,
                        Active = x.Active
                    });
                });
            }

            return obj;
        }

        public static Boolean ValidateConfigActive(Int32 IdFileInfoConfig)
        {
            Boolean result = false;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_FileInfoConfigActiveValidate(IdFileInfoConfig).FirstOrDefault().Value;
            }

            return result;
        }
    }
}
