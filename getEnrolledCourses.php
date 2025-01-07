<?php 

$query = $connection->prepare("SELECT c.*,u.first_name,u.last_name FROM courses as c INNER JOIN enrollments as e on c.course_id=e.course_id 
                                INNER JOIN users as u on c.instructor_id=u.user_id where e.user_id=? and e.is_enrolled=1;");
$query->bind_param("i", $id);




if($query->execute()) {
    $result = $query->get_result();
    $courses = [];
    while($course = $result->fetch_assoc())
    {
        $courses[]=$course;
    }
    

    http_response_code(200);
    echo json_encode([
        "message"=>"Retrieved enrolled courses successfully",
        "courses"=>$courses
    ]);

} 
else {
    http_response_code(404);

    echo json_encode([
    "message" => "Courses of student not found"
    ]);
}

