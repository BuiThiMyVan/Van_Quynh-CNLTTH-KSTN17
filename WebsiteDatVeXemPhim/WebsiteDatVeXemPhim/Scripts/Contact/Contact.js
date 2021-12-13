var vmCreateFeedback = new Vue({
    el: "#CreateFeedback",
    data: {
        Name: '',
        Phone: '',
        Email: '',
        Address: '',
        Content: '',

        err_Name: '',
        err_Phone: '',
        err_Content: ''
    },

    watch: {
        Name: function () {
            var self = this;
            if (self.Name == '') {
                self.err_Name = 'Bạn cần điền họ tên';
            } else {
                self.err_Name = '';
            }
        },
        Phone: function () {
            var self = this;
            var regex = /((09|03|07|08|05)+([0-9]{8})\b)/g;

            if (self.Phone == '') {
                self.err_Phone = 'Bạn cần nhập số điện thoại';
            } else {
                if (regex.test(self.Phone) != true) {
                    self.err_Phone = 'Bạn cần nhập đúng định dạng số điện thoại';
                } else {
                    self.err_Phone = '';
                }
            }
        },
        Content: function () {
            var self = this;
            if (self.Name == '') {
                self.err_Content = 'Bạn cần điền phản hồi';
            } else {
                self.err_Content = '';
            }
        },

    },

    methods: {
        createFeedback: function () {
            var self = this;
            var bug = 0;

            if (self.Name == '') {
                self.err_Name = 'Bạn cần điền họ tên';
                bug++;
            }

            if (self.Phone == '') {
                self.err_Phone = 'Bạn cần nhập số điện thoại';
                bug++;
            }

            if (self.err_Phone != '') {
                bug++;
            }

            if (self.Name == '') {
                self.err_Content = 'Bạn cần điền phản hồi';
                bug++;
            }

            if (bug != 0) {
                return false;
            }

            var modal = {
                Name: self.Name,
                Phone: self.Phone,
                Email: self.Email,
                Address: self.Address,
                Content: self.Content
            }

            $.ajax({
                data: modal,
                url: "/api/FeedbackApi/addPhanHoi",
                type: 'POST',
                dataType: 'json',
                contentType: "application/x-www-form-urlencoded; charset=UTF-8"
            }).then(res => {
                if (res == 200) {
                    alert("Gửi phản hồi thành công");
                } else {
                    alert("Đã xảy ra lỗi trong quá trình gửi phản hồi");
                }
            });
        }
    }

})