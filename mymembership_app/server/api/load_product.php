<?php

include_once("dbconnect.php");

$results_per_page = 4;
if (isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

$sqlloadproduct = "SELECT * FROM `product_table` ORDER BY `product_date` DESC";
$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct." LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
    $productarray['product'] = array();
    while ($row = $result->fetch_assoc()) {
        $product = array();
        $product['product_id'] = $row['product_id'];
        $product['product_name'] = $row['product_name'];
        $product['product_description'] = $row['product_description'];
        $product['product_type'] = $row['product_type'];
        $product['product_price'] = $row['product_price'];
        $product['product_filename'] = $row['product_filename'];
        $product['product_rate'] = $row['product_rate'];
        $product['product_date'] = $row['product_date'];
        array_push($productarray['product'], $product);
    }
    $response = array('status' => 'success', 'data' => $productarray,'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
    sendJsonResponse($response);
}
	
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>