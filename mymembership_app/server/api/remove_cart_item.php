<?php
// Database connection
include_once("dbconnect.php");
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Get product_id to remove from POST request
        $product_id = $_POST['product_id'];

        // Validate input
        if (empty($product_id)) {
            echo json_encode(['status' => 'error', 'message' => 'Invalid product ID']);
            exit();
        }

        // Check if the product exists in the cart
        $check_query = "SELECT * FROM `cart_table` WHERE `product_id` = '$product_id'";
        $check_result = $conn->query($check_query);

        if ($check_result->num_rows > 0) {
            // Remove product from cart
            $remove_query = "DELETE FROM `cart_table` WHERE `product_id` = '$product_id'";
            
            if ($conn->query($remove_query) === TRUE) {
                echo json_encode(['status' => 'success', 'message' => 'Product removed from cart']);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Failed to remove product from cart']);
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

$conn->close();
?>