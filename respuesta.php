<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarConsulta.php");

if (!isset($_SESSION['ADMIN']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formularioDieta"]);
    unset($_SESSION["formularioEntrenamiento"]);
    unset($_SESSION["formularioPagos"]);
}

if (isset($_REQUEST["tipo"])) {
    $consulta["tipo"] = $_REQUEST["tipo"];
    $consulta["idConsulta"] = $_REQUEST["id"];
    $consulta["descripcion"] = $_REQUEST["des"];
    $consulta["fecha"] = $_REQUEST["fecha"];
    $consulta["tema"] = $_REQUEST["tema"];
    $consulta["respuesta"] = $_REQUEST["respuesta"];
    $_SESSION["consulta"] = $consulta;
} else {
    $consulta = $_SESSION["consulta"];
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
}
//Se crea la conexion con la BD
$conexion = crearConexionBD();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer - Respuesta</title>
    <meta name="description" content="respuesta">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
</head>

<body>
    <?php include("headerAdmin.php"); ?>


    <h2>Consulta <?php echo $consulta["fecha"]  ?></h4>
        <?php
        if (isset($errores) && count($errores) > 0) {
            echo "<div class=\"errorBox\">";
            echo "<h4> Errores en el formulario:</h4>";
            foreach ($errores as $error) {
                if (isset($error)) echo $error;
            }
            echo "</div>";
        }
        if (isset($correcto)) {
            echo "<div class=\"correctBox\">";
            echo "<h4> $correcto </h4>";
            echo "</div>";
        }
        ?>
        <div class="WhiteBackgroundContainer">
            <div class="container">
                <p>Tipo: <?php echo $consulta["tipo"];  ?></p>
                <p>Tema: <?php echo $consulta["tema"];  ?></p>
                <p>Consulta:</p>
                <p class="textBox"><?php echo $consulta["descripcion"]; ?></p>
                <form action="validacionRespuesta.php" method="POST">
                    <div class="row">
                        <label for="respuesta" class="col-25">Respuesta:</label>
                        <textarea required id="respuesta" name="respuesta" placeholder="Escriba la respuesta ..." style="height:200px" maxlength="560"><?php if ($consulta["respuesta"] != null) echo $consulta["respuesta"] ?></textarea>
                        <input type="hidden" name="idConsulta" id="idConsulta" value="<?php echo $consulta["idConsulta"] ?>">
                    </div>
                    <br>
                    <div class="row">
                        <input type="submit" value="Aceptar">
                    </div>
                </form>
            </div>
        </div>

</body>

</html>