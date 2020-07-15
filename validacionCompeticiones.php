<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarIntroducirCompeticiones.php");


if (isset($_SESSION["formulario"])) {
    $nuevaCompeticion["fecha"] = $_REQUEST["fecha"];
    $nuevaCompeticion["nombre"] = $_REQUEST["nombre"];
    $nuevaCompeticion["lugar"] = $_REQUEST["lugar"];
    $nuevaCompeticion["tipo"] = $_REQUEST["tipo"];
    $nuevaCompeticion["alcance"] = $_REQUEST["alcance"];
    $_SESSION["formulario"] = $nuevaCompeticion;
} else
    Header("Location: introducirCompeticion.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarCompeticion($conexion, $nuevaCompeticion);


if (count($errores) > 0) {
    $_SESSION["errores"] = $errores;
    Header('Location: introducirCompeticion.php');
} else if (altaCompeticion($conexion, $nuevaCompeticion)) {
    $correcto = "Se ha realizado con éxito";
    $_SESSION["correcto"] = $correcto;
    Header('Location: introducirCompeticion.php');
} else {
    $errores[] = "No se ha podido acceder a la base de datos, disculpe las molestias";
    $_SESSION["errores"] = $errores;
    Header('Location: introducirCompeticion.php');
}
cerrarConexionBD($conexion);

function validarCompeticion($conexion, $nuevaCompeticion)
{
    $errores = array();

    if($nuevaCompeticion["fecha"] == "0000-00-00"){
        $errores[] = "<p>La fecha no puede estar vacía</p>";
    }else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/",$nuevaCompeticion["fecha"]))
        $errores[] = "<p>La fecha debe cumplir su formato</p>";

    if ($nuevaCompeticion["nombre"] == "")
        $errores[] = "<p>El nombre de la competición debe indicarse</p>";
    else if(strlen($nuevaCompeticion["nombre"]) > 100){
        $errores[] = "<p>El nombre de la competicion es demasiado largo</p>";
    }

    if ($nuevaCompeticion["lugar"] == "")
        $errores[] = "<p> El lugar de la competicion no puede estar vacío</p>";
    else if(strlen($nuevaCompeticion["lugar"]) > 150){
        $errores[] = "<p>El lugar de la competicion es demasiado largo</p>";
    }

    if (!($nuevaCompeticion["tipo"] == "Popular" ||
        $nuevaCompeticion["tipo"] == "Federado" ||
        $nuevaCompeticion["tipo"] == "Benefica"))
        $errores[] = "<p> El tipo de la competicion debe ser uno de los indicados</p>";

    if (!($nuevaCompeticion["alcance"] == "Nacional" ||
        $nuevaCompeticion["alcance"] == "Internacional" ||
        $nuevaCompeticion["alcance"] == "Regional"))
        $errores[] = "<p> El tipo de la competicion debe ser uno de los indicados</p>";

    return $errores;
}
