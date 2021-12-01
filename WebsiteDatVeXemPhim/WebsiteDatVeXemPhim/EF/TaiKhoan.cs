namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("TaiKhoan")]
    public partial class TaiKhoan
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(100)]
        public string UserName { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(1000)]
        public string Pass { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int LoaiTK { get; set; }

        [Key]
        [Column(Order = 3)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idNV { get; set; }

        public int? TinhTrang { get; set; }

        public virtual NhanVien NhanVien { get; set; }
    }
}
