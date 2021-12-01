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

            LichChieu lc = new LichChieu()
            {
                id = 1,
                ThoiGianChieu = DateTime.Now,
                SuatChieu = new SuatChieu()
                {
                    id = 1
                }
                
            };

            con.LichChieux.Add(lc);
            con.SaveChanges();

            var infoTicket = con.Ves.Where(x => x.idLichChieu == idLichchieu).ToList().Select(s => new
            {
                mave = s.id,
                LoaiVe = s.LoaiVe,
                lichchieu = s.idLichChieu,
                idkhachhang = s.idKhachHang,
                maghe = s.MaGheNgoi,
                ThoiLuong = s.TrangThai,
                
            }).FirstOrDefault();

            return Json(new { infoTicket = infoTicket });
        }
        ////them ve khi them lich chieu
      

    }
}