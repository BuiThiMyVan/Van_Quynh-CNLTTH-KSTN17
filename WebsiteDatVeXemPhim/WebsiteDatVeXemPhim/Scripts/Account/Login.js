var vmLogin = new Vue({
    el: "#Login",
    data: {
        username: '',
        password: '',
        error_username: '',
        error_password: ''
    },
    watch: {
        username: function () {
            var self = this;
            if (self.username == '') {
                self.error_username = "Bạn cần nhập tên đăng nhập";
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
        }
    },

    methods: {
        login: function () {
            var self = this;
            if (self.error_username !== '' || self.error_username !== '') {
                return false;
            }
            else {
                var account = {
                    UserName: self.username,
                    Pass: self.password
                };
                console.log(account);

                $.ajax({
                    data: account,
                    url: "/Account/CheckLogin",
                    type: 'POST',
                    dataType: 'json',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8"
                }).then(res => {
                    //console.log(res);
                    switch (res) {
                        case 1:
                            window.location.href = "/Home/Index";
                            break;
                        case 2:
                            error_login.innerText = "Tài khoản không tồn tại";
                            $("#error-login").show();
                            break;
                        case 3:
                            error_login.innerText = "Mật khẩu nhập không chính xác";
                            $("#error-login").show();
                            break;
                    }
                });
            }
        }
    }
})