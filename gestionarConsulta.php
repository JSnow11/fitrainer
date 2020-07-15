<?php
function alta_consulta($conexion, $consulta, $perfil)
{
	try {
		$llamada = "CALL nueva_consulta(:tipo, :tema, :descripcion, :idAtleta)";
		$stmt = $conexion->prepare($llamada);
		$stmt->bindParam(':tipo', $consulta["tipo"]);
		$stmt->bindParam(':tema', $consulta["tema"]);
		$stmt->bindParam(':descripcion', $consulta["descripcion"]);
		$stmt->bindParam(':idAtleta', $perfil["IDATLETA"]);
		$stmt->execute();
		return true;
	} catch (PDOException $e) {
		$_SESSION["PDOException"] = $e->getMessage();
		return false;
	}
}

function get_consultas($conexion, $Perfil)
{
	$query = "SELECT * FROM (SELECT * from CONSULTAS WHERE IDATLETA=:id ORDER BY fecha DESC) WHERE ROWNUM < 20";
	$stmt = $conexion->prepare($query);
	$stmt->bindParam(':id', $Perfil["IDATLETA"]);
	$stmt->execute();
	return $stmt->fetchAll();
}

function add_Respuesta($conexion, $resp, $idConsulta)
{
	try {
		$query = "CALL respuesta_consulta(:resp,:idConsulta)";
		$stmt = $conexion->prepare($query);
		$stmt->bindParam(':resp', $resp);
		$stmt->bindParam(':idConsulta', $idConsulta);
		$stmt->execute();
		return true;
	} catch (PDOException $e) {
		return false;
	}
}
