<!DOCTYPE html>
<html lang="en">
<head>
<?php include 'project_info.php'; ?>
	<title> <?php echo($course_code); ?> </title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<form action="verify.php" method="post">

		<?php echo($project_title); ?> </br>

		<?php echo($login_text); ?>
	<div  data-validate = "Field is required">
		<input type="text" id="rid" name="randomno"> </br>
	</div>
		<button type="submit" id="submit"> <?php echo($login_buton); ?> </button>
</form>
</body>
</html>
