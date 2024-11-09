<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$newPassword = sha1($_POST['password']);


$sqlemailcheck = "SELECT `user_email` FROM `users_table` WHERE `user_email` = '$email'";
$result = $conn->query($sqlemailcheck);

if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE `users_table` SET `user_pass`='$newPassword' WHERE `user_email`='$email'";

    if ($conn->query($sqlupdate) === TRUE) {
        // Password updated successfully
        $response = array('status' => 'success', 'data' => null);
    } else {
        // Failed to update the password
        $response = array('status' => 'update_failed', 'data' => null);
    }
}else {
    // Email does not exist in the database
    $response = array('status' => 'no_email', 'data' => null);
}

sendJsonResponse($response); 



function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
