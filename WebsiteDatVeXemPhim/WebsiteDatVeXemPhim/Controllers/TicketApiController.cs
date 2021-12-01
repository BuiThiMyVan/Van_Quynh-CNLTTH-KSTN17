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
                idkhachhang = s.idKhachHang,
                maghe = s.MaGheNgoi,
                ThoiLuong = s.TrangThai,
                Tienbanve = s.TienBanVe,
            }).FirstOrDefault();

            return Json(new { infoTicket = infoTicket });
        }
    }
}