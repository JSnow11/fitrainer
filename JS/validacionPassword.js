function validateForm() {
    var noValidation = document.getElementById("altaUsuario").novalidate;

    if (!noValidation) {
        var error1 = passwordValidation();
        var error2 = passwordConfirmation();

        return (error1.length == 0) && (error2.length == 0);
    } else
        return true;
}

function passwordValidation() {
    var password = document.getElementById("pass");
    var pwd = password.value;
    var valid = true;

    valid = valid && (pwd.length >= 8);

    var hasNumber = /\d/;
    var hasUpperCases = /[A-Z]/;
    var hasLowerCases = /[a-z]/;

    valid = valid && (hasNumber.test(pwd)) && (hasUpperCases.test(pwd)) && (hasLowerCases.test(pwd));

    if (!valid) {
        var error = "La contraseña debe contener minúsculas, mayúsculas, cifras y longitud >= 8";
    } else {
        var error = "";
    }
    password.setCustomValidity(error);
    return error;
}

function passwordConfirmation() {
    var password = document.getElementById("pass");
    var pwd = password.value;

    var passconfirm = document.getElementById("confirmpass");
    var confirmation = passconfirm.value;

    if (pwd != confirmation) {
        var error = "Las contraseñas deben coincidir";
    } else {
        var error = "";
    }

    passconfirm.setCustomValidity(error);

    return error;
}

function passwordStrength(password) {
    var letters = {};

    var length = password.length;
    for (x = 0, length; x < length; x++) {
        var l = password.charAt(x);
        letters[l] = (isNaN(letters[l]) ? 1 : letters[l] + 1);
    }

    return Object.keys(letters).length / length;
}

function passwordColor() {
    var passField = document.getElementById("pass");
    var strength = passwordStrength(passField.value);

    if (!isNaN(strength)) {
        var type = "red";
        if (passwordValidation() != "") {
            type = "#ffe6e6";
        } else if (strength > 0.7) {
            type = "#ffeecc";
        } else if (strength > 0.4) {
            type = "#e6ffe6";
        }
    } else {
        type = "nanpass";
    }

    passField.style.backgroundColor = type;
    return type;
}