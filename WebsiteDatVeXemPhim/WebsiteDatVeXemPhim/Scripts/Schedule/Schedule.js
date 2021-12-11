var vmListSchedule = new Vue({
    el: "#ListSchedule",
    data: {
        list: []
    },
    methods: {
        getListSchedule: function () {
            AddLoader();
            var self = this;
            $.ajax({
                url: "/api/ScheduleApi/getLichChieu",
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res.data);
                self.list = res.data.listPhongChieu;
                HiddenLoader();
                $("#ListSchedule").css("display", "block");
            });
        }

    }
})

vmListRoom.getListSchedule();