<?php

function get10Microciclos($conexion,$Perfil) {
    $query = "SELECT * from MICROCICLOS WHERE IDATLETA=:id and ROWNUM < 10 ORDER BY FECHAFIN DESC";
    $stmt=$conexion->prepare($query);
	$stmt->bindParam(':id',$Perfil["IDATLETA"]);
	$stmt->execute();
	return $stmt->fetchAll();
}

function getMicroActual($conexion,$microciclos) {
    $picked = null;
    foreach($microciclos as $microciclo) {
        if(strtotime($microciclo["FECHAINICIO"]) <= date('m/d/y', time()) && strtotime($microciclo["FECHAFIN"]) >= date('m/d/y', time()) 
                || $microciclo["FECHAINICIO"] == date('d/m/y', time()) 
                || $microciclo["FECHAFIN"] == date('d/m/y', time())){

            $picked = $microciclo;
            break;
        }  
    }
    return $picked;
}

function getMicrociclo($conexion,$idMicrociclo) {
    $query = "SELECT * from MICROCICLOS WHERE IDMICROCICLO=:idMicrociclo";
    $stmt=$conexion->prepare($query);
    $stmt->bindParam(':idMicrociclo',$idMicrociclo);
    $stmt->execute();
    return $stmt->fetch();
}

function getEjercicios($conexion, $idMicrociclo) {
    $query = "SELECT titulo, EJERCICIOS.tipo, repeticiones, distancia, descripcion 
    FROM EJERCICIOS NATURAL JOIN ESPECIFICACIONES
    WHERE idMicrociclo = :idMicrociclo
    ORDER BY idEjercicio";
    $stmt=$conexion->prepare($query);
    $stmt->bindParam(':idMicrociclo', $idMicrociclo);
    $stmt->execute();
    return $stmt->fetchAll();
}

function addMicrociclo($conexion,$arrayId, $arrayDist, $arrayRep, $microciclo, $idAtleta) {
    $microciclo["fecha"] =  new DateTime($microciclo["fecha"]);
	$microciclo["fecha"] = $microciclo["fecha"]->format('d/m/Y');
    $null = null;
    $b = true;
    try{
        $query = "CALL introducir_microciclo(:tipo, :descripcion, :fechaInicio, :recuperacion, :idAtleta)";
        $stmt=$conexion->prepare($query);
        $stmt->bindParam(':idAtleta',$idAtleta);
        $stmt->bindParam(':descripcion',$null);
        $stmt->bindParam(':tipo',$microciclo["tipo"]);
        $stmt->bindParam(':fechaInicio',$microciclo["fecha"]);
        $stmt->bindParam(':recuperacion',$microciclo["recuperacion"]);
        $stmt->bindParam(':idAtleta',$idAtleta);
        $stmt->execute();
        
        $query2 = "SELECT * FROM (SELECT idMicrociclo FROM MICROCICLOS WHERE idAtleta=:id ORDER BY idMicrociclo DESC) WHERE ROWNUM < 2";
        $stmt=$conexion->prepare($query2);
        $stmt->bindParam(':id',$idAtleta);
        $stmt->execute();
        
        $result = $stmt->fetch();

    }catch(PDOException $e){
        $_SESSION["PDOException"] = $e -> getMessage();
        $b = false;
    }
    
    if(isset($result) && $b){
        for($i=0; $i < sizeof($arrayId); $i++){
            try{
                $query = "CALL introducir_ej_a_microciclo
                (:repeticiones, :distancia, :idEjercicio, :idMicrociclo)";
                $stmt=$conexion->prepare($query);
                $stmt->bindParam(':repeticiones',$arrayRep[$i]);     
                $stmt->bindParam(':idEjercicio',$arrayId[$i]);
                $stmt->bindParam(':idMicrociclo',$result["IDMICROCICLO"]);
                $stmt->bindParam(':distancia',$arrayDist[$i]);
                $stmt->execute();
            }catch(PDOException $e2){
                $b = false;
                break;
            }
        }
    }else{
        $b = false;
    }

    return $b;
}