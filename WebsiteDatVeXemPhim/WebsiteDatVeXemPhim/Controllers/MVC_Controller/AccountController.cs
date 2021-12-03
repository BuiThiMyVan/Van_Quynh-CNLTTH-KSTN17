using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Controllers.MVC_Controller
{
    public class AccountController : Controller
    {
        // GET: Account
        public ActionResult Index()
        {
            return View();
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Login()
        {
            //    ADMIN admin = new ADMIN();
            //    model.Password = admin.EncodePassword(model.Password);
            //    var res = con.ADMINs.Where(a => a.Username == model.Username && a.Password == model.Password).SingleOrDefault();
            //    var res_username = con.ADMINs.Where(a => a.Username == model.Username).SingleOrDefault();
            //    var result = 0;

            //    //Login successfully
            //    if (res != null)
            //    {
            //        //Set Session
            //        var adminSession = new ADMIN();
            //        adminSession.Username = res.Username;
            //        adminSession.Id = res.Id;
            //        adminSession.Password = res.Password;
            //        Session.Add(CommonConstants.USER_SESSION, adminSession);
            //        result = 1;
            //    }
            //    else
            //    {
            //        if (res_username != null)
            //        {
            //            //Account doesn't exist
            //            result = 3;
            //        }
            //        else
            //        {
            //            //Fill wrong password
            //            result = 2;
            //        }
            //    }
            //    return new JsonResult() { Data = result };
            return View();

        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public ActionResult Register()
        {
            return View();
        }
    }
}