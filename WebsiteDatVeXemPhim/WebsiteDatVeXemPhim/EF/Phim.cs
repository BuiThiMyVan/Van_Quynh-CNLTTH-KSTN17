namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Phim")]
    public partial class Phim
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Phim()
        {
            LichChieux = new HashSet<LichChieu>();
        }

        public int id { get; set; }

        [StringLength(100)]
        public string TenPhim { get; set; }

        [StringLength(1000)]
        public string MoTa { get; set; }

        public double? ThoiLuong { get; set; }

        [Column(TypeName = "date")]
        public DateTime? NgayKhoiChieu { get; set; }

        [Column(TypeName = "date")]
        public DateTime? NgayKetThuc { get; set; }

        [StringLength(50)]
        public string SanXuat { get; set; }

        [StringLength(100)]
        public string DaoDien { get; set; }

        public int? NamSX { get; set; }

        public string ApPhich { get; set; }

        public int? TinhTrang { get; set; }

        [StringLength(30)]
        public string TheLoai { get; set; }

        public DateTime? NgayTao { get; set; }

        public DateTime? NgayCapNhat { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<LichChieu> LichChieux { get; set; }
    }
}
