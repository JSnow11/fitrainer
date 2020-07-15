<?php
session_start();

require_once("gestionBD.php");
require_once("gestionarPruebas.php");
require_once("paginacion.php");

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

if (!isset($_SESSION["formulario"])) {
    $formulario["tipo"] = "";
    $formulario["tema"] = "";
    $formulario["descipcion"] = "";

    $_SESSION["formulario"] = $formulario;
} else if (isset($_SESSION["formulario"]) && !isset($_SESSION["formulario"]["tipo"])) {
    unset($_SESSION["formulario"]);
} else {
    $formulario = $_SESSION["formulario"];
}

// ¿Venimos simplemente de cambiar página o de haber seleccionado un registro ?
// ¿Hay una sesión activa?
if (isset($_SESSION["paginacion"]))
    $paginacion = $_SESSION["paginacion"];

$pagina_seleccionada = isset($_GET["PAG_NUM"]) ? (int) $_GET["PAG_NUM"] : (isset($paginacion) ? (int) $paginacion["PAG_NUM"] : 1);
$pag_tam = isset($_GET["PAG_TAM"]) ? (int) $_GET["PAG_TAM"] : (isset($paginacion) ? (int) $paginacion["PAG_TAM"] : 5);

if ($pagina_seleccionada < 1) $pagina_seleccionada = 1;
if ($pag_tam < 1) $pag_tam = 5;

// Antes de seguir, borramos las variables de sección para no confundirnos más adelante
unset($_SESSION["paginacion"]);

$conexion = crearConexionBD();

// La consulta que ha de paginarse
$perfil = $_SESSION["Perfil"];
$query = 'SELECT * FROM PRUEBAS NATURAL JOIN DOCUMENTOS WHERE idAtleta=' .  $perfil["IDATLETA"] . ' ORDER BY fecha DESC';

// Se comprueba que el tamaño de página, página seleccionada y total de registros son conformes.
// En caso de que no, se asume el tamaño de página propuesto, pero desde la página 1
$total_registros = total_consulta($conexion, $query);
$total_paginas = (int) ($total_registros / $pag_tam);

if ($total_registros % $pag_tam > 0)        $total_paginas++;

if ($pagina_seleccionada > $total_paginas)        $pagina_seleccionada = $total_paginas;

if ($total_registros < 5) $pag_tam = $total_registros;
// Generamos los valores de sesión para página e intervalo para volver a ella después de una operación
$paginacion["PAG_NUM"] = $pagina_seleccionada;
$paginacion["PAG_TAM"] = $pag_tam;
$_SESSION["paginacion"] = $paginacion;

$filas = consulta_paginada($conexion, $query, $pagina_seleccionada, $pag_tam);

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
} elseif (isset($_SESSION["correcto"])) {
    $correcto = $_SESSION["correcto"];
    unset($_SESSION["correcto"]);
    unset($_SESSION["formulario"]);
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
    <script src="js/validacionPdf.js"></script>
</head>

<body>
    <?php
    $ac = "aPrueba";
    include("header.php");
    ?>

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">
            <h3>Últimas Pruebas</h3>
            <div class="scroll">
                <form method="get" action="Pruebas.php">
                    <input id="PAG_NUM" name="PAG_NUM" type="hidden" value="<?php echo $pagina_seleccionada ?>" />
                    Mostrando
                    <input id="PAG_TAM" name="PAG_TAM" type="number" min="1" max="<?php echo $total_registros; ?>" value="<?php echo $pag_tam ?>" autofocus="autofocus" />
                    entradas de <?php echo $total_registros ?>
                    <input type="submit" value="Cambiar">
                </form>
                <table>
                    <tr>
                        <th>Fecha</th>
                        <th>Tipo</th>
                        <th>Link</th>
                    </tr>
                    <?php
                    foreach ($filas as $fila) {
                    ?>
                        <tr>
                            <td><?php echo $fila["FECHA"]; ?></td>
                            <td><?php echo $fila["TIPO"]; ?></td>
                            <td><a href="<?php
                                            echo $fila["RUTAFICHERO"];
                                            ?>"><?php
                                                echo $fila["RUTAFICHERO"];
                                                ?></a></td>
                        </tr>
                    <?php
                    }
                    ?>


                </table>
                <div style="float:right">
                    <?php
                    for ($pagina = 1; $pagina <= $total_paginas; $pagina++)
                        if ($pagina == $pagina_seleccionada) { ?>
                        <span class="current"><?php echo $pagina; ?></span>
                    <?php } else { ?>
                        <a href="Pruebas.php?PAG_NUM=<?php echo $pagina; ?>&PAG_TAM=<?php echo $pag_tam; ?>"><?php echo $pagina; ?></a>
                    <?php } ?>
                </div>
            </div>
        </div>

        <div class="smallContainer">
            <h3>Nueva Prueba</h3>
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
            <form action="validacionPruebas.php" id="form" method="POST" enctype="multipart/form-data">
                <div class="row">
                    <label for="tipo" class="col-25">Tipo:</label>
                    <input class="col-75" required type="text" id="tipo" name="tipo" value="<?php echo $formulario["tipo"] ?>" placeholder="Introduce el tipo..." maxlength="35">
                </div>
                <div class="row">
                    <label for="fecha" class="col-25">Fecha:</label>
                    <input class="col-75" required type="date" id="fecha" value="<?php echo $formulario["fecha"] ?>" name="fecha">
                </div>
                <div class="row">
                    <label for="descripcion" class="col-25">Descripción:</label>
                    <textarea placeholder="Introduce una descripcción..." name="descripcion" value="<?php echo $formulario["descripcion"] ?>" class="col-75" maxlength="" required></textarea>
                </div>
                <br>
                <div class="row">
                    <label for="file" id="filelabel" class="fileInput">
                        <input type="file" id="file" name="file">
                        Selecciona un documento pdf...
                    </label>
                </div>
                <br><br>
                <div class="row">
                    <input type="submit" value="Enviar">
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