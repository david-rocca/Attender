<?php
	class Database {
		static private $handle;

		function Database() {

		}

		public function connect() {
			$connection = new mysqli("146.115.94.121", "datacom", "helloworld", "Attender");
			if ($connection->connect_errno) {
				echo "Failed to connect to MySQL: (" . $conection->connect_errno . ") " . $connection->connect_error;
			} else {
				//$arr = array("response" => "YAY");
				//echo json_encode($arr);
			}
			self::$handle = $connection;
		}

		 public function disconnect() {
	     	echo "<br>Closing Connection.";
	     	self::$handle->close();
	    }

	    public function createUser($params) {
	    	$temp = json_decode($params);
	    	$arr = array("response" => "success", "params" => "$temp");
	    	echo json_encode($arr);
	    }
	}



	$type = $_POST['type'];
	$params = $_POST['params'];
	$methodName = $_POST['method'];
	$dataBaseHandle = new Database();
	if ($type != 'rocca') {
		$arr = array("response" => "Failure", "Note" => "Bad request type");
		echo json_encode($arr);
	} else {
		if ($methodName = 'createUser') {
			$dataBaseHandle->createUser($params);
		}
	}












?>