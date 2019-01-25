using System.Web;
using System.Web.Optimization;

namespace Index.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/site.css",
                      "~/Content/toastr.min.css"));

            bundles.Add(new StyleBundle("~/TelerikMVC/CSS").Include(
                "~/Content/kendo/kendo.common-office365.min.css",
                "~/Content/kendo/kendo.office365.mobile.min.css",
                "~/Content/kendo/kendo.office365.min.css",
                "~/Content/kendo/kendo.dataviz.office365.min.css"));

            bundles.Add(new ScriptBundle("~/TelerikMVC/CULTURE").Include(
                "~/Scripts/kendo/kendo.all.min.js",
                "~/Scripts/kendo/kendo.aspnetmvc.min.js",
                "~/Scripts/kendo/cultures/kendo.culture.es-GT.min.js",
                "~/Scripts/kendo/messages/kendo.messages.es-ES.js"));

            bundles.Add(new ScriptBundle("~/TelerikMVC/JS").Include(
                "~/Scripts/kendo/jquery.min.js",
                "~/Scripts/kendo/jszip.min.js",
                "~/Scripts/kendo/kendo.all.min.js",
                "~/Scripts/kendo/kendo.aspnetmvc.min.js",
                "~/Scripts/kendo/kendo.modernizr.custom.js",
                "~/Scripts/Index.js"
                ));
        }
    }
}
