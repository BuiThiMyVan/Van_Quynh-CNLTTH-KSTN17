var vmMyRoom = new Vue({
    el: "#MyRoom",
    data: {
        TenPhong: '',
        SoChoNgoi: null,
        SoHang: null,
        SoCot: null,
        TinhTrang: 1,
        LoaiManHinh: '',

        error_name: '',
        error_numberseat: '',
        error_row: '',
        error_column: '',
        error_cate: ''
    },

    watch: {
        TenPhong: function () {
            var self = this;
            if (self.TenPhong == '') {
                self.error_name = 'Tên phòng không được để trống';
            } else {
                self.error_name = '';
            }
        },

        SoChoNgoi: function () {
            var self = this;
            if (self.SoChoNgoi == null) {
                self.error_numberseat = 'Số chỗ ngồi không được để trống';
            } else {
                self.error_numberseat = '';
            }
        },

        SoHang: function () {
            var self = this;
            if (self.SoHang == null) {
                self.error_row = 'Số hàng không được để trống';
            } else {
                self.error_row = '';
            }
        },

        SoCot: function () {
            var self = this;
            if (self.SoCot == null) {
                self.error_column = 'Số dãy không được để trống';
            } else {
                self.error_column = '';
            }
        },

        LoaiManHinh: function () {
            var self = this;
            if (self.LoaiManHinh == '') {
                self.error_cate = 'Loại màn hình không được để trống';
            } else {
                self.error_cate = '';
            }
        },
    },

    methods: {
        getInfoRoom: function () {
            AddLoader();
            var self = this;
            $.ajax({
                url: "/api/RoomApi/getPhongChieubyId?maPC=" + id,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                self.TenPhong = res.infoPC.TenPhong;
                self.SoChoNgoi = res.infoPC.SoChoNgoi;
                self.SoHang = res.infoPC.SoHang;
                self.SoCot = res.infoPC.SoCot;
                self.TinhTrang = res.infoPC.TinhTrang;
                self.LoaiManHinh = res.infoPC.LoaiManHinh;
                HiddenLoader();
                $("#MyRoom").css("display", "block");
            });
        },

        updateRoom: function () {
            // AddLoader();
            var self = this;
            var bug = 0;

            if (self.TenPhong == '') {
                self.error_name = 'Tên phòng không được để trống';
                bug++;
            }

            if (self.SoChoNgoi == null) {
                self.error_numberseat = 'Số chỗ ngồi không được để trống';
                bug++;
            } else {
                if (self.SoChoNgoi == 0) {
                    self.error_numberseat = 'Số chỗ ngồi không hợp lệ';
                    bug++;
                }
            }

            if (self.SoHang == null) {
                self.error_row = 'Số hàng không được để trống';
                bug++;
            } else {
                if (self.SoHang == 0) {
                    self.error_row = 'Số hàng không hợp lệ';
                    bug++;
                }
            }
            if (self.SoCot == null) {
                self.error_column = 'Số dãy không được để trống';
                bug++;
            } else {
                if (self.SoCot == 0) {
                    self.error_column = 'Số dãy không hợp lệ';
                    bug++;
                }
            }

            if (self.LoaiManHinh == '') {
                self.error_cate = 'Loại màn hình không được để trống';
                bug++;
            }

            if (bug != 0) {
                return false;
            }

            var modal = {
                id: id,
                TenPhong: self.TenPhong,
                SoChoNgoi: self.SoChoNgoi,
                SoHang: self.SoHang,
                SoCot: self.SoCot,
                TinhTrang: self.TinhTrang,
                LoaiManHinh: self.LoaiManHinh
            };

            $.ajax({
                data: modal,
                url: "/api/RoomApi/updatePC",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res == 200) {
                    alert('Cập nhật thông tin phòng chiếu thành công');
                } else {
                    alert('Đã xảy ra lỗi khi cập nhật thông tin phòng chiếu');
                }
                HiddenLoader();
                  $("#MyRoom").css("display", "block");
            });
        },

    }
})

vmMyRoom.getInfoRoom();

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}