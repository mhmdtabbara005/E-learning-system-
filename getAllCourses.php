<?php 

include "connection.php";

$query = $connection->prepare("SELECT * FROM courses");

$query->execute();

$result = $query->get_result();

if($result->num_rows != 0) {
    $courses = [];
    while($course = $result->fetch_assoc())
    {
        $courses[]=$course;
    }
    

    http_response_code(200);
    echo json_encode([
        "message"=>"Retrieved all courses successfully",
        "courses"=>$courses
    ]);

} 
else {
    http_response_code(404);

    echo json_encode([
    "message" => "All Courses not found"
    ]);
}

