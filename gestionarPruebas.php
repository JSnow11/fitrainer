<?php
function alta_Pruebas($conexion, $nuevaPrueba, $Perfil){
	$nuevaPrueba["fecha"] = new DateTime($nuevaPrueba["fecha"]);
	$nuevaPrueba["fecha"] = $nuevaPrueba["fecha"]->format('d/m/Y');
    try {
		$llamada = "CALL nueva_prueba(:tipo, :fecha, :idAtleta)";
		$stmt=$conexion->prepare($llamada);
        $stmt->bindParam(':tipo',$nuevaPrueba["tipo"]);
		$stmt->bindParam(':fecha',$nuevaPrueba["fecha"]);
		$stmt->bindParam(':idAtleta',$Perfil["IDATLETA"]);
        $stmt->execute();

        $llamada1 = "SELECT * FROM (SELECT * FROM PRUEBAS WHERE idAtleta=:id ORDER BY idPrueba DESC) WHERE ROWNUM < 2  ";
        $stmt1=$conexion->prepare($llamada1);
        $stmt1->bindParam(':id',$Perfil["IDATLETA"]);
        $stmt1->execute();
        $result = $stmt1->fetch();

        $llamada2="CALL introducir_documento(:descripcion,:ruta,:idpago,:idPrueba)";
        $stmt2=$conexion->prepare($llamada2);
        $stmt2->bindParam(':descripcion', $nuevaPrueba["descripcion"]);
        $stmt2->bindParam(':ruta',$nuevaPrueba["ruta"]);
        $null = null;
        $stmt2->bindParam(':idPago',$null);
	    $stmt2->bindParam(':idPrueba',$result["IDPRUEBA"]);
        $stmt2->execute();
        return true;
        
	} catch(PDOException $e) {
		return false;
		
    }
    
}
?>