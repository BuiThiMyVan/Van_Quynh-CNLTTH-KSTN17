var vmMyFilm = new Vue({
    el: "#MyFilm",
    data: {
        TenPhim : '',
        MoTa: '',
        ThoiLuong: 0,
        NgayKhoiChieu: '',
        NgayKetThuc: '',
        Sanxuat: '',
        DaoDien: '',
        NamSX: 0,
        ApPhich: '',
        TinhTrang: -1,
        TheLoai: ''
    },

    methods: {
        getInfoFilm: function () {
         // AddLoader();
            var self = this;
            $.ajax({
                url: "/api/MovieApi/getPhimbyId?MaPhim=" + id,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
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
              //HiddenLoader();
            //  $("#ListFilm").css("display", "block");
            });
        }

    }
})

vmMyFilm.getInfoFilm();

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}