using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Controllers.MVC_Controller
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult Account()
        {
            return PartialView();
        }

        public ActionResult DetailsFilm(int id)
        {
            ViewBag.Id = id;
            return View();
        }

        public ActionResult BookingTicket(int idLichChieu, int idPhim)
        {
            var session = Session["USER_SESSION"];
            if(session == null)
            {
                return Redirect("/Account/Login?idPhim=" + idPhim);
            }

            ViewBag.idLichChieu = idLichChieu;
            ViewBag.idPhim = idPhim;
            return View();
        }
    }
}