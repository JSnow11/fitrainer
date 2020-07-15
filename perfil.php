<?php
session_start();

require_once("gestionBD.php");
require_once("gestionarUsuarios.php");


if (!isset($_SESSION['login']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

$conexion = crearConexionBD();
unset($_SESSION["formulario"]);

$perfil = getPerfil($conexion, $_SESSION['login']);
$_SESSION["Perfil"] = $perfil;


$ultCompeticiones = getUltimosResultadosEnCompeticiones($conexion, $_SESSION["Perfil"]);
$ultEsfuerzos = getUltimosEsfuerzosEnFeedbacks($conexion, $_SESSION["Perfil"]);

?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <meta name="description" content="Perfil">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">

</head>

<body>
    <?php
    include("header.php"); ?>

    <br><br>
    <div class="WhiteBackgroundContainer">
        <div class="smallContainer">
            <img src="img/profileDefault.png" alt="profile" width="200">
            <p>Nombre: <?php echo $perfil['NOMBRE']; ?></p>
            <p>Apellidos: <?php echo $perfil['APELLIDOS']; ?> </p>
            <p>Teléfono: <?php echo $perfil['TELEFONO']; ?></p>
            <p>Edad: <?php echo $perfil['EDAD']; ?></p>
            <p>Género: <?php if ($perfil['GENERO'] == "M") {
                            echo "Hombre";
                        } else {
                            echo "Mujer";
                        }
                        ?></p>
            <p>Dirección: <?php echo $perfil['DIRECCION']; ?></p>
            <p>Estado Físico: <?php echo $perfil['ESTADOFISICO']; ?></p>
            <p>E-mail: <?php echo $perfil['CORREO']; ?></p>
            <p><a href="registroUsuario.php"><button>Editar</button></a> <a href="eliminarUsuario.php"><button>Eliminar</button></a></p>
        </div>
        <div class="bigContainer">
            <h3>Últimas Competiciones:</h3>
            <ul>
                <?php foreach ($ultCompeticiones as $c) { ?>
                    <li><?php echo $c["NOMBRE"] . "(" . $c["TIPO"] . ")" ?> <img src="img/rightrow.png" alt="rightrow" width="10"> <?php echo $c["POSICION"] . "º:  " . $c["MARCA"] ?></li>
                    <br>
                <?php } ?>
            </ul>
            <h3>Esfuerzo por Microciclos</h3>
            <ul>
                <?php foreach ($ultEsfuerzos as $e) { ?>
                    <li><?php echo $e["FECHAINICIO"] . " - " . $e["FECHAFIN"] ?> <img src="img/rightrow.png" alt="rightrow" width="10"> <?php echo "Esfuerzo: " . $e["ESFUERZO"] ?></li>
                    <br>
                <?php } ?>
            </ul>
        </div>
    </div>

    <script src="js/responsive.js"></script>
    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>

</html>