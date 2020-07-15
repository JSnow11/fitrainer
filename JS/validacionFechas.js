function validateForm() {
    var noValidation = document.getElementById("fDietas").novalidate;

    if (!noValidation) {
        var error1 = startAndEnd();
        return (error1.length == 0);
    } else
        return true;
}

function startAndEnd() {
    var start = document.getElementById("FechaDieta");
    var end = document.getElementById("FechaFinDieta");

    if (start.value > end.value) {
        var error = "La fecha final debe ser posterior a la inicial.";
    } else {
        var error = "";
    }
    end.setCustomValidity(error);
    return error;
}