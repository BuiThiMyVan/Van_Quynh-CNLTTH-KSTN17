using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class PhongChieu
    {
        public enum PC
        {
            sudung = 2,
            khongsudung = 1,
        }
        public class PhongChieuDTO
        {
            public int id { get; set; }
            public string TenPhong{ get; set; }
            public int SoChongoi { get; set; }
            public int SoHang { get; set; }
            public int SoCot { get; set; }

            public int TinhTrang { get; set; }
            public string LoaiManHinh { get; set; }
         
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
        public class JsonPhongChieu
        {
            public object[] listPhongChieu { get; set; }
        }

        public PhongChieuDTO CopyObjectForMovieRoom()
        {
            var kol_campaignDTO = new PhongChieuDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }
    }
}