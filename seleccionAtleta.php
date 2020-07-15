<?php
session_start();
require_once("gestionBD.php");
require_once("paginacion.php");

    unset($_REQUEST);
    unset($_SESSION["formulario"]);
    unset($_SESSION["paginacion"]);
    unset($_SESSION["AtletaSelec"]);
    unset($_SESSION["formularioDieta"]);
    unset($_SESSION["formularioPagos"]);
    unset($_SESSION["Consultas"]);

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
}

if (!isset($_SESSION['ADMIN']))
    Header("Location: login.php");

$conexion = crearConexionBD();


$atletas = "SELECT * 
FROM ATLETAS
ORDER BY idAtleta ASC";

if (isset($_SESSION["paginacion"]))
    $paginacion = $_SESSION["paginacion"];

$pagina_seleccionada = isset($_GET["PAG_NUM"]) ? (int) $_GET["PAG_NUM"] : (isset($paginacion) ? (int) $paginacion["PAG_NUM"] : 1);
$pag_tam = isset($_GET["PAG_TAM"]) ? (int) $_GET["PAG_TAM"] : (isset($paginacion) ? (int) $paginacion["PAG_TAM"] : 5);

if ($pagina_seleccionada < 1) $pagina_seleccionada = 1;
if ($pag_tam < 1) $pag_tam = 5;

// Antes de seguir, borramos las variables de sección para no confundirnos más adelante
unset($_SESSION["paginacion"]);

$conexion = crearConexionBD();

$total_registros = total_consulta($conexion, $atletas);
$total_paginas = (int) ($total_registros / $pag_tam);

if ($total_registros % $pag_tam > 0) $total_paginas++;
if ($pagina_seleccionada > $total_paginas) $pagina_seleccionada = $total_paginas;

if ($total_registros < 5) $pag_tam = $total_registros;

// Generamos los valores de sesión para página e intervalo para volver a ella después de una operación
$paginacion["PAG_NUM"] = $pagina_seleccionada;
$paginacion["PAG_TAM"] = $pag_tam;
$_SESSION["paginacion"] = $paginacion;

$filas = consulta_paginada($conexion, $atletas, $pagina_seleccionada, $pag_tam);

?>


<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <title>FiTrainer - Selección de atleta</title>
    <meta name="description" content="seleccionAtleta">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
</head>

<body>
    <?php include("headerAdmin.php"); ?>

    <h2>Atletas</h2>
    <div class="WhiteBackgroundContainer">
        <div class="container">
            <div class="scroll">
                <form method="get" action="seleccionAtleta.php">
                    <input id="PAG_NUM" name="PAG_NUM" type="hidden" value="<?php echo $pagina_seleccionada ?>" />
                    Mostrando
                    <input id="PAG_TAM" name="PAG_TAM" type="number" min="1" max="<?php echo $total_registros; ?>" value="<?php echo $pag_tam ?>" autofocus="autofocus" />
                    entradas de <?php echo $total_registros ?>
                    <input type="submit" value="Cambiar">
                </form>
                <table>
                    <tr>
                        <th>id</th>
                        <th>
                            Nombre
                        </th>
                        <th>
                            Apellidos
                        </th>
                        <th>Seleccionar</th>
                    </tr>
                    <?php foreach ($filas as $fila) { ?>
                        <tr>
                            <td>
                                <?php echo $fila["IDATLETA"] ?>
                            </td>
                            <td>
                                <?php echo $fila["NOMBRE"] ?>
                            </td>
                            <td>
                                <?php echo $fila["APELLIDOS"] ?>
                            </td>
                            <td>
                                <a href="insertar.php?id=<?php echo $fila["IDATLETA"] ?>&nombre=<?php echo $fila["NOMBRE"] ?>&apellidos=<?php echo $fila["APELLIDOS"] ?>&estadoFisico=<?php echo $fila["ESTADOFISICO"] ?>"><button>Seleccionar</button></a>
                            </td>
                        </tr>
                    <?php } ?>
                </table>
                <div style="float:right">
                    <?php
                    for ($pagina = 1; $pagina <= $total_paginas; $pagina++)
                        if ($pagina == $pagina_seleccionada) { ?>
                        <span class="current"><?php echo $pagina; ?></span>
                    <?php } else { ?>
                        <a href="seleccionAtleta.php?PAG_NUM=<?php echo $pagina; ?>&PAG_TAM=<?php echo $pag_tam; ?>"><?php echo $pagina; ?></a>
                    <?php } ?>
                </div>
            </div>
        </div>
    </div>
    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>