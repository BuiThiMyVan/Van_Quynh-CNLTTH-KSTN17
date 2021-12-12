using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Areas.Admin.Controllers
{
    public class ScheduleController : BaseController
    {
        // GET: Admin/Schedule
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Create(int id)
        {
            ViewBag.Id = id;
            return View();
        }
    }
}