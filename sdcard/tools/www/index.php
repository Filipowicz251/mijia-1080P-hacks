<?php
	if(isset($_GET['IR_OFF']))
			{
				//your code
				shell_exec('echo 0 >> /sys/class/leds/IR/brightness');
			}
	if(isset($_GET['IR_ON']))
			{
				//your code
				shell_exec('echo 1 >> /sys/class/leds/IR/brightness');
			}
?>


<form id="frm" method="post"  action="?IR_OFF" >
<input type="submit" value="IR_OFF" id="submit" />
</form>
<form id="frm" method="post"  action="?IR_ON" >
<input type="submit" value="IR_ON" id="submit" />
</form>
