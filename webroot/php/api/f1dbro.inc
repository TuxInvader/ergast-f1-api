<?php
$user="ergast";
$password="f1RuleZ";
$database="ergastdb";
$connection = new mysqli("localhost", $user, $password, $database);
if (!$connection) {
    die('Could not connect: ' . $connection->connect_error());
}
mysqli_set_charset($connection, "utf8");
?>
