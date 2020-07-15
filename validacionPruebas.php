<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarPruebas.php");

if (isset($_SESSION["formulario"])) {
	$nuevaPrueba["fecha"] = $_REQUEST["fecha"];
	$nuevaPrueba["tipo"] = $_REQUEST["tipo"];
	$nuevaPrueba["descripcion"] = $_REQUEST["descripcion"];

	$_SESSION["formulario"] = $nuevaPrueba;
} else
	Header("Location: Pruebas.php");

// Validamos el formulario en servidor
$conexion = crearConexionBD();
$errores = validarPrueba($conexion, $nuevaPrueba);
$perfil = $_SESSION["Perfil"];
$nuevaPrueba["ruta"] = "ficheros/pruebas/" . $_FILES["file"]["name"];

if (count($errores) > 0) {
	$_SESSION["errores"] = $errores;
	Header('Location: Pruebas.php');
} else if (alta_Pruebas($conexion, $nuevaPrueba, $perfil)) {
	$correcto = "Se ha realizado";
	unset($_SESSION["formulario"]);
	$_SESSION["correcto"] = $correcto;
	Header('Location: Pruebas.php');
} else {
	$errores[] = "Actualmente no se puede acceder a la base de datos, disculpe las molestias";
	unset($_SESSION["PDOException"]);
	$_SESSION["errores"] = $errores;
	Header('Location: Pruebas.php');
}
cerrarConexionBD($conexion);



function validarPrueba($conexion, $nuevaPrueba)
{
	$errores = array();

	if ($nuevaPrueba["tipo"] == "")
		$errores[] = "<p>El tipo de la Prueba no puede estar vacío</p>";

	if ($nuevaPrueba["fecha"] == "0000-00-00") {
		$errores[] = "<p>La fecha no puede estar vacía</p>";
	} else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/", $nuevaPrueba["fecha"]))
		$errores[] = "<p>La fecha debe cumplir su formato</p>";

	if ($nuevaPrueba["descripcion"] == "")
		$errores[] = "<p> La descripción no puede estar vacía</p>";

	if (!($_FILES["file"]["type"] == 'application/pdf')) {
		$errores[] = "<p> El formato del archivo debe ser <b>.pdf </b></p>";
	} else {
		move_uploaded_file($_FILES["file"]["tmp_name"], "ficheros/pruebas/" . $_FILES["file"]["name"]);
		$nuevaPrueba["ruta"] = "ficheros/pruebas/" . $_FILES["file"]["name"];
	}
	return $errores;
}