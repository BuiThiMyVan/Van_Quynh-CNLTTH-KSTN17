var vmRegister = new Vue({
    el: "#Register",
    data: {
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

        password: function () {
            var self = this;
            if (self.password == '') {
                self.error_password = 'Bạn cần nhập mật khẩu';
            } else {
                self.error_password = '';
            }
        },

        confirm_pass: function () {
            var self = this;
            if (self.confirm_pass !== self.password) {
                self.error_confirm_pass = 'Mật khẩu nhập lại không khớp';
            } else {
                self.error_confirm_pass = '';
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
            var regex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/i;
            if (!regex.test(self.sdt)) {
                self.error_sdt = 'Bạn cần nhập đúng định dạng số điện thoại';
            }
            if (self.sdt == '') {
                self.error_sdt = 'Bạn cần nhập số điện thoại';
            } else {
                self.error_sdt = '';
            }
        }
    },

    methods: {
        register: function () {
            var self = this;

            if (self.username == '') {
                self.error_username = 'Bạn cần điền tên đăng nhập';
            }

            if (self.password == '') {
                self.error_password = 'Bạn cần nhập mật khẩu';
            }

            if (self.confirm_pass !== self.password) {
                self.error_confirm_pass = 'Mật khẩu nhập lại không khớp';
            }

            if (self.hoten == '') {
                self.error_hoten = 'Bạn cần nhập họ tên';
            }

            if (self.sdt == '') {
                self.error_sdt = 'Bạn cần nhập số điện thoại';
            }

            if (self.error_username !== '' || self.error_password !== '' || self.error_confirm_pass || self.error_hoten !== '' || self.error_sdt !== '') {
                return false;
            }

            var modal = {
                UserName: self.username,
                Pass: self.password,
                HoTen: self.hoten,
                NgaySinh: moment(self.ngaysinh, 'DD/MM/YYYY').format('YYYY-MM-DD'),
                DiaChi: self.diachi,
                SDT: self.sdt
            };
            console.log(modal);
            $.ajax({
                data: modal,
                url: "/api/CustommerAPI/addKH",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                if (res.message == 200) {
                    alert('Đăng ký tài khoản thành công');
                } else {
                    alert('Đã xảy ra lỗi trong quá trình đăng ký');
                }
            });
        }
    },



})