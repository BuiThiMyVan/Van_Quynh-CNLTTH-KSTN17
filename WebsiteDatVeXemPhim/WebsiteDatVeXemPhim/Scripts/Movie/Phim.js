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

    method: {
        getListFilm: function () {
            //AddLoader();
            var self = this;
            var modal = {
                //Search: self.txtSearch.trim(),
                pageSize: self.pageSize,
                page: self.currentPage,
                //Status: self.Status
            }
            $.ajax({
                data: modal,
                url: "/api/MovieApi/loadListPhim",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                self.list = res.data.listPhim;
                self.totalPage = res.data.totalPage;
                self.pageView = res.data.PageView;
                //HiddenLoader();
                //$("#ListFilm").css("display", "block");
                //setTimeout(function () {
                //    $(function () {
                //        $('[data-toggle="tooltip"]').tooltip(
                //            {
                //                container: 'body'
                //            }
                //        );
                //    });
                //});
            });
        },

    }
})

vmListFilm.getListFilm();

