<?php
session_start();

include_once("gestionBD.php");
include_once("gestionarUsuarios.php");

unset($_SESSION["formulario"]);

if (isset($_SESSION["Perfil"])) {
    Header("Location: perfil.php");
}

if (isset($_SESSION["ADMIN"])){
    Header("Location: seleccionAtleta.php?unset=true");
}

if (isset($_POST['submit'])) {
    $email = $_POST['email'];
    $pass = $_POST['pass'];

    if($email == "admin@admin.com" && $pass == "admin"){
        $_SESSION["ADMIN"] = true;
        Header("Location: seleccionAtleta.php?unset=true");
    }

    $conexion = crearConexionBD();
    $num_usuarios = consultarUsuario($conexion, $email, $pass);
    cerrarConexionBD($conexion);
    if ($num_usuarios == 0)
        $login = "error";
    else {
        $_SESSION['login'] = $email;
        Header("Location: perfil.php");
    }
}

?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <meta name="description" content="Inicio de sesión">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
</head>

<body style="background-color: #77BAE8;">
    <header>
    </header>

    <!-- Formulario HTML -->
    <div class="BlueBackground">
        <div class="loginContainer">
            <img src="img/logoFT-blancoTransparente.png" alt="LogoFiTrainer" width="200">
            <br><br><br><br><br>
            <form action="login.php" method="post">
                <h4>E-MAIL</h4>
                <input type="email" name="email" id="email">
                <h4>PASSWORD</h4>
                <input type="password" name="pass" id="pass">
                <br><br>
                <input type="submit" name="submit" value="Log-IN">
                <br>
                <a href="registroUsuario.php">¡Registrate!</a>
            </form>
        </div>
        <?php
        if (isset($login)) {
            echo "<p>Error en la contraseña o no existe el usuario.</p>";
        }
        if (isset($_SESSION["registrado"])) {
            echo "<p>" . $_SESSION["registrado"] . "</p>";
            unset($_SESSION["registrado"]);
        }
        ?>
    </div>
    <?php
    include("footer.php");
    ?>
</body>

</html>