var vmLogin = new Vue({
    el: "#Login",
    data: {
        username: '',
        password: '',
        error_username: '',
        error_password: '',
        error_login: ''
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
            var bug = 0;
            if (self.username == '') {
                self.error_username = "Bạn cần nhập tên đăng nhập";
                bug++;
            }

            if (self.password == '') {
                self.error_password = 'Bạn cần nhập mật khẩu';
                bug++;
            }

            if (bug != 0) {
                return false;
            }
            else {
                var account = {
                    UserName: self.username,
                    Pass: self.password
                };

                $.ajax({
                    data: account,
                    url: "/Account/CheckLogin",
                    type: 'POST',
                    dataType: 'json',
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8"
                }).then(res => {
                    console.log(res);
                    switch (res.result) {
                        case 1:
                            if (idPhim != 0) {
                                window.location.href = "/Home/DetailsFilm/" + idPhim;
                            } else {
                                window.location.href = "/Home/Index";
                            }
                            
                            break;
                        case 2:
                            self.error_login = "Tài khoản không tồn tại";
                            break;
                        case 3:
                            self.error_login = "Mật khẩu nhập không chính xác";
                            break;
                        case 4:
                            window.location.href = "/Admin/Home/Dashboard";
                            break;
                    }
                });
            }
        }
    }
})