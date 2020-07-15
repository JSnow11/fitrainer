<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarIntroducirReuniones.php");


if (isset($_SESSION["formulario"])) {
	$nuevaReunion["fecha"] = $_REQUEST["fecha"];
	$nuevaReunion["duracion"] = $_REQUEST["duracion"];
	$nuevaReunion["lugar"] = $_REQUEST["lugar"];
	$_SESSION["formulario"] = $nuevaReunion;
} else
	Header("Location: introducirReunion.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarReunion($conexion, $nuevaReunion);

if (count($errores) > 0) {
	$_SESSION["errores"] = $errores;
	Header('Location: introducirReunion.php');
} else if (altaReunion($conexion, $nuevaReunion)) {
	unset($_SESSION["formulario"]);
	$correcto = "Se ha realizado con éxito";
	$_SESSION["correcto"] = $correcto;
	Header('Location: introducirReunion.php');
} else {
	$errores[] = "No se puede acceder a la base de datos actualmente, disculpe las molestias.";
    $_SESSION["errores"] = $errores;
	Header('Location: introducirReunion.php');
}
cerrarConexionBD($conexion);

function validarReunion($conexion, $nuevaReunion)
{
	$errores = array();
	if($nuevaReunion["fecha"] == "0000-00-00"){
		$errores[] = "<p>La fecha no puede estar vacía</p>";
		
	}else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/",$nuevaReunion["fecha"])){
		$errores[] = "<p>La fecha debe cumplir su formato</p>";
	}

	if (!preg_match("/[0-9]{2}:[0-5][0-9]/",$nuevaReunion["duracion"]))
		$errores[] = "<p>La duración debe rellenarse con el formato adecuado hh:mm</p>";

	if ($nuevaReunion["lugar"] == "")
		$errores[] = "<p> El lugar de la reunion no puede estar vacío</p>";
	else if(strlen($nuevaReunion["lugar"]) >80){
		$errores[] = "<p> El lugar de la reunion es demasiado largo</p>";
	}

	return $errores;
}
