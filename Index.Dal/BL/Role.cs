using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Role
    {
        public static Boolean Add(Commons.Role model) {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_role(model.Name, model.Description,model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.Role model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_role(model.Id);
            }

            return true;
        }

        public static Boolean Update(Commons.Role model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_role(model.Id, model.Name, model.Description, model.RegisterUser);
            }

            return true;
        }

        public static List<Commons.Role> Get(Int32? IdRole)
        {
            List<Commons.Role> obj = new List<Commons.Role>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Role_Result> result = db.spg_Role(IdRole).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Role()
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Description = x.Description,
                        Premisions = Premission.Get(x.Id)
                    });
                });
            }

            return obj;
        }

        public static List<Commons.UserByRole> Get(String UserName)
        {
            List<Commons.UserByRole> obj = new List<Commons.UserByRole>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_RoleByUser_Result> result = db.spg_RoleByUser(UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.UserByRole()
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Description = x.Description,
                        Premisions = Premission.Get(x.Id),
                        RoleAssigned = (x.RoleAssigned == 1) ? true : false
                    });
                });
            }

            return obj;
        }

        public static List<Commons.UserByRole> GetToAssign(String UserName)
        {
            List<Commons.UserByRole> obj = new List<Commons.UserByRole>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_RoleByUserToAssign_Result> result = db.spg_RoleByUserToAssign(UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.UserByRole()
                    {
                        Id = x.Id,
                        Name = x.Name,
                        Description = x.Description,
                        Premisions = Premission.Get(x.Id),
                        RoleAssigned = (x.RoleAssigned == 1) ? true : false
                    });
                });
            }

            return obj;
        }

        public static Boolean AddUserToRole(String UserName, Int32? IdRole, String RegisterUser)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spi_AssignUserToRole(UserName, IdRole, RegisterUser);
            }

            return true;
        }

        public static Boolean DeleteUserToRole(String UserName, Int32? IdRole)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_AssignUserToRole(UserName, IdRole);
            }

            return true;
        }
    }
}
