<!DOCTYPE html>
<html lang="en">
<?php include 'project_info.php'; ?>	
<head>
	<title> <?php echo($course_code); ?> </title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<form method="POST" >
	<?php
		$rid = $_POST['randomno'];
		$k=0;
		if (($handle = fopen($students_csvFile, "r")) !== FALSE) {
		  while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
			$num = count($data);
			$user[$k] = $data;
			$k++;
		  }
		  fclose($handle);
		}
		else { echo($file_open_fail); }
		
		echo ($login_user_info.$rid);
		#$rid = (int) $rid;
		$n=0;
		foreach ($user as $stu){
			$stu_name[$n] = $stu[0];
			if($stu[3] === $rid)
				$name = $stu[0];
			$n++;
		}
		
		if(in_array($name,$stu_name))
		{
			echo ("</br>".$login_success.$name);
			echo ("</br>".$login_success_verify_text);
	?>
		<input type="hidden" name="user" value="<?php echo($name) ?>">
		</br></br>
		<button formaction="submit.php"> <?php echo($login_success_button); ?> </button>
		<button formaction="index.php"> <?php echo($login_fail_button); ?> </button>
	<?php
	} else {
		echo ($login_fail);
	?>
	<button formaction="index.php"> <?php echo($login_fail_button);?> </button>
	<?php } ?>
</form>
</body>
</html>
