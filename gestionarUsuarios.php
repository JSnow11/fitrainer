<?php
 

 function alta_usuario($conexion,$usuario) {
	try {
		$consulta = "CALL nuevo_atleta(:nombre, :ape, :eda, :gen, :tel, :dic, :esta, :correo, :contra, :activo)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':nombre',$usuario["nombre"]);
		$stmt->bindParam(':ape',$usuario["apellidos"]);
		$stmt->bindParam(':eda',$usuario["edad"]);
		$stmt->bindParam(':gen',$usuario["genero"]);
		$stmt->bindParam(':tel',$usuario["telefono"]);
		$stmt->bindParam(':dic',$usuario["direccion"]);
		$stmt->bindParam(':esta',$usuario["estadoFisico"]);
		$stmt->bindParam(':correo',$usuario["email"]);
		$stmt->bindParam(':contra',$usuario["pass"]);
		$stmt->bindParam(':activo',$usuario["activo"]);
		
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
		
    }
}

function editar_usuario($conexion,$usuario,$perfil) {
	try {
		$consulta = "CALL actualizar_atleta(:id,:nombre, :ape, :eda, :gen, :tel, :dic, :esta, :correo, :contra, :activo)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':id',$perfil["IDATLETA"]);
		$stmt->bindParam(':nombre',$usuario["nombre"]);
		$stmt->bindParam(':ape',$usuario["apellidos"]);
		$stmt->bindParam(':eda',$usuario["edad"]);
		$stmt->bindParam(':gen',$usuario["genero"]);
		$stmt->bindParam(':tel',$usuario["telefono"]);
		$stmt->bindParam(':dic',$usuario["direccion"]);
		$stmt->bindParam(':esta',$usuario["estadoFisico"]);
		$stmt->bindParam(':correo',$usuario["email"]);
		$stmt->bindParam(':contra',$usuario["pass"]);
		$stmt->bindParam(':activo',$usuario["activo"]);
		
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
		
    }
}

function eliminar_usuario($conexion,$perfil) {
	try {
		$consulta = "CALL eliminar_atleta(:id)";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':id',$perfil["IDATLETA"]);
		
		$stmt->execute();
		return true;
	} catch(PDOException $e) {
		return false;
		
    }
}

  
function consultarUsuario($conexion,$email,$pass) {
 	$consulta = "SELECT COUNT(*) AS TOTAL FROM ATLETAS WHERE CORREO=:email AND CONTRASENNA=:pass";
	$stmt = $conexion->prepare($consulta);
	$stmt->bindParam(':email',$email);
	$stmt->bindParam(':pass',$pass);
	$stmt->execute();
	return $stmt->fetchColumn();
}

function getPerfil($conexion,$email){
	try {
		$consulta = "SELECT * FROM ATLETAS WHERE CORREO=:email";
		$stmt=$conexion->prepare($consulta);
		$stmt->bindParam(':email',$email);
		$stmt->execute();
		$result = $stmt->fetch();
		
		return $result;
	} catch(PDOException $e) {
		return null;
    }
}

function getUltimosResultadosEnCompeticiones($conexion,$perfil){
	try {
		$consulta = "SELECT * FROM (SELECT * FROM RESULTADOS NATURAL JOIN COMPETICIONES WHERE IDATLETA=:id AND (MARCA IS NOT NULL AND POSICION IS NOT NULL) ORDER BY FECHA DESC) WHERE ROWNUM < 5";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':id',$perfil["IDATLETA"]);
		$stmt->execute();
		return $stmt->fetchAll();
	}catch(PDOException $e){
		return null;
	}
}

function getUltimosEsfuerzosEnFeedbacks($conexion,$perfil){
	try {
		$consulta = "SELECT * FROM FEEDBACKS NATURAL JOIN MICROCICLOS WHERE IDATLETA=:id and ROWNUM < 5 ORDER BY FECHAFIN DESC";
		$stmt = $conexion->prepare($consulta);
		$stmt->bindParam(':id',$perfil["IDATLETA"]);
		$stmt->execute();
		return $stmt->fetchAll();
	}catch(PDOException $e){
		return null;
	}
}
?>