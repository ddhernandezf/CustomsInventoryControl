using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Index.Web.Controllers
{
    [IndexAuth]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            if (Session["CUSTOMERINFO"] != null && Session["ACCOUNTINFO"] != null)
            {
                DashboardController dashboard = new DashboardController();
                Commons.Customer customer = (Session["CUSTOMERINFO"] == null) ? null : (Commons.Customer)Session["CUSTOMERINFO"];
                Commons.Account cuenta = (Session["ACCOUNTINFO"] == null) ? null : (Commons.Account)Session["ACCOUNTINFO"];

                ViewBag.Customer = dashboard.GetCustomer(customer.Id);
                ViewBag.Expired = dashboard.GetExpired(customer.Id, cuenta.Id);
                ViewBag.Transmited = dashboard.GetTransmited(customer.Id, cuenta.Id);
            }

            return View();
        }

        public ActionResult CambiarRol()
        {
            return View();
        }

        public ActionResult CambiarCliente()
        {
            return View();
        }

        public ActionResult CambiarCuenta()
        {
            return View();
        }

        public ActionResult Expirados(Int32 IdCustomer, Int32 IdAccount)
        {
            ViewBag.IdCustomer = IdCustomer;
            ViewBag.IdAccount = IdAccount;

            return View();
        }

        public ActionResult Transmitidos(Int32 IdCustomer, Int32 IdAccount)
        {
            ViewBag.IdCustomer = IdCustomer;
            ViewBag.IdAccount = IdAccount;

            return View();
        }
    }
}