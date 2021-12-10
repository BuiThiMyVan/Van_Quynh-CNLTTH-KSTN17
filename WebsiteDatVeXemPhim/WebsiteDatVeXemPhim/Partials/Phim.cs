using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebsiteDatVeXemPhim.Utils;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class Phim
    {
        public enum StatusFilm
        {
            ChuaKhoiChieu = 0,
            DangKhoiChieu = 1,
            KetThuc = 2
        }

        public class PhimDTO
        {
            public int id { get; set; }
            public string TenPhim { get; set; }
            public double ThoiLuong { get; set; }
            public DateTime? NgayKhoiChieu { get; set; }
            public string NgayKhoiChieuFormat
            {
                get
                {
                    return NgayKhoiChieu == null ? "" : NgayKhoiChieu.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }
            public DateTime? NgayKetThuc { get; set; }
            public string NgayKetThucFormat
            {
                get
                {
                    return NgayKetThuc == null ? "" : NgayKetThuc.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }
            public string SanXuat { get; set; }
            public string DaoDien { get; set; }
            public int NamSX { get; set; }
            public string  ApPhich { get; set; }
            public int TinhTrang { get; set; }
            public string TheLoai { get; set; }
            public DateTime? NgayTao { get; set; }
            public string NgayTaoFormat
            {
                get
                {
                    return NgayTao == null ? "" : NgayTao.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }
            public DateTime? NgayCapNhat { get; set; }
            public string NgayCapNhatFormat
            {
                get
                {
                    return NgayCapNhat == null ? "" : NgayCapNhat.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }

        }

        public class JsonPhim
        {
            public object[] listPhim { get; set; }
            public int totalPage { get; set; }
            public string pageView { get; set; }
        }

        public PhimDTO CopyObjectForMovieApi()
        {
            var kol_campaignDTO = new PhimDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }
    }
}