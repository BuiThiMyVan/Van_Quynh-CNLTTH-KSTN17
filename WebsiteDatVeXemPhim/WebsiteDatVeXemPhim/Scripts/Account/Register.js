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
        register: function () {
            var self = this;
            var bug = 0;

            if (self.username == '') {
                self.error_username = 'Bạn cần điền tên đăng nhập';
                bug++;
            }

            if (self.password == '') {
                self.error_password = 'Bạn cần nhập mật khẩu';
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

            if (self.remember == false) {
                self.error_remember = 'Chưa xác nhận điều khoản';
                bug++;
            }

            if (bug != 0) {
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
                url: "/api/CustommerAPI/addKH",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                if (res.message == 200) {
                    alert('Đăng ký tài khoản thành công');
                    window.location.href = '/home-page';
                } else if (res.message == 400) {
                    self.error_username = 'Tên đăng nhập đã tồn tại';                    
                } else {
                    alert('Đã xảy ra lỗi trong quá trình đăng ký');
                }
            });
        }
    },



})