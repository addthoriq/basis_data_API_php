<?php

require 'koneksi.php';

$kdMK = $_POST['kode_matkul'];
$nmMK = $_POST['nama_matkul'];
$sksMK = $_POST['sks'];

$sql = "CALL sp_tambah_mk('$kdMK', '$nmMK', $sksMK)";
$koneksi->query($sql);

header('location: index.php');