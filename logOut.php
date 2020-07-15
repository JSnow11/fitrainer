<?php
session_start();
unset($_SESSION["Perfil"]);
unset($_SESSION['login']);
unset($_SESSION['ADMIN']);
Header("Location: login.php");
?>