var vmMyFilm = new Vue({
    el: "#MyFilm",
    data: {
        Id: 0,
        TenPhim : '',
        MoTa: '',
        ThoiLuong: 0,
        NgayKhoiChieu: '',
        NgayKetThuc: '',
        Sanxuat: '',
        DaoDien: '',
        NamSX: 0,
        ApPhich: '',
        TinhTrang: -1,
        TheLoai: '',

        error_name: '',
        error_time: '',
        error_startdate: '',
        error_finishdate: '',
        error_produceyear: '',
        error_image: '',
        error_cate: ''
    },

    watch: {
        TenPhim: function () {
            var self = this;
            if (self.TenPhim == '') {
                self.error_name = 'Tên phim không được để trống';
            } else {
                self.error_name = '';
            }
        },

        ThoiLuong: function () {
            var self = this;
            if (self.ThoiLuong <= 0) {
                self.error_time = 'Thời Lượng không được để trống';
            } else {
                self.error_time = '';
            }
        },

        NgayKhoiChieu: function () {
            var self = this;
            if (self.NgayKhoiChieu < moment().valueOf()) {
                self.error_startdate = 'Ngày khởi chiếu không không hợp lệ';
            } else {
                self.error_startdate = '';
            }
        },

        NgayKetThuc: function () {
            var self = this;
            if (self.NgayKetThuc < moment().valueOf()) {
                self.error_finishdate = 'Ngày kết thúc không hợp lệ';
            } else {
                self.error_finishdate = '';
            }
        },

        NamSX: function () {
            var self = this;
            if (self.NamSX < 1700) {
                self.error_produceyear = 'Năm sản xuất không hợp lệ';
            } else {
                self.error_produceyear = '';
            }
        },

        ApPhich: function () {
            var self = this;
            if (self.TenPhim == '') {
                self.error_image = 'Poster không được để trống';
            } else {
                self.error_image = '';
            }
        },

        TheLoai: function () {
            var self = this;
            if (self.TheLoai == '') {
                self.error_cate = 'Thể loại không được để trống';
            } else {
                self.error_cate = '';
            }
        }
    },

    methods: {
        ChooseImage: function () {
            var self = this;
            var finder = new CKFinder();
            finder.selectActionFunction = function (fileUrl) {
                self.ApPhich = fileUrl;
            }
            finder.popup();
        },

        getInfoFilm: function () {
         // AddLoader();
            var self = this;
            $.ajax({
                url: "/api/MovieApi/getPhimbyId?MaPhim=" + id,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.TenPhim = res.infoPhim.TenPhim == null ? '' : res.infoPhim.TenPhim;
                self.MoTa = res.infoPhim.MoTa == null ? '' : res.infoPhim.MoTa;
                self.ThoiLuong = res.infoPhim.ThoiLuong == null ? 0 : res.infoPhim.ThoiLuong;
                self.NgayKhoiChieu = res.infoPhim.NgayKhoiChieu == null ? '' : res.infoPhim.NgayKhoiChieu;
                self.NgayKetThuc = res.infoPhim.NgayKetThuc == null ? '' : res.infoPhim.NgayKetThuc;
                self.Sanxuat = res.infoPhim.Sanxuat == null ? '' : res.infoPhim.Sanxuat;
                self.DaoDien = res.infoPhim.DaoDien == null ? '' : res.infoPhim.DaoDien;
                self.NamSX = res.infoPhim.NamSX == null ? 0 : res.infoPhim.NamSX;
                self.ApPhich = res.infoPhim.ApPhich == null ? '' : res.infoPhim.ApPhich;
                self.TinhTrang = res.infoPhim.TinhTrang == null ? -1 : res.infoPhim.TinhTrang;
                self.TheLoai = res.infoPhim.TheLoai == null ? '' : res.infoPhim.TheLoai;
              //HiddenLoader();
            //  $("#ListFilm").css("display", "block");
            });
        },

        updateFilm: function () {
            // AddLoader();
            var self = this;
            var bug = 0;

            if (self.TenPhim == '') {
                self.error_name = 'Tên phim không được để trống';
                bug++;
            }

            if (self.ThoiLuong == null) {
                self.error_time = 'Thời lượng không được để trống';
                bug++;
            } else {
                if (self.ThoiLuong == 0) {
                    self.error_time = 'Thời lượng không hợp lệ';
                    bug++;
                }
            }

            if (self.NgayKhoiChieu == '') {
                self.error_startdate = 'Ngày khởi chiếu không được để trống';
                bug++;
            }

            if (self.NgayKetThuc == '') {
                self.error_finishdate = 'Ngày kết thúc không được để trống';
                bug++;
            }

            if (self.NamSX == null) {
                self.error_produceyear = 'Năm sản xuất không được để trống';
                bug++;
            } else {
                if (self.NamSX < 1700) {
                    self.error_produceyear = 'Năm sản xuất không hợp lệ';
                    bug++;
                }
            }

            if (self.ApPhich == '') {
                self.error_image = 'Poster không được để trống';
                bug++;
            }

            if (self.TheLoai == '') {
                self.error_cate = 'Thể loại không được để trống';
                bug++;
            }

            if (bug != 0) {
                return false;
            }

            var modal = {
                id: id,
                TenPhim: self.TenPhim,
                MoTa: self.MoTa,
                ThoiLuong: self.ThoiLuong,
                NgayKhoiChieu: moment(self.NgayKhoiChieu, 'DD/MM/YYYY').format('YYYY-MM-DD'),
                NgayKetThuc: moment(self.NgayKetThuc, 'DD/MM/YYYY').format('YYYY-MM-DD'),
                Sanxuat: self.Sanxuat,
                DaoDien: self.DaoDien,
                NamSX: self.NamSX,
                ApPhich: self.ApPhich,
                TinhTrang: self.TinhTrang,
                TheLoai: self.TheLoai
            };

            $.ajax({
                data: modal,
                url: "/api/MovieApi/updatePhim",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res == 200) {
                    alert('Cập nhật thông tin phim thành công');
                } else {
                    alert('Đã xảy ra lỗi khi cập nhật thông tin phim');
                }
                //HiddenLoader();
                //  $("#ListFilm").css("display", "block");
            });
        }

    }
})

vmMyFilm.getInfoFilm();

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}