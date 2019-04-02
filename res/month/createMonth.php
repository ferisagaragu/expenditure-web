<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
include '../../context.php';
error_reporting(5);

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call createMonth('" . $_POST['id'] . "');";
$result = $conn->query($sql);
echo $result;
$conn->close();

