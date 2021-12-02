function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if (charCode == 13) {
        lstStudent.getList();
    } else if ((charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}