<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarEjercicios.php");

if(isset($_REQUEST["unset"])) unset($_SESSION["formulario"]);

if (!isset($_SESSION["formulario"])) {
    $formulario["titulo"] = "";
    $formulario["descripcion"] = "";
    $formulario["tipo"] = "";

    $_SESSION["formulario"] = $formulario;
} else {
    $formulario = $_SESSION["formulario"];
}

if(isset($_SESSION["errores"])){
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
}elseif(isset($_SESSION["correcto"])){
    $correcto =$_SESSION["correcto"];
    unset($_SESSION["correcto"]);
}
//Se crea la conexion con la BD
$conexion = crearConexionBD();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Introducir Ejercicios</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">

</head>

<body>
    <?php
    $_SESSION["ac"] = "iEjercicios";
    include("headerAdmin.php"); ?>

    <h2>Nuevo Ejercicio</h2>

    <?php

    if (isset($errores) && count($errores) > 0) {
        echo "<div class=\"errorBox\">";
        echo "<h4> Errores en el formulario:</h4>";
        foreach ($errores as $error) {
            if (isset($error)) echo $error;
        }
        echo "</div>";
        unset($errores);
    }
    if (isset($correcto)) {
        echo "<div class=\"correctBox\">";
        echo   $correcto;

        echo "</div>";
        unset($correcto);
    }
    ?>

    <div class="WhiteBackgroundContainer">
        <div class="container">
            <form action="validacionEjercicio.php" method="POST">
                <div class="row">
                    <label for="titulo" class="col-25">Título:</label>
                    <input class="col-75" required type="text" id="titulo" name="titulo" placeholder="Introduce un título..." maxlength="30" value="<?php echo $formulario['titulo']; ?>">
                </div>
                <div class="row">
                    <label class="col-25" for="tipo">Tipo:</label>
                    <input value="<?php echo $formulario['tipo']; ?>" class="col-75" required type="text" id="tipo" name="tipo" placeholder="Tipo de ejercicio..." maxlength="40">
                </div>
                <div class="row">
                    <label for="descripcion" class="col-25">Descripción:</label>
                    <textarea value="<?php echo $formulario['descripcion']; ?>" class="col-75" required id="descripcion" name="descripcion" placeholder="Describe el ejercicio..." style="height:200px" maxlength="500"></textarea>
                </div>
                <br>
                <div class="row">
                    <input type="submit" value="Crear">
                </div>
            </form>
        </div>
    </div>
    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>

</html>