using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace WebsiteDatVeXemPhim.EF
{
    public partial class BookTicketDbContext : DbContext
    {
        public BookTicketDbContext()
            : base("name=BookTicketDbContext")
        {
        }

        public virtual DbSet<KhachHang> KhachHangs { get; set; }
        public virtual DbSet<LichChieu> LichChieux { get; set; }
        public virtual DbSet<Phim> Phims { get; set; }
        public virtual DbSet<PhongChieu> PhongChieux { get; set; }
        public virtual DbSet<SuatChieu> SuatChieux { get; set; }
        public virtual DbSet<TheLoai> TheLoais { get; set; }
        public virtual DbSet<Ve> Ves { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<KhachHang>()
                .Property(e => e.UserName)
                .IsUnicode(false);

            modelBuilder.Entity<KhachHang>()
                .Property(e => e.Pass)
                .IsUnicode(false);

            modelBuilder.Entity<KhachHang>()
                .Property(e => e.SDT)
                .IsUnicode(false);

            modelBuilder.Entity<KhachHang>()
                .HasMany(e => e.Ves)
                .WithOptional(e => e.KhachHang)
                .HasForeignKey(e => e.idKhachHang);

            modelBuilder.Entity<LichChieu>()
                .Property(e => e.GiaVe)
                .HasPrecision(19, 4);

            modelBuilder.Entity<LichChieu>()
                .HasMany(e => e.Ves)
                .WithOptional(e => e.LichChieu)
                .HasForeignKey(e => e.idLichChieu);

            modelBuilder.Entity<Phim>()
                .HasMany(e => e.LichChieux)
                .WithOptional(e => e.Phim)
                .HasForeignKey(e => e.idPhim);

            modelBuilder.Entity<PhongChieu>()
                .Property(e => e.LoaiManHinh)
                .IsUnicode(false);

            modelBuilder.Entity<PhongChieu>()
                .HasMany(e => e.LichChieux)
                .WithOptional(e => e.PhongChieu)
                .HasForeignKey(e => e.idPhong);

            modelBuilder.Entity<SuatChieu>()
                .HasMany(e => e.LichChieux)
                .WithOptional(e => e.SuatChieu)
                .HasForeignKey(e => e.idSuatChieu);

            modelBuilder.Entity<Ve>()
                .Property(e => e.MaGheNgoi)
                .IsUnicode(false);

            modelBuilder.Entity<Ve>()
                .Property(e => e.idKhachHang)
                .IsUnicode(false);
        }
    }
}
