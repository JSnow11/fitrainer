<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarDietas.php");
require_once("gestionarEjercicios.php");
require_once("gestionarConsulta.php");

if (!isset($_SESSION['ADMIN']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formularioDieta"]);
    unset($_SESSION["formularioEntrenamiento"]);
    unset($_SESSION["formularioPagos"]);
}

$conexion = crearConexionBD();

if (!isset($_SESSION["AtletaSelec"]) && empty($_REQUEST)) {
    Header("Location:seleccionAtleta.php");
} else if (isset($_SESSION["AtletaSelec"])) {
    $atletaSec = $_SESSION["AtletaSelec"];
    $nombre = $atletaSec["nombre"];
    $apellidos = $atletaSec["apellidos"];
    $estadoFisico = $atletaSec["estadoFisico"];
    $id = $atletaSec["id"];
} else {
    $atletaSec["nombre"] = $_REQUEST["nombre"];
    $atletaSec["apellidos"] = $_REQUEST["apellidos"];
    $atletaSec["id"] = $_REQUEST["id"];
    $atletaSec["estadoFisico"] = $_REQUEST["estadoFisico"];

    $_SESSION["AtletaSelec"] = $atletaSec;
    $nombre = $_REQUEST["nombre"];
    $apellidos = $_REQUEST["apellidos"];
    $estadoFisico = $atletaSec["estadoFisico"];
    $id = $_REQUEST["id"];

    unset($_SESSION["formularioDieta"]);
    unset($_SESSION["formularioEntrenamiento"]);
    unset($_SESSION["formularioPagos"]);
}

if (!isset($_SESSION["formularioDieta"])) {
    $formularioDieta["fecha"] = "";
    $formularioDieta["fechafin"] = "";
    $formularioDieta["descripcion"] = "";
    $_SESSION["formularioDieta"] = $formularioDieta;
} else {
    $formularioDieta = $_SESSION["formularioDieta"];
}

if (!isset($_SESSION["formularioPagos"])) {
    $formularioPagos["fecha"] = "";
    $formularioPagos["descripcion"] = "";
    $_SESSION["formularioPagos"] = $formularioPagos;
} else {
    $formularioPagos = $_SESSION["formularioPagos"];
}

if (!isset($_SESSION["formularioEntrenamiento"])) {
    $formularioEntrenamiento["fecha"] = "";
    $formularioEntrenamiento["recuperacion"] = "";
    $formularioEntrenamiento["tipo"] = "";
    $_SESSION["formularioEntrenamiento"] = $formularioEntrenamiento;
} else {
    $formularioEntrenamiento = $_SESSION["formularioEntrenamiento"];
}

if (!isset($_SESSION["Ejercicios"])) {
    $ejercicios = get_ejercicios($conexion);
    $_SESSION["Ejercicios"] = $ejercicios;
}

if (!isset($_SESSION["Consultas"])) {
    $Perfil["IDATLETA"] = $id;
    $consultas = get_consultas($conexion, $Perfil);
    $_SESSION["Consultas"] = $consultas;
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
} elseif (isset($_SESSION["correcto"])) {
    $correcto = $_SESSION["correcto"];
    unset($_SESSION["correcto"]);
    unset($_SESSION["formulario"]);
}
$ejercicios = $_SESSION["Ejercicios"];
$consultas = $_SESSION["Consultas"];

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="js/validacionPdf.js"></script>
    <script>
        $(document).ready(function() {
            $("#fDietas").on("submit", function() {
                return validateForm();
            });
        });
    </script>
</head>

<body>
    <?php include("headerAdmin.php"); ?>

    <div class="infoInsertar">
        <h1><?php echo $nombre . " " . $apellidos ?></h1>
    </div>
    <br>
    </div>
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
    </div>

    <div class="WhiteBackgroundContainer">
        <div class="smallContainer">
            <h3>Entrenamiento</h3>
            <form action="validacionMicrociclo.php" method="POST" >
                <div class="row">
                    <label for="tipo" class="col-25">Tipo:</label>
                    <input class="col-75" required hidden type="text" id="tipo" name="tipoEnt" maxlength="35" value="<?php echo $estadoFisico ?>">
                    <input class="col-75" required disabled type="text" id="tipo" name="tipoN" placeholder="Introduce el tipo..." maxlength="35" value="<?php echo $estadoFisico ?>">
                </div>
                <div class="row">
                    <label for="tipo" class="col-25">Fecha:</label>
                    <input required value="<?php echo $formularioEntrenamiento["fecha"] ?>" type="date" class="col-75" id="Fecha" name="FechaEnt" placeholder="dd/mm/yyyy">
                </div>
                <br>
                <div class="smallerScroll">
                    <table>
                        <tr>
                            <th>Ejercicios</th>
                            <th>Repeticiones</th>
                            <th>Distancia</th>
                        </tr>
                        <?php
                        $i = 0;
                        foreach ($ejercicios as $ejercio) {
                        ?>
                            <tr>
                                <td><?php echo $ejercio["TITULO"] ?></td>
                                <input type="hidden" name="<?php echo $i ?>" value="<?php echo $ejercio["IDEJERCICIO"] ?>"></input>
                                <td><input type="text" name="repeticiones<?php echo $i ?>" pattern="[0-9]{1,2}" maxlength="2" placeholder="x" style="width: 50px;"></td>
                                <td><input type="text" name="distancia<?php echo $i ?>" pattern="[0-9]{1-3},[0-9]{1,2}" maxlength="6" placeholder="x,xx" style="width: 50px;"></td>
                            </tr>
                        <?php $i++;
                        } ?>
                    </table>
                    <input type="hidden" name="tam" value="<?php echo $i ?>"></input>
                    <input type="hidden" name="idAtleta" value="<?php echo $id ?>"></input>
                    <input type="hidden" name="estadoFisico" value="<?php echo $estadoFisico ?>"></input>
                </div>
                <div class="row">
                    <label for="tipo" class="col-25">Recuperacion:</label>
                    <textarea name="recuperacion" required maxlength="300"><?php echo $formularioEntrenamiento["recuperacion"] ?></textarea>
                </div>
                <br><br>
                <div class="row">
                    <input type="submit" value="Enviar">
                </div>
            </form>
        </div>
        <div class="smallContainer">
            <h3>Dieta</h3>
            <form id="fDietas" action="validacionDieta.php" method="POST" novalidate>
                <div class="row">
                    <label for="tipo" class="col-25">Fecha inicio:</label>
                    <input value="<?php echo $formularioDieta["fecha"] ?>" type="date" class="col-75" id="FechaDieta" name="Fecha" placeholder="dd/mm/yyyy">
                </div>
                <div class="row">
                    <label for="tipo" class="col-25">Fecha fin:</label>
                    <input value="<?php echo $formularioDieta["fechafin"] ?>" type="date" class="col-75" id="FechaFinDieta" name="FechaFin" placeholder="dd/mm/yyyy">
                </div>
                <br>
                <div class="row">
                    <label for="tipo" class="col-25">Descripcion</label>
                    <textarea name="message" id="message" required><?php echo $formularioDieta["descripcion"] ?></textarea>
                </div>
                <input type="hidden" id="id" name="idAtleta" value="<?php echo $id ?>">
                <br><br>
                <div class="row">
                    <input type="submit" value="Enviar">
                </div>

            </form>
        </div>
        <div class="smallContainer">
            <h3>Pagos</h3>
            <form action="validacionPagos.php" method="POST" id="form" enctype="multipart/form-data">
                <div>
                    <div class="row">
                        <label for="fecha" class="col-25">Fecha:</label>
                        <input required value="<?php echo $formularioPagos['fecha']; ?>" type="date" id="fechaPag" name="fecha" placeholder="Seleccione una fecha" class="col-75">
                    </div>
                    <br>
                    <div class="row">
                        <label for="descripcion" class="col-25">Descripción:</label>
                        <textarea required id="descripcionPag" name="descripcion"><?php echo $formularioPagos["descripcion"] ?></textarea>
                    </div>
                    <br>
                    <input hidden type="text" id="id" name="idAtleta" value="<?php echo $id ?>">
                    <div class="row">
                        <label for="file" id="filelabel" class="fileInput">
                            Selecciona un documento pdf...
                            <input type="file" id="file" name="file">
                        </label>
                    </div>
                    <br>
                    <div class="row">
                        <input type="submit" value="Enviar">
                    </div>
                </div>

            </form>
        </div>
        <div class="smallContainer ">
            <h3>Consultas</h3>
            <table>
                <tr>
                    <th>
                        id
                    </th>
                    <th>
                        Fecha
                    </th>
                    <th>
                        Enviar
                    </th>
                </tr>
                <?php

                foreach ($consultas as $consulta) {
                ?>
                    <form action="respuesta.php?unset=true" method="post">
                        <tr>
                            <td>
                                <?php echo $consulta["IDCONSULTA"]; ?>
                            </td>
                            <td>
                                <?php echo $consulta["FECHA"]; ?>
                            </td>
                            <td>
                                <input hidden type="text" id="id" name="id" value="<?php echo $consulta["IDCONSULTA"] ?>">
                                <input hidden type="text" name="tipo" value="<?php echo $consulta["TIPO"]; ?>">
                                <input hidden type="text" name="tema" value="<?php echo $consulta["TEMA"] ?>">
                                <input hidden type="date" name="fecha" value="<?php echo $consulta["FECHA"] ?>">
                                <input hidden type="text" name="des" value="<?php echo $consulta["DESCRIPCION"] ?>">
                                <input hidden type="text" name="respuesta" value="<?php echo $consulta["RESPUESTA"] ?>">
                                <input type="submit" name="submit" value="Responder"></input>
                            </td>
                        </tr>
                    </form>
                <?php } ?>
            </table>
        </div>
    </div>


    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>

</html>