<?php

// Billplz API Configuration
$api_key = 'YOUUR_API_KEY';
$collection_id = 'YOUR_COLLECTION_ID';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Get POST data
$email = $_GET['email'] ?? '';
$amount = $_GET['amount'] ?? '';
$membershipName = $_GET['membershipName'] ?? '';
$membershipId = $_GET['membershipId'] ?? '';


// Validate required fields
// if (!$email || !$amount || !$name || !$membershipId) {
//     echo json_encode(['error' => 'Missing required fields']);
//     exit;
// }

// Create bill data
$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'name' => $membershipName,
    'amount' => $amount * 100, // Convert to cents
    'membership_id' => $membershipId,
    'redirect_url' => "https://mymember.threelittlecar.com/membership/api/payment_update.php?email=$email&amount=$amount&name=$membershipName&membership_id=$membershipId",
    'callback_url' => "https://mymember.threelittlecar.com/return_url",
    'description' => "Payment for $name membership"
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) );

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    $error_message = isset($bill['error']) ? (is_array($bill['error']) ? print_r($bill['error'], true) : $bill['error']) : 'Unknown error';
    die("Error creating bill: $error_message");
}

?>