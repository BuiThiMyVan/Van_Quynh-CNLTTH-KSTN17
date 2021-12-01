namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("PhongChieu")]
    public partial class PhongChieu
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public PhongChieu()
        {
            LichChieux = new HashSet<LichChieu>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(100)]
        public string TenPhong { get; set; }

        public int SoChoNgoi { get; set; }

        public int TinhTrang { get; set; }

        [StringLength(50)]
        public string LoaiManHinh { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<LichChieu> LichChieux { get; set; }
    }
}
