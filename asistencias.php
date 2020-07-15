<?php
session_start();
require_once("gestionBD.php");

$conexion = crearConexionBD();
if (isset($_GET)) {
    $id = $_GET["id"];

    if ($_GET["table"] == "reuniones") {
        $query = "SELECT nombre, apellidos FROM ASISTENCIAS NATURAL JOIN ATLETAS WHERE idReunion=:id";
    } else {
        $query = "SELECT nombre, apellidos FROM RESULTADOS NATURAL JOIN ATLETAS WHERE idCompeticion=:id";
    }
    try {
        $stmt = $conexion->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        $result = $stmt->fetchAll();
    } catch (PDOException $e) {
        echo $e;
        $result = null;
    }


    if ($result != null) {
        echo "<table>
    <tr>
        <th>Atleta</th>
    </tr>";

        foreach ($result as $atleta) {
            echo "<tr>";
            echo "<td>" . $atleta["NOMBRE"] . " " . $atleta["APELLIDOS"] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "<p> NO HAY PARTICIPANTES </p>";
    }
}
cerrarConexionBD($conexion);
unset($_GET["id"]);
