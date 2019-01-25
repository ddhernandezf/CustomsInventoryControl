using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Index.Web.Startup))]
namespace Index.Web
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
