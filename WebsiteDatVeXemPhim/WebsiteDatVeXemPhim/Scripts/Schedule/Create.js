var vmCreateSchedule = new Vue({
    el: "#CreateSchedule",
    data: {
        listSC: [],
        listPC: []
    },

    watch: {
        
    },

    methods: {
        getPhongChieu: function () {
            var self = this;
            $.ajax({
                url: "/api/RoomApi/loadListPC",
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res.data);
                self.listPC = res.data;
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
                self.listSC = res.infoSC;
            });
        },

        addSchedule: function () {
            var self = this;
            var bug = 0;         

            var modal = {

            };

            $.ajax({
                data: modal,
                url: "/api/Schedule/addLichChieu",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res == 200) {
                    alert('Thêm mới phim thành công');
                    window.location.href = '/Admin/Movie/Index';
                } else {
                    alert('Đã xảy ra lỗi khi thêm mới phim');
                }
            });
        }

    }
})

vmCreateSchedule.getSuatChieu();
vmCreateSchedule.getPhongChieu();

