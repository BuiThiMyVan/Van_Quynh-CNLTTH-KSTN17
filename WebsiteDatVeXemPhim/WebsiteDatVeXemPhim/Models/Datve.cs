using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;
namespace WebsiteDatVeXemPhim.Models
{
    public class Datve
    {
        public int id { get; set; }

        public int? LoaiVe { get; set; }

        public int? idLichChieu { get; set; }

        [StringLength(50)]
        public string MaGheNgoi { get; set; }

        public int? SoHang { get; set; }

        public int? SoCot { get; set; }

        [StringLength(50)]
        public string idKhachHang { get; set; }

        public int? TrangThai { get; set; }

        public DateTime? NgayTao { get; set; }

        public DateTime? NgayCapNhat { get; set; }
       
        [StringLength(50)]
        public string UserName { get; set; }
    }
}