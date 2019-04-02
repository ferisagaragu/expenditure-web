<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
include 'your path';

$pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);

$sql = "your statement here";

$stmt = $pdo -> prepare($sql);
$stmt -> execute();
$stmt -> closeCursor();

$row = $pdo -> query("call params from your statement") -> fetch(PDO::FETCH_ASSOC);
if ($row) {
    echo $row !== false ? $row['your row name'] : null;
}
