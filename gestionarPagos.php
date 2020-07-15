<?php
    function getUltimosPagos($conexion, $perfil){
        try{  
            $query = "SELECT * FROM (SELECT * 
            FROM PAGOS NATURAL JOIN DOCUMENTOS
            WHERE idAtleta = :id ORDER BY fecha DESC) WHERE ROWNUM < 10";
            $stmt=$conexion->prepare($query);
            $stmt->bindParam(':id', $perfil["IDATLETA"]);
            $stmt->execute();
            return $stmt->fetchAll();
        }catch (PDOException $e){
            $e->getMessage();
        }
    }

    function buscarPago($conexion, $perfil, $fecha){
        $query = "SELECT rutaFichero 
        FROM PAGOS NATURAL JOIN DOCUMENTOS
        WHERE idAtleta = :id and fecha = :fecha";

        $stmt=$conexion->prepare($query);
        $stmt->bindParam(':id', $perfil["IDATLETA"]);
        $stmt->bindParam(':fecha', $fecha);
        $stmt->execute();
        return $stmt->fetch();
    }
    
    function alta_Pagos($conexion, $nuevoPago){
		$nuevoPago["fecha"] = new DateTime($_REQUEST["fecha"]);
		$nuevoPago["fecha"]=$nuevoPago["fecha"]-> format('d/m/Y');
        try {
            $llamada = "CALL introducir_pago(:fecha, :idAtleta)";
            $stmt=$conexion->prepare($llamada);
		    $stmt->bindParam(':fecha',$nuevoPago["fecha"]);
            $stmt->bindParam(':idAtleta',$nuevoPago["idAtleta"]);
            $stmt->execute();
    
            $llamada1 = "SELECT * FROM (SELECT * FROM PAGOS WHERE idAtleta=:id ORDER BY idPago DESC) WHERE ROWNUM < 2  ";
            $stmt1=$conexion->prepare($llamada1);
            $stmt1->bindParam(':id',$nuevoPago["idAtleta"]);
            $stmt1->execute();
            $result = $stmt1->fetch();
    
            $llamada2="CALL introducir_documento(:descripcion,:ruta,:idpago,:idPrueba)";
            $stmt2=$conexion->prepare($llamada2);
            $stmt2->bindParam(':descripcion', $nuevoPago["descripcion"]);
            $stmt2->bindParam(':ruta',$nuevoPago["ruta"]);
            $null = null;
            $stmt2->bindParam(':idPago',$result["IDPAGO"]);
            $stmt2->bindParam(':idPrueba',$null);
            $stmt2->execute();
            return true;
            
        } catch(PDOException $e) {
            return false;
            
        }
    }
?>