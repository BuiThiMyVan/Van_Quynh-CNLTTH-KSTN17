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


namespace WebsiteDatVeXemPhim.Controllers
{
    public class TicketApiController : ApiController
    {
        // GET: TicketApi
        BookTicketDbContext con = new BookTicketDbContext();
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult loadListTicketByIdLichchieu(int idLichchieu)
        {
            var infoTicket = con.Ves.Where(x => x.idLichChieu == idLichchieu).ToList().Select(s => new
            {
                mave = s.id,
                LoaiVe = s.LoaiVe,
                lichchieu = s.idLichChieu,
                maghengoi = s.MaGheNgoi,
                sohang = s.SoHang,
                socot = s.SoCot,
                idkhachhang = s.idKhachHang,
                trangthai = s.TrangThai,
                ngaytao = s.NgayTao,
                ngaycapnhat = s.NgayCapNhat
            });

            return Json(new { infoTicket = infoTicket });
        }
        ////dat ve chua chay dc
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


    }
}