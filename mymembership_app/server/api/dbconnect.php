<?php
$servername = "localhost:3307";
$username   = "root";
$password   = "";
$dbname     = "membership_db";

//database connector
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}//else{
//     echo "Yay";
// } for testing dbconnect working or not (http://192.168.0.159/memberlink/api/dbconnect.php)
?>