<?php
// Database connection
include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $product_id = $_POST['product_id'];
    $quantity = $_POST['quantity'];

    // Validate input
    if (empty($product_id) || empty($quantity)) {
        echo json_encode(["status" => "error", "message" => "Missing required data"]);
        die();
    }

    // Check if the product exists in the product_table
    $product_check_query = "SELECT * FROM `product_table` WHERE `product_id` = '$product_id'";
    $product_check_result = $conn->query($product_check_query);

    if ($product_check_result->num_rows > 0) {
        // Product exists, now check if it's already in the cart
        $cart_check_query = "SELECT * FROM `cart_table` WHERE `product_id` = '$product_id'";
        $cart_check_result = $conn->query($cart_check_query);

        if ($cart_check_result->num_rows > 0) {
            // Product is already in the cart, update the quantity
            $cart_row = $cart_check_result->fetch_assoc();
            $new_quantity = $cart_row['quantity'] + $quantity;

            $update_cart_query = "UPDATE `cart_table` SET `quantity` = '$new_quantity' WHERE `product_id` = '$product_id'";
            if ($conn->query($update_cart_query) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Quantity updated in cart"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to update cart"]);
            }
        } else {
            // Product is not in the cart, insert it
            $insert_cart_query = "INSERT INTO `cart_table`(`product_id`, `quantity`) VALUES ('$product_id', '$quantity')";
            if ($conn->query($insert_cart_query) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Product added to cart"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Failed to add product to cart"]);
            }
        }
    } else {
        // Product does not exist in the product_table
        echo json_encode(["status" => "error", "message" => "Product not found"]);
    }

    // Close the database connection
    $conn->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
}
?>
