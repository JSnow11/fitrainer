<?php
	session_start();
	require_once("gestionBD.php");
	require_once("gestionarPagos.php");

	if (isset($_SESSION["formularioPagos"])) {
		$nuevoPago["fecha"] =$_REQUEST["fecha"];
		$nuevoPago["descripcion"]= $_REQUEST["descripcion"];
		$nuevoPago["idAtleta"]=$_REQUEST["idAtleta"];
		$_SESSION["formularioPagos"] = $nuevoPago;
	}
	else 
		Header("Location: introducirPago.php");

	// Validamos el formulario en servidor
	$conexion = crearConexionBD();
	$perfil = $_SESSION["Perfil"];
	$errores = validarPago($conexion, $nuevoPago);
    $nuevoPago["ruta"] = "ficheros/pagos/".$_FILES["file"]["name"];
    
	if (count($errores)>0) {
		$_SESSION["errores"] = $errores;
		Header('Location: insertar.php');
	} else if(alta_Pagos($conexion, $nuevoPago)){ 
		$correcto = "Se ha realizado";
		$_SESSION["correcto"] = $correcto;
		Header('Location: insertar.php?unset=true');
    } else {
		$errores[] = "Actualmente no se puede acceder a la base de datos, disculpe las molestias";
    	$_SESSION["errores"] = $errores;
		Header('Location: insertar.php');
	}
	cerrarConexionBD($conexion);
    	    


function validarPago($conexion, $nuevoPago){
	$errores=array();
	if($nuevoPago["fecha"] == "0000-00-00"){
		$errores[] = "<p>La fecha no puede estar vacía</p>";
	}else if (!preg_match("/[0-9]{4}\-[0-9]{2}\-[0-9]{2}/",$nuevoPago["fecha"]))
		$errores[] = "<p>La fecha debe cumplir su formato</p>";

    if ($nuevoPago["descripcion"] == "")
		$errores[] = "<p> La descripción no puede estar vacía</p>";
	else if(strlen($nuevoPago["descripcion"]) > 560){
		$errores[] = "<p> La descripción es demasiado larga</p>";
	}

    if(!($_FILES["file"]["type"] == 'application/pdf')){
        $errores[] = "<p> El formato del archivo debe ser <b> .pdf </b></p>";
    }else{
        move_uploaded_file($_FILES["file"]["tmp_name"], "ficheros/pagos/".$_FILES["file"]["name"]);
        $nuevoPago["ruta"] = "ficheros/pagos/".$_FILES["file"]["name"];
    }
    return $errores;
}
?>