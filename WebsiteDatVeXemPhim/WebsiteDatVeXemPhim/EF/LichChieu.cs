namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LichChieu")]
    public partial class LichChieu
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public LichChieu()
        {
            Ves = new HashSet<Ve>();
        }

        public int id { get; set; }

        public DateTime ThoiGianChieu { get; set; }

        public int idPhong { get; set; }

        public int idPhim { get; set; }

        [Column(TypeName = "money")]
        public decimal GiaVe { get; set; }

        public int TrangThai { get; set; }

        public int idSuatChieu { get; set; }

        public virtual Phim Phim { get; set; }

        public virtual PhongChieu PhongChieu { get; set; }

        public virtual SuatChieu SuatChieu { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Ve> Ves { get; set; }
    }
}
