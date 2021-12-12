var vmListFilm_Homepage = new Vue({
    el: "#ListFilm_Hompage",
    data: {
        currentPage: 1,
        pageSize: 10,
        pageCount: 1,
        pageView: "",
        txtSearch: '',
        Status: -1,
        list: [],
        textFilter: "Tất cả",
        CountAllFilm: 0,
        VName: "",
        RoleId: -1
    },

    methods: {
        next: function () {
            if (this.currentPage < this.totalPage) {
                this.currentPage++;
                this.getListFilm();
            }
        },

        prev: function () {
            if (this.currentPage > 1) {
                this.currentPage--;
                this.getListFilm();
            }
        },

        getListFilm: function () {
            AddLoader();
            var self = this;
            var modal = {
                page: self.currentPage,
                pageSize: self.pageSize
            };
            $.ajax({
                data: modal,
                url: "/api/MovieApi/loadListPhim",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.list = res.data.listPhim;
                self.totalPage = res.data.totalPage;
                HiddenLoader();
                $("#ListFilm_Hompage").css("display", "block");
            });
        }

    }
})

vmListFilm_Homepage.getListFilm();
