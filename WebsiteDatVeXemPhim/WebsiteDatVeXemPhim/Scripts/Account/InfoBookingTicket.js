var vmInfoBookingTicket = new Vue({
    el: "#InfoBookingTicket",
    data: {
        list: [],

    },
    methods: {
        isCompleted: function(date) {
            var now = moment().format('DD/MM/YYYY');
            return now > date;
        },
        getListTicket: function () {
            AddLoader();
            var self = this;
            $.ajax({
                url: "/api/TicketApi/loadTicketByUsername?Username=" + session,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.list = res.data.listVe;
                HiddenLoader();
                $("#InfoBookingTicket").css("display", "block");
            });
        },

        cancelTicket: function (id) {
            var self = this;
            if (confirm("Bạn chắc chắn muốn huỷ đặt vé chứ?")) {
                var modal = {
                    id: id
                }
                $.ajax({
                    data: modal,
                    url: "/api/TicketApi/huyVE",
                    type: 'POST',
                    dataType: 'json',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8"
                }).then(res => {
                    if (res.message == 200) {
                        alert("Huỷ vé thành công");
                        vmInfoBookingTicket.getListTicket();
                    } else {
                        alert("Đã có lỗi xảy ra trong quá trình huỷ vé");
                    }
                });
            } else {
                return false;
            }
        }

    }
})

vmInfoBookingTicket.getListTicket();