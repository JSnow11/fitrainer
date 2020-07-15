<?php

session_start();
require_once("gestionBD.php");
require_once("gestionarReuniones.php");
if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

$conexion = crearConexionBD();
$perfil = $_SESSION["Perfil"];
$reuniones = getReuniones($conexion);

if (isset($_REQUEST["asistencia"])) {
    $asistencia = $_REQUEST["asistencia"];
    if ($asistencia == "Asisto") participar($conexion, $_REQUEST["id"], $perfil["IDATLETA"]);
    if ($asistencia == "No asisto") noParticipar($conexion, $_REQUEST["id"], $perfil["IDATLETA"]);
    unset($_REQUEST["asistencia"]);
    Header("Location: reuniones.php");
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <meta name="description" content="Perfil">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/asistentes.js"></script>
</head>

<body>
    <?php include("header.php"); ?>

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">
            <h3>Próximas Reuniones</h3>
            <div class="scroll">
                <?php foreach ($reuniones as $r) { ?>
                    <hr>
                    <form action="reuniones.php" method="POST" D>
                        <p>Lugar: <?php echo $r["LUGAR"]; ?></p>
                        <p>Fecha: <?php echo $r["FECHA"]; ?></p>
                        <p>Duracion: <?php echo $r["DURACION"]; ?></p>
                        <?php $asistencia = getAsistencia($conexion, $r["IDREUNION"], $perfil["IDATLETA"]); ?>
                        <input type="radio" id="a . <?php echo $r["IDREUNION"] ?>" name="asistencia" value="Asisto" <?php if ($asistencia != null) echo "checked" ?>>
                        <label for="a . <?php echo $r["IDREUNION"] ?>">Asisto</label><br>
                        <input type="radio" id="n . <?php echo $r["IDREUNION"] ?>" name="asistencia" value="No asisto" <?php if ($asistencia == null) echo "checked" ?>>
                        <label for="n . <?php echo $r["IDREUNION"] ?>">No asisto</label><br>
                        <input type="submit" value="Actualizar">
                        <button data-id="<?php echo $r["IDREUNION"] ?>" data-table="reuniones" id="butt" class="fRight">Asistentes</button>
                        <input type="text" name="id" hidden value="<?php echo $r["IDREUNION"] ?>">
                    </form><br><br>

                <?php } ?>
            </div>
        </div>
        <div class="smallContainer">
            <h3>Asistentes</h3>
            <div id="asistentes" class="scroll">

            </div>
        </div>
    </div>

    <?php include("footer.php"); ?>
</body>

</html>