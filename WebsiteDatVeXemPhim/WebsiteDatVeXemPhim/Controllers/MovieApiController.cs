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


        [System.Web.Http.AcceptVerbs("GET")]
        public IHttpActionResult loadListPhim(string infoPage)
        {
            Pagination objpage = JsonConvert.DeserializeObject<Pagination>(infoPage);
            var totalRecord = con.Phims.Count();
            var listPhim = con.Phims.OrderBy(s => s.id).Skip((objpage.page - 1) * objpage.pageSize).Take(objpage.pageSize).ToList().Select(s => new
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
            return Json(new { listPhim = listPhim, page = objpage.page, pageSize = objpage.pageSize, totalPage = totalPage, totalRecord = totalRecord, start = start, end = end });
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
            return Json(new { listLoaiPhim = listLoaiPhim, page = objpage.page, pageSize = objpage.pageSize, totalPage = totalPage, totalRecord = totalRecord, start = start, end = end });
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
            }).FirstOrDefault();

            return Json(new { infoLoaiPhim = infoLoaiPhim });
        }



        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addPhim(string ph)
        {
            Phim objph = JsonConvert.DeserializeObject<Phim>(ph);
            try
            {
                con.Phims.Add(objph);
                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
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

                con.SaveChanges();
                return Json(1);
            }
            catch
            {
                return Json(0);
            }
        }
        [System.Web.Http.AcceptVerbs("POST")]
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
       


        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addLoaiPhim(string objlp)
        {
            TheLoai lph = JsonConvert.DeserializeObject<TheLoai>(objlp);
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
