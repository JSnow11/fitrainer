<?php
    session_start();
    require_once("gestionBD.php");
    require_once("gestionarIntroducirCompeticiones.php");

if (isset($_REQUEST["unset"])) unset($_SESSION["formulario"]);

if (!isset($_SESSION["formulario"])) {
    $formulario["fecha"] = "";
    $formulario["nombre"] = "";
    $formulario["lugar"] = "";
    $formulario["tipo"] = "";
    $formulario["alcance"] = "";

    $_SESSION["formulario"] = $formulario;
} else {
    $formulario = $_SESSION["formulario"];
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
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
    <title>Introducir Competiciones</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">

</head>

<body>
    <?php include("headerAdmin.php") ?>

    <h2>Nueva Competición</h2>

    <div class="WhiteBackgroundContainer">
        <div class="container">
            <form action="validacionCompeticiones.php" method="POST">
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
                    echo  $correcto;
                    echo "</div>";
                    unset($correcto);
                }
                ?>
                <div class="row">
                    <label for="nombre" class="col-25">Nombre:</label>
                    <input required value="<?php echo $formulario['nombre']; ?>" type="text" id="nombre" name="nombre" placeholder="Introduce el nombre..." maxlength="100" class="col-75">
                </div>
                <div class="row">
                    <label for="lugar" class="col-25">Lugar:</label>
                    <input required value="<?php echo $formulario['lugar']; ?>" type="text" id="lugar" name="lugar" placeholder="Introduce el lugar..." maxlength="150" class="col-75">
                </div>

                <div class="row">
                    <label for="fecha" class="col-25">Fecha:</label>
                    <input required value="<?php echo $formulario['fecha']; ?>" type="date" id="fecha" name="fecha" class="col-75">
                </div>

                <div class="row">
                    <label for="alcance" class="col-25">Alcance:</label>
                    <select id="alcance" name="alcance" class="col-75">
                        <option label='Regional' value='Regional' <?php if ($formulario['alcance'] == "Regional") echo "selected"; ?>>
                        <option label='Nacional' value='Nacional' <?php if ($formulario['alcance'] == "Nacional") echo "selected"; ?>>
                        <option label='Internacional' value='Internacional' <?php if ($formulario['alcance'] == "Internacional") echo "selected"; ?>>
                    </select>
                </div>
                <div class="row">
                    <label for="tipo" class="col-25">Tipo:</label>
                    <select id="tipo" name="tipo" class="col-75">
                        <option label='Benéfica' value='Benefica' <?php if ($formulario['tipo'] == "Benefica") echo "selected"; ?>>
                        <option label='Federado' value='Federado' <?php if ($formulario['tipo'] == "Federado") echo "selected"; ?>>
                        <option label='Popular' value='Popular' <?php if ($formulario['tipo'] == "Popular") echo "selected"; ?>>
                    </select>
                </div>
                <br>
                <div class="row">
                    <input type="submit" value="Crear">
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