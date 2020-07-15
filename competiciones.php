<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarCompeticiones.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
    unset($error);
}

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

$conexion = crearConexionBD();
$perfil = $_SESSION["Perfil"];
$competiciones = getCompeticiones($conexion);
unset($error);

if (isset($_REQUEST["asistencia"])) {
    if (isset($_REQUEST["prueba"]) && ($_REQUEST["prueba"] == "" || strlen($_REQUEST["prueba"]) > 25)) {
        $_SESSION["error"] = "La prueba es demasiado larga o está vacía";
        unset($_REQUEST["asistencia"]);
        Header("Location competiciones.php");
    } else {
        $asistencia = $_REQUEST["asistencia"];
        unset($_SESSION["error"]);
        unset($_REQUEST["asistencia"]);
        if ($asistencia == "Asisto") participar($conexion, $_REQUEST["id"], $perfil["IDATLETA"], $_REQUEST["prueba"]);
        if ($asistencia == "No asisto") noParticipar($conexion, $_REQUEST["id"], $perfil["IDATLETA"]);
        Header("Location: competiciones.php");
    }
}

if (isset($_SESSION["error"])) {
    $error = $_SESSION["error"];
    unset($_SESSION["error"]);
}
if (isset($_SESSION["PDOException"])) {
    $error = "No se ha podido acceder a la base de datos";
    unset($_SESSION["PDOException"]);
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer - Competiciones</title>
    <meta name="description" content="competiciones">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/asistentes.js"></script>
</head>

<body>
    <?php
    include("header.php");
    ?>

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">

            <h3>Próximas Competiciones</h3>
            <div class="scroll">

                <?php foreach ($competiciones as $c) { ?>
                    <hr>
                    <form action="competiciones.php" method="POST">
                        <p>Nombre: <?php echo $c["NOMBRE"] ?> </p>
                        <p>Lugar: <?php echo $c["LUGAR"] ?></p>
                        <p>Fecha: <?php echo $c["FECHA"] ?></p>
                        <p>Alcance: <?php echo $c["ALCANCE"] ?></p>
                        <p>Tipo: <?php echo $c["TIPO"] ?></p>
                        <?php $asistencia = getAsistencia($conexion, $perfil["IDATLETA"], $c["IDCOMPETICION"]); ?>
                        <label for="prueba">Prueba en la que participa: </label>
                        <input required <?php if ($asistencia != null) echo "disabled" ?> maxlength="25" type="text" id=prueba name="prueba" value="<?php echo $asistencia["PRUEBA"] ?>"><br>
                        <input type="radio" id="a . <?php echo $c["IDCOMPETICION"] ?>" name="asistencia" value="Asisto" <?php if ($asistencia != null) echo "checked" ?>>
                        <label for="a . <?php echo $c["IDCOMPETICION"] ?>">Asisto</label><br>
                        <input type="radio" id="n . <?php echo $c["IDCOMPETICION"] ?>" name="asistencia" value="No asisto" <?php if ($asistencia == null) echo "checked" ?>>
                        <label for="n . <?php echo $c["IDCOMPETICION"] ?>">No asisto</label><br>
                        <input type="submit" value="Actualizar">
                        <button data-id="<?php echo $c["IDCOMPETICION"] ?>" data-table="competiciones" id="butt" class="fRight">Asistentes</button>
                        <input type="text" name="id" hidden value="<?php echo $c["IDCOMPETICION"] ?>">
                    </form>
                    <br><br>
                <?php } ?>

            </div>
        </div>
        <div class="smallContainer">
            <h3>Asistentes</h3>
            <div id="asistentes" class="scroll">
                <?php
                if (isset($error)) {
                    echo "<div class=\"errorBox\">";
                    echo "<h4>Errores en el formulario:</h4>";
                    echo "<p>" . $error . "</p>";
                    echo "</div>";
                }
                ?>
            </div>
        </div>
    </div>
    <?php
        include_once("footer.php");
        cerrarConexionBD($conexion);
    ?>
</body>

</html>