﻿var vmRegister = new Vue({
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
        error_sdt: '',
        remember: false,
        error_remember: ''
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

        remember: function () {
            var self = this;
            if (!self.remember) {
                self.error_remember = 'Chưa xác nhận điều khoản';
            } else {
                self.error_remember = '';
            }
        }
    },

    methods: {
        getInfoUser: function () {
            $.ajax({
                data: modal,
                url: "/api/CustommerAPI?username=" + username,
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                
            });
        },

        updateInfoUser: function () {
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

            if (self.remember == false) {
                self.error_remember = 'Chưa xác nhận điều khoản';
            }

            if (self.error_username !== '' || self.error_password !== '' || self.error_confirm_pass || self.error_hoten !== '' || self.error_sdt !== '' || self.error_remember !== '') {
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

            $.ajax({
                data: modal,
                url: "/api/CustommerAPI/updateKH",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                if (res.message == 200) {
                    alert('Cập nhật thông tin tài khoản thành công');
                    window.location.href = '/home-page';
                } else if (res.message == 400) {
                    self.error_username = 'Tên đăng nhập đã tồn tại';
                } else {
                    alert('Đã xảy ra lỗi trong quá trình cập nhật');
                }
            });
        }
    },



})