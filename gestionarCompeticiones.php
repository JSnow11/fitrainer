<?php
function getCompeticiones($conexion){
	try {
		$consulta = "SELECT * FROM COMPETICIONES WHERE fecha>sysdate ORDER BY FECHA DESC";
		$stmt = $conexion->prepare($consulta);
		$stmt->execute();
		return $stmt->fetchAll();
	}catch(PDOException $e){
		return $e -> getMessage();
	}
}

function getAsistencia($conexion, $idAtleta, $idCompeticion){
	try {
		$consulta = "SELECT * FROM RESULTADOS NATURAL JOIN COMPETICIONES WHERE IDATLETA = :idAtleta and IDCOMPETICION =:idCompeticion";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idCompeticion',$idCompeticion);
		$stmt->execute();
		return $stmt->fetch();
	} catch(PDOException $e) {
		return null;
	}
}

function participar($conexion,$idCompeticion,$idAtleta,$prueba) {
	$null = null;
	try {
		$consulta = "CALL nuevo_resultado(:idAtleta, :idCompeticion, :prueba, :marca, :posicion)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idCompeticion',$idCompeticion);
		$stmt->bindParam(':prueba', $prueba);
		$stmt->bindParam(':marca', $null);
		$stmt->bindParam(':posicion', $null);
		$stmt->execute();
	} catch(PDOException $e) {
		$_SESSION["PDOException"] = $e->getMessage();
    }
}

function noParticipar($conexion,$idCompeticion,$idAtleta) {
	try {
		$consulta = "DELETE FROM RESULTADOS WHERE idAtleta=:idAtleta and idCompeticion=:idCompeticion";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':idAtleta',$idAtleta);
		$stmt->bindParam(':idCompeticion',$idCompeticion);
		$stmt->execute();
	} catch(PDOException $e) {
		$_SESSION["PDOException"] = $e->getMessage();
    }
}

?>