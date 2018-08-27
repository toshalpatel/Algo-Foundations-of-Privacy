<?php

#text in the html
$course_code = "CS4257";
$project_title = "Project 2 Submission";
$login_text = "Enter your RANDOM-ID";
$login_buton = "Login";
$login_user_info = "Random-ID: ";
$login_success = "Welcome, ";
$login_success_verify_text = "(If you are not the above student, please re-login. Thank you!)";
$login_success_button = "Proceed";
$login_fail = "</br> Student does not exist! Please retry. </br>";
$login_fail_button = "Retry";

$file_open_fail = "Cannot open the file.";
$file_upload_error = "Cannot upload your file ";
$invalid_file_format= "Invalid format of the file. Each line should contain only user-id in numeric format.";

$upload_text = "Upload your solutions:";
$upload_source_code = "Upload your source code:";
$upload_soln_text = "Upload the solution of ";
$upload_submit = "Submit";
$upload_successful = "File has been uploaded!";
$upload_unsuccessful = "File could not be uploaded. Please try again.";

$solution_file_name = array('cut', 'obf1', 'obf2', 'sub');
$solution_text = "Accuracy (%) for ";

$attempts_allowed = "Attempt ";
$attempts_exceeded = "Number of attempts exceeded!";
$student_info = "Student name: ";

#Paths to the directories
$SUBMIT_PATH = "/var/www/html/uploads/";
$ANSWER_PATH = "/var/www/html/ans_keys/";
$students_csvFile = '/var/www/html/students.csv';

$ans_file = array('cut'=>$ANSWER_PATH.'cut_ans.txt', 'obf1'=>$ANSWER_PATH.'obf1_ans.txt','obf2'=>$ANSWER_PATH.'obf2_ans.txt','sub'=>$ANSWER_PATH.'sub_ans.txt');

?>
