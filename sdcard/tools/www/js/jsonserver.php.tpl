<?php

class %SERVICENAME%Service
{
	var $sessionId = null;

	public function __call($name, $arguments)
	{
		$params = array();

		$params['method'] = $name;

		if($name == 'InitiateSession')
		{
			$this->sessionId = null;

			$params['version']['name'] = '%CLIENTNAME%';
		}
		else if(!empty($this->sessionId))
		{
			$params['sessionId'] = $this->sessionId;
		}

		foreach($arguments as $arg)
		{
			foreach($arg as $k => $v) $params[$k] = $v;
		}

		$options = array(
			'http' => array(
				'method' => 'POST',
				'header'=> "Content-type: application/x-www-form-urlencoded\r\n",
				'content' => http_build_query($params)
				)
			);

		$context = stream_context_create($options);

		$res = file_get_contents('%URL%', false, $context);

		if(!empty($res))
		{
			$res = json_decode($res); 

			if($name == 'InitiateSession')
			{
				$this->sessionId = $res;
			}
		}

		return $res;
	}
        
	public static function __callStatic($name, $arguments)
	{
		$svc = new %SERVICENAME%Service();

		return $svc->__call($name, $arguments);
	}%MEMBERS%
}

?>