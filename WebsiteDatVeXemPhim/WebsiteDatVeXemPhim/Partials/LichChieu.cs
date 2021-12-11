using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class LichChieu
    {
        public class LichChieuDTO {
            BookTicketDbConText db = new BookTicketDbConText();

            public int id { get; set }
            public DateTime ThoiGianChieu { get; set; }
            public string ThoiGianChieuFormat
            {
                get
                {
                    return ThoiGianChieu == null ? "" : ThoiGianChieu.ToString("dd/MM/yyyy");
                }
            }
            public int idPhong {get; set;}
            public string TenPhong
            {
                get
                {
                    var phong = db.PhongChieux.Find(idPhong);
                    return phong.TenPhong == null ? "" : phong.TenPhong;
                }
            }
            public double GiaVe { get; set; }
            public int TrangThai { get; set; }
            public int idSuatChieu { get; set; }
            public int? SuatChieu
            {
                get
                {
                    var sc = db.SuatChieux.Find(idSuatChieu);
                    return sc.SuatChieu1;
                }
            }
        }

        public LichChieuDTO CopyObjectForSchedule()
        {
            var scheduleDTO = new LichChieuDTO();
            Utils.ObjectUtil.CopyPropertiesTo(this, scheduleDTO);
            return scheduleDTO;
        }
    }
}