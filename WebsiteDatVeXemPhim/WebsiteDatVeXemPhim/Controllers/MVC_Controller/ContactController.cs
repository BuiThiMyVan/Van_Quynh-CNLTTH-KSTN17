using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebsiteDatVeXemPhim.EF;
namespace WebsiteDatVeXemPhim.Controllers.MVC_Controller
{
    public class ContactController : Controller
    {
        // GET: Contact
        BookTicketDbConText con = new BookTicketDbConText();
        public ActionResult Index()
        {
            var contact = con.LienHes.Single(x => x.Status == 1);
            return View(contact);
        }
      
    }
}