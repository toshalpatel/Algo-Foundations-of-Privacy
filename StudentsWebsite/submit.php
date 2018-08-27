<!DOCTYPE html>
<html lang="en">
<?php include 'project_info.php'; ?>
<head>
	<title> <?php echo($course_code); ?> </title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<form method="POST" action="uploadFile.php" enctype="multipart/form-data" onSubmit="return checkform()">
	<?php 	
		$name = $_POST['user']; 
		echo $student_info. $name."</br>";
	
		if(!file_exists($SUBMIT_PATH.$name."/attempt.txt")){
			$attempt = 1;
			mkdir($SUBMIT_PATH.$name, 0777);
			file_put_contents($SUBMIT_PATH.$name."/attempt.txt", $attempt);
			chmod($file, 0777); 
		}
		
		$attempt = file_get_contents($SUBMIT_PATH.$name."/attempt.txt");
		if ((int)$attempt <= 2)	{	
			echo ($attempts_allowed.$attempt."</br>");
	
		echo($upload_text."</br>"); 
		echo($upload_source_code); ?> </br>
		<input type="file" name="source_code" />
	</br></br>
	<?php 
		foreach($solution_file_name as $file_name){
			echo($upload_soln_text.$file_name."</br>");
	?>
			<input type="file" accept='text/*' name="solution_file[]" id="fileinput" onchange="readmultifiles(this.files)" nultiple="" />
			</br></br>
	<?php
		}
	?> 
	
	<script type="text/javascript">
	
		function readmultifiles(files) {
			
			setup_reader(files, 0);
		}

		// Don't define functions in functions in functions, when possible.

		function setup_reader(files, i) {
			var file = files[i];
			var name = file.name;
			var reader = new FileReader();
			reader.onload = function(e){
				                readerLoaded(e, files, i, name);
				            };
			reader.readAsText(file);
		}

		function readerLoaded(e, files, i, name) {
			// get file content  
			var bin = e.target.result;
			//console.log(bin);
			if(bin.match(/^\s*\d[\d\s]*$/)){
			if (i < files.length - 1) {
				// Load the next file
				setup_reader(files, i+1);
			}
			}
			else{
				alert(<?php echo("\"".$invalid_file_format."\""); ?>);
			}
		}
	</script>
	
	<input type="hidden" name="user" value="<?php echo($name); ?>">
	<button type="submit" >
		<?php echo($upload_submit); ?>
	</button>
	<?php } else { echo($attempts_exceeded) ; } ?>
</form>
</body>
</html>
