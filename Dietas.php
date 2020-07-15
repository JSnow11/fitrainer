<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarDietas.php");

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

$conexion = crearConexionBD();
$titulo = "Dieta Actual";
$Perfil = $_SESSION["Perfil"];
$dietas = get_dietas($conexion, $Perfil);

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
}
if (!empty($_POST)) { //Se comprueba si hay una dieta seleccionada, si no es asi se muestra la dieta actual
    $id = $_POST["IDDIETA"];
    $dietaActual = get_dieta($conexion, $dietas, $id);
    $titulo = "Dieta Seleccionada";
} else {
    $dietaActual = get_dietaActual($conexion, $dietas);
}

?>

<!DOCTYPE html>
<html>

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

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">
            <h3><?php echo $titulo ?></h3>
            <p>Fecha Inicio: <?php echo $dietaActual["FECHAINICIO"]; ?></p>
            <p>Fecha Fin: <?php echo $dietaActual["FECHAFIN"]; ?></p>
            <p>Descripción:</p>
            <p class="textBox">
                <?php echo $dietaActual["DESCRIPCION"]; ?>
            </p>
        </div>

        <div class="smallContainer">
            <h3>Anteriores</h3>
            <div class="scroll">
                <table>
                    <tr>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Ver</th>
                    </tr>
                    <?php


                    if (isset($dietas)) {
                        foreach ($dietas as $dieta) {
                            if (!($dieta["IDDIETA"] == $dietaActual["IDDIETA"])) { //Se muestran todas las dietas menos la seleccionada
                    ?>
                                <form id="dieta" action="Dietas.php" method="post">
                                    <tr>
                                        <td>
                                            <?php echo $dieta["FECHAINICIO"] ?>
                                        </td>
                                        <td>
                                            <?php echo $dieta["FECHAFIN"] ?>
                                        </td>
                                        <td>
                                            <input type="text" hidden id="IDDIETA" name="IDDIETA" value=<?php echo $dieta["IDDIETA"] ?>>
                                            <button type="submit">Ver</button>
                                        </td>
                                </form>
                    <?php
                            }
                        }
                    }
                    ?>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <?php
    cerrarConexionBD($conexion);
    include_once("footer.php");
    ?>
</body>

</html>