using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.Spatial;
namespace WebsiteDatVeXemPhim.Models
{
    public class PHIM_LOAIPHIM
    { 

        [StringLength(50)]
        public string id { get; set; }

        [Required]
        [StringLength(100)]
        public string TenPhim { get; set; }

        [StringLength(1000)]
        public string MoTa { get; set; }

        public double ThoiLuong { get; set; }

        [Column(TypeName = "date")]
        public DateTime NgayKhoiChieu { get; set; }

        [Column(TypeName = "date")]
        public DateTime NgayKetThuc { get; set; }

        [Required]
        [StringLength(50)]
        public string SanXuat { get; set; }

        [StringLength(100)]
        public string DaoDien { get; set; }

        public int NamSX { get; set; }

        [Column(TypeName = "image")]
        public byte[] ApPhich { get; set; }

        [StringLength(50)]
        public string idloaiphim { get; set; }
    }
}