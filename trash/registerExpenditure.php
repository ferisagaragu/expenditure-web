<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
error_reporting(5);
include '../../context.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call registerExpenditure('". $_POST['id'] ."', '". $_POST['name'] ."', '". $_POST['expenditure'] ."', '". $_POST['monthPay'] ."')";
$result = $conn->query($sql);

if ($result->num_rows > 0) {

    $myJson = array();
    while ($row = $result-> fetch_assoc()) {
        $json->id = $row['id'];
        $json->expenditureName = $row['expenditureName'];
        $json->period = $row['period'];
        $json->expenditure = $row['expenditure'];
        $json->expenditureMonth = $row['expenditureMonth'];
        $json->expenditureMonthPayed = $row['expenditureMonthPayed'];
        $json->monthPay = $row['monthPay'];
        $json->monthPayed = $row['monthPayed'];
        $json->expenditureDate = $row['expenditureDate'];
        $json->isPayed = $row['isPayed'];
        $myJson[] = json_encode($json);
    }

    echo jsonFormat(json_encode($myJson));
} else {
    echo '[{"error":"' . $result . '"}]';
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