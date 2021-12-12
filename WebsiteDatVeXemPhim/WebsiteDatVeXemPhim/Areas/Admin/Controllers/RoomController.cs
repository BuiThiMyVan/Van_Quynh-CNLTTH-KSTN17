using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Areas.Admin.Controllers
{
    public class RoomController : BaseController
    {
        // GET: Admin/Room
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public ActionResult MyRoom(int id)
        {
            ViewBag.Id = id;
            return View();
        }
    }
}