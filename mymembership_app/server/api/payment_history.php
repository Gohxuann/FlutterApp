<?php
error_reporting(0);
include_once("dbconnect.php");

// Updated SQL query with correct column names
$sql = "SELECT mp.payment_id, mp.receipt_id, mp.payment_status, 
               mp.payment_amount as amount, mp.paid_at as payment_date,
               mt.membership_name, mt.membership_price
        FROM membership_payments mp 
        LEFT JOIN memberships_table mt ON mp.membership_id = mt.membership_id 
        ORDER BY mp.paid_at DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $payments = array();
    while ($row = $result->fetch_assoc()) {
        $payments[] = array(
            'payment_id' => $row['payment_id'],
            'receipt_id' => $row['receipt_id'],
            'payment_status' => $row['payment_status'],
            'amount' => $row['amount'],
            'membership_name' => $row['membership_name'] ?? 'N/A',
            'payment_date' => $row['payment_date']
        );
    }
    echo json_encode(array("status" => "success", "data" => $payments));
} else {
    echo json_encode(array("status" => "failed", "data" => null));
}

$conn->close();
?>