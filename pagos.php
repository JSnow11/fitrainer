<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarPagos.php");

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

$conexion = crearConexionBD();
$ultPagos = getUltimosPagos($conexion, $_SESSION["Perfil"]);

if (!empty($_POST)) {
    $pagoEncontrado = null;
    if ($_POST["FECHA"] == "0000-00-00") {
        $pagoEncontrado["ERROR"] = "<p>La fecha no puede estar vacía</p>";
    } else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/", $_POST["FECHA"]))
        $pagoEncontrado["ERROR"] = "<p>La fecha debe cumplir su formato</p>";
    else {
        $fecha = new DateTime($_POST["FECHA"]);
        $pagoEncontrado = buscarPago($conexion,  $_SESSION["Perfil"], $fecha->format('d/m/Y'));
        if (empty($pagoEncontrado)) $pagoEncontrado["ERROR"] = "No hay ningún pago que coincida con la fecha indicada: " . $fecha->format('d/m/Y');
    }
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
</head>

<body>
    <?php
    include("header.php");
    ?>

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">
            <h3>Últimos Pagos</h3>
            <div class=scroll>
                <table>
                    <tr>
                        <th>
                            Fecha
                        </th>
                        <th>
                            Archivo
                        </th>
                    </tr>
                    <?php foreach ($ultPagos as $p) { ?>
                        <tr>
                            <td>
                                Fecha <?php echo $p["FECHA"] ?>
                            </td>
                            <td>
                                Archivo <a href="<?php echo $p["RUTAFICHERO"] ?>"><?php echo $p["RUTAFICHERO"] ?></a>
                            </td>
                        </tr>
                    <?php } ?>
                </table>

            </div>
        </div>
        <div class=smallContainer>
            <h3>Buscar pagos</h3>
            <form method="POST" action="pagos.php">
                <div class="row">
                    <label for="FECHA" class="col-25">Fecha:</label>
                    <input type="date" class="col-75" id="FECHA" name="FECHA" placeholder="dd/mm/yyyy">
                </div>
                <br>
                <div class="row">
                    <input type="submit" value="Buscar">
                </div>
            </form>
            <?php if (isset($pagoEncontrado["RUTAFICHERO"])) { ?>
                <h3>Resultado de la Búsqueda</h3>
                Archivo: <a href="<?php echo $pagoEncontrado["RUTAFICHERO"] ?>"> <?php echo $pagoEncontrado["RUTAFICHERO"] ?></a>
            <?php
            } elseif (isset($pagoEncontrado["ERROR"])) {
            ?>
                <h3>Resultado de la Búsqueda</h3>
                <?php echo $pagoEncontrado["ERROR"] ?></a>
            <?php
            }
            ?>

        </div>

    </div>

    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>

</html>