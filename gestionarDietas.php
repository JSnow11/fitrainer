<?php
function get_dietas($conexion, $Perfil)
{
    $query = "SELECT * from DIETAS WHERE IDATLETA=:id and ROWNUM < 10 ORDER BY FECHAFIN DESC";
    $stmt = $conexion->prepare($query);
    $stmt->bindParam(':id', $Perfil["IDATLETA"]);
    $stmt->execute();
    return $stmt->fetchAll();
}

function get_dieta($conexion, $dietas, $s)
{
    $picked = null;
    foreach ($dietas as $dieta) {
        if ($dieta["IDDIETA"] == $s)
            $picked = $dieta;
    }
    return $picked;
}
function get_dietaActual($conexion, $dietas)
{
    $picked = null;
    foreach ($dietas as $dieta) {
        if (strtotime($dieta["FECHAINICIO"]) >= date('m/d/y', time()) && strtotime($dieta["FECHAFIN"]) <= date('m/d/y', time()) 
                || $dieta["FECHAINICIO"] == date('d/m/y', time()) 
                || $dieta["FECHAFIN"] == date('d/m/y', time())) {

            $picked = $dieta;
            break;
        }
    }
    return $picked;
}
function alta_Dietas($conexion, $nuevaDieta, $id)
{
    $nuevaDieta["fechafin"] =  new DateTime($nuevaDieta["fechafin"]);
    $nuevaDieta["fechafin"] = $nuevaDieta["fechafin"]->format('d/m/Y');
    $nuevaDieta["fecha"] = new DateTime($nuevaDieta["fecha"]);
    $nuevaDieta["fecha"] = $nuevaDieta["fecha"]->format('d/m/Y');

    try {
        $llamada = "CALL nueva_dieta(:descripcion,:fechaFin,:fecha,:idAtleta)";
        $stmt = $conexion->prepare($llamada);
        $stmt->bindParam(':descripcion', $nuevaDieta["descripcion"]);
        $stmt->bindParam(':fechaFin', $nuevaDieta["fechafin"]);
        $stmt->bindParam(':fecha', $nuevaDieta["fecha"]);
        $stmt->bindParam(':idAtleta', $id);
        $stmt->execute();
        return true;
    } catch (PDOException $p) {
        return false;
    }
}
