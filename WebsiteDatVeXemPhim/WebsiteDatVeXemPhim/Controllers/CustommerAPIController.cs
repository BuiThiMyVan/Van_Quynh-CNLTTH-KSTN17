using System;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WebsiteDatVeXemPhim.EF;

namespace WebsiteDatVeXemPhim.Controllers
{
    public class CustommerAPIController : ApiController
    {
        BookTicketDbContext con = new BookTicketDbContext();

        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult addKH(KhachHang objkh)
        {
            //KhachHang objkh = JsonConvert.DeserializeObject<KhachHang>(kh);
            objkh.TinhTrang = (int)KhachHang.KH.enable;
            objkh.Pass = objkh.EncodePassword(objkh.Pass);
            objkh.NgayTao = DateTime.Now;
            objkh.NgayCapNhat = DateTime.Now;
            try
            {
                NguoiDung nd = new NguoiDung();
                nd.UserName = objkh.UserName;
                nd.Pass = objkh.Pass;
                nd.roleid = (int)NguoiDung.Role.admin;
                con.NguoiDungs.Add(nd);
                con.KhachHangs.Add(objkh);
                con.SaveChanges();
                return Json(new { message = 200 });
            }
            catch
            {
                return Json(new { message = 404 });
            }

        }
        [System.Web.Http.AcceptVerbs("POST")]
        public IHttpActionResult updateKH(string kh)
        {
            KhachHang objkh = JsonConvert.DeserializeObject<KhachHang>(kh);
            try
            {
                KhachHang Khachhang = con.KhachHangs.Find(objkh.UserName);
                Khachhang.UserName = objkh.UserName;
                Khachhang.Pass = objkh.EncodePassword(objkh.Pass);
                Khachhang.HoTen = objkh.HoTen;
                Khachhang.NgaySinh = objkh.NgaySinh;
                Khachhang.DiaChi = objkh.DiaChi;
                Khachhang.SDT = objkh.SDT;
                Khachhang.NgayCapNhat = DateTime.Now;
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
