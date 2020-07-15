$(document).ready(function() {
    console.log("Document ready");

    $("button").click(function(e) {
        e.preventDefault();
        console.log("Butt clicked");
        var id = $(this).data('id');
        var table = $(this).data('table');
        $.get("asistencias.php", { id: id, table: table }, function(data) {
            console.log(data);
            $("#asistentes").empty();
            $("#asistentes").append(data);
        });
        console.log("Atletas cargados");
    });
});