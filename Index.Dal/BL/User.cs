using System;
using System.Linq;
using System.Collections.Generic;

namespace Index.Dal
{
    public static class User
    {
        public static Boolean Add(Commons.User model) {
            using (IndexEntities db = new IndexEntities()) {
                db.spi_User(model.FirstName, model.LastName, model.Nit, model.UserName,
                    model.SitePassword, model.MobilePassword, model.PasswordReset, model.OAuthSite,
                    model.OAuthMobile, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Update(Commons.User model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_User(model.Id, model.FirstName, model.LastName, model.Nit, model.UserName,
                    model.SitePassword, model.MobilePassword, model.PasswordReset, model.OAuthSite,
                    model.OAuthMobile, model.Active, model.RegisterUser);
            }

            return true;
        }

        public static Boolean Delete(Commons.User model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_user(model.UserName);
            }

            return true;
        }

        public static Commons.User SiteLogin(Commons.UserLogin model)
        {
            Commons.User obj = new Commons.User();
            using (IndexEntities db = new IndexEntities())
            {
                sp_SiteLogin_Result result =  db.sp_SiteLogin(model.Username, Functionalities.Security.Cryptography.Encrypt(model.Password)).FirstOrDefault();

                if (result != null)
                {
                    obj.Id = result.IdPerson;
                    obj.FirstName = result.FirstName;
                    obj.LastName = result.LastName;
                    obj.Nit = result.Nit;
                    obj.SitePassword = result.SitePassword;
                    obj.PasswordReset = result.PasswordReset;
                    obj.OAuthSite = result.OAuthSite;
                    obj.OAuthMobile = result.OAuthMobile;
                    obj.Active = result.Active;
                    obj.UserName = result.UserName;
                    obj.Roles = Role.Get(result.UserName);
                }
                else
                {
                    obj = null;
                }
            }

            return obj;
        }

        public static Commons.User MobileLogin(Commons.UserLogin model)
        {
            Commons.User obj = new Commons.User();
            using (IndexEntities db = new IndexEntities())
            {
                sp_MobileLogin_Result result = db.sp_MobileLogin(model.Username, Functionalities.Security.Cryptography.Encrypt(model.Password)).FirstOrDefault();

                if (result != null)
                {
                    obj.Id = result.IdPerson;
                    obj.FirstName = result.FirstName;
                    obj.LastName = result.LastName;
                    obj.Nit = result.Nit;
                    obj.SitePassword = result.SitePassword;
                    obj.PasswordReset = result.PasswordReset;
                    obj.OAuthSite = result.OAuthSite;
                    obj.OAuthMobile = result.OAuthMobile;
                    obj.Active = result.Active;
                    obj.UserName = result.UserName;
                    obj.Roles = Role.Get(result.UserName);
                }
                else
                {
                    obj = null;
                }
            }

            return obj;
        }

        public static Boolean PasswordResetMobile(Commons.UserLogin model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.sp_MobilePasswordReset(model.Username,Functionalities.Security.Cryptography.Encrypt(model.Password));
            }

            return true;
        }

        public static Boolean PasswordResetSite(Commons.UserLogin model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.sp_SitePasswordChange(model.Username, Functionalities.Security.Cryptography.Encrypt(model.Password));
            }

            return true;
        }

        public static List<Commons.User> Get(String UserName)
        {
            List<Commons.User> obj = new List<Commons.User>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_User_Result> result = db.spg_User(UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.User()
                    {
                        Id = x.IdPerson,
                        FirstName = x.FirstName,
                        LastName = x.LastName,
                        Nit = x.Nit,
                        UserName = x.UserName,
                        SitePassword = Functionalities.Security.Cryptography.Decrypt(x.SitePassword),
                        Active = x.Active,
                        MobilePassword = Functionalities.Security.Cryptography.Decrypt(x.MobilePassword),
                        OAuthMobile = x.OAuthMobile,
                        OAuthSite = x.OAuthSite,
                        PasswordReset = x.PasswordReset
                    });
                });
            }

            return obj;
        }

        public static Boolean SiteChangePassword(Commons.UserLogin model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_UserSitePassword(model.Username, model.Password);
            }

            return true;
        }
    }
}
