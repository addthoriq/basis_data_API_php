<?php

require 'koneksi.php';

$nimMHS = $_POST['nim'];
$kdMK = $_POST['kode_matkul'];
$smt = $_POST['smt'];
$ta = $_POST['tahun_ajaran'];

$sql = "CALL tambah_krs('$nimMHS', '$kdMK', '$smt', '$ta')";
$koneksi->query($sql);

header('location: index.php');