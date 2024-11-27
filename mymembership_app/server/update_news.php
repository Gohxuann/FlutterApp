<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$newsid = $_POST['newsid'];
$title = addslashes($_POST['title']);
$description =addslashes( $_POST['description']);

$sqlupdatenews="UPDATE `news_table` SET `news_title`='$title',`news_des`='$description' WHERE `news_id` = '$newsid'";

if ($conn->query($sqlupdatenews) === TRUE) {
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