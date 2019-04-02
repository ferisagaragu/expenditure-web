<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
error_reporting(5);
include '../../context.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call updateSalary('". $_POST['id'] ."','". $_POST['salary'] ."')";
$result = $conn->query($sql);
echo $result;
$conn->close();


