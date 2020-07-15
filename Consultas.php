<?php
session_start();
require_once("gestionBD.php");
require_once("gestionarConsulta.php");

if (!isset($_SESSION['Perfil']))
    Header("Location: login.php");

if (isset($_REQUEST["unset"])) {
    unset($_SESSION["formulario"]);
    unset($_REQUEST);
}

if (!isset($_SESSION["formulario"])) {
    $formulario["tipo"] = 'Medica';
    $formulario["tema"] = "";
    $formulario["descripcion"] = "";

    $_SESSION["formulario"] = $formulario;
} else {
    $formulario = $_SESSION["formulario"];
}

if (isset($_SESSION["errores"])) {
    $errores = $_SESSION["errores"];
    unset($_SESSION["errores"]);
} elseif (isset($_SESSION["correcto"])) {
    $correcto = $_SESSION["correcto"];
    unset($_SESSION["correcto"]);
}
//Se crea la conexion con la BD
$conexion = crearConexionBD();
?>

<!DOCTYPE html>
<html lang="es">

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
            <h3>Ultimas Consultas</h3>

            <div class="scroll">

                <table>
                    <tr>
                        <th>
                            Fecha
                        </th>
                        <th>
                            Tipo
                        </th>
                        <th>
                            Tema
                        </th>
                        <th>
                            Descripcion
                        </th>
                        <th>
                            Respuesta
                        </th>
                    </tr>


                    <?php
                    $Perfil = $_SESSION["Perfil"];
                    $consultas = get_consultas($conexion, $Perfil);

                    if (isset($consultas)) {
                        foreach ($consultas as $consulta) {
                    ?>

                            <tr>
                                <td>
                                    <?php echo $consulta['FECHA'] ?>
                                </td>
                                <td>
                                    <?php echo $consulta['TIPO'] ?>
                                </td>
                                <td>
                                    <?php echo $consulta['TEMA'] ?>
                                </td>
                                <td>
                                    <p class="waiting"><?php echo $consulta['DESCRIPCION'] ?></p>
                                </td>
                                <td>
                                    <b>
                                        <p class="waiting"><?php echo $consulta['RESPUESTA'] ?></p>
                                    </b>
                                </td>
                            </tr>
                    <?php
                        }
                    }
                    ?>

                </table>
            </div>

        </div>
        <div class="smallContainer">
            <h3>Nueva Consulta</h3>
            <?php
            if (isset($errores) && count($errores) > 0) {
                echo "<div class=\"errorBox\">";
                echo "<h4> Errores en el formulario:</h4>";
                foreach ($errores as $error) {
                    if (isset($error)) echo $error;
                }
                echo "</div>";
            }
            if (isset($correcto)) {
                echo "<div class=\"correctBox\">";
                echo "<h4> $correcto </h4>";
                echo "</div>";
            }
            ?>
            <form action="validacionConsulta.php" method="POST">

                <div class="row">
                    <label for="tipo" class="col-25">Tipo:</label>
                    <select required id="tipo" name="tipo" class="col-75">
                        <option value="Medica" <?php if ($formulario['tipo'] == 'Medica') echo ' selected ' ?>>Médica</option>
                        <option value="Dietetica" <?php if ($formulario['tipo'] == 'Dietetica') echo ' selected ' ?>>Dietética</option>
                        <option value="Otro" <?php if ($formulario['tipo'] == 'Otro') echo ' selected ' ?>>Otro</option>
                    </select>
                </div>
                <div class="row">
                    <label for="tema" class="col-25">Tema:</label>
                    <input placeholder="Introduce un tema..." value="<?php echo $formulario["tema"] ?>" type="text" class="col-75" id="tema" name="tema" maxlength="40" placeholder="Introduce un tema...">
                </div>
                <div class="row">
                    <label for="descripcion" class="col-25">Descripción:</label>
                    <textarea required placeholder="Introduce una descripcción..." name="descripcion" maxlength="560" class="col-75"><?php echo $formulario["descripcion"] ?></textarea>
                </div>
                <br>
                <div class="row">
                    <input type="submit">
                </div>
            </form>
        </div>
    </div>
    <?php
    cerrarConexionBD($conexion);
    include_once("footer.php");
    ?>


</body>

</html>