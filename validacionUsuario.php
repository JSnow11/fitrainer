<?php
	session_start();
	require_once("gestionBD.php");
	require_once("gestionarUsuarios.php");

	
	if (isset($_SESSION["formulario"])) {
		$nuevoUsuario["nombre"]= $_REQUEST["nombre"];
		$nuevoUsuario["apellidos"]= $_REQUEST["apellidos"];
		$nuevoUsuario["edad"]= $_REQUEST["edad"];
		$nuevoUsuario["genero"]= $_REQUEST["genero"];
		$nuevoUsuario["telefono"]= $_REQUEST["telefono"];
		$nuevoUsuario["direccion"]= $_REQUEST["direccion"];
		$nuevoUsuario["estadoFisico"]= $_REQUEST["estadoFisico"];
		$nuevoUsuario["email"]= $_REQUEST["email"];
		$nuevoUsuario["pass"]= $_REQUEST["pass"];
		$nuevoUsuario["confirmpass"]= $_REQUEST["confirmpass"];
		$nuevoUsuario["activo"] = 1;
		
		$_SESSION["formulario"] = $nuevoUsuario;

	}else Header("Location: registroUsuario.php");

	
	$conexion = crearConexionBD(); 
	$errores = validarDatosUsuario($conexion, $nuevoUsuario);

	if (count($errores)>0) {
		$_SESSION["errores"] = $errores;
		Header('Location: registroUsuario.php');
	
	}else{
		if(isset($_SESSION["Perfil"])){ //En este caso se edita el perfil en la base de datos
			$perfil=$_SESSION["Perfil"];
			
			if(editar_usuario($conexion, $nuevoUsuario, $perfil)){ 
				unset($_SESSION["formulario"]);
				Header('Location: perfil.php');
			} else {
				$errores[] = "Actualmente no se puede acceder a la base de datos, disculpe las molestias";
				$_SESSION["errores"] = $errores;
				Header('Location: RegistroUsuario.php');
			}
		}
		else{
			if(alta_usuario($conexion, $nuevoUsuario)){ 
				$registrado = "Ha sido registrado, inicie sesión";
				$_SESSION["registrado"] = $registrado;
				unset($_SESSION["formulario"]);
				Header('Location: login.php');
			} else {
				$errores[] = "El email ya ha sido usado.";
				$_SESSION["errores"] = $errores;
				Header('Location: registroUsuario.php');
			}
		}
	}

	cerrarConexionBD($conexion);
    	    

function validarDatosUsuario($conexion, $nuevoUsuario){
	$errores=array();
				
	if($nuevoUsuario["nombre"]==""){
        $errores[] = "<p>El nombre no puede estar vacío</p>";
	}else if(strlen($nuevoUsuario["nombre"]) > 20){
		$errores[] = "<p>El nombre es demasiado largo</p>";
	}
    			
	if($nuevoUsuario["apellidos"]==""){
		$errores[] = "<p>Los apellidos no pueden estar vacíos</p>";
	}else if(strlen($nuevoUsuario["apellidos"]) > 50){
		$errores[] = "<p>Los apellidos son demasiado largos</p>";
	}

    if($nuevoUsuario["edad"]=="") {
        $errores[] = "<p>Los apellidos no pueden estar vacíos</p>";
    }else if(!preg_match("/([0-9]){1,2}/",$nuevoUsuario["edad"])){
        $errores[] = "<p>La edad debe estar entre 0 y 100</p>";
    }
	
	if($nuevoUsuario["genero"] != "M" && $nuevoUsuario["genero"] != "F") {
		$errores[] = "<p>El genero debe ser hombre o mujer</p>";
    }
    
    if(!preg_match("/([0-9]){8}/", $nuevoUsuario["telefono"])) {
		$errores[] = "<p>El telefono debe cumplir el formato</p>";
    }
	
	if($nuevoUsuario["direccion"]==""){
		$errores[] = "<p>La dirección no puede estar vacía</p>";	
    }else if(strlen($nuevoUsuario["direccion"]) > 50){
		$errores[] = "<p>La dirección es demasiado larga</p>";
	}
    
    if(!($nuevoUsuario["estadoFisico"]=="Alto rendimiento" || 
    $nuevoUsuario["estadoFisico"]=="Buena forma" || 
    $nuevoUsuario["estadoFisico"]=="Baja forma" ||
    $nuevoUsuario["estadoFisico"]=="Lesionado")){
		$errores[] = "<p>Debe seleccionarse una de las opciones</p>";	
    }
    
	if($nuevoUsuario["email"]==""){ 
		$errores[] = "<p>El email no puede estar vacío</p>";
	}else if(!filter_var($nuevoUsuario["email"], FILTER_VALIDATE_EMAIL)){
		$errores[] = "<p>El email no es válido: " . $nuevoUsuario["email"]. "</p>";
    }
    
	if(!isset($nuevoUsuario["pass"]) || strlen($nuevoUsuario["pass"])<8){
		$errores[] = "<p>Contraseña no válida: debe tener al menos 8 caracteres</p>";
	}else if($nuevoUsuario["pass"] != $nuevoUsuario["confirmpass"]){
		$errores[] = "<p>La confirmación de contraseña no coincide con la contraseña</p>";
	}else if(!preg_match("/[a-z]+/", $nuevoUsuario["pass"]) || 
				!preg_match("/[A-Z]+/", $nuevoUsuario["pass"]) || 
				!preg_match("/[0-9]+/", $nuevoUsuario["pass"])){
		$errores[] = "<p>Contraseña poco segura: debe contener letras mayúsculas y minúsculas y dígitos</p>";
	}
	return $errores;
}
