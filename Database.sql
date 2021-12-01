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

CREATE TABLE KhachHang
(
	UserName VarChar(50) PRIMARY KEY,
	Pass VarChar(50),
	HoTen NVARCHAR(100),
	NgaySinh DATE,
	DiaChi NVARCHAR(100),
	SDT VARCHAR(11),
	TinhTrang int,
	NgayTao Datetime,
	NgayCapNhat Datetime,
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
	idKhachHang Varchar(50),
	TrangThai INT, --0: 'Chưa Bán' || 1: 'Đã Bán'
	NgayTao Datetime,
	NgayCapNhat Datetime,
	FOREIGN KEY (idLichChieu) REFERENCES dbo.LichChieu(id),
	FOREIGN KEY (idKhachHang) REFERENCES dbo.KhachHang(UserName)
)
GO

--Trigger
CREATE TRIGGER UTG_INSERT_CheckDateLichChieu
ON dbo.LichChieu
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idDinhDang VARCHAR(50), @ThoiGianChieu DATE, @NgayKhoiChieu DATE, @NgayKetThuc DATE

	SELECT @idDinhDang = idDinhDang, @ThoiGianChieu = CONVERT(DATE, ThoiGianChieu) from INSERTED

	SELECT @NgayKhoiChieu = P.NgayKhoiChieu, @NgayKetThuc = P.NgayKetThuc
	FROM dbo.Phim P, dbo.DinhDangPhim DD
	WHERE @idDinhDang = DD.id AND DD.idPhim = P.id

	IF ( @ThoiGianChieu > @NgayKetThuc or @ThoiGianChieu < @NgayKhoiChieu)
	BEGIN
		ROLLBACK TRAN
		Raiserror('Lịch Chiếu lớn hơn hoặc bằng Ngày Khởi Chiếu và nhỏ hơn hoặc bằng Ngày Kết Thúc',16,1)
		Return
    END
END
GO

CREATE TRIGGER UTG_CheckTimeLichChieu
ON dbo.LichChieu
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @count INT = 0, @count2 INT = 0, @ThoiGianChieu DATETIME, @idPhong VARCHAR(50), @idDinhDang VARCHAR(50)

	SELECT @idPhong = idPhong, @ThoiGianChieu = ThoiGianChieu, @idDinhDang = Inserted.idDinhDang from INSERTED

	SELECT @count = COUNT(*)
	FROM dbo.LichChieu LC, dbo.DinhDangPhim DD, dbo.Phim P
	WHERE LC.idPhong = @idPhong AND LC.idDinhDang = DD.id AND DD.idPhim = P.id AND (@ThoiGianChieu >= LC.ThoiGianChieu AND @ThoiGianChieu <= DATEADD(MINUTE, P.ThoiLuong, LC.ThoiGianChieu))

	SELECT @count2 = COUNT(*)
	FROM dbo.LichChieu LC, dbo.DinhDangPhim DD, dbo.Phim P
	WHERE @idPhong = LC.idPhong AND @idDinhDang = DD.id AND DD.idPhim = P.id AND (LC.ThoiGianChieu >= @ThoiGianChieu AND LC.ThoiGianChieu <= DATEADD(MINUTE, P.ThoiLuong, @ThoiGianChieu))

	IF (@count > 1 OR @count2 > 1)
	BEGIN
		ROLLBACK TRAN
		Raiserror('Thời Gian Chiếu đã trùng với một lịch chiếu khác cùng Phòng Chiếu',16,1)
		Return
	END
END
GO

--Stored Procedures
--TÀI KHOẢN (Đổi mật khẩu & đăng nhập)
CREATE PROC USP_UpdatePasswordForAccount
@username NVARCHAR(100), @pass VARCHAR(1000), @newPass VARCHAR(1000)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	SELECT @isRightPass = COUNT(*) FROM dbo.TaiKhoan WHERE UserName = @username AND Pass = @pass

	IF (@isRightPass = 1)
	BEGIN
		UPDATE dbo.TaiKhoan SET Pass = @newPass WHERE UserName = @username
    END
END
GO

CREATE PROC USP_Login
@userName NVARCHAR(1000), @pass VARCHAR(1000)
AS
BEGIN
	SELECT * FROM dbo.TaiKhoan WHERE UserName = @userName AND Pass = @pass
END
GO

--TÀI KHOẢN (frmAdmin)
CREATE PROC USP_GetAccountList
AS
BEGIN
	SELECT TK.UserName AS [Username], TK.LoaiTK AS [Loại tài khoản], NV.id AS [Mã nhân viên], NV.HoTen AS [Tên nhân viên]
	FROM dbo.TaiKhoan TK, dbo.NhanVien NV
	WHERE NV.id = TK.idNV
END
GO

CREATE PROC USP_InsertAccount
@username NVARCHAR(100), @loaiTK INT, @idnv VARCHAR(50)
AS
BEGIN
	INSERT dbo.TaiKhoan ( UserName, Pass, LoaiTK, idNV )
	VALUES ( @username, '5512317111114510840231031535810616566202691', @loaiTK, @idnv )
END
GO

CREATE PROC USP_UpdateAccount
@username NVARCHAR(100), @loaiTK INT
AS
BEGIN
	UPDATE dbo.TaiKhoan 
	SET LoaiTK = @loaiTK
	WHERE UserName = @username
END
GO

CREATE PROC USP_ResetPasswordtAccount
@username NVARCHAR(100)
AS
BEGIN
	UPDATE dbo.TaiKhoan 
	SET Pass = '5512317111114510840231031535810616566202691' 
	WHERE UserName = @username
END
GO

CREATE PROC USP_SearchAccount
@hoTen NVARCHAR(100)
AS
BEGIN
	SELECT TK.UserName AS [Username], TK.LoaiTK AS [Loại tài khoản], NV.id AS [Mã nhân viên], NV.HoTen AS [Tên nhân viên]
	FROM dbo.TaiKhoan TK, dbo.NhanVien NV
	WHERE NV.id = TK.idNV AND dbo.fuConvertToUnsign1(NV.HoTen) LIKE N'%' + dbo.fuConvertToUnsign1(@hoTen) + N'%'
END
GO


--DOANH THU
CREATE PROC USP_GetRevenueByMovieAndDate
@idMovie VARCHAR(50), @fromDate date, @toDate date
AS
BEGIN
	SELECT P.TenPhim AS [Tên phim], CONVERT(DATE, LC.ThoiGianChieu) AS [Ngày chiếu], CONVERT(TIME(0),LC.ThoiGianChieu) AS [Giờ chiếu], COUNT(V.id) AS [Số vé đã bán], SUM(TienBanVe) AS [Tiền vé]
	FROM dbo.Ve AS V, dbo.LichChieu AS LC, dbo.DinhDangPhim AS DDP, Phim AS P
	WHERE V.idLichChieu = LC.id AND LC.idDinhDang = DDP.id AND DDP.idPhim = P.id AND V.TrangThai = 1 AND P.id = @idMovie AND LC.ThoiGianChieu >= @fromDate AND LC.ThoiGianChieu <= @toDate
	GROUP BY idLichChieu, P.TenPhim, LC.ThoiGianChieu
END
GO

CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
GO

CREATE PROC USP_GetReportRevenueByMovieAndDate
@idMovie VARCHAR(50), @fromDate date, @toDate date
AS
BEGIN
	SELECT P.TenPhim, CONVERT(DATE, LC.ThoiGianChieu) AS NgayChieu, CONVERT(TIME(0),LC.ThoiGianChieu) AS GioChieu, COUNT(V.id) AS SoVeDaBan, SUM(TienBanVe) AS TienBanVe
	FROM dbo.Ve AS V, dbo.LichChieu AS LC, dbo.DinhDangPhim AS DDP, Phim AS P
	WHERE V.idLichChieu = LC.id AND LC.idDinhDang = DDP.id AND DDP.idPhim = P.id AND V.TrangThai = 1 AND P.id = @idMovie AND LC.ThoiGianChieu >= @fromDate AND LC.ThoiGianChieu <= @toDate
	GROUP BY idLichChieu, P.TenPhim, LC.ThoiGianChieu
END
GO

--KHÁCH HÀNG
CREATE PROC USP_GetCustomer
AS
BEGIN
	SELECT id AS [Mã khách hàng], HoTen AS [Họ tên], NgaySinh AS [Ngày sinh], DiaChi AS [Địa chỉ], SDT AS [SĐT], CMND AS [CMND], DiemTichLuy AS [Điểm tích lũy]
	FROM dbo.KhachHang
END
GO

CREATE PROC USP_InsertCustomer
@idCus VARCHAR(50), @hoTen NVARCHAR(100), @ngaySinh date, @diaChi NVARCHAR(100), @sdt VARCHAR(100), @cmnd INT
AS
BEGIN
	INSERT dbo.KhachHang (id, HoTen, NgaySinh, DiaChi, SDT, CMND, DiemTichLuy)
	VALUES (@idCus, @hoTen, @ngaySinh, @diaChi, @sdt, @cmnd, 0)
END
GO

CREATE PROC USP_SearchCustomer
@hoTen NVARCHAR(100)
AS
BEGIN
	SELECT id AS [Mã khách hàng], HoTen AS [Họ tên], NgaySinh AS [Ngày sinh], DiaChi AS [Địa chỉ], SDT AS [SĐT], CMND AS [CMND], DiemTichLuy AS [Điểm tích lũy]
	FROM dbo.KhachHang
	WHERE dbo.fuConvertToUnsign1(HoTen) LIKE N'%' + dbo.fuConvertToUnsign1(@hoTen) + N'%'
END
GO

--THỂ LOẠI
CREATE PROC USP_InsertGenre
@idGenre VARCHAR(50), @ten NVARCHAR(100), @moTa NVARCHAR(100)
AS
BEGIN
	INSERT dbo.TheLoai (id, TenTheLoai, MoTa)
	VALUES  (@idGenre, @ten, @moTa)
END
GO

--LOẠI MÀN HÌNH
CREATE PROC USP_InsertScreenType
@idScreenType VARCHAR(50), @ten NVARCHAR(100)
AS
BEGIN
	INSERT dbo.LoaiManHinh ( id, TenMH )
	VALUES  (@idScreenType, @ten)
END
GO

--PHIM
CREATE PROC USP_GetMovie
AS
BEGIN
	SELECT id AS [Mã phim], TenPhim AS [Tên phim], MoTa AS [Mô tả], ThoiLuong AS [Thời lượng], NgayKhoiChieu AS [Ngày khởi chiếu], NgayKetThuc AS [Ngày kết thúc], SanXuat AS [Sản xuất], DaoDien AS [Đạo diễn], NamSX AS [Năm SX], ApPhich AS [Áp Phích]
	FROM dbo.Phim
END
GO

CREATE PROC USP_GetListGenreByMovie
@idPhim VARCHAR(50)
AS
BEGIN
	SELECT TL.id, TenTheLoai, TL.MoTa
	FROM dbo.PhanLoaiPhim PL, dbo.TheLoai TL
	WHERE idPhim = @idPhim AND PL.idTheLoai = TL.id
END
GO

CREATE PROC USP_InsertMovie
@id VARCHAR(50), @tenPhim NVARCHAR(100), @moTa NVARCHAR(1000), @thoiLuong FLOAT, @ngayKhoiChieu DATE, @ngayKetThuc DATE, @sanXuat NVARCHAR(50), @daoDien NVARCHAR(100), @namSX INT, @apPhich IMAGE
AS
BEGIN
	INSERT dbo.Phim (id , TenPhim , MoTa , ThoiLuong , NgayKhoiChieu , NgayKetThuc , SanXuat , DaoDien , NamSX, ApPhich)
	VALUES (@id , @tenPhim , @moTa , @thoiLuong , @ngayKhoiChieu , @ngayKetThuc , @sanXuat , @daoDien , @namSX, @apPhich)
END
GO

CREATE PROC USP_UpdateMovie
@id VARCHAR(50), @tenPhim NVARCHAR(100), @moTa NVARCHAR(1000), @thoiLuong FLOAT, @ngayKhoiChieu DATE, @ngayKetThuc DATE, @sanXuat NVARCHAR(50), @daoDien NVARCHAR(100), @namSX INT , @apPhich IMAGE
AS
BEGIN
	UPDATE dbo.Phim SET TenPhim = @tenPhim, MoTa = @moTa, ThoiLuong = @thoiLuong, NgayKhoiChieu = @ngayKhoiChieu, NgayKetThuc = @ngayKetThuc, SanXuat = @sanXuat, DaoDien = @daoDien, NamSX = @namSX, ApPhich = @apPhich WHERE id = @id
END
GO

--ĐỊNH DẠNG PHIM
CREATE PROC USP_GetListFormatMovie
AS
BEGIN
	SELECT DD.id AS [Mã định dạng], P.id AS [Mã phim], P.TenPhim AS [Tên phim], MH.id AS [Mã MH], MH.TenMH AS [Tên MH]
	FROM dbo.DinhDangPhim DD, Phim P, dbo.LoaiManHinh MH
	WHERE DD.idPhim = P.id AND DD.idLoaiManHinh = MH.id
END
GO

CREATE PROC USP_InsertFormatMovie
@id VARCHAR(50), @idPhim VARCHAR(50), @idLoaiManHinh VARCHAR(50)
AS
BEGIN
	INSERT dbo.DinhDangPhim ( id, idPhim, idLoaiManHinh )
	VALUES  ( @id, @idPhim, @idLoaiManHinh )
END
GO


--LỊCH CHIẾU
CREATE PROC USP_GetListShowTimesByFormatMovie
@ID varchar(50), @Date Datetime
AS
BEGIN
	select l.id, pc.TenPhong, p.TenPhim, l.ThoiGianChieu, d.id as idDinhDang, l.GiaVe, l.TrangThai
	from Phim p ,DinhDangPhim d, LichChieu l, PhongChieu pc
	where p.id = d.idPhim and d.id = l.idDinhDang and l.idPhong = pc.id
	and d.id = @ID and CONVERT(DATE, @Date) = CONVERT(DATE, l.ThoiGianChieu)
	order by l.ThoiGianChieu
END
GO

CREATE PROC USP_GetShowtime
AS
BEGIN
	SELECT LC.id AS [Mã lịch chiếu], LC.idPhong AS [Mã phòng], P.TenPhim AS [Tên phim], MH.TenMH AS [Màn hình], LC.ThoiGianChieu AS [Thời gian chiếu], LC.GiaVe AS [Giá vé]
	FROM dbo.LichChieu AS LC, dbo.DinhDangPhim AS DD, Phim AS P, dbo.LoaiManHinh AS MH
	WHERE LC.idDinhDang = DD.id AND DD.idPhim = P.id AND DD.idLoaiManHinh = MH.id
END
GO

CREATE PROC USP_InsertShowtime
@id VARCHAR(50), @idPhong VARCHAR(50), @idDinhDang VARCHAR(50), @thoiGianChieu DATETIME, @giaVe FLOAT
AS
BEGIN
	INSERT dbo.LichChieu ( id , idPhong , idDinhDang, ThoiGianChieu  , GiaVe , TrangThai )
	VALUES  ( @id , @idPhong , @idDinhDang, @thoiGianChieu  , @giaVe , 0 )
END
GO

CREATE PROC USP_UpdateShowtime
@id VARCHAR(50), @idPhong VARCHAR(50), @idDinhDang VARCHAR(50), @thoiGianChieu DATETIME, @giaVe FLOAT
AS
BEGIN
	UPDATE dbo.LichChieu 
	SET idPhong = @idPhong, idDinhDang = @idDinhDang, ThoiGianChieu = @thoiGianChieu , GiaVe = @giaVe
	WHERE id = @id
END
GO

CREATE PROC USP_SearchShowtimeByMovieName
@tenPhim NVARCHAR(100)
AS
BEGIN
	SELECT LC.id AS [Mã lịch chiếu], LC.idPhong AS [Mã phòng], P.TenPhim AS [Tên phim], MH.TenMH AS [Màn hình], LC.ThoiGianChieu AS [Thời gian chiếu], LC.GiaVe AS [Giá vé]
	FROM dbo.LichChieu AS LC, dbo.DinhDangPhim AS DD, Phim AS P, dbo.LoaiManHinh AS MH
	WHERE LC.idDinhDang = DD.id AND DD.idPhim = P.id AND DD.idLoaiManHinh = MH.id AND dbo.fuConvertToUnsign1(P.TenPhim) LIKE N'%' + dbo.fuConvertToUnsign1(@tenPhim) + N'%'
END
GO

CREATE PROC USP_GetAllListShowTimes
AS
BEGIN
	select l.id, pc.TenPhong, p.TenPhim, l.ThoiGianChieu, d.id as idDinhDang, l.GiaVe, l.TrangThai
	from Phim p ,DinhDangPhim d, LichChieu l, PhongChieu pc
	where p.id = d.idPhim and d.id = l.idDinhDang and l.idPhong = pc.id
	order by l.ThoiGianChieu
END
GO

CREATE PROC USP_GetListShowTimesNotCreateTickets
AS
BEGIN
	select l.id, pc.TenPhong, p.TenPhim, l.ThoiGianChieu, d.id as idDinhDang, l.GiaVe, l.TrangThai
	from Phim p ,DinhDangPhim d, LichChieu l, PhongChieu pc
	where p.id = d.idPhim and d.id = l.idDinhDang and l.idPhong = pc.id and l.TrangThai = 0
	order by l.ThoiGianChieu
END
GO

CREATE PROC USP_UpdateStatusShowTimes
@idLichChieu NVARCHAR(50), @status int
AS
BEGIN
	UPDATE dbo.LichChieu
	SET TrangThai = @status
	WHERE id = @idLichChieu
END
GO

--NHÂN VIÊN
CREATE PROC USP_GetStaff
AS
BEGIN
	SELECT id AS [Mã nhân viên], HoTen AS [Họ tên], NgaySinh AS [Ngày sinh], DiaChi AS [Địa chỉ], SDT AS [SĐT], CMND AS [CMND]
	FROM dbo.NhanVien
END
GO

CREATE PROC USP_InsertStaff
@idStaff VARCHAR(50), @hoTen NVARCHAR(100), @ngaySinh date, @diaChi NVARCHAR(100), @sdt VARCHAR(100), @cmnd INT
AS
BEGIN
	INSERT dbo.NhanVien (id, HoTen, NgaySinh, DiaChi, SDT, CMND)
	VALUES (@idStaff, @hoTen, @ngaySinh, @diaChi, @sdt, @cmnd)
END
GO

CREATE PROC USP_SearchStaff
@hoTen NVARCHAR(100)
AS
BEGIN
	SELECT id AS [Mã nhân viên], HoTen AS [Họ tên], NgaySinh AS [Ngày sinh], DiaChi AS [Địa chỉ], SDT AS [SĐT], CMND AS [CMND]
	FROM dbo.NhanVien
	WHERE dbo.fuConvertToUnsign1(HoTen) LIKE N'%' + dbo.fuConvertToUnsign1(@hoTen) + N'%'
END
GO


--PHÒNG CHIẾU
CREATE PROC USP_GetCinema
AS
BEGIN
	SELECT PC.id AS [Mã phòng], TenPhong AS [Tên phòng], TenMH AS [Tên màn hình], PC.SoChoNgoi AS [Số chỗ ngồi], PC.TinhTrang AS [Tình trạng], PC.SoHangGhe AS [Số hàng ghế], PC.SoGheMotHang AS [Ghế mỗi hàng]
	FROM dbo.PhongChieu AS PC, dbo.LoaiManHinh AS MH
	WHERE PC.idManHinh = MH.id
END
GO

CREATE PROC USP_InsertCinema
@idCinema VARCHAR(50), @tenPhong NVARCHAR(100), @idMH VARCHAR(50), @soChoNgoi INT, @tinhTrang INT, @soHangGhe INT, @soGheMotHang INT
AS
BEGIN
	INSERT dbo.PhongChieu ( id , TenPhong , idManHinh , SoChoNgoi , TinhTrang , SoHangGhe , SoGheMotHang)
	VALUES (@idCinema , @tenPhong , @idMH , @soChoNgoi , @tinhTrang , @soHangGhe , @soGheMotHang)
END
GO


--VÉ
CREATE PROC USP_InsertTicketByShowTimes
@idlichChieu VARCHAR(50), @maGheNgoi VARCHAR(50)
AS
BEGIN
	INSERT INTO dbo.Ve
	(
		idLichChieu,
		MaGheNgoi,
		idKhachHang
	)
	VALUES
	(
		@idlichChieu,
		@maGheNgoi,
		NULL
	)
END
GO

CREATE PROC USP_DeleteTicketsByShowTimes
@idlichChieu VARCHAR(50)
AS
BEGIN
	DELETE FROM dbo.Ve
	WHERE idLichChieu = @idlichChieu
END
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

