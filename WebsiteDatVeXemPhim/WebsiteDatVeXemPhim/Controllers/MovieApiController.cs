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
using static WebsiteDatVeXemPhim.EF.Phim;

namespace WebsiteDatVeXemPhims.Controllers
{
    public class MovieApiController : ApiController
    {
        BookTicketDbContext con = new BookTicketDbContext();

        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult getPhimbyId(int MaPhim)
        {
            var infoPhim = con.Phims.Where(x => x.id == MaPhim).ToList().Select(s => new
            {
                MaPhim = s.id,
                TenPhim = s.TenPhim,
                MoTa = s.MoTa,
                ThoiLuong = s.ThoiLuong,
                NgayKhoiChieu = s.NgayKhoiChieu,
                NgayKetThuc = s.NgayKetThuc,
                Sanxuat = s.SanXuat,
                DaoDien = s.DaoDien,
                NamSX = s.NamSX,
                ApPhich = s.ApPhich,
                TinhTrang = s.TinhTrang,
                TheLoai = s.TheLoai,
                NgayTao = s.NgayTao,
                NgayCapNhat = s.NgayCapNhat,
            }).FirstOrDefault();

            return Json(new { infoPhim = infoPhim });
        }


        [System.Web.Http.AcceptVerbs("GET", "POST")]
        public IHttpActionResult loadListPhim(Pagination objpage)
        {
            var totalRecord = con.Phims.Count();
            var listPhim = con.Phims.OrderByDescending(s => s.NgayTao).Skip((objpage.page - 1) * objpage.pageSize).Take(objpage.pageSize).ToList();

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
            var pageView = "";
            pageView = start + "-" + end + " của tổng số " + totalRecord;

            JsonPhim jsonreturn = new JsonPhim
            {
                listPhim = listPhim.Select(t => t.CopyObjectForMovieApi()).ToArray(),
                totalPage = totalPage,
                pageView = pageView
            };
            return Json(new { data = jsonreturn });
        }

        
        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadListLoaiPhim(string infoPage)
        {
            Pagination objpage = JsonConvert.DeserializeObject<Pagination>(infoPage);
            var totalRecord = con.TheLoais.Count();
            var listLoaiPhim = con.TheLoais.OrderBy(s => s.id).Skip((objpage.page - 1) * objpage.pageSize).Take(objpage.pageSize).ToList().Select(s => new
            {
                Maloai = s.id,
                TenLoai = s.TenTheLoai,
                MoTa = s.MoTa,
                TinhTrang = s.TinhTrang,
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
            return Json(new { listLoaiPhim = listLoaiPhim, totalPage = totalPage, mota = "từ" + start + "đến" + end + "của tổng số" + totalRecord });
        }


        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult getLoaiPhimId(int MaLoaiPhim)
        {
            var infoLoaiPhim = con.TheLoais.Where(x => x.id == MaLoaiPhim).ToList().Select(s => new
            {
                MaLoaiPhim = s.id,
                TenTheLoai = s.TenTheLoai,
                MoTa = s.MoTa,
                TinhTrang = s.TinhTrang,
                NgayTao = s.NgayTao,
                NgayCapNhat = s.NgayCapNhat,
            }).FirstOrDefault();

            return Json(new { infoLoaiPhim = infoLoaiPhim });
        }



        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addPhim(string ph)
        {
            Phim objph = JsonConvert.DeserializeObject<Phim>(ph);
            objph.NgayTao = DateTime.Now;
            objph.NgayCapNhat = null;
            try
            {
                con.Phims.Add(objph);
                con.SaveChanges();
                return Json(200);
            }
            catch
            {
                return Json(404);
            }

        }
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult updatePhim(string ph1)
        {
            Phim objph = JsonConvert.DeserializeObject<Phim>(ph1);
            try
            {
                Phim phim = con.Phims.Find(objph.id);
                phim.TenPhim = objph.TenPhim;
                phim.MoTa = objph.MoTa;
                phim.ThoiLuong = objph.ThoiLuong;
                phim.NgayKhoiChieu = objph.NgayKhoiChieu;
                phim.NgayKetThuc = objph.NgayKetThuc;
                phim.SanXuat = objph.SanXuat;
                phim.DaoDien = objph.DaoDien;
                phim.NamSX = objph.NamSX;
                phim.ApPhich = objph.ApPhich;
                phim.TinhTrang = objph.TinhTrang;
                phim.NgayCapNhat = DateTime.Now;

                con.SaveChanges();
                return Json(200);
            }
            catch
            {
                return Json(404);
            }
        }
        //[System.Web.Http.AcceptVerbs("POST")]
        //public IHttpActionResult deletePhim(int id)
        //{
        //    try
        //    {
        //        var phim = con.Phims.Find(id);
        //        con.Phims.Remove(phim);
        //        con.SaveChanges();
        //        return Json(1);
        //    }
        //    catch
        //    {
        //        return Json(0);
        //    }

        //}
       


        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addLoaiPhim(string objlp)
        {
            TheLoai lph = JsonConvert.DeserializeObject<TheLoai>(objlp);
            lph.NgayTao =DateTime.Now;
            lph.NgayCapNhat = null;
            try
            {
                con.TheLoais.Add(lph);
                con.SaveChanges();
                return Json(200);
            }
            catch
            {
                return Json(404);
            }

        }


        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult updateLoaiPhim(string objlp)
        {
            TheLoai lph = JsonConvert.DeserializeObject<TheLoai>(objlp);
           
            try
            {
                TheLoai loaiphim = con.TheLoais.Find(lph.id);
                loaiphim.TenTheLoai = lph.TenTheLoai;
                loaiphim.MoTa = lph.MoTa;
                loaiphim.TinhTrang = lph.TinhTrang;
                loaiphim.NgayCapNhat = DateTime.Now;
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
