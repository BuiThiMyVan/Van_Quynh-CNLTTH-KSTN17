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
                self.error_username = 'B?n c?n ?i?n t?n ??ng nh?p';
            } else {
                self.error_username = '';
            }
        },

        password: function () {
            var self = this;
            if (self.password == '') {
                self.error_password = 'B?n c?n nh?p m?t kh?u';
            } else {
                self.error_password = '';
            }
        },

        confirm_pass: function () {
            var self = this;
            if (self.confirm_pass !== self.password) {
                self.error_confirm_pass = 'M?t kh?u nh?p l?i kh?ng kh?p';
            } else {
                self.error_confirm_pass = '';
            }
        },

        hoten: function () {
            var self = this;
            if (self.hoten == '') {
                self.error_hoten = 'B?n c?n nh?p h? t?n';
            } else {
                self.error_hoten = '';
            }
        },

        sdt: function () {
            var self = this;
            var regex = /((09|03|07|08|05)+([0-9]{8})\b)/g;
            
            if (self.sdt == '') {
                self.error_sdt = 'B?n c?n nh?p s? ?i?n tho?i';
            } else {
                if (regex.test(self.sdt) == true) {
                    self.error_sdt = '';
                } else {
                    self.error_sdt = 'B?n c?n nh?p ??ng ??nh d?ng s? ?i?n tho?i';
                }
            }
        },

        remember: function () {
            var self = this;
            if (!self.remember) {
                self.error_remember = 'Ch?a x?c nh?n ?i?u kho?n';
            } else {
                self.error_remember = '';
            }
        }
    },

    methods: {
        register: function () {
            var self = this;

            if (self.username == '') {
                self.error_username = 'B?n c?n ?i?n t?n ??ng nh?p';
            }

            if (self.password == '') {
                self.error_password = 'B?n c?n nh?p m?t kh?u';
            }

            if (self.confirm_pass !== self.password) {
                self.error_confirm_pass = 'M?t kh?u nh?p l?i kh?ng kh?p';
            }

            if (self.hoten == '') {
                self.error_hoten = 'B?n c?n nh?p h? t?n';
            }

            if (self.sdt == '') {
                self.error_sdt = 'B?n c?n nh?p s? ?i?n tho?i';
            }

            if (self.remember == false) {
                self.error_remember = 'Ch?a x?c nh?n ?i?u kho?n';
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
                url: "/api/CustommerAPI/addKH",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                console.log(res);
                if (res.message == 200) {
                    alert('??ng k? t?i kho?n th?nh c?ng');
                    window.location.href = '/home-page';
                } else if (res.message == 400) {
                    self.error_username = 'T?n ??ng nh?p ?? t?n t?i';                    
                } else {
                    alert('?? x?y ra l?i trong qu? tr?nh ??ng k?');
                }
            });
        }
    },



})