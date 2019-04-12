<?php
header("Content-Type: text/html; charset=utf-8");
include '../../context.php';
$pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

$sql = "call registerUser('". $_POST['user'] ."','". $_POST['email'] ."','". $_POST['password'] ."','". $_POST['firstname'] ."','". $_POST['lastname'] ."',@res)";

$stmt = $pdo -> prepare($sql);
$stmt -> execute();
$stmt -> closeCursor();

$row = $pdo -> query("SELECT @res AS result") -> fetch(PDO::FETCH_ASSOC);
if ($row) {
    echo $row !== false ? $row['result'] : null;
}


