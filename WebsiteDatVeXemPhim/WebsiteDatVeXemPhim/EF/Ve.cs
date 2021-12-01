namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Ve")]
    public partial class Ve
    {
        public int id { get; set; }

        public int? LoaiVe { get; set; }

        public int? idLichChieu { get; set; }

        [StringLength(50)]
        public string MaGheNgoi { get; set; }

        public int? idKhachHang { get; set; }

        public int TrangThai { get; set; }

        [Column(TypeName = "money")]
        public decimal? TienBanVe { get; set; }

        public virtual KhachHang KhachHang { get; set; }

        public virtual LichChieu LichChieu { get; set; }
    }
}
