<?php
  

 function alta_ejercicios($conexion,$ejercicio) {
	try {
		$llamada = "CALL introducir_ejercicio(:titulo, :descripcion, :tipo)";
		$stmt=$conexion->prepare($llamada);
		$stmt->bindParam(':titulo',$ejercicio["titulo"]);
		$stmt->bindParam(':descripcion',$ejercicio["descripcion"]);
		$stmt->bindParam(':tipo',$ejercicio["tipo"]);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
		
    }
}

function get_ejercicios($conexion) {
	$query = "SELECT * from EJERCICIOS";
	$stmt=$conexion->query($query);
	return $stmt->fetchAll();
}
  
?>