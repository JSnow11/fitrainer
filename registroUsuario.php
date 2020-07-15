<?php
session_start();
require_once("gestionBD.php");
$conexion = crearConexionBD();

if (!isset($_SESSION['login'])) {
    if (!isset($_SESSION["formulario"])) {
        $formulario["nombre"] = "";
        $formulario["apellidos"] = "";
        $formulario["edad"] = "";
        $formulario["genero"] = "M";
        $formulario["telefono"] = "";
        $formulario["direccion"] = "";
        $formulario["estadoFisico"] = "";
        $formulario["email"] = "";
        $formulario["pass"] = "";
        $formulario["confirmpass"] = "";

        $_SESSION["formulario"] = $formulario;
    } else {
        $formulario = $_SESSION["formulario"];
    }
} else {
    $perfil = $_SESSION["Perfil"];

    if (!isset($_SESSION["formulario"])) {
        $formulario["nombre"] = $perfil['NOMBRE'];
        $formulario["apellidos"] = $perfil['APELLIDOS'];
        $formulario["edad"] = $perfil['EDAD'];
        $formulario["genero"] = $perfil['GENERO'];
        $formulario["telefono"] = $perfil['TELEFONO'];
        $formulario["direccion"] = $perfil['DIRECCION'];
        $formulario["estadoFisico"] = $perfil['ESTADOFISICO'];
        $formulario["email"] = $perfil['CORREO'];
        $formulario["pass"] = $perfil['CONTRASENNA'];
        $formulario["confirmpass"] = "";

        $_SESSION["formulario"] = $formulario;
    } else {
        $formulario = $_SESSION["formulario"];
    }

    if (isset($_SESSION["errores"])) {
        $errores = $_SESSION["errores"];
        unset($_SESSION["errores"]);
    }
}


?>


<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/validacionPassword.js"></script>
    <script>
    $(document).ready(function() {
			$("#altaUsuario").on("submit", function() {
				return validateForm();
            });
            $("#pass").on("keyup", function() {
				passwordColor();
			});
    });
    </script>
</head>

<body>
    <header>
        <nav class="topnav">
            <img src="img/logoFT cuadrado.png" alt="logo" width="48" logo>
            <a href="login.php">FiTrainer</a>
            <a href="login.php" class="floatRight"><img src="img/power.png" alt="off" width="20"></a>
        </nav>
    </header>


    <h2>Registro</h2>
    <div class="WhiteBackgroundContainer">

        <div class="container">

            <div class="scroll">
                <?php

                if (isset($errores) && count($errores) > 0) {
                    echo "<div class=\"errorBox\">";
                    echo "<h4> Errores en el formulario:</h4>";
                    foreach ($errores as $error) {
                        if (isset($error)) echo $error;
                    }
                    echo "</div>";
                }
                ?>
                <form id="altaUsuario" action="validacionUsuario.php" method="get">
                    <div class="row">
                        <label for="nombre" class="col-25">Nombre:</label>
                        <input class="col-75" required type="text" id="nombre" name="nombre" placeholder="Introduzca su nombre" maxlength="20" value="<?php echo $formulario['nombre']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="apellidos">Apellidos:</label>
                        <input class="col-75" required type="text" id="apellidos" name="apellidos" placeholder="Introduzca sus apellidos" maxlength="50" value="<?php echo $formulario['apellidos']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="edad">Edad:</label>
                        <input class="col-75" required type="text" id="edad" name="edad" placeholder="Introduzca su edad" maxlength="2" value="<?php echo $formulario['edad']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="genero">Género:</label>
                        <div class="col-75">
                            <input name="genero" id="Male" type="radio" value="M" <?php if ($formulario['genero'] == 'M') echo 'checked'; ?>><label class="pickOp" for="Male">Hombre</label>
                            <input name="genero" id="Female" type="radio" value="F" <?php if ($formulario['genero'] == 'F') echo 'checked'; ?>><label class="pickOp" for="Female">Mujer</label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-25" for="telefono">Teléfono:</label>
                        <input class="col-75" required type="text" id="telefono" name="telefono" placeholder="123456789" pattern="^[0-9]{9}" maxlength="9" value="<?php echo $formulario['telefono']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="direccion">Dirección:</label>
                        <input class="col-75" required type="text" id="direccion" name="direccion" placeholder="Calle/Avda, Número, Ciudad" maxlength="50" value="<?php echo $formulario['direccion']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="estadoFisico">Estado Físico:</label>
                        <select required id="estadoFisico" name="estadoFisico" class="col-75">
                            <option value="Alto rendimiento" <?php if ($formulario['estadoFisico'] == 'Alto rendimiento') echo ' selected '; ?>>Alto Rendimiento</option>
                            <option value="Buena forma" <?php if ($formulario['estadoFisico'] == 'Buena forma') echo ' selected '; ?>>Buena forma</option>
                            <option value="Baja forma" <?php if ($formulario['estadoFisico'] == 'Baja forma') echo ' selected '; ?>>Baja forma</option>
                            <option value="Lesionado" <?php if ($formulario['estadoFisico'] == 'Lesionado') echo ' selected '; ?>>Lesionado</option>
                        </select>
                    </div>
                    <div class="row">
                        <label class="col-25" for="email">E-mail:</label>
                        <input class="col-75" required type="email" id="email" name="email" placeholder="usuario@dominio.extension" maxlength="50" value="<?php echo $formulario['email']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="pass">Contraseña:</label>
                        <input class="col-75" required type="password" id="pass" name="pass" placeholder="Introduzca una contraseña" maxlength="40" value="<?php echo $formulario['pass']; ?>">
                    </div>
                    <div class="row">
                        <label class="col-25" for="confirmpass">Confirmar contraseña:</label>
                        <input class="col-75" required type="password" id="confirmpass" name="confirmpass" placeholder="Repita la contraseña" maxlength="40" value="<?php echo $formulario['pass']; ?>">
                    </div>

                    <br>
                    <div class="row">
                        <input type="submit" value="Enviar">
                    </div>
                </form>
            </div>
        </div>
    </div>



    <?php
    cerrarConexionBD($conexion);
    include_once("footer.php");
    ?>


</body>

</html>