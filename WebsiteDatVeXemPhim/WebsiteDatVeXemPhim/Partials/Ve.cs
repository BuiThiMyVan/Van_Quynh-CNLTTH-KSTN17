using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class Ve
    {
        public enum TK
        {
            daban = 0,
            chuaban = 1,
        }
        public class VeDTO
        {
            public int id { get; set; }

            public int? LoaiVe { get; set; }

            public int? idLichChieu { get; set; }

            [StringLength(50)]
            public string MaGheNgoi { get; set; }

            public int? SoHang { get; set; }

            public int? SoCot { get; set; }

            public int? idKhachHang { get; set; }

            public int? TrangThai { get; set; }

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
        public class JsonVe
        {
            public object[] listVe { get; set; }
        }

        public VeDTO CopyObjectForTicket()
        {
            var kol_campaignDTO = new VeDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }
    }
}