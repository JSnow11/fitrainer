<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarMicrociclos.php");

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

    
if (isset($_REQUEST["unset"])){
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

$conexion = crearConexionBD();
$microciclos = get10Microciclos($conexion, $_SESSION["Perfil"]);
$titulo = "Microciclo Actual";

if (!empty($_POST)) {
    $microMostrado = getMicrociclo($conexion, $_POST["select"]);
    $titulo = "Microciclo Seleccionado";
    unset($_POST);
} else {
    $microMostrado = getMicroActual($conexion, $microciclos);
}

if (isset($microMostrado)) $ejercicios = getEjercicios($conexion, $microMostrado["IDMICROCICLO"]);

?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>FiTrainer</title>
    <meta name="description" content="Perfil">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" href="img/logoFT.png">
</head>

<body>
    <?php
    include("header.php");
    ?>

    <div class="WhiteBackgroundContainer">
        <div class="bigContainer">
            <h3><?php echo $titulo ?></h3>
            <p>Tipo: <?php echo $microMostrado["TIPO"] ?> </p>
            <p>Fecha Inicio: <?php echo $microMostrado["FECHAINICIO"] ?></p>
            <p>Fecha Fin: <?php echo $microMostrado["FECHAFIN"] ?></p>

            <div class="smallScroll">
                <table>
                    <tr>
                        <th>Ejercicios</th>
                        <th>Repeticiones</th>
                        <th>Distancia (KM)</th>
                        <th>Descripción</th>
                    </tr>
                    <?php
                    if (isset($ejercicios))
                        foreach ($ejercicios as $ej) {
                    ?>
                        <tr>
                            <td><?php echo $ej["TITULO"] ?> </td>
                            <td><?php echo $ej["REPETICIONES"] ?> </td>
                            <td><?php echo $ej["DISTANCIA"] ?> </td>
                            <td><?php echo $ej["DESCRIPCION"] ?> </td>
                        </tr>
                    <?php
                        }
                    ?>
                </table>
            </div>
            <p>Descripción: </p>
            <p class="textBox"><?php echo $microMostrado["DESCRIPCION"] ?></p>
            <p>Recuperación: </p>
            <p class="textBox"><?php echo $microMostrado["RECUPERACION"] ?></p>
        </div>

        <div class="smallContainer">
            <h3>Anteriores</h3>
            <div class="smallScroll">

                <table>
                    <tr>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Ver</th>
                    </tr>
                    <?php
                    if (isset($microciclos))
                        foreach ($microciclos as $micro) {
                            if (($micro != $microMostrado)) {
                    ?>
                            <tr>
                                <form class="noStyle" method="post" action="microciclo.php">
                                    <td>
                                        <?php echo $micro["FECHAINICIO"] ?> <?php if ($micro == getMicroActual($conexion, $microciclos)) echo "(Actual)" ?>
                                    </td>
                                    <td>
                                        <?php echo $micro["FECHAFIN"] ?>
                                    </td>
                                    <td>
                                        <input type="text" name="select" hidden value="<?php echo $micro["IDMICROCICLO"] ?>">
                                        <input type="submit" value="Ver">
                                </form>
                                </td>
                            </tr>
                    <?php
                            }
                        }
                    ?>
                </table>
            </div>
        </div>
    </div>
    <?php
    include("footer.php");
    cerrarConexionBD($conexion);
    ?>
</body>

</html>