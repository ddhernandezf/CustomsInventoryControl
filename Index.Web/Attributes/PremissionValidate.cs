using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Index.Web
{
    public class PremissionValidate : AuthorizeAttribute
    {
        public string PremissionName { get; set; }

        public PremissionValidate()
        { }

        public PremissionValidate(string Permiso)
        {
            this.PremissionName = Permiso;
        }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (this.PremissionName == "Leer")
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Seguridad", action = "Restriccion" }));
        }
    }
}