var vmBookingTicket = new Vue({
    el: "#BookingTicket",
    data: {
        listVe: [],
        lichChieu: {},
        listHang: [],
        listHangAlphabet: [],
        listCot: [],
        listCotSo: [],
        listSeats: [],
        soHang: 0,
        soCot: 0,
        soHangCurrent: 0,
        soCotCurrent: 0,
        soHangChoosen: -1,
        soCotChoosen: -1,
        idKhachHang: -1,
    },

    computed: {
        statusOfSeat: function () {
            var self = this;
            for (var i = 0; i < self.listVe.length; i++) {
                if (self.listVe[i].SoHang == self.soHangCurrent && self.listVe[i].SoCot == self.soCotCurrent) {
                    var result = self.listVe[i].TrangThai;
                    return result;
                }
            }
        },

        idOfSeat: function () {
            var self = this;
            for (var i = 0; i < self.listVe.length; i++) {
                if (self.listVe[i].SoHang == self.soHangChoosen && self.listVe[i].SoCot == self.soCotChoosen) {
                    var result = self.listVe[i].id;
                    return result;
                }
            }
        },
    },

    methods: {
        getListTicket: function () {
            var self = this;
            $.ajax({
                url: "/api/TicketApi/loadListTicketByIdLichchieu?idLichchieu=" + idLichChieu,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.listVe = res.data.listVe;
            });
        },

        getScheduleById: function () {
            AddLoader();
            var self = this;
            $.ajax({
                url: "/api/ScheduleApi/getLichChieuTheoId?id=" + idLichChieu,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.lichChieu = res.data;
                self.soHang = res.data.SoHang;
                self.soCot = res.data.SoCot;
                //var lisHang = [];
                self.soHangCurrent = 0;
                self.soCotCurrent = 0;
                var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

                for (var i = 0; i < self.soHang; i++) {
                    self.listCot = [];
                    self.soHangCurrent = i;
                    for (var j = 0; j < self.soCot; j++) {
                        self.soCotCurrent = j
                        var seat = {
                            idCot: j,
                            TrangThai: self.statusOfSeat
                        }
                        self.listCot.push(seat);
                    }
                    var hang = {
                        alphabet: alphabet.charAt(i),
                        itemHangs: self.listCot
                    }
                    self.listHang.push(hang);
                }

                for (var i = 0; i < self.soCot; i++) {
                    self.listCotSo.push(i + 1);
                }
            });
            HiddenLoader();
        },

        getInfoCustomer: function () {
            var self = this;
            $.ajax({
                url: "/api/CustommerAPI/getCustommerByUsername?username=" + userName,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.idKhachHang = res.kh[0].id;
            });
        },

        getInfo: function () {
            AddLoader();
            vmBookingTicket.getListTicket();
            setTimeout(function () {
                vmBookingTicket.getScheduleById();
                vmBookingTicket.getInfoCustomer();
            }, 1000)
            
            HiddenLoader();
            $("#BookingTicket").css("display", "block");
        },

        bookingTicket: function () {
            var self = this;
            var seatChoosen = $('input[name="seat"]:checked');
            if (seatChoosen.length == 0) {
                alert('Bạn cần chọn chỗ ngồi');
                return false;
            } else {
                self.soCotChoosen = $(seatChoosen.parent()[0]).attr('data-value');
                self.soHangChoosen = $(seatChoosen.parent().parent()[0]).attr('data-value');
            }

            if (confirm("Bạn chắc chắn muốn đặt vé chứ?")) {
                var modal = {
                    id: self.idOfSeat,
                    idKhachHang: self.idKhachHang
                }

                $.ajax({
                    data: modal,
                    url: "/api/TicketApi/datVE",
                    type: 'POST',
                    dataType: 'json',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8"
                }).then(res => {
                    if (res.message == 200) {
                        alert('Đặt vé thành công');
                        window.location.href = '/Account/InfoBookingTicket';
                    } else {
                        alert('Đã xảy ra lỗi trong quá trình đặt vé');
                    }
                });
            } else {
                window.location.href = "";
            }


        }
    }
})

vmBookingTicket.getInfo();
