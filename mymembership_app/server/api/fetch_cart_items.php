<?php
// Database connection
include_once("dbconnect.php");

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    try {
        // SQL query to fetch all cart items along with product details
        $sql = "SELECT cart_table.quantity, cart_table.added_date, 
                    product_table.product_id, product_table.product_name, 
                    product_table.product_type, product_table.product_price, 
                    product_table.product_filename 
                FROM cart_table 
                INNER JOIN product_table 
                ON cart_table.product_id = product_table.product_id
                ORDER BY cart_table.added_date DESC";


        $result = $conn->query($sql);

        // Check if the query executed successfully
        if ($result === false) {
            // Output the error message for debugging
            $response = array('status' => 'failed', 'data' => null, 'error' => $conn->error);
            sendJsonResponse($response);
            exit; // Stop further execution
        }

        if ($result->num_rows > 0) {
            $cartItems['cart'] = array();
            while ($row = $result->fetch_assoc()) {
                $cart = array();
                $cart['product_id'] = $row['product_id'];
                $cart['product_name'] = $row['product_name'];
                $cart['product_type'] = $row['product_type'];
                $cart['added_date'] = $row['added_date'];
                $cart['product_price'] = $row['product_price'];
                $cart['quantity'] = $row['quantity'];
                $cart['product_filename'] = $row['product_filename'];
                array_push($cartItems['cart'], $cart);
            }
            $response = array('status' => 'success', 'data' => $cartItems);
            sendJsonResponse($response);
        } else {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array('status' => 'failed', 'data' => null, 'error' => $e->getMessage());
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>