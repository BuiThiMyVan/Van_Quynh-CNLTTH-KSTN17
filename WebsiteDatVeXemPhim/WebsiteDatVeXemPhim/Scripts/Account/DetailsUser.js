var vmDetailsUser = new Vue({
    el: "#DetailsUser",
    data: {
        id: -1,
        username: '',
        password: '',
        confirm_pass: '',
        hoten: '',
        ngaysinh: '',
        diachi: '',
        sdt: '',
        error_username: '',
        error_password: '',
        error_confirm_pass: '',
        error_hoten: '',
        error_sdt: ''
    },

    watch: {
        username: function () {
            var self = this;
            if (self.username == '') {
                self.error_username = 'Bạn cần điền tên đăng nhập';
            } else {
                self.error_username = '';
            }
        },

        hoten: function () {
            var self = this;
            if (self.hoten == '') {
                self.error_hoten = 'Bạn cần nhập họ tên';
            } else {
                self.error_hoten = '';
            }
        },

        sdt: function () {
            var self = this;
            var regex = /((09|03|07|08|05)+([0-9]{8})\b)/g;

            if (self.sdt == '') {
                self.error_sdt = 'Bạn cần nhập số điện thoại';
            } else {
                if (regex.test(self.sdt) == true) {
                    self.error_sdt = '';
                } else {
                    self.error_sdt = 'Bạn cần nhập đúng định dạng số điện thoại';
                }
            }
        },

        confirm_pass: function () {
            var self = this;
            if (self.confirm_pass != self.password) {
                self.error_confirm_pass = "Mật khẩu nhập lại không khớp";
            } else {
                self.error_confirm_pass = "";
            }
        }
    },

    methods: {
        getInfoUser: function () {
            var self = this;
            $.ajax({
                url: "/api/CustommerAPI/getCustommerByUsername?username=" + session,
                type: 'GET',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                self.id = res.kh[0].id;
                self.username = res.kh[0].username;
                self.hoten = res.kh[0].hoten == null ? '' : res.kh[0].hoten,
                self.ngaysinh = res.kh[0].ngaysinh == null ? '' : res.kh[0].ngaysinh,
                self.diachi = res.kh[0].diachi == null ? '' : res.kh[0].diachi,
                self.sdt = res.kh[0].sodienthoai == null ? '' : res.kh[0].sodienthoai
            });
        },

        updateInfoUser: function () {
            var self = this;
            var bug = 0;

            if (self.username == '') {
                self.error_username = 'Bạn cần điền tên đăng nhập';
                bug++;
            }

            if (self.confirm_pass !== self.password) {
                self.error_confirm_pass = 'Mật khẩu nhập lại không khớp';
                bug++;
            }

            if (self.hoten == '') {
                self.error_hoten = 'Bạn cần nhập họ tên';
                bug++;
            }

            if (self.sdt == '') {
                self.error_sdt = 'Bạn cần nhập số điện thoại';
                bug++;
            }

            if (bug != 0) {
                return false;
            }
            var modal = {
                id: self.id,
                UserName: self.username,
                Pass: self.password,
                HoTen: self.hoten,
                NgaySinh: moment(self.ngaysinh, 'DD/MM/YYYY').format('YYYY-MM-DD'),
                DiaChi: self.diachi,
                SDT: self.sdt
            };

            $.ajax({
                data: modal,
                url: "/api/CustommerAPI/updateKH",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res.message == 200) {
                    alert('Cập nhật thông tin tài khoản thành công');
                    window.location.href = "/home-page";               
                } else {
                    alert('Đã xảy ra lỗi trong quá trình cập nhật');
                }
            });
        }
    },
})

vmDetailsUser.getInfoUser();