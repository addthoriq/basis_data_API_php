<?php

require 'koneksi.php';

$sql = "SELECT get_kode_matkul('Basis Data')";
$res = $koneksi->query($sql);

var_dump($res);