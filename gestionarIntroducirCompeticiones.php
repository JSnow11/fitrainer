<?php

function altaCompeticion($conexion, $nuevaCompeticion){
    $nuevaCompeticion["fecha"] = new DateTime( $nuevaCompeticion["fecha"]);
    $nuevaCompeticion["fecha"]=$nuevaCompeticion["fecha"]-> format('d/m/Y');
    try {
		$llamada = "CALL nueva_competicion(:lugar, :nombre, :fecha, :tipo, :alcance)";
        $stmt=$conexion->prepare($llamada);
		$stmt->bindParam(':fecha',$nuevaCompeticion["fecha"]);
		$stmt->bindParam(':lugar',$nuevaCompeticion["lugar"]);
        $stmt->bindParam(':alcance',$nuevaCompeticion["alcance"]);
        $stmt->bindParam(':tipo',$nuevaCompeticion["tipo"]);
		$stmt->bindParam(':nombre',$nuevaCompeticion["nombre"]);
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
    }
}

?>