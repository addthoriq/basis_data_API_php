<?php

$server = "127.0.0.1";
$db = "tugas_pbd";
$usr = "root";
$pass = "";

$koneksi = new mysqli($server, $usr, $pass, $db);

if ($koneksi->connect_error) {
  die("Koneksi Gagal:" . $koneksi->connect_error);
}