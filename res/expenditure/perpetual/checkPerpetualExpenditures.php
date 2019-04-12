<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
error_reporting(5);
include '../../../context.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call expenditure.checkPerpetualExpenditure('". $_POST['id'] ."','". $_POST['status'] ."','". $_POST['monthsId'] ."')";
$result = $conn->query($sql);

if ($result->num_rows > 0) {

    $myJson = array();
    while ($row = $result-> fetch_assoc()) {
        $json->id = $row['id'];
        $json->name = $row['name'];
        $json->payDate = $row['payDate'];
        $json->cost = $row['cost'];
        $json->total = $row['total'];
        $json->status = $row['status'];
        $json->monthsFk = $row['monthsFk'];
        $myJson[] = json_encode($json);
    }

    echo jsonFormat(json_encode($myJson));
} else {
    echo '';
}

$conn->close();

function jsonFormat($string) {
    $bad_chars = "\\";
    $keywords = str_replace($bad_chars, '', $string);
    $bad_chars2 = '"{';
    $keywords = str_replace($bad_chars2, '{', $keywords);
    $bad_chars3 = '}"';
    $keywords = str_replace($bad_chars3, '}', $keywords);
    return $keywords;
}
