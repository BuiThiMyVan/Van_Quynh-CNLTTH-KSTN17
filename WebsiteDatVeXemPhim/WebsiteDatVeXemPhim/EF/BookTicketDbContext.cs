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
        public virtual DbSet<NhanVien> NhanViens { get; set; }
        public virtual DbSet<Phim> Phims { get; set; }
        public virtual DbSet<PhongChieu> PhongChieux { get; set; }
        public virtual DbSet<SuatChieu> SuatChieux { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<TheLoai> TheLoais { get; set; }
        public virtual DbSet<Ve> Ves { get; set; }
        public virtual DbSet<TaiKhoan> TaiKhoans { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
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

            modelBuilder.Entity<NhanVien>()
                .Property(e => e.SDT)
                .IsUnicode(false);

            modelBuilder.Entity<NhanVien>()
                .HasMany(e => e.TaiKhoans)
                .WithRequired(e => e.NhanVien)
                .HasForeignKey(e => e.idNV)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Phim>()
                .HasMany(e => e.LichChieux)
                .WithRequired(e => e.Phim)
                .HasForeignKey(e => e.idPhim)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<PhongChieu>()
                .Property(e => e.LoaiManHinh)
                .IsUnicode(false);

            modelBuilder.Entity<PhongChieu>()
                .HasMany(e => e.LichChieux)
                .WithRequired(e => e.PhongChieu)
                .HasForeignKey(e => e.idPhong)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<SuatChieu>()
                .HasMany(e => e.LichChieux)
                .WithRequired(e => e.SuatChieu)
                .HasForeignKey(e => e.idSuatChieu)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Ve>()
                .Property(e => e.MaGheNgoi)
                .IsUnicode(false);

            modelBuilder.Entity<Ve>()
                .Property(e => e.TienBanVe)
                .HasPrecision(19, 4);

            modelBuilder.Entity<TaiKhoan>()
                .Property(e => e.Pass)
                .IsUnicode(false);
        }
    }
}
