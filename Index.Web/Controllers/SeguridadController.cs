using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Index.Commons;
using Newtonsoft.Json.Linq;
using RestSharp;
using System.Net;
using System.Threading.Tasks;
using System.Web.Security;

namespace Index.Web.Controllers
{
    public class SeguridadController : Controller
    {
        Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

        public ActionResult LogOut()
        {
            Session.Clear();
            TempData.Clear();
            //return RedirectToAction("Login", "Seguridad");

            return View();
        }

        [AllowAnonymous]
        public ActionResult Login()
        {
            return View(new UserLogin());
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(UserLogin model)
        {
            Commons.User response = new Commons.User();
            if (ModelState.IsValid)
            {
                IRestResponse result = Task.Run(() => apiClient.getJArray("Seguridad/Autenticar/Web",
                    "UserName=" + model.Username
                    + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.Password))).Result;

                if (result.StatusCode == HttpStatusCode.OK)
                {
                    if (result.Content != "null")
                    {
                        response = Newtonsoft.Json.JsonConvert.DeserializeObject<Commons.User>(result.Content);
                        if (response.Active)
                        {
                            FormsAuthentication.SetAuthCookie(model.Username, true);
                            Session["USERINFO"] = response;
                            Session["STRUSERNAME"] = response.UserName;

                            List<Role> roles = new List<Role>();
                            IRestResponse wsrAssigned = Task.Run(() => apiClient.getJArray("Rol/ListarPorUsuario", "UserName=" + response.UserName)).Result;
                            if (wsrAssigned.StatusCode == HttpStatusCode.OK)
                            {
                                roles = JArray.Parse(wsrAssigned.Content).ToObject<List<Role>>();
                            }

                            if (roles.Count == 0)
                            {
                                ModelState.AddModelError("", "Su usuario no cuenta no cuenta con roles asignados en el sistema. Comuníquese con el administrador de seguridad de la aplicación.");
                                return View(model);
                            }
                            else if (response.PasswordReset)
                            {
                                if (response.OAuthMobile == true && response.OAuthSite == true)
                                {
                                    TempData["USERNAME"] = response.UserName;
                                    if (roles.Count == 1)
                                    {
                                        Session["ROLEINFO"] = roles[0];
                                        Session["MENUINFO"] = new MenuController().Get(roles[0].Name, response.UserName);
                                    }
                                    Session["GOTCUSTOMER"] = new UsuarioController().GotUserAssigned(response.UserName);
                                    Session.Timeout = 30;
                                    return RedirectToAction("Cambio", "Seguridad");
                                }
                                else
                                {
                                    if (response.OAuthMobile)
                                    {
                                        TempData["USERNAME"] = response.UserName;
                                        if (roles.Count == 1)
                                        {
                                            Session["ROLEINFO"] = roles[0];
                                            Session["MENUINFO"] = new MenuController().Get(roles[0].Name, response.UserName);
                                        }
                                        Session["GOTCUSTOMER"] = new UsuarioController().GotUserAssigned(response.UserName);
                                        Session.Timeout = 30;
                                        return RedirectToAction("CambioMovil", "Seguridad");
                                    }
                                    else if (response.OAuthSite)
                                    {
                                        TempData["USERNAME"] = response.UserName;
                                        if (roles.Count == 1)
                                        {
                                            Session["ROLEINFO"] = roles[0];
                                            Session["MENUINFO"] = new MenuController().Get(roles[0].Name, response.UserName);
                                        }
                                        Session["GOTCUSTOMER"] = new UsuarioController().GotUserAssigned(response.UserName);
                                        Session.Timeout = 30;
                                        return RedirectToAction("CambioWeb", "Seguridad");
                                    }
                                    else
                                    {
                                        if (roles.Count == 1)
                                        {
                                            Session["ROLEINFO"] = roles[0];
                                            Session["MENUINFO"] = new MenuController().Get(roles[0].Name, response.UserName);
                                        }
                                        Session["GOTCUSTOMER"] = new UsuarioController().GotUserAssigned(response.UserName);
                                        Session.Timeout = 30;
                                        return RedirectToAction("EvaluteAssigned");
                                    }
                                }
                            }
                            else
                            {
                                if (roles.Count == 1)
                                {
                                    Session["ROLEINFO"] = roles[0];
                                    Session["MENUINFO"] = new MenuController().Get(roles[0].Name, response.UserName);
                                }
                                Session["GOTCUSTOMER"] = new UsuarioController().GotUserAssigned(response.UserName);
                                Session.Timeout = 30;
                                return RedirectToAction("EvaluteAssigned");
                            }
                        }
                        else
                        {
                            ModelState.AddModelError("", "Credenciales incorrectas");
                            return View(model);
                        }
                    }
                    else
                    {
                        ModelState.AddModelError("", "Credenciales incorrectas");
                        return View(model);
                    }
                }
                else
                {
                    ModelState.AddModelError("", JObject.Parse(result.Content).ToObject<Commons.Error>().Message.ToString());
                    return View(model);
                }
            }
            else
            {
                return View(model);
            }
        }

        public JsonResult jsonLogin(UserLogin model)
        {
            Boolean response = false;
            IRestResponse result = Task.Run(() => apiClient.getJArray("Seguridad/Autenticar/Web",
                    "UserName=" + model.Username
                    + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.Password))).Result;

            if (result.StatusCode == HttpStatusCode.OK)
            {
                if (result.Content != "null")
                {
                    response = true;
                }
            }

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public JsonResult jsonCambiarPassword(UserLogin model)
        {
            Boolean response = false;
            IRestResponse result = Task.Run(() => apiClient.getJArray("Usuario/CambiarPassword",
                    "UserName=" + model.Username
                    + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.Password))).Result;

            if (result.StatusCode == HttpStatusCode.OK)
            {
                response = Convert.ToBoolean(result.Content);
            }

            return Json(response, JsonRequestBehavior.AllowGet);
        }

        [IndexAuth]
        public ActionResult CambiarPassword()
        {
            return View();
        }

        [AllowAnonymous]
        public ActionResult Restriccion()
        {
            return View();
        }

        [IndexAuth]
        public ActionResult CambioWeb()
        {
            PasswordSiteReset model = new PasswordSiteReset();
            model.UserName = TempData["USERNAME"].ToString();

            return View(model);
        }

        [HttpPost]
        [IndexAuth]
        [ValidateAntiForgeryToken]
        public ActionResult CambioWeb(PasswordSiteReset model)
        {
            if (ModelState.IsValid)
            {
                if (model.SitePassword == model.SitePasswordConfirm)
                {
                    Boolean flagWeb = false;
                    IRestResponse rsltWeb = Task.Run(() => apiClient.getJArray("Seguridad/Reset/Password/Web",
                                                        "UserName=" + model.UserName
                                                        + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.SitePassword))).Result;

                    if (rsltWeb.StatusCode == HttpStatusCode.OK)
                    {
                        flagWeb = Convert.ToBoolean(rsltWeb.Content);
                    }

                    if (flagWeb)
                    {
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        ModelState.AddModelError("", "Error desconocido");
                        return View(model);
                    }
                }
                else
                {
                    if (model.SitePassword != model.SitePasswordConfirm)
                    {
                        ModelState.AddModelError("SitePasswordConfirm", "Los passwords no coinciden");
                    }

                    return View(model);
                }
            }
            else
            {
                return View(model);
            }
        }

        [IndexAuth]
        public ActionResult CambioMovil()
        {
            PasswordMobileReset model = new PasswordMobileReset();
            model.UserName = TempData["USERNAME"].ToString();

            return View(model);
        }

        [HttpPost]
        [IndexAuth]
        [ValidateAntiForgeryToken]
        public ActionResult CambioMovil(PasswordMobileReset model)
        {
            if (ModelState.IsValid)
            {
                if (model.MobilePassword == model.MobilePasswordConfirm)
                {
                    Boolean FlagMovil = false;
                    IRestResponse rsltMovil = Task.Run(() => apiClient.getJArray("Seguridad/Reset/Password/Movil",
                                                        "UserName=" + model.UserName
                                                        + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.MobilePassword))).Result;

                    if (rsltMovil.StatusCode == HttpStatusCode.OK)
                    {
                        FlagMovil = Convert.ToBoolean(rsltMovil.Content);
                    }

                    if (FlagMovil)
                    {
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        ModelState.AddModelError("", "Error desconocido");
                        return View(model);
                    }
                }
                else
                {
                    if (model.MobilePassword != model.MobilePasswordConfirm)
                    {
                        ModelState.AddModelError("MobilePasswordConfirm", "Los passwords no coinciden");
                    }

                    return View(model);
                }
            }
            else
            {
                return View(model);
            }
        }

        [IndexAuth]
        public ActionResult Cambio()
        {
            PasswordReset model = new PasswordReset();
            model.UserName = TempData["USERNAME"].ToString();

            return View(model);
        }

        [HttpPost]
        [IndexAuth]
        [ValidateAntiForgeryToken]
        public ActionResult Cambio(PasswordReset model)
        {
            if (ModelState.IsValid)
            {
                if ((model.MobilePassword == model.MobilePasswordConfirm) && (model.SitePassword == model.SitePasswordConfirm))
                {
                    Boolean flagWeb = false, FlagMovil = false;
                    IRestResponse rsltWeb = Task.Run(() => apiClient.getJArray("Seguridad/Reset/Password/Web",
                                                        "UserName=" + model.UserName
                                                        + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.SitePassword))).Result;
                    IRestResponse rsltMovil = Task.Run(() => apiClient.getJArray("Seguridad/Reset/Password/Movil",
                                                        "UserName=" + model.UserName
                                                        + "&Password=" + Functionalities.Security.Cryptography.Encrypt(model.MobilePassword))).Result;

                    if (rsltWeb.StatusCode == HttpStatusCode.OK)
                    {
                        flagWeb = Convert.ToBoolean(rsltWeb.Content);
                    }
                    if (rsltMovil.StatusCode == HttpStatusCode.OK)
                    {
                        FlagMovil = Convert.ToBoolean(rsltMovil.Content);
                    }

                    if (flagWeb && FlagMovil)
                    {
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        ModelState.AddModelError("", "Error desconocido");
                        return View(model);
                    }
                }
                else
                {
                    if (model.MobilePassword != model.MobilePasswordConfirm)
                    {
                        ModelState.AddModelError("MobilePasswordConfirm", "Los passwords no coinciden");
                    }
                    if (model.SitePassword != model.SitePasswordConfirm)
                    {
                        ModelState.AddModelError("SitePasswordConfirm", "Los passwords no coinciden");
                    }

                    return View(model);
                }
            }
            else
            {
                return View(model);
            }
        }

        [IndexAuth]
        public ActionResult GetComboRoles()
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Rol/ListarPorUsuario", "UserName=" + user.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                return Json(JArray.Parse(WSR.Content).ToObject<List<PhoneType>>().Select(x => new { Id = x.Id, Name = x.Description }).ToList(), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return null;
            }
        }

        [IndexAuth]
        public ActionResult ChangeRole(Int32 IdRole)
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Role role = (Commons.Role)Session["ROLEINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Rol/ListarPorUsuario", "UserName=" + user.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Role> roles = JArray.Parse(WSR.Content).ToObject<List<Role>>();
                Role item = roles.FirstOrDefault(x => x.Id == IdRole);

                if (item != null)
                {
                    Session.Remove("ROLEINFO");
                    Session.Remove("MENUINFO");
                    Session["ROLEINFO"] = item;
                    Session["MENUINFO"] = new MenuController().Get(item.Name, user.UserName);


                    return Json(true, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(false, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }

        [IndexAuth]
        public ActionResult ChangeCustomer(Int32 IdCustomer)
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Account AccountInfo = (Commons.Account)Session["ACCOUNTINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/ListarAsignados", "UserName=" + user.UserName + "&IdAccount=" + AccountInfo.Id)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Customer> customers = JArray.Parse(WSR.Content).ToObject<List<Customer>>();
                Customer item = customers.FirstOrDefault(x => x.Id == IdCustomer);

                if (item != null)
                {
                    Session.Remove("CUSTOMERINFO");
                    Session["CUSTOMERINFO"] = item;
                    Session.Remove("IDFILEHEADER");
                    TempData.Clear();

                    return Json(true, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(false, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }

        [IndexAuth]
        public ActionResult ChangeAccount(Int32 IdAccount)
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Cliente/Listar/Cuentas", "UserName=" + user.UserName)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                List<Account> customers = JArray.Parse(WSR.Content).ToObject<List<Account>>();
                Account item = customers.FirstOrDefault(x => x.Id == IdAccount);
                if (item != null)
                {
                    Session.Remove("ACCOUNTINFO");
                    Session["ACCOUNTINFO"] = item;
                    Session.Remove("CUSTOMERINFO");
                    Session.Remove("IDFILEHEADER");
                    TempData.Clear();

                    return Json(true, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(false, JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }

        [IndexAuth]
        public ActionResult EvaluteAssigned()
        {
            Commons.User user = (Commons.User)Session["USERINFO"];
            Commons.Role role = (Commons.Role)Session["ROLEINFO"];

            List<Account> accounts = new List<Account>();
            IRestResponse wsrAccounts = Task.Run(() => apiClient.getJArray("Cliente/Listar/Cuentas", "UserName=" + user.UserName)).Result;
            if (wsrAccounts.StatusCode == HttpStatusCode.OK)
            {
                accounts = JArray.Parse(wsrAccounts.Content).ToObject<List<Account>>().ToList();
            }

            if (accounts.Count == 1)
            {
                Account cuenta = accounts.FirstOrDefault();
                Session["ACCOUNTINFO"] = cuenta;
                ChangeAccount(cuenta.Id);

                List<Customer> customers = new List<Customer>();
                IRestResponse wsrCustomers = Task.Run(() => apiClient.getJArray("Cliente/ListarAsignados", "UserName=" + user.UserName + "&IdAccount=" + cuenta.Id)).Result;
                if (wsrCustomers.StatusCode == HttpStatusCode.OK)
                {
                    customers = JArray.Parse(wsrCustomers.Content).ToObject<List<Customer>>().ToList();
                }

                if (customers.Count == 1)
                {
                    Customer cliente = customers.FirstOrDefault();
                    @Session["CUSTOMERINFO"] = cliente;
                    ChangeCustomer(cliente.Id);
                }

                return RedirectToAction("Index", "Home");
            }
            else
            {
                if (accounts.Count == 0)
                {
                    if (new PermisosController().Validate(user.UserName, null, "Asignar Clientes") == true)
                    {
                        return RedirectToAction("Index", "Cliente");
                    }
                    else
                    {
                        TempData["ERRORMESSAGE"] = "No cuenta con clientes asignados a su usuario. Comuníquese con el administrador de seguridad del sistema.";
                        TempData["CLEARDATA"] = true;
                        return RedirectToAction("Index", "Error");
                    }
                }
                else
                {
                    return RedirectToAction("Index", "Home");
                }
            }
        }

        public JsonResult IsSessionAlive()
        {
            Boolean result = true;

            if (System.Web.HttpContext.Current.Session["USERINFO"] == null)
            {
                result = false;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        public JsonResult SetGUID(String guid) {
            Session["GUID"] = guid;

            return Json(true, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        public JsonResult GetGUID()
        {
            return Json((Session["GUID"] == null) ? "" : Session["GUID"], JsonRequestBehavior.AllowGet);
        }
    }
}