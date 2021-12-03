CREATE DATABASE QLRP
GO
--drop database QLRP
USE QLRP
GO

SET DATEFORMAT DMY
GO

--drop database QLRP


GO



CREATE TABLE PhongChieu
(
	id int identity(1,1) PRIMARY KEY,
	TenPhong NVARCHAR(100),
	SoChoNgoi INT ,
	SoHang int,
	SoCot int,
	TinhTrang INT, -- 0:không hoạt động || 1:đang hoạt động
	LoaiManHinh VARCHAR(50),
	NgayTao Datetime,
	NgayCapNhat Datetime,
)
GO

CREATE TABLE Phim
(
	id int identity(1,1) PRIMARY KEY,
	TenPhim nvarchar(100),
	MoTa nvarchar(1000),
	ThoiLuong float,
	NgayKhoiChieu date,
	NgayKetThuc date,
	SanXuat nvarchar(50),
	DaoDien nvarchar(100),
	NamSX int,
	ApPhich image,
	TinhTrang int,
	TheLoai Nvarchar(30),
	NgayTao Datetime,
	NgayCapNhat Datetime,
)
GO



CREATE TABLE TheLoai
(
	id int identity(1,1) PRIMARY KEY,
	TenTheLoai NVARCHAR(100),
	MoTa NVARCHAR(100),
	TinhTrang int,
	NgayTao Datetime,
	NgayCapNhat Datetime,
)
GO

CREATE TABLE SuatChieu
(
	id int identity(1,1) PRIMARY KEY,
	SuatChieu int,
)
GO

CREATE TABLE LichChieu
(
	id int identity(1,1) PRIMARY KEY,
	ThoiGianChieu DATETIME,
	idPhong int,
	idPhim int,
	GiaVe Money,
	TrangThai INT, --0: Chưa tạo vé cho lịch chiếu || 1: Đã tạo vé
	idSuatChieu int,
	FOREIGN KEY (idPhong) REFERENCES dbo.PhongChieu(id),
	FOREIGN KEY (idPhim) REFERENCES dbo.Phim(id),
	FOREIGN KEY (idSuatChieu) REFERENCES dbo.SuatChieu(id),
	NgayTao Datetime,
	NgayCapNhat Datetime,

	--CONSTRAINT PK_LichChieu PRIMARY KEY(ngayChieu,gioChieu,idPhong) --Vì cùng 1 thời điểm có thể có nhiều phòng cùng hoạt động nên khóa chính phải là cả 3 cái
)
GO

CREATE TABLE NguoiDung
(
	UserName VarChar(50) PRIMARY KEY,
	Pass VarChar(50),
	roleid int,
)

GO
CREATE TABLE KhachHang
(
	id int identity(1,1) PRIMARY KEY,
	UserName VarChar(50),
	Pass VarChar(50),
	HoTen NVARCHAR(100),
	NgaySinh DATE,
	DiaChi NVARCHAR(100),
	SDT VARCHAR(11),
	TinhTrang int,
	NgayTao Datetime,
	NgayCapNhat Datetime,
	FOREIGN KEY (UserName) REFERENCES dbo.NguoiDung(UserName)
)
GO




CREATE TABLE Ve
(
	id int identity(1,1) PRIMARY KEY,
	LoaiVe INT, --0: Vé người lớn || 1: Vé học sinh - sinh viên || 2: vé trẻ em
	idLichChieu int,
	MaGheNgoi VARCHAR(50),
	SoHang int,
	SoCot int,
	idKhachHang int,
	TrangThai INT, --0: 'Chưa Bán' || 1: 'Đã Bán'
	NgayTao Datetime,
	NgayCapNhat Datetime,
	FOREIGN KEY (idLichChieu) REFERENCES dbo.LichChieu(id),
	FOREIGN KEY (idKhachHang) REFERENCES dbo.KhachHang(id)
)
GO



--Insert Dữ Liệu
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (7 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (8 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (9 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (10 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (11 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (12)
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (13)
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (14 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (15 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (16 )

INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (17 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (18 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (19 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (20 )
INSERT [dbo].[SuatChieu] ([SuatChieu]) VALUES (21 )





INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hành Động', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hoạt Hình', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hài', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Viễn Tưởng', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Phiêu lưu', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Gia đình', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Tình Cảm', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Tâm Lý', NULL)

INSERT [dbo].[NhanVien] ( [HoTen], [NgaySinh], [DiaChi], [SDT], [CMND]) VALUES ( N'admin', CAST(N'2018-04-22' AS Date), N'admin', NULL, 123456789)
INSERT [dbo].[NhanVien] ( [HoTen], [NgaySinh], [DiaChi], [SDT], [CMND]) VALUES ( N'Bán Vé', CAST(N'2018-04-30' AS Date), NULL, NULL, 14725836)

INSERT [dbo].[TaiKhoan] ([UserName], [Pass], [LoaiTK], [idNV]) VALUES (N'admin', N'59113821474147731767615617822114745333', 1, 1)-- mk hiện thị là admin
INSERT [dbo].[TaiKhoan] ([UserName], [Pass], [LoaiTK], [idNV]) VALUES (N'NV01', N'5512317111114510840231031535810616566202691', 2, 2)-- mk hiện thị là 12345

INSERT [dbo].[KhachHang] ([HoTen], [NgaySinh], [DiaChi], [SDT], [CMND], [DiemTichLuy]) VALUES ( N'Nguyễn Văn A', CAST(N'1998-05-03' AS Date), N'Bla Bla', N'0123456789', 218161554, 0)
INSERT [dbo].[KhachHang] ([HoTen], [NgaySinh], [DiaChi], [SDT], [CMND], [DiemTichLuy]) VALUES ( N'Nguyễn Văn B', CAST(N'1998-05-03' AS Date), N'Bla Bla', N'0123456789', 218161564, 0)
INSERT [dbo].[KhachHang] ([HoTen], [NgaySinh], [DiaChi], [SDT], [CMND], [DiemTichLuy]) VALUES ( N'Nguyễn Văn B', CAST(N'1998-05-03' AS Date), N'Bla Bla', N'0123456789', 218161654, 0)

INSERT [dbo].[LoaiManHinh] ([id], [TenMH]) VALUES (N'MH01', N'2D')
INSERT [dbo].[LoaiManHinh] ([id], [TenMH]) VALUES (N'MH02', N'3D')
INSERT [dbo].[LoaiManHinh] ([id], [TenMH]) VALUES (N'MH03', N'IMAX')
INSERT [dbo].[LoaiManHinh] ([id], [TenMH]) VALUES (N'MH04', N'4D')
INSERT [dbo].[PhongChieu] ( [TenPhong], [SoChoNgoi], [TinhTrang], [LoaiManHinh]) VALUES ( N'CINEMA 01', 140, 1, '2D')
INSERT [dbo].[PhongChieu] ( [TenPhong], [SoChoNgoi], [TinhTrang], [LoaiManHinh]) VALUES ( N'CINEMA 02', 140, 1, '3D')
INSERT [dbo].[PhongChieu] ( [TenPhong], [SoChoNgoi], [TinhTrang], [LoaiManHinh]) VALUES ( N'CINEMA 03', 140, 1, '2D')
INSERT [dbo].[PhongChieu] ( [TenPhong], [SoChoNgoi], [TinhTrang], [LoaiManHinh]) VALUES ( N'CINEMA 04', 140, 1, '3D')

INSERT [dbo].[Phim] ( [TenPhim], [MoTa], [ThoiLuong], [NgayKhoiChieu], [NgayKetThuc], [SanXuat], [DaoDien], [NamSX], [TinhTrang], [TheLoai]) VALUES ( N'Avengers: Cuộc Chiến Vô Cực', N'Avengers: Infinity War', 150, CAST(N'2018-05-01' AS Date), CAST(N'2018-06-01' AS Date), N'Mỹ', N'Anthony Russo,  Joe Russo', 2018,1,N'hài,tình cảm')
INSERT [dbo].[Phim] ( [TenPhim], [MoTa], [ThoiLuong], [NgayKhoiChieu], [NgayKetThuc], [SanXuat], [DaoDien], [NamSX], [TinhTrang], [TheLoai]) VALUES ( N'Lật Mặt: 3 Chàng Khuyết', N'Lat Mat 3 Chang Khuyet', 100, CAST(N'2018-05-01' AS Date), CAST(N'2018-06-01' AS Date), N'Việt Nam', N'Lý Hải', 2018,1, N'Hành động')
INSERT [dbo].[Phim] ( [TenPhim], [MoTa], [ThoiLuong], [NgayKhoiChieu], [NgayKetThuc], [SanXuat], [DaoDien], [NamSX], [TinhTrang], [TheLoai]) VALUES ( N'100 Ngày Bên Em', NULL, 100, CAST(N'2018-05-01' AS Date), CAST(N'2018-06-01' AS Date), N'Việt Nam', N'Vũ Ngọc Phượng', 2018,1, N'Tâm lý')
INSERT [dbo].[Phim] ( [TenPhim], [MoTa], [ThoiLuong], [NgayKhoiChieu], [NgayKetThuc], [SanXuat], [DaoDien], [NamSX], [TinhTrang], [TheLoai]) VALUES ( N'Ngỗng Vịt Phiêu Lưu Ký', N'Duck Duck Goose', 91, CAST(N'2018-05-01' AS Date), CAST(N'2018-06-01' AS Date), N'Mỹ', N'Christopher Jenkins', 2018,1, N'Viễn tưởng')

INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P01', N'TL01')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P01', N'TL04')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P01', N'TL05')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P02', N'TL01')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P02', N'TL07')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P02', N'TL08')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P03', N'TL03')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P03', N'TL07')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P03', N'TL08')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P04', N'TL02')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P04', N'TL03')
INSERT [dbo].[PhanLoaiPhim] ([idPhim], [idTheLoai]) VALUES (N'P04', N'TL05')

INSERT [dbo].[DinhDangPhim] ([id], [idPhim], [idLoaiManHinh]) VALUES (N'DD01', N'P01', N'MH01')
INSERT [dbo].[DinhDangPhim] ([id], [idPhim], [idLoaiManHinh]) VALUES (N'DD02', N'P01', N'MH03')
INSERT [dbo].[DinhDangPhim] ([id], [idPhim], [idLoaiManHinh]) VALUES (N'DD03', N'P02', N'MH01')
INSERT [dbo].[DinhDangPhim] ([id], [idPhim], [idLoaiManHinh]) VALUES (N'DD04', N'P03', N'MH02')

INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 1, 1, 85000.0000, 1,1)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 4, 2, 85000.0000, 0,2)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 3, 3, 85000.0000, 0,3)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 2, 4, 85000.0000, 0,4)



INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 1, N'A9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'A10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'A11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'A12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'A13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'A14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'B14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'C14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'D14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (1, 2, N'E4', NULL, 1, 85000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (1, 2, N'E5', NULL, 1, 85000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (2, 2, N'E6', NULL, 1, 68000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (2, 2, N'E7', NULL, 1, 68000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'E14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (3, 2, N'F6', NULL, 1, 59500.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (2, 2, N'F7', NULL, 1, 68000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (3, 2, N'F8', NULL, 1, 59500.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (1, 2, N'F9', NULL, 1, 85000.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'F14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (2, 2, N'G6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (1, 2, N'G7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'G14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES (0, 2, N'J1', NULL, 0, 0.0000)
GO
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'J14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'I14', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K1', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K2', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K3', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K4', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K5', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K6', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K7', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K8', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K9', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K10', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K11', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K12', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K13', NULL, 0, 0.0000)
INSERT [dbo].[Ve] ( [LoaiVe], [idLichChieu], [MaGheNgoi], [idKhachHang], [TrangThai], [TienBanVe]) VALUES ( 0, 3, N'K14', NULL, 0, 0.0000)

