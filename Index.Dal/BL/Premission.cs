using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Premission
    {
        public static List<Commons.Premission> Get(Int32? IdRole)
        {
            List<Commons.Premission> obj = new List<Commons.Premission>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_premission_Result> result = db.spg_premission(IdRole).ToList();
                result.ForEach(x =>
                {
                    obj.Add(new Commons.Premission()
                    {
                        Id = x.IdPremission,
                        IdParent = x.IdParent,
                        IdRole = x.IdRole,
                        RoleName = x.RoleName,
                        Area = x.Area,
                        Controller = x.Controller,
                        Action = x.Action,
                        Parameters = x.Parameters,
                        Name = x.Name,
                        Description = x.Description
                    });
                });
            }

            return obj;
        }

        public static Boolean AddRoleToPremission(Int32? IdRole, Int32? IdPremission, String RegisterUser)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_AssignRoleToPremission(IdRole, IdPremission, RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteRoleToPremision(Int32? IdRole, Int32? IdPremission)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_AssignRoleToPremission(IdRole, IdPremission);
            }

            return true;
        }

        public static List<Commons.PremissionTree> getTree(Int32? IdRole)
        {
            List<Commons.PremissionTree> obj = new List<Commons.PremissionTree>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_PremissionByRole_Result> result = db.spg_PremissionByRole(IdRole).ToList();
                List<spg_PremissionByRole_Result> childs = result;

                result.Where(z => z.IdParent == 0).ToList().ForEach(x =>
                {
                    obj.Add(new Commons.PremissionTree()
                    {
                        Id = x.Id,
                        IdParent = null,
                        Name = x.Name,
                        Assigned = (x.PremissionAssigned == 1) ? true : false,
                        Image = x.Image,
                        HasChildren = getChilds(childs.Where(a => a.IdParent == x.Id).ToList(), IdRole)
                    });
                });
            }

            return obj;
        }

        private static List<Commons.PremissionTree> getChilds(List<spg_PremissionByRole_Result> data, Int32? idrole)
        {
            List<Commons.PremissionTree> result = new List<Commons.PremissionTree>();

            using (IndexEntities db = new IndexEntities())
            {
                data.ForEach(x =>
                {
                    result.Add(new Commons.PremissionTree()
                    {
                        Id = x.Id,
                        IdParent = x.IdParent,
                        Name = x.Name,
                        Assigned = (x.PremissionAssigned == 1) ? true : false,
                        Image = x.Image,
                        HasChildren = getChilds(db.spg_PremissionByRole(idrole).Where(b => b.IdParent == x.Id).ToList(), idrole)
                    });
                });
            }

            return result;
        }

        public static Boolean? Validate(String UserName, String RoleName, String PremissionName)
        {
            Boolean? result;
            using (IndexEntities db = new IndexEntities())
            {
                result = db.spg_PremissionValidate(UserName, RoleName, PremissionName).FirstOrDefault();
            }

            return result;
        }
    }
}
