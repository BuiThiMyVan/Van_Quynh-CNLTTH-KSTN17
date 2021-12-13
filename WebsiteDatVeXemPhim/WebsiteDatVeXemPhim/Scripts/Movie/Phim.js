var vmListFilm = new Vue({
    el: "#ListFilm",
    data: {
        currentPage: 1,
        pageSize: 10,
        listPageSize: [10, 25, 50],
        pageCount: 1,
        pageView: "",
        txtSearch: '',
        Status: -1,
        list: {},
        textFilter: "Tất cả",
        CountAllFilm: 0,
        VName: "",
        RoleId: -1
    },

    methods: {
        first: function () {
            this.currentPage = 1;
            this.getListFilm();
        },

        last: function () {
            this.currentPage = this.totalPage;
            this.getListFilm();
        },

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

        validatePage: function () {
            var page = $("#pagePicked").val();
            if (page > this.totalPage) {
                this.currentPage = this.totalPage;
            }
        },

        getListFilm: function () {
            AddLoader();
            var self = this;
            var modal = {
                page: self.currentPage,
                pageSize: self.pageSize,
                txtSearch: self.txtSearch.trim()
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
                self.pageView = res.data.pageView;
                HiddenLoader();
                $("#ListFilm").css("display", "block");
            });
        }

    }
})

vmListFilm.getListFilm();

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode == 13) {
        vmListFilm.getListFilm();
    } else if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}