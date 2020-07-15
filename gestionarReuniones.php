<?php
function getReuniones($conexion){
	try {
		$query = "SELECT * FROM REUNIONES WHERE fecha>sysdate ORDER BY FECHA DESC";
		$stmt = $conexion->prepare($query);
		$stmt->execute();
		return $stmt->fetchAll();
	}catch(PDOException $e){
	}
}

function getAsistencia($conexion, $idReunion, $idAtleta){
	try {
		$consulta = "SELECT * FROM ASISTENCIAS NATURAL JOIN REUNIONES WHERE IDATLETA = :idAtleta and IDREUNION =:idReunion";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idReunion',$idReunion);
		$stmt->execute();
		return $stmt->fetchAll();
	} catch(PDOException $e) {
		return null;
	}
}

function participar($conexion,$idReunion,$idAtleta) {
	noParticipar($conexion,$idReunion,$idAtleta);
	try {
		$consulta = "CALL nueva_asistencia(:idAtleta, :idReunion)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idReunion',$idReunion);
		$stmt->execute();
	} catch(PDOException $e) {
    }
}

function noParticipar($conexion,$idReunion,$idAtleta) {
	try {
		$consulta = "DELETE FROM ASISTENCIAS WHERE idAtleta=:idAtleta and idReunion=:idReunion";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idReunion',$idReunion);
		$stmt->execute();
	} catch(PDOException $e) {
    }
}

?>