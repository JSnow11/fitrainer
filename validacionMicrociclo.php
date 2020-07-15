<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarMicrociclos.php");


if (isset($_SESSION["formularioEntrenamiento"])) {
    $nuevoMicrociclo["tipo"] = $_REQUEST["tipoEnt"];
    $nuevoMicrociclo["fecha"] = $_REQUEST["FechaEnt"];
    $nuevoMicrociclo["recuperacion"] = $_REQUEST["recuperacion"];
    $tam = $_REQUEST["tam"];
    $estadoFisicoAt = $_REQUEST["estadoFisico"];
    for ($i = 0; $i < $tam; $i++) {
        if (($_REQUEST["repeticiones" . $i]) >= 1) {
            $nuevoMicrociclo["arrayId"][] = $_REQUEST[$i];
            $nuevoMicrociclo["arrayRep"][] = $_REQUEST["repeticiones" . $i];
            $nuevoMicrociclo["arrayDist"][] = $_REQUEST["distancia" . $i];
        }
    }
    $id = $_REQUEST["idAtleta"];

    $_SESSION["formularioEntrenamiento"] = $nuevoMicrociclo;
} else
    Header("Location: insertar.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarMicrocilo($conexion, $nuevoMicrociclo, $estadoFisicoAt);
if (count($errores) > 0) {
    $_SESSION["errores"] = $errores;
    Header('Location: insertar.php');
} else if (addMicrociclo($conexion, $nuevoMicrociclo["arrayId"], $nuevoMicrociclo["arrayDist"], $nuevoMicrociclo["arrayRep"], $nuevoMicrociclo, $id)) {
    $correcto = "Se ha realizado";
    $_SESSION["correcto"] = $correcto;
    Header('Location: insertar.php?unset=true');
} else {
    if (isset($_SESSION["PDOException"])) $errores[] = "No se pueden seguir 2 microciclos al mismo tiempo, selecciona una fecha válida";
    else  $errores[] = "Ha habido algún error con la base de datos, disculpe las molestias." ;
    unset($_SESSION["PDOException"]);
    $_SESSION["errores"] = $errores;
    Header('Location: insertar.php');
}
cerrarConexionBD($conexion);


function validarMicrocilo($conexion, $nuevoMicrociclo, $estadoFisicoAt)
{
    $errores = array();

    if ($nuevoMicrociclo["fecha"] == "0000-00-00") {
        $errores[] = "<p>La fecha no puede estar vacía</p>";
    } else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/", $nuevoMicrociclo["fecha"]))
        $errores[] = "<p>La fecha debe cumplir su formato</p>";

    if (!($nuevoMicrociclo["tipo"] == "Alto rendimiento" ||
        $nuevoMicrociclo["tipo"] == "Buena forma" ||
        $nuevoMicrociclo["tipo"] == "Baja forma" ||
        $nuevoMicrociclo["tipo"] == "Lesionado")) {
        $errores[] = "<p>Debe seleccionarse una de las opciones</p>";
    }

    if ($nuevoMicrociclo["tipo"] == "")
        $errores[] = "<p>El tipo del ejercicio no puede estar vacío</p>";
    else if (!$nuevoMicrociclo["tipo"] == $estadoFisicoAt) {
        $errores[] = "<p>El estado fisico del atleta debe ser igual al del microciclo</p>";
    }

    if ($nuevoMicrociclo["recuperacion"] == "")
        $errores[] = "<p> La recuperacion no puede estar vacía</p>";
    else if (strlen($nuevoMicrociclo["recuperacion"]) > 200) {
        $errores[] = "<p> La recuperación es demasiado grande</p>";
    }

    if(sizeof($nuevoMicrociclo["arrayId"]) < 1 || $nuevoMicrociclo["arrayId"] < 1 || $nuevoMicrociclo["arrayId"] < 1 ){
        $errores[] = "<p>No has introducido ningún ejercicio correctamente</p>";
    }

    for ($i = 0; $i < sizeof($nuevoMicrociclo["arrayId"]); $i++) {
        if ($nuevoMicrociclo["arrayRep"][$i] > 99 || $nuevoMicrociclo["arrayRep"][$i] < 0) {
            $errores[] = "<p>Repeticiones tiene que ser un valor entre 0 y 9</p>";
        }
        if (!preg_match("/[0-9]{1,3},[0-9]{1,2}/", $nuevoMicrociclo["arrayDist"][$i]) && !empty($nuevoMicrociclo["arrayDist"][$i])) {
            $errores[] = "<p>Distancia tiene que ser un valor que cumpla el formato: x,xx </p>";
        }
    }

    return $errores;
}
