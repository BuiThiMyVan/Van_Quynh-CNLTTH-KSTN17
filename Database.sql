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
	ApPhich nvarchar(max),
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

CREATE TABLE LienHe
(
	id int identity(1,1) PRIMARY KEY,
	Content nvarchar(Max),
	Status int,
	
)
GO
CREATE TABLE PhanHoi
(
	id int identity(1,1) PRIMARY KEY,
	Name nvarchar(50),
	Phone VARCHAR(11),
	Email VARCHAR(30),
	Address nvarchar(Max),
	Content nvarchar(Max),
	CreateDate datetime,
	Status int,
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


INSERT [dbo].LienHe([Content], [Status]) VALUES ('<P>Rạp chiếu Phim BUG Cinema</p><P>Địa Chỉ: Số 62 Hoàng Quốc Việt, Bắc Từ Liên, Hà Nội</p><P>Số điện thoại: 0999988888</p>','1' )


INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hành Động', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hoạt Hình', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Hài', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Viễn Tưởng', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Phiêu lưu', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Gia đình', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Tình Cảm', NULL)
INSERT [dbo].[TheLoai] ( [TenTheLoai], [MoTa]) VALUES (N'Tâm Lý', NULL)




INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 1, 1, 85000.0000, 1,1)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 4, 2, 85000.0000, 0,2)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 3, 3, 85000.0000, 0,3)
INSERT [dbo].[LichChieu] ( [ThoiGianChieu], [idPhong], [idPhim], [GiaVe], [TrangThai], [idSuatChieu]) VALUES (CAST(N'2018-05-02' AS Date), 2, 4, 85000.0000, 0,4)



