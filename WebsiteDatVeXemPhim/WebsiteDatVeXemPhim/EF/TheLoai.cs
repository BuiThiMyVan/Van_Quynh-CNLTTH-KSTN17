namespace WebsiteDatVeXemPhim.EF
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("TheLoai")]
    public partial class TheLoai
    {
        public int id { get; set; }

        [Required]
        [StringLength(100)]
        public string TenTheLoai { get; set; }

        [StringLength(100)]
        public string MoTa { get; set; }

        public int? TinhTrang { get; set; }
    }
}
