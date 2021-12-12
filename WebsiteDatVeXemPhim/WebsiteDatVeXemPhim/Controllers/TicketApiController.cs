using Newtonsoft.Json;
using WebsiteDatVeXemPhim.Models;
using WebsiteDatVeXemPhim.EF;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;
using System.Web.Mvc;
using static WebsiteDatVeXemPhim.EF.Ve;

namespace WebsiteDatVeXemPhim.Controllers
{
    public class TicketApiController : ApiController
    {
        // GET: TicketApi
        BookTicketDbConText con = new BookTicketDbConText();
        ////lấy vé theo lịch chiếu
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult loadListTicketByIdLichchieu(int idLichchieu)
        {
            var listLichChieu = con.Ves.Where(x => x.idLichChieu == idLichchieu).ToList();

            JsonVe jsonreturn = new JsonVe
            {
                listVe = listLichChieu.Select(t => t.CopyObjectForTicket()).ToArray()
            };
            return Json(new { data = jsonreturn });
        }
        ////lấy danh sách vé của khách hàng theo user name
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadTicketByUsername(string Username)
        {
            var kh = con.KhachHangs.Where(x => x.UserName == Username).FirstOrDefault();
            //KhachHang objkh = JsonConvert.DeserializeObject<KhachHang>(khachhang);
            var listVe = (from Ve v in con.Ves
                         where v.idKhachHang == kh.id 
                         select v).OrderByDescending(v => v.NgayTao).ToList(); 
            JsonVe jsonreturn = new JsonVe
            {
                listVe = listVe.Select(t => t.CopyObjectForTicket()).ToArray()
            };
            return Json(new { data = jsonreturn });
        }


        //// đặt vé
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult datVE(Ve objve)
        {
            //Ve objve = JsonConvert.DeserializeObject<Ve>(ve);
            try
            {
                Ve ve = con.Ves.Find(objve.id);
                ve.idKhachHang = objve.idKhachHang;
                ve.TrangThai = (int)Ve.TK.daban;
                ve.NgayCapNhat = DateTime.Now;
                con.SaveChanges();
                return Json(new { message = 200 });
            }
            catch
            {
                return Json(new { message = 404 });
            }
        }
        //hủy vé
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult huyVE(Ve objve)
        {
            //Ve objve = JsonConvert.DeserializeObject<Ve>(ve);
            try
            {
                Ve ve = con.Ves.Find(objve.id);
                ve.idKhachHang = null;
                ve.TrangThai = (int)Ve.TK.chuaban;
                ve.NgayCapNhat = DateTime.Now;
                con.SaveChanges();
                return Json(new { message = 200 });
            }
            catch
            {
                return Json(new { message = 404 });
            }
        }


    }
}