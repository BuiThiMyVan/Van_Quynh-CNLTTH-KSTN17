﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebsiteDatVeXemPhim.Areas.Admin.Controllers
{
    public class ScheduleController : Controller
    {
        // GET: Admin/Schedule
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Create()
        {
            return View();
        }
    }
}