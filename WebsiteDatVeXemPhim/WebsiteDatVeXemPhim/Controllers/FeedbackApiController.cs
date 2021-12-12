using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebsiteDatVeXemPhim.EF;
namespace WebsiteDatVeXemPhim.Controllers
{
    public class FeedbackApiController : ApiController
    {
        BookTicketDbContext con = new BookTicketDbContext();
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addPhanHoi(PhanHoi objph)
        {
            objph.CreateDate = DateTime.Now;
            objph.Status = 1;
            try
            {
                con.PhanHois.Add(objph);
                con.SaveChanges();
                return Json(200);
            }
            catch
            {
                return Json(404);
            }

        }
    }
}
