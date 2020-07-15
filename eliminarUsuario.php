<?php 
    session_start();
    include_once("gestionBD.php");
    $conexion = crearConexionBD();
    require_once("gestionarUsuarios.php");
    $perfil=$_SESSION["Perfil"];
    if(eliminar_usuario($conexion, $perfil)){
        unset($_SESSION["Perfil"]);
        unset($_SESSION["login"]);
        Header("Location: login.php");
    }else{
        Header("Location: perfil.php");
    }
    cerrarConexionBD($conexion);
?>