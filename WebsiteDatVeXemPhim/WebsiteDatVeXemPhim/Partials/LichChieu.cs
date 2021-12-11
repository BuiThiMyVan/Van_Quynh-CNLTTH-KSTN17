using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class LichChieu
    {
        public class LichChieuDTO
        {
            public int id { get; set; }

            public DateTime? ThoiGianChieu { get; set; }
            public string ThoiGianChieuFormat
            {
                get
                {
                    return ThoiGianChieu == null ? "" : ThoiGianChieu.GetValueOrDefault().ToString("dd/MM/yyyy");
                }
            }

            public int? idPhong { get; set; }

            public int? idPhim { get; set; }

            [Column(TypeName = "money")]
            public decimal? GiaVe { get; set; }

            public int? TrangThai { get; set; }

            public int? idSuatChieu { get; set; }

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
        public class JsonLichChieu
        {
            public object[] listLichChieu { get; set; }
        }

        public LichChieuDTO CopyObjectForSchedule()
        {
            var kol_campaignDTO = new LichChieuDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, kol_campaignDTO);
            return kol_campaignDTO;
        }

    }
}