using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using WebsiteDatVeXemPhim.Common;
using WebsiteDatVeXemPhim.EF;

namespace WebsiteDatVeXemPhim.Controllers.MVC_Controller
{
    public class AccountController : Controller
    {
        BookTicketDbConText con = new BookTicketDbConText();
        // GET: Account
        public ActionResult Index()
        {
            return View();
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Login()
        {
            return View();
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult checkLogin(NguoiDung model)
        {
            model.Pass = new KhachHang().EncodePassword(model.Pass);
            var res = con.NguoiDungs.Where(a => a.UserName == model.UserName && a.Pass == model.Pass).SingleOrDefault();
            var res_username = con.NguoiDungs.Where(a => a.UserName == model.UserName).SingleOrDefault();
            var result = 0;

            //Login successfully
            if (res != null)
            {
                //Set Session
                var userSession = new NguoiDung();
                userSession.UserName = res.UserName;
                Session.Add(CommonConstants.USER_SESSION, userSession);
                result = 1;
            }
            else
            {
                if (res_username != null)
                {
                    //Account doesn't exist
                    result = 3;
                }
                else
                {
                    //Fill wrong password
                    result = 2;
                }
            }
            return Json(new { result = result });
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Register()
        {
            return View();
        }

        [HttpGet]
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            return RedirectToAction("Index", "Home");
        }

       	[System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Details()
        {
            return View();
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Error404()
        {
            return View();
        }
    }
}