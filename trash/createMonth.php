<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
error_reporting(5);
include '../../context.php';

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call createMonth('" . $_POST['id'] . "')";
$result = $conn->query($sql);

if ($result->num_rows > 0) {

    $myJson = array();
    while ($row = $result-> fetch_assoc()) {
        $json->id = $row['id'];
        $json->name = $row['name'];
        $json->start = $row['start'];
        $json->end = $row['end'];
        $json->salary = $row['salary'];
        $json->totalPay = $row['totalPay'];
        $json->totalPeriod1 = $row['totalPeriod1'];
        $json->totalPayPeriod1 = $row['totalPayPeriod1'];
        $json->totalPayedPeriod1 = $row['totalPayedPeriod1'];
        $json->enableMoneyPeriod1 = $row['enableMoneyPeriod1'];
        $json->totalPeriod2 = $row['totalPeriod2'];
        $json->totalPayPeriod2 = $row['totalPayPeriod2'];
        $json->totalPayedPeriod2 = $row['totalPayedPeriod2'];
        $json->enableMoneyPeriod2 = $row['enableMoneyPeriod2'];
        $json->period = $row['period'];
        $myJson[] = json_encode($json);
    }

    echo jsonFormat(json_encode($myJson));
} else {
    echo '[{"error":"No results"}]';
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