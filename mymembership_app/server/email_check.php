<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$email = $_POST['email'];

$sqlcheck = "SELECT `user_email` FROM `users_table` WHERE `user_email` = '$email'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {
    $response = array('status' => 'exist', 'data' => null); 
    sendJsonResponse($response); 
}else{
    $response = array('status' => 'available', 'data' => null); 
    sendJsonResponse($response); 
}


function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>