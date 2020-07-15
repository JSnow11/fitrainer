<?php

function altaReunion($conexion, $nuevaReunion){
	$nuevaReunion["fecha"] = new DateTime($nuevaReunion["fecha"]);
	$nuevaReunion["fecha"] = $nuevaReunion["fecha"]-> format('d/m/Y');
    try {
		$llamada = "CALL nueva_reunion(:fecha, :lugar, :duracion)";
        $stmt=$conexion->prepare($llamada);
		$stmt->bindParam(':fecha',$nuevaReunion["fecha"]);
		$stmt->bindParam(':lugar',$nuevaReunion["lugar"]);
		$stmt->bindParam(':duracion',$nuevaReunion["duracion"]);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
    }
}

?>