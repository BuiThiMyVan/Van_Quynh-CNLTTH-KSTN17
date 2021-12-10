var vmListRoom = new Vue({
    el: "#ListRoom",
    data: {
        list: []  
    },
    methods: {
        getListRoom: function () {
            //AddLoader();
            var self = this;
            $.ajax({
                url: "/api/RoomApi/loadListPC",
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res.data);
                self.list = res.data.listPhongChieu;
                //HiddenLoader();
                //$("#ListFilm").css("display", "block");
            });
        }

    }
})

vmListRoom.getListRoom();