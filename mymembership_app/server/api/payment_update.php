<?php
error_reporting(0);
include_once("dbconnect.php");

$amount = $_GET['amount'];
$email = $_GET['email'];
$membershipName = $_GET['name'];
$membershipId = $_GET['membership_id'];
$payment_id = $_GET['payment_id'];

// Log incoming data for debugging
error_log("Received GET Data: " . print_r($_GET, true));

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'] === "true" ? "Success" : "Failed";
$receiptid = $_GET['billplz']['id'];

// Generate signature for validation
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'YOUR_XSIGNATURE_KEY');

// Validate signature
if ($signed === $data['x_signature']) {
    if ($paidstatus === "Success") {
        // Payment success, insert record into database
        $sqlinsert = "INSERT INTO membership_payments (payment_status, receipt_id, payment_amount, membership_id) 
                      VALUES ('$paidstatus', '$receiptid', '$amount', '$membershipId')";

        if ($conn->query($sqlinsert) === TRUE) {
            error_log("Payment record inserted successfully");
        } else {
            error_log("Error inserting payment record: " . $conn->error);
        }

        // Generate receipt for successful payment
        generateReceipt($receiptid, $payment_id, $membershipName, $email, $amount, $paidstatus, 'w3-text-green');
    } else {
        // Generate receipt for failed payment
        generateReceipt($receiptid, $payment_id, $membershipName, $email, $amount, $paidstatus, 'w3-text-red');
    }
} else {
    error_log("Signature validation failed.");
    echo "<p>Invalid transaction signature.</p>";
}

// Function to generate receipt
function generateReceipt($receiptid, $payment_id, $membershipName, $email, $amount, $paidstatus, $statusColor) {
    echo "
    <!DOCTYPE html>
    <html lang='en'>
    <head>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: white;
                color: #333;
                margin: 0;
                padding: 0;
            }
            .receipt-container {
                max-width: 380px;
                margin: 50px auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                overflow: hidden;
            }
            .header {
                background: linear-gradient(to right, #673ab7, #607d8b);
                color: white;
                text-align: center;
                padding: 20px;
            }
            .header h4 {
                margin: 0;
                font-size: 24px;
            }
            .table-container {
                padding: 20px;
            }
            .w3-table {
                width: 100%;
                border-collapse: collapse;
            }
            .w3-table th {
                background: #f5f5f5;
                text-align: left;
                padding: 10px;
                font-size: 16px;
            }
            .w3-table td {
                padding: 10px;
                font-size: 14px;
            }
            .w3-table tr:nth-child(even) {
                background: #f9f9f9;
            }
            .footer {
                text-align: center;
                padding: 15px;
                font-size: 14px;
                color: #777;
            }
        </style>
    </head>
    <body>
        <div class='receipt-container'>
            <div class='header'>
                <h4>Receipt</h4>
            </div>
            <div class='table-container'>
                <table class='w3-table w3-striped'>
                    <tr>
                        <th>Item</th>
                        <th>Description</th>
                    </tr>
                    <tr>
                        <td>Receipt</td>
                        <td>$receiptid</td>
                    </tr>
                    <tr>
                        <td>Payment Id</td>
                        <td>$payment_id</td>
                    </tr>
                    <tr>
                        <td>Membership Type</td>
                        <td>$membershipName</td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td>$email</td>
                    </tr>
                    <tr>
                        <td>Paid Amount</td>
                        <td>RM $amount</td>
                    </tr>
                    <tr>
                        <td>Paid Status</td>
                        <td class='$statusColor'>$paidstatus</td>
                    </tr>
                </table>
            </div>
            <div class='footer'>
                Thank you for your payment!
            </div>
        </div>
    </body>
    </html>";
}
?>
