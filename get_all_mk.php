<?php

require 'koneksi.php';

$sql = "CALL get_all_mk()";
$res = $koneksi->query($sql);

if ($res->num_rows > 0) {
  while ($row = $res->fetch_assoc()) {
      // Convert Array to String
      $rowArr = implode(" ", $row);
      // Convert String to Object
      $obj = json_decode($rowArr);
      var_dump($obj);
    }
}
