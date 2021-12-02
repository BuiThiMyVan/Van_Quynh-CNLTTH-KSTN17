using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebsiteDatVeXemPhim.EF;
using WebsiteDatVeXemPhim.Models;

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

        //lay danh sach phong chieu
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadListPC(string infoPage)
        {
            Pagination objpage = JsonConvert.DeserializeObject<Pagination>(infoPage);
            var totalRecord = con.PhongChieux.Count();
            var listPC = con.PhongChieux.OrderBy(s => s.id).Skip((objpage.page - 1) * objpage.pageSize).Take(objpage.pageSize).ToList().Select(s => new
            {
                MaPC = s.id,
                TenPhong = s.TenPhong,
                SoChoNgoi = s.SoChoNgoi,
                TinhTrang = s.TinhTrang,
                LoaiManHinh = s.LoaiManHinh,
                NgayTao = s.NgayTao,
                NgayCapNhat = s.NgayCapNhat,

            });

            int totalPage = 0;
            totalPage = (int)Math.Ceiling((double)totalRecord / objpage.pageSize);
            int start = (objpage.page - 1) * objpage.pageSize + 1;
            int end = 0;
            if (objpage.page == totalPage)
            {
                end = totalRecord;
            }
            else
            {
                end = objpage.page * objpage.pageSize;
            }
            return Json(new { lishPC = listPC, totalPage = totalPage, mota = "từ" + start + "đến" + end + "của tổng số" + totalRecord });
        }

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
                return Json(200);
            }
            catch
            {
                return Json(404);
            }
        }
       
    }
}
