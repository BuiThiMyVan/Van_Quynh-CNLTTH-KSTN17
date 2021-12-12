var vmMyFilm = new Vue({
    el: "#MyFilm",
    data: {
        Id: 0,
        TenPhim: '',
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
        listLichChieu: [],
        pickedSchedule: null,
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
                self.Id = id;
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
                HiddenLoader();
                $("#MyFilm").css("display", "block");
            });
        },

        getScheduleByFilmId: function () {
            var self = this;
            $.ajax({
                url: "/api/ScheduleApi/getLichChieuTheoPhim?idPhim=" + id,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.listLichChieu = res.data.listLichChieu;
            });
        },

        getInfo: function () {
            AddLoader();
            vmMyFilm.getInfoFilm();
            vmMyFilm.getScheduleByFilmId();
            HiddenLoader();
            $("#MyFilm").css("display", "block");
        },

        checkPickedSchedule: function () {
            var self = this;
            if (self.pickedSchedule == null) {
                alert("Bạn cần chọn lịch chiếu");
            } else {
                window.location.href = "/Home/BookingTicket?idLichChieu=" + self.pickedSchedule + "&idPhim=" + self.Id;
            }
        },

        chooseSchedule: function (event, id) {
            var self = this;
            var scheduleItems = $('.schedule_item');
            for (var item of scheduleItems) {
                $(item).removeClass('active_schedule');
            }
            self.pickedSchedule = id;

            $(event.target.parentNode).addClass('active_schedule');
        }
    }
})

vmMyFilm.getInfo();
