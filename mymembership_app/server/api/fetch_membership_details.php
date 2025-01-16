<?php
include_once("dbconnect.php");

if (isset($_GET['membership_id'])) {
    $membership_id = intval($_GET['membership_id']); // Ensure it’s an integer

    // Debugging: Log incoming membership_id
    error_log("Received membership_id: $membership_id");

    $sql = "SELECT * FROM `memberships_table` WHERE membership_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $membership_id);

    if ($stmt->execute()) {
        $result = $stmt->get_result();

        // Check if data exists
        if ($result->num_rows > 0) {
            $data = $result->fetch_assoc();

            // Debugging: Log fetched data
            error_log("Fetched data: " . json_encode($data));

            echo json_encode(["status" => "success", "data" => $data]);
        } else {
            // No record found
            error_log("No record found for membership_id: $membership_id");
            echo json_encode(["status" => "failed", "message" => "No details found"]);
        }
    } else {
        // SQL execution failed
        error_log("SQL Error: " . $stmt->error);
        echo json_encode(["status" => "failed", "message" => "SQL Error"]);
    }

    $stmt->close();
} else {
    // Missing parameter
    error_log("Error: membership_id parameter is missing");
    echo json_encode(["status" => "failed", "message" => "Invalid request"]);
}

$conn->close();
?>
