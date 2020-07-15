<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarDietas.php");


if (isset($_SESSION["formularioDieta"])) {
	$nuevaDieta["fechafin"] = $_REQUEST["FechaFin"];
	$nuevaDieta["fecha"] = $_REQUEST["Fecha"];
	$nuevaDieta["descripcion"] = $_REQUEST["message"];
	$_SESSION["formularioDieta"] = $nuevaDieta;

	$id = $_REQUEST["idAtleta"];
} else
	Header("Location: insertar.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarDieta($conexion, $nuevaDieta);

if (count($errores) > 0) {
	$_SESSION["errores"] = $errores;
	Header('Location: insertar.php');
} else if (alta_Dietas($conexion, $nuevaDieta, $id)) {
	$correcto = "Se ha realizado";
	$_SESSION["correcto"] = $correcto;
	unset($_SESSION["formularioDieta"]);
	Header('Location: insertar.php?unset=true');
} else {
	$errores[] = "No se ha podido acceder a la base de datos en estos momentos, disculpe las molestias.";
	$_SESSION["errores"] = $errores;
	Header('Location: insertar.php');
}

cerrarConexionBD($conexion);



function validarDieta($conexion, $nuevaDieta)
{
	$errores = array();

	if ($nuevaDieta["fecha"] == "0000-00-00") {
		$errores[] = "<p>La fecha no puede estar vacía</p>";
	} else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/", $nuevaDieta["fecha"]))
		$errores[] = "<p>La fecha debe cumplir su formato</p>";

	if ($nuevaDieta["fechafin"] == "0000-00-00") {
		$errores[] = "<p>La fecha fin no puede estar vacía</p>";
	} else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/", $nuevaDieta["fechafin"]))
		$errores[] = "<p>La fecha fin debe cumplir su formato</p>";

	if ($nuevaDieta["fecha"] > $nuevaDieta["fechafin"]) {
		$errores[] = "<p>La fecha inicio no puede ser posterior a la fecha fin</p>";
	}

	if ($nuevaDieta["descripcion"] == "")
		$errores[] = "<p> La descripción no puede estar vacía</p>";
	else if (strlen($nuevaDieta["descripcion"]) > 1500) {
		$errores[] = "<p>La dieta es demasiado larga</p>";
	}

	return $errores;
}
