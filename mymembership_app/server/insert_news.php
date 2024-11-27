<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$title = addslashes($_POST['title']);
$description =addslashes( $_POST['description']);

$sqlinsertnews="INSERT INTO `news_table`(`news_title`, `news_des`) VALUES ('$title','$description')";


if ($conn->query($sqlinsertnews) === TRUE) {
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