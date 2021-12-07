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
            
            objkh.TinhTrang = (int)KhachHang.KH.enable;
            objkh.Pass = objkh.EncodePassword(objkh.Pass);
            objkh.NgayTao = DateTime.Now;
            objkh.NgayCapNhat = DateTime.Now;
            foreach (NguoiDung lnd in con.NguoiDungs)
            {
                if (lnd.UserName.Contains(objkh.UserName))
                {
                    return Json(new { message = 400 });
                }
            }
            try
            {
                NguoiDung nd = new NguoiDung();
                nd.UserName = objkh.UserName;
                nd.Pass = objkh.Pass;
                nd.roleid = (int)NguoiDung.Role.kh;
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
        public IHttpActionResult updateKH(KhachHang objkh)
        {
            //KhachHang objkh = JsonConvert.DeserializeObject<KhachHang>(kh);
            try
            {
                KhachHang khachHang = con.KhachHangs.Find(objkh.id);
                NguoiDung nguoiDung = con.NguoiDungs.Find(khachHang.UserName);
               
                nguoiDung.Pass = objkh.EncodePassword(objkh.Pass);

                khachHang.Pass = objkh.EncodePassword(objkh.Pass);
                khachHang.HoTen = objkh.HoTen;
                khachHang.NgaySinh = objkh.NgaySinh;
                khachHang.DiaChi = objkh.DiaChi;
                khachHang.SDT = objkh.SDT;
                khachHang.NgayCapNhat = DateTime.Now;
                con.SaveChanges();
                return Json(new { message = 200 });
            }
            catch
            {
                return Json(new { message = 404 });
            }
        }
        //// lấy khách hàng theo username
        [System.Web.Http.AcceptVerbs("POST", "GET")]
        public IHttpActionResult getCustommerByUsername(string username)
        {
            var kh = con.KhachHangs.Where(x => x.UserName == username).ToList().Select(s => new {
                id = s.id,
                username = s.UserName,
                hoten = s.HoTen,
                ngaysinh = s.NgaySinh,
                diachi = s.DiaChi,
                sodienthoai = s.SDT,
                tinhtrang = s.TinhTrang,
                ngaytao = s.NgayTao,
                ngaycapnhat = s.NgayCapNhat,
            });
            return Json(new { kh = kh });
        }
    }
}
