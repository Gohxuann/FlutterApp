<?php
// Database connection
include_once("dbconnect.php");
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get product_id and new quantity from POST request
        $product_id = $_POST['product_id'];
        $quantity = $_POST['quantity'];

        // Validate input
        if (empty($product_id) || empty($quantity)) {
            echo json_encode(['status' => 'error', 'message' => 'Invalid input']);
            exit();
        }

        // Check if the product exists in the cart
        $check_query = "SELECT * FROM `cart_table` WHERE `product_id` = '$product_id'";
        $check_result = $conn->query($check_query);

        if ($check_result->num_rows > 0) {
            // Update quantity in cart
            $update_query = "UPDATE `cart_table` SET `quantity` = '$quantity' WHERE `product_id` = '$product_id'";
            
            if ($conn->query($update_query) === TRUE) {
                echo json_encode(['status' => 'success', 'message' => 'Quantity updated successfully']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Failed to update quantity']);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Product not found in cart']);
        }
    } catch (Exception $e) {
        // Handle errors and exceptions
        echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
} else {
    // Invalid request method
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>