loadData(){
    $ajax({
        url:"https://localhost:44382/api/Movie/Phim",
        method:"GET",
        data:"",
        contentType:"application/json",
        dataType:""
    }).done(function (response){

    }).fail(function(response){

    })
}