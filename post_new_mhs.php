<?php

require 'koneksi.php';

$nimMHS = $_POST['nim'];
$namaMHS = $_POST['nama_mhs'];
$jkMHS = $_POST['jenis_kelamin'];

$sql = "CALL sp_tambah_mhs('$nimMHS', '$namaMHS', '$jkMHS')";
$koneksi->query($sql);

header("Location: index.php");