<?php
include_once("dbconnect.php");

$sql = "SELECT * FROM `memberships_table`";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $data]);
} else {
    echo json_encode(["status" => "fail", "message" => "No memberships found"]);
}
$conn->close();
?>
