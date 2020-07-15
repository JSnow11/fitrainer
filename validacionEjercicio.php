<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarEjercicios.php");


if (isset($_SESSION["formulario"])) {

	$nuevoEjercicio["titulo"] = $_REQUEST["titulo"];
	$nuevoEjercicio["descripcion"] = $_REQUEST["descripcion"];
	$nuevoEjercicio["tipo"] = $_REQUEST["tipo"];
	$nuevoEjercicio["file"] = $_REQUEST["file"];

	$_SESSION["formulario"] = $nuevoEjercicio;
} else
	Header("Location: introducirEjercicio.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarEjercicio($conexion, $nuevoEjercicio);

if (count($errores) > 0) {
	$_SESSION["errores"] = $errores;
	Header('Location: introducirEjercicio.php');
} else if (alta_ejercicios($conexion, $nuevoEjercicio)) {
	$correcto = "Se ha realizado";
	$_SESSION["correcto"] = $correcto;
	unset($_SESSION["formulario"]);
	Header('Location: introducirEjercicio.php');
} else {
	$errores[] = "Actualmente no se puede acceder a la base de datos, disculpe las molestias";
	$_SESSION["errores"] = $errores;
	Header('Location: introducirEjercicio.php');
}
cerrarConexionBD($conexion);



function validarEjercicio($conexion, $nuevoEjercicio)
{
	$errores = array();
	if ($nuevoEjercicio["titulo"] == "")
		$errores[] = "<p>El titulo del ejercicio no puede estar vacío</p>";
	else if (strlen($nuevoEjercicio["titulo"]) > 30) {
		$errores[] = "<p> El titulo es demasiado grande</p>";
	}

	if ($nuevoEjercicio["descripcion"] == "")
		$errores[] = "<p>La descripción del ejercicio no puede estar vacía</p>";
	else if (strlen($nuevoEjercicio["descripcion"]) > 500) {
		$errores[] = "<p> La descripción de la consulta es demasiado grande</p>";
	}
	
	if ($nuevoEjercicio["tipo"] == "")
		$errores[] = "<p> El tipo del ejercicio no puede estar vacío</p>";
	else if (strlen($nuevoEjercicio["tipo"]) > 40) {
		$errores[] = "<p> El tipo de la consulta es demasiado grande</p>";
	}

	return $errores;
}
