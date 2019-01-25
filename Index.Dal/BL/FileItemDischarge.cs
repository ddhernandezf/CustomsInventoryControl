
using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class FileItemDischarge
    {
        public static Boolean Add(Commons.FileItemDischarge model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_FileItemDischarge(model.IdFileDetailSubstract, model.IdFileDetailStock, model.Quantity,
                    model.Decrease, model.UseFormula, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.FileItemDischarge model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_FileItemDischarge(model.IdFileDetailSubstract, model.IdFileDetailStock, model.Quantity,
                    model.Decrease, model.UseFormula, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Operate(Commons.FileItemDischarge model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spo_FileItemDischarge(model.IdFileDetailSubstract, model.IdFileDetailStock, model.Quantity,
                    model.Decrease, model.UseFormula, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.FileItemDischarge model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileItemDischarge(model.IdFileDetailSubstract, model.IdFileDetailStock);
            }

            return true;
        }

        public static Boolean DeleteTransmited(Int32 IdFileItemDischarge)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_FileItemDischargeTransmited(IdFileItemDischarge);
            }

            return true;
        }

        public static Commons.FileItemDischargeValidateResponse IsValidate(Int32 IdFileItemDischarge)
        {
            Commons.FileItemDischargeValidateResponse obj = new Commons.FileItemDischargeValidateResponse();
            using (IndexEntities db = new IndexEntities())
            {
                spg_FilItemDischargeValidate_Result x = db.spg_FilItemDischargeValidate(IdFileItemDischarge).FirstOrDefault();
                obj.IsValid = x.IsValid;
                obj.ErrorMsg = x.ErrorMsg;
            }

            return obj;
        }
    }
}
