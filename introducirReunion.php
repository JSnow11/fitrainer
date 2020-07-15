<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarIntroducirReuniones.php");

if (isset($_REQUEST["unset"])) unset($_SESSION["formulario"]);

if (!isset($_SESSION["formulario"])) {
    $formulario["fecha"] = "";
    $formulario["duracion"] = "";
    $formulario["lugar"] = "";

    $_SESSION["formulario"] = $formulario;
} else {
    $formulario = $_SESSION["formulario"];
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
    unset($_SESSION["correcto"]);
} elseif (isset($_SESSION["correcto"])) {
    $correcto = $_SESSION["correcto"];
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
    <title>Introducir Reuniones</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
</head>

<body>
    <?php include("headerAdmin.php") ?>

    <h2>Nueva Reunión</h2>
    <div class="WhiteBackgroundContainer">
        <div class="container">
            <form action="validacionReuniones.php" method="POST">
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
                    echo  $correcto;

                    echo "</div>";
                }
                ?>
                <div>
                    <div class="row">
                        <label for="duracion" class="col-25">Duración:</label>
                        <input required value="<?php echo $formulario['duracion']; ?>" type="text" id="duracion" name="duracion" placeholder="Introduce la duración: 00:00" pattern="[0-6][0-9]:[0-6][0-9]" maxlength="25" class="col-75">
                    </div>
                    <div class="row">
                        <label for="lugar" class="col-25">Lugar:</label>
                        <input required value="<?php echo $formulario['lugar']; ?>" type="text" id="lugar" name="lugar" placeholder="Introduce el lugar..." maxlength="80" class="col-75">
                    </div>
                    <div class="row">
                        <label for="fecha" class="col-25">Fecha:</label>
                        <input required value="<?php echo $formulario['fecha']; ?>" type="date" id="fecha" name="fecha" placeholder="Seleccione una fecha" class="col-75">
                    </div>
                    <br>
                    <div class="row">
                        <input type="submit" value="crear">
                    </div>
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