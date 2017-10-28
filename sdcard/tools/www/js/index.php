<?php

require_once('jsonserver.php');
require_once('data.php');

class Service
{
	public function __construct()
	{
	}

	/**
	 * @param string $soundfile .
	 * @return boolean .
	 */

	public function PlaySound($soundfile)
	{
		$path = '/mnt/data/sound/'.basename($soundfile);
		if(!file_exists($path)) throw new JsonFault(JF_INVALID_ARG, $soundfile);
		shell_exec("echo '$path' > /tmp/sound_fifo");
		return true;
	}
}

JSONServer::Run('Mijia', 'Service');

?>