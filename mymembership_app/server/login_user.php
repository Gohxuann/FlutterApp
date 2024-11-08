<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}//just for safeguard (mostly API return json file)

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);//start with '$' = variable

$sqllogin = "SELECT `user_email`, `user_pass` FROM `users_table` WHERE `user_email`= '$email' AND `user_pass`= '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $response = array('status' => 'success', 'data' => null); 
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>