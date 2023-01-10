<?php

require 'koneksi.php';

$nimMHS = $_POST['nim'];
$kodeMK = $_POST['kode_matkul'];
$nilai = $_POST['nilai'];

$sql = "CALL isi_nilai('$nimMHS', '$nilai', '$kodeMK')";
$koneksi->query($sql);

header('location: post_khs_param.php?nim='.$nimMHS);