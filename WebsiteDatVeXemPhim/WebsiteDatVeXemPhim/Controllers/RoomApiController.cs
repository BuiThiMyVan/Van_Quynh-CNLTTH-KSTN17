using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebsiteDatVeXemPhim.EF;
using WebsiteDatVeXemPhim.Models;
using static WebsiteDatVeXemPhim.EF.PhongChieu;

namespace WebsiteDatVeXemPhim.Controllers
{
    public class RoomApiController : ApiController
    {
        BookTicketDbContext con = new BookTicketDbContext();
        // lay phong chieu theo id
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult getPhongChieubyId(int maPC)
        {
            var infoPC = con.PhongChieux.Where(x => x.id == maPC).ToList().Select(s => new
            {
                MaPC = s.id,
                TenPhong = s.TenPhong,
                SoChoNgoi = s.SoChoNgoi,
                TinhTrang = s.TinhTrang,
                LoaiManHinh = s.LoaiManHinh,
                NgayTao = s.NgayTao,
                NgayCapNhat = s.NgayCapNhat,

            }).FirstOrDefault();

            return Json(new { infoPC = infoPC });
        }

        //lay danh sach phong chieu hiển thị lên commbobox
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadListPC()
        {
            var listPhongChieu = con.PhongChieux.ToList();

            JsonPhongChieu jsonreturn = new JsonPhongChieu
            {
                listPhongChieu = listPhongChieu.Select(t => t.CopyObjectForMovieRoom()).ToArray()
            };
            return Json(new { data = jsonreturn });
        }
        //sửa phòng chiếu
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult updatePC(string PC)
        {
            PhongChieu objPC = JsonConvert.DeserializeObject<PhongChieu>(PC);
            try
            {
                PhongChieu PhongChieu = con.PhongChieux.Find(objPC.id);
                PhongChieu.TenPhong = objPC.TenPhong;
                PhongChieu.SoChoNgoi = objPC.SoChoNgoi;
                PhongChieu.SoHang = objPC.SoHang;
                PhongChieu.SoCot = objPC.SoCot;
                PhongChieu.TinhTrang = objPC.TinhTrang;
                PhongChieu.LoaiManHinh = objPC.LoaiManHinh;
                PhongChieu.NgayTao = null;
                PhongChieu.NgayCapNhat = DateTime.Now;
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
