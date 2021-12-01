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

namespace WebsiteDatVeXemPhims.Controllers
{
    public class MovieApiController : ApiController
    {
        BookTicketDbContext con = new BookTicketDbContext();
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult loadListPhim(Pagination infoPage)
        {
            var totalRecord = con.Phims.Count();
            var listPhim = con.Phims.OrderBy(s => s.id).Skip((infoPage.page - 1) * infoPage.pageSize).Take(infoPage.pageSize).ToList().Select(s => new
            {
                MaPhim = s.id,
                TenPhim = s.TenPhim,
                MoTa = s.MoTa,
                ThoiLuong = s.ThoiLuong,
                NgayKhoiChieu = s.NgayKhoiChieu.ToString("dd/MM/yyyy"),
                NgayKetThuc = s.NgayKetThuc.ToString("dd/MM/yyyy"),
                Sanxuat = s.SanXuat,
                DaoDien = s.DaoDien,
                NamSX = s.NamSX,
                ApPhich =s.ApPhich,
                TinhTrang = s.TinhTrang,
                TheLoai = s.TheLoai,
                });

            int totalPage = 0;
            totalPage = (int)Math.Ceiling((double)totalRecord / infoPage.pageSize);
            int start = (infoPage.page - 1) * infoPage.pageSize + 1;
            int end = 0;
            if (infoPage.page == totalPage)
            {
                end = totalRecord;
            }
            else
            {
                end = infoPage.page * infoPage.pageSize;
            }
            return Json(new { listPhim = listPhim, page = infoPage.page, pageSize = infoPage.pageSize, totalPage = totalPage, totalRecord = totalRecord, start = start, end = end });
        }

        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult getPhimbyId(int MaPhim)
        {
            var infoPhim = con.Phims.Where(x => x.id == MaPhim).ToList().Select(s => new
            {
                MaPhim = s.id,
                TenPhim = s.TenPhim,
                MoTa = s.MoTa,
                ThoiLuong = s.ThoiLuong,
                NgayKhoiChieu = s.NgayKhoiChieu.ToString("dd/MM/yyyy"),
                NgayKetThuc = s.NgayKetThuc.ToString("dd/MM/yyyy"),
                Sanxuat = s.SanXuat,
                DaoDien = s.DaoDien,
                NamSX = s.NamSX,
                ApPhich = s.ApPhich,
                TinhTrang = s.TinhTrang,
                TheLoai = s.TheLoai,
            }).FirstOrDefault();

            return Json(new { infoPhim = infoPhim });
        }
       

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult addPhim(Phim ph,TheLoai tl)
        {
            try
            {
                con.Phims.Add(ph);
                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }

        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult updatePhim(Phim ph)
        {
            try
            {
                var phim = con.Phims.Find(ph.id);
                phim.TenPhim = ph.TenPhim;
                phim.MoTa = ph.MoTa;
                phim.ThoiLuong = ph.ThoiLuong;
                phim.NgayKhoiChieu = ph.NgayKhoiChieu;
                phim.NgayKetThuc = ph.NgayKetThuc;
                phim.SanXuat = ph.SanXuat;
                phim.DaoDien = ph.DaoDien;
                phim.NamSX = ph.NamSX;
                phim.ApPhich = ph.ApPhich;
                phim.TinhTrang = ph.TinhTrang;

                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult deletePhim(string id)
        {
            try
            {
                var phim = con.Phims.Find(id);
                con.Phims.Remove(phim);
                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }

        }
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult loadListLoaiPhim(Pagination infoPage)
        {
            var totalRecord = con.TheLoais.Count();
            var listLoaiPhim = con.TheLoais.OrderBy(s => s.id).Skip((infoPage.page - 1) * infoPage.pageSize).Take(infoPage.pageSize).ToList().Select(s => new
            {
                Maloai = s.id,
                TenLoai = s.TenTheLoai,
                MoTa = s.MoTa,
                TinhTrang = s.TinhTrang,
            });

            int totalPage = 0;
            totalPage = (int)Math.Ceiling((double)totalRecord / infoPage.pageSize);
            int start = (infoPage.page - 1) * infoPage.pageSize + 1;
            int end = 0;
            if (infoPage.page == totalPage)
            {
                end = totalRecord;
            }
            else
            {
                end = infoPage.page * infoPage.pageSize;
            }
            return Json(new { listLoaiPhim = listLoaiPhim, page = infoPage.page, pageSize = infoPage.pageSize, totalPage = totalPage, totalRecord = totalRecord, start = start, end = end });
        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult getLoaiPhimId(int MaLoaiPhim)
        {
            var infoLoaiPhim = con.TheLoais.Where(x => x.id == MaLoaiPhim).ToList().Select(s => new
            {
                MaLoaiPhim = s.id,
                TenTheLoai = s.TenTheLoai,
                MoTa = s.MoTa,
                TinhTrang = s.TinhTrang,
            }).FirstOrDefault();

            return Json(new { infoLoaiPhim = infoLoaiPhim });
        }


        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult addLoaiPhim(TheLoai lph)
        {
            try
            {
                con.TheLoais.Add(lph);
                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }

        }

        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult updateLoaiPhim(TheLoai lph)
        {
            try
            {
                var loaiphim = con.TheLoais.Find(lph.id);
                loaiphim.TenTheLoai = lph.TenTheLoai;
                loaiphim.MoTa = lph.MoTa;
                loaiphim.TinhTrang = lph.TinhTrang;
                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }
        }
        
        
        
    }
}
