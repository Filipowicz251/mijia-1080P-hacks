<?php ?>
<html>
<head>
	<title>Mijia</title>
	<script src="/js/jquery.js" type="text/javascript"></script>
	<script src="/js/svc.js" type="text/javascript"></script>
	<script type="text/javascript">

	function PlaySound(s) 
	{
		var svc = new MijiaService(); 

		svc.PlaySound(
			null, 
			function(xhr, ajaxOptions, thrownError) {alert(xhr.responseText);}, 
			s);
	}

	</script>
</head>
<body>
	<a href="/media">media</a>
	<a href="phpinfo.php">phpinfo</a>
	<a href="javascript:void(0);" onclick="PlaySound('ding'); return false;">ding</a>
</body>
</html>