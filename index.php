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
	    	self::connect();
	    	$sqlInsert = "INSERT INTO users (uname, password, email) VALUES ('$uname', '$password', '$email')";

	    	if (self::$handle->query($sqlInsert) === TRUE) {
	    		$arr = array("response" => "success", "email" => "$email", "password" => "$password");
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
						$arr = array("response" => "success, Logged in", "email" => "$email", "password" => "$password");
	    				echo json_encode($arr);
					} else {
						$arr = array("response" => "failed", "data" => "Wrong password $password");
	    				echo json_encode($arr);
					}
				}
			} else {
				$arr = array("response" => "failed", "data" => "noAccount");
	    		echo json_encode($arr);
			}

	    	self::disconnect();
	    }


	    public function createSession($email) {
	    	$random = rand(100000, 999999);

	    	$sql = "SELECT * from users WHERE email = '" . $random . "'";

	    	self::connect();

	    	$result = self::$handle->query($sql);
	    	while ($result->num_rows > 0) {
	    		$random = rand(100000, 999999);
	    		$result = self::$handle->query($sql);
	    	}
	    		


	    	/*
	    		Currently not checking if you were already the owner of another session or if you were in another session.
	    		This will need to be added. Probably with a join of some sort.
	    	*/

	    	$sql = "UPDATE users SET sessionID = '" . $random . "'" . ", isOwner = '" . TRUE . "', isInSession = '" . TRUE . "' WHERE email = '" . $email . "'";
	    	self::$handle->query($sql);


	    	self::disconnect();


	    	$arr = array("response" => "Suceeded", "data" => "$sql");
	    	echo json_encode($arr);
	    	
	    }



	    public function joinSession($email, $sessionNumber) {

	    	$sql = "UPDATE users SET sessionID = '" . $sessionNumber . "', isInSession = '" . TRUE . "' WHERE email = '" . $email . "'";

	    	self::connect();
	    	self::$handle->query($sql);
	    	self::$disconnect();



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
			$dataBaseHandle->createSession($email);
		}
	}

?>