<?php
	session_start();
	require_once("gestionBD.php");
	require_once("gestionarConsulta.php");

	
	if (isset($_SESSION["formulario"])) {
        
		$nuevaConsulta["tema"]= $_REQUEST["tema"];
		$nuevaConsulta["tipo"]= $_REQUEST["tipo"];
		$nuevaConsulta["descripcion"]= $_REQUEST["descripcion"];

		$_SESSION["formulario"] = $nuevaConsulta;		
	}
	else 
		Header("Location: Consultas.php");

	// Validamos el formulario en servidor
	$conexion = crearConexionBD(); 
	$errores = validarConsulta($conexion, $nuevaConsulta);
	$perfil = $_SESSION["Perfil"];

	
	if (count($errores)>0) {
		
		$_SESSION["errores"] = $errores;
		Header('Location: Consultas.php');
	} else if(alta_consulta($conexion, $nuevaConsulta, $perfil)){ 
		$correcto = "Se ha realizado";
		$_SESSION["correcto"] = $correcto;
		unset($_SESSION["formulario"]);
		Header('Location: Consultas.php');
    } else {
		$exception = $_SESSION["PDOException"];
		unset($_SESSION["PDOException"]);
		if(strpos($exception, 'LIMITE_CONSULTA')) $errores[] = "No puedes realizar 2 consultas del mismo tipo en un mismo día, espera a mañana.";
		else $errores[] = "Actualmente no se puede introducir una consulta en la base de datos, disculpe las molestias.";
		$_SESSION["errores"] = $errores;
		Header('Location: Consultas.php');
	}
	cerrarConexionBD($conexion);


function validarConsulta($conexion, $nuevaConsulta){
	$errores=array();
				
    if(!($nuevaConsulta["tipo"]=="Medica" || 
    $nuevaConsulta["tipo"]=="Dietetica" || 
    $nuevaConsulta["tipo"]=="Otro" )){
		$errores[] = "<p>Debe seleccionarse una de las opciones</p>";	
	}
	
	if(strlen($nuevaConsulta["tema"]) > 40){
		$errores[] = "<p>El tema de la consulta es demasiado largo</p>";	
	}
    	
	if($nuevaConsulta["descripcion"]=="") {
		$errores[] = "<p> La descripción de la consulta no puede estar vacía</p>";
	}else if(strlen($nuevaConsulta["descripcion"]) > 560) {
		$errores[] = "<p> La descripción de la consulta es demasiado grande</p>";
	}

    return $errores;
}
