using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Index.Web.Controllers
{
    public class ErrorController : Controller
    {
        // GET: Error
        public ActionResult Index()
        {
            if (TempData["ERRORMESSAGE"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                ViewBag.ErrorMessage = TempData["ERRORMESSAGE"];

                if (TempData["CLEARDATA"] != null)
                {
                    if ((Boolean)TempData["CLEARDATA"])
                    {
                        Session.Clear();
                    }
                }

                return View();
            }
        }

        public ActionResult MultiplesTabs()
        {
            return View();
        }
    }
}