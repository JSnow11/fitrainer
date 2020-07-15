<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarConsulta.php");

$nuevaRespuesta["respuesta"] = $_REQUEST["respuesta"];
$nuevaRespuesta["idConsulta"] = $_REQUEST["idConsulta"];
$conexion = crearConexionBD();
$errores = validarRespuesta($conexion, $nuevaRespuesta);

if (count($errores) > 0) {
	$_SESSION["errores"] = $errores;
	Header('Location: respuesta.php');
} else if (add_Respuesta($conexion, $nuevaRespuesta["respuesta"], $nuevaRespuesta["idConsulta"])) {
	unset($_SESSION["Consultas"]);
	$correcto = "Se ha realizado";
	$_SESSION["correcto"] = $correcto;
	Header('Location: insertar.php');
} else {
	$errores[] = "No se puede acceder a la base de datos en estos momentos, disculpe las molestias.";
	$_SESSION["errores"] = "$errores";
	Header('Location: respuesta.php');
}
cerrarConexionBD($conexion);

function validarRespuesta($conexion, $nuevaRespuesta){
	$errores = array();

	if ($nuevaRespuesta["respuesta"] == "")
		$errores[] = "<p>La respuesta de la consulta no puede estar vacía</p>";
	else if(strlen($nuevaRespuesta["respuesta"]) > 560){
		$errores[] = "<p>La respuesta es demasiado larga</p>";
	}

	return $errores;
}
