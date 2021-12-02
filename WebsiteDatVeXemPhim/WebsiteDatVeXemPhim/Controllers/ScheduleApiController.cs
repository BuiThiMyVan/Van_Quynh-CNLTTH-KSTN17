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
    public class ScheduleApiController : ApiController
    {

        BookTicketDbContext con = new BookTicketDbContext();
        // lay Suất chiếu theo id
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult getSuatChieuById(int masc)
        {
            var infoSC = con.SuatChieux.Where(x => x.id == masc).ToList().Select(s => new
            {
                MaSC = s.id,
                SuatChieu = s.SuatChieu1,

            }).FirstOrDefault();

            return Json(new { infoSC = infoSC });
        }

        //lay danh sach Suất chiếu
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadListPC(string infoPage)
        {
            Pagination objpage = JsonConvert.DeserializeObject<Pagination>(infoPage);
            var totalRecord = con.SuatChieux.Count();
            var listSC = con.SuatChieux.OrderBy(s => s.id).Skip((objpage.page - 1) * objpage.pageSize).Take(objpage.pageSize).ToList().Select(s => new
            {
                MaSC = s.id,
                SuatChieu = s.SuatChieu1,

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
            return Json(new { listSC = listSC, totalPage = totalPage, mota = "từ" + start + "đến" + end + "của tổng số" + totalRecord });
        }
        ////thêm 1 lịch chiếu thì thêm vé
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult addLichChieu(string lc)
        {
            LichChieu objlc = JsonConvert.DeserializeObject<LichChieu>(lc);
            objlc.NgayTao = DateTime.Now;
            objlc.NgayCapNhat = null;
            ////lấy phòng chiếu theo idphong
            var infoRoom = con.PhongChieux.Where(x => x.id == objlc.idPhong).ToList().Select(s => new
            {
                maphong = s.id,
                tenpc = s.TenPhong,
                sochongoi = s.SoChoNgoi,
                sohang = s.SoHang,
                socot = s.SoCot,
                tt= s.TinhTrang,
                loaimanhinh = s.LoaiManHinh,
                ngaytao =  s.NgayTao,
                ngaycapnhat = s.NgayCapNhat,

            }).FirstOrDefault();
           
            try
            {
                con.LichChieux.Add(objlc);
                Ve ve = new Ve();
                for (int i=0; i<infoRoom.sohang; i++)
                {
                    for (int j=0;j<infoRoom.socot; j++)
                    {
                        ve.LoaiVe = 0;
                        ve.idLichChieu = objlc.id;
                        ve.MaGheNgoi = "HANG"+i+"COT"+j;
                        ve.SoHang = i;
                        ve.SoCot = j;
                        ve.idKhachHang = null;
                        ve.TrangThai = 1;
                        ve.NgayCapNhat = null;
                        ve.NgayTao = DateTime.Now;
                        con.Ves.Add(ve);
                        con.SaveChanges();
                    }
                }    
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
