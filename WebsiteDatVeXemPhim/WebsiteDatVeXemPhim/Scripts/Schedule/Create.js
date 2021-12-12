var vmCreateSchedule = new Vue({
    el: "#CreateSchedule",
    data: {
        TenPhim: '',
        ThoiGianChieu: '',
        idPhong: -1,
        GiaVe: null,
        TrangThai: 1,
        idSuatChieu: -1,
        listSC: [],
        listPC: [],

        error_showtime: '',
        error_room: '',
        error_price: '',
        error_sc: ''
    },

    watch: {
        ThoiGianChieu: function () {
            var self = this;
            if (self.ThoiGianChieu == '') {
                self.error_showtime = 'Cần chọn thời gian chiếu';
            } else {
                self.error_showtime = '';
            }
        },

        idPhong: function () {
            var self = this;
            if (self.idPhong == -1) {
                self.error_room = 'Cần chọn phòng chiếu';
            } else {
                self.error_room = '';
            }
        },

        GiaVe: function () {
            var self = this;
            if (self.GiaVe == null) {
                self.error_price = 'Cần nhập giá vé';
            } else {
                self.error_price = '';
            }
        },

        idSuatChieu: function () {
            var self = this;
            if (self.idSuatChieu == -1) {
                self.error_sc = 'Cần chọn suất chiếu';
            } else {
                self.error_sc = '';
            }
        },
    },

    methods: {
        getInfoFilm: function () {
            AddLoader();
            var self = this;
            $.ajax({
                url: "/api/MovieApi/getPhimbyId?MaPhim=" + id,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.TenPhim = res.infoPhim.TenPhim == null ? '' : res.infoPhim.TenPhim;
                HiddenLoader();
                $("#CreateSchedule").css("display", "block");
            });
        },
        getPhongChieu: function () {
            var self = this;
            $.ajax({
                url: "/api/RoomApi/loadListPC",
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res.data);
                self.listPC = res.data.listPhongChieu;
            });
        },
        getSuatChieu: function () {
            var self = this;
            $.ajax({
                url: "/api/ScheduleApi/getSuatChieu",
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                self.listSC = res.data.listSuatChieu;
            });
        },

        addSchedule: function () {
            var self = this;
            var bug = 0;

            if (self.ThoiGianChieu == '') {
                self.error_showtime = 'Cần chọn thời gian chiếu';
                bug++;
            }

            if (self.GiaVe == null) {
                self.error_price = 'Cần nhập giá vé';
                bug++;
            }

            if (self.idPhong == -1) {
                self.error_room = 'Cần chọn phòng chiếu';
                bug++;
            }

            if (self.idSuatChieu == -1) {
                self.error_sc = 'Cần chọn suất chiếu';
                bug++;
            }

            if (bug != 0) {
                return false;
            }

            var modal = {
                ThoiGianChieu: moment(self.ThoiGianChieu, 'DD/MM/YYYY').format('YYYY-MM-DD'),
                idPhong: self.idPhong,
                idPhim: id,
                GiaVe: self.GiaVe,
                TrangThai: self.TrangThai,
                idSuatChieu: self.idSuatChieu
            };

            $.ajax({
                data: modal,
                url: "/api/ScheduleApi/addLichChieu",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res == 200) {
                    alert('Thêm mới lịch chiếu thành công');
                    window.location.href = '/Admin/Schedule/Index';
                } else {
                    alert('Đã xảy ra lỗi khi thêm mới lịch chiếu');
                }
            });
        }

    }
})
vmCreateSchedule.getInfoFilm();
vmCreateSchedule.getSuatChieu();
vmCreateSchedule.getPhongChieu();

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}