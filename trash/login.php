<?php
//Creado por Fernando Isaías García Aguirre
header("Content-Type: text/html; charset=utf-8");
include '../../context.php';
error_reporting(5);

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("'error': '" . $conn->connect_error . "'");
}

$sql = "call login('". $_POST['user'] ."','" . $_POST['password'] . "');";
$result = $conn->query($sql);

if ($result-> num_rows > 0) {

    $myJson = array();
    while ($row = $result-> fetch_assoc()) {
        $json->id = $row['id'];
        $json->user = $row['user'];
        $json->password = $row['password'];
        $json->email = $row['email'];
        $json->active = $row['active'];
        $json->firstname = $row['firstname'];
        $json->lastname = $row['lastname'];
        $myJson[] = json_encode($json);
    }

    echo jsonFormat(json_encode($myJson));
} else {
    echo '[{"error":"' . $result . '"}]';
}

echo $result-> num_rows === 0;

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
