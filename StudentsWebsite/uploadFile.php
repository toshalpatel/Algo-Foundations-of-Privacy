<!DOCTYPE html>
<html lang="en">
<?php include 'project_info.php'; ?>
<head>
	<title><?php echo($course_code); ?></title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<?php
	$name = $_POST['user'];
	$no_of_attempt = file_get_contents($SUBMIT_PATH.$name."/attempt.txt");
	if ((int)$no_of_attempt <=2){
		echo $attempts_allowed.$no_of_attempt."</br>";
		$no_of_attempt = (int)$no_of_attempt;
		
		$target_dir = $SUBMIT_PATH.$name."/attempt_".$no_of_attempt."/";
		if ( !file_exists($target_dir) ) {
			 $oldmask = umask(0); 
			 mkdir ($target_dir, 0744);
		}
				
		$no_of_attempt++;
		file_put_contents($SUBMIT_PATH.$name."/attempt.txt", $no_of_attempt);
	
		
		$target_file = $target_dir . basename($_FILES['source_code']['name']);
		if (move_uploaded_file($_FILES['source_code']['tmp_name'], $target_file)) {
			echo $_FILES['source_code']['name']." : ".$upload_successful."</br></br>";
		} else {
			echo $upload_unsuccessful." error:".$_FILES['source_code']['error'];
		}
				
		$result = "";
		$i=0;
		foreach($_FILES['solution_file']['tmp_name'] as $key => $tmp_name){
			$target_file = $target_dir."_".$solution_file_name[$i]."_".basename($_FILES['solution_file']['name'][$key]);
			if (move_uploaded_file($_FILES['solution_file']['tmp_name'][$key], $target_file)) {
				echo $solution_file_name[$i]." : ".basename($_FILES['solution_file']['name'][$key])." : ".$upload_successful."</br>";
				$correct_key = file($ans_file[$solution_file_name[$i]]);
				$correct = 0;
				$k=0;
				$key = file($target_file);
				$total_keys = sizeof($correct_key);
				foreach($key as $ans){
					if((int)$correct_key[$k] === (int)$ans){
						$correct++;
					}
					$k++;
				}
				$accuracy = (((float)$correct)/$total_keys) * 100;
				$result = $result.$solution_text.$solution_file_name[$i]." ".$accuracy."\n";
				echo $solution_text.$solution_file_name[$i]." ".$accuracy."</br>";
				$i++;
			} else {
				echo $upload_unsuccessful." error:". $_FILES['obf1_file']['error'];
			}
		}
		$target_file = $target_dir . "accuracy.txt";
		if(!file_exists($target_file)){
			file_put_contents($target_file, $result);
			chmod($file, 0777); 
		} else{
			file_put_contents($target_file, $result);
		}
	}
	else { echo($attempts_exceeded) ; }
?>

</body>
</html>
