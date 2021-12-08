using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Areas.Admin.Controllers
{
    public class MovieController : Controller
    {
        // GET: Admin/Movie
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult AddFilm()
        {
            return View();
        }

        public ActionResult MyFilm(int id)
        {
            ViewBag.Id = id;
            return View();
        }
    }
}