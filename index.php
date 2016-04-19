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
	     	self::$handle->close();
	    }

	    public function createUser($uname, $email, $password) {
	    	
	    	$sqlInsert = "INSERT INTO users (uname, password, email) VALUES ('$uname', '$password', '$email')";
			self::connect();
	    	if (self::$handle->query($sqlInsert) === TRUE) {
	    		$arr = array("response" => "success", "method" => "createUser", "email" => "$email", "password" => "$password");
	    		echo json_encode($arr);
	    	} else {
	    		$arr = array("response" => self::$handle->error);
	    		echo json_encode($arr);
	    	}
	    	self::disconnect();
	    }


	    public function logIn($email, $password) {
	    	$sql = "SELECT * from users WHERE email = '" . $email . "'";

	    	self::connect();
			$result = self::$handle->query($sql);

			if ($result->num_rows == 1) {
				while($row = $result->fetch_assoc()) {
					if ($row["password"] == $password) {
						$arr = array("response" => "success", "method" =>  "logIn", "email" => "$email", "password" => "$password");
	    				echo json_encode($arr);
					} else {
						$arr = array("response" => "failed", "method" => "logIn", "data" => "Wrong password $password");
	    				echo json_encode($arr); 
					}
				}
			} else {
				$arr = array("response" => "failed", "method" =>  "logIn", "data" => "noAccount");
	    		echo json_encode($arr);
			}

	    	self::disconnect();
	    }


	    public function createSession($email, $locationX, $locationY) {
	    	$random = rand(100000, 999999);

	    	$sql = "SELECT * from users WHERE email = '" . $random . "'";

	    	self::connect();

	    	$result = self::$handle->query($sql);
	    	while ($result->num_rows > 0) {
	    		$random = rand(100000, 999999);
	    		$result = self::$handle->query($sql);
	    	}
	    		

	    	$flocationX = floatval($locationX);
	    	$flocationY = floatval($locationY);
	    	/*
	    		Currently not checking if you were already the owner of another session or if you were in another session.
	    		This will need to be added. Probably with a join of some sort.
	    	*/

	    	$sql = "UPDATE users SET sessionID = '" . $random . "'" . ", isOwner = '" . TRUE . "', isInSession = '" . TRUE . "', locationX = '" . $flocationX . "', locationY = '" . $flocationY . "' WHERE email = '" . $email . "'";
	    	self::$handle->query($sql);


	    	self::disconnect();


	    	$arr = array("response" => "success", "method" => "createSession", "data" => "$random", "sqlData" => "$sql");
	    	echo json_encode($arr);
	    	
	    }



	    public function joinSession($email, $locationX, $locationY, $sessionNumber) {


	    	$sql = "SELECT * from users WHERE sessionID = '" . $sessionNumber . "' AND isOwner = '1'";

	    	self::connect();
	    	$result = self::$handle->query($sql);


	    	
	    	if ($result->num_rows > 0) {
	    		while ($row = $result->fetch_assoc()) {
	    			$meters = self::haversineGreatCircleDistance($row["locationX"], $row["locationY"], $locationX, $locationY);

	    			if($meters <= 100) {
	    				//In Range
	    				$sql = "UPDATE users SET sessionID = '" . $sessionNumber . "', isInSession = '" . TRUE . "', locationX = '" . $locationX . "', locationY = '" . $location . "' WHERE email = '" . $email . "'";
	    				self::$handle->query($sql);


	    				$arr = array("response" => "success", "method" => "joinSession", "data" => "joined", "distance" => "$meters");
	    				echo json_encode($arr);
	    				self::disconnect();
	    			} else {
	    				//Out of range
	    				$arr = array("response" => "failure", "method" => "joinSession", "data" => "outOfRange", "distance" => "$meters");
	    				echo json_encode($arr);
	    				self::disconnect();
	    			}

	    		}
	    	} else {
	    		//No Session found
	    		$arr = array("response" => "failure", "method" => "joinSession", "data" => "No session");
	    		echo json_encode($arr);
	    		self::disconnect();
	    	}
	    }



	    private function haversineGreatCircleDistance ($latitudeFrom, $longitudeFrom, $latitudeTo, $longitudeTo, $earthRadius = 6371000) {
		  	// convert from degrees to radians
		  	$latFrom = deg2rad($latitudeFrom);
		  	$lonFrom = deg2rad($longitudeFrom);
		  	$latTo = deg2rad($latitudeTo);
		  	$lonTo = deg2rad($longitudeTo);

		  	$latDelta = $latTo - $latFrom;
		  	$lonDelta = $lonTo - $lonFrom;

		  	$angle = 2 * asin(sqrt(pow(sin($latDelta / 2), 2) + cos($latFrom) * cos($latTo) * pow(sin($lonDelta / 2), 2)));
		  	return $angle * $earthRadius;
		}
	}



	$type = $_POST['type'];
	$methodName = $_POST['method'];


	$dataBaseHandle = new Database();
	if ($type != 'rocca') {
		$arr = array("response" => "Failure", "Note" => "Bad request type");
		echo json_encode($arr);
	} else {
		if ($methodName == 'createUser') {
			$email = $_POST['email'];
			$uname = $_POST['uname'];
			$password = $_POST['password'];
			$dataBaseHandle->createUser($uname, $email, $password);
		} else if ($methodName == 'logIn') {
			$email = $_POST['email'];
			$password = $_POST['password'];
			$dataBaseHandle->logIn($email, $password);
		} else if ($methodName == 'createSession') {
			$email = $_POST['email'];
			$locationX = $_POST['latitude'];
			$locationY = $_POST['longitude'];
			$dataBaseHandle->createSession($email, $locationX, $locationY);
		} else if ($methodName == 'joinSession') {
			$email = $_POST['email'];
			$locationX = $_POST['latitude'];
			$locationY = $_POST['longitude'];
			$sessionNumber = $_POST['sessionNumber'];
			$dataBaseHandle->joinSession($email, $locationX, $locationY, $sessionNumber);
		}
	}





?>