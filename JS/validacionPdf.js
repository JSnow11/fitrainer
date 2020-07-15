$(document).ready(function() {
    $('input[type="file"]').on('change', function() {
        var label = document.getElementById("filelabel");
        var file = document.getElementById("file");
        if (!document.getElementById("form").novalidate) {
            var val = $(this).val()
            var ext = val.split('.').pop();
            if ($(this).val() != '') {
                if (!(ext == "pdf")) {
                    label.style.backgroundColor = "#ffd6cc";
                    file.setCustomValidity("Extensión no permitida: " + ext);
                } else {
                    file.setCustomValidity("");
                    label.style.backgroundColor = "#ccffdd";
                }
            }
        }
    });
});