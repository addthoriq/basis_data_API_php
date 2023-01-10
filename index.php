<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>

<body>

  <h1>Tambah Mahasiswa</h1>
  <form action="post_new_mhs.php" method="post">
    <input type="text" name="nim" placeholder="Masukkan Nim maximal: 9 digit">
    <input type="text" name="nama_mhs" placeholder="Masukkan Nama maximal: 50 huruf">
    <label for="l">
      <input type="radio" name="jenis_kelamin" value="L" id="l">
      Laki-Laki
    </label>
    <label for="p">
      <input type="radio" name="jenis_kelamin" value="P" id="p">
      Perempuan
    </label>
    <button type="submit">Submit</button>
  </form>

  <h1>List Mahasiswa</h1>
  <?php
  require 'get_all_mhs.php';
  ?>

  <h1>Tambah Mata Kuliah</h1>
  <form action="post_mk.php" method="POST">
    <input type="text" name="kode_matkul" placeholder="Masukkan Kode Matkul max: 5 huruf">
    <input type="text" name="nama_matkul" placeholder="Masukkan Nama Matkul">
    <input type="text" name="sks" placeholder="Masukkan SKS maksimal 2 digit">
    <button type="submit">Submit</button>
  </form>
  <h1>Daftar Mata Kuliah</h1>
  <?php
  require 'list_matkul.php';
  ?>

  <h1>Tambah KRS</h1>
  <form action="post_krs.php" method="POST">
    <input type="text" name="nim" placeholder="Masukkan NIM max: 9 digit">
    <select name="kode_matkul">
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
      ?>
          <option value="<?= $obj->kode_matkul ?>"><?= $obj->nama_matkul ?></option>
      <?php
        }
      }
      ?>
    </select>
    <input type="text" name="smt" placeholder="Masukkan Semester maksimal 2 digit">
    <input type="text" name="tahun_ajaran" placeholder="Masukkan Tahun ajaran maksimal 8 digit">
    <button type="submit">Submit</button>
  </form>

  <h1>List KRS</h1>
  <?php
  require 'get_krs_json.php';
  ?>

  <h1>Cari detail mahasiswa dan riwayat studi</h1>
  <form action="post_khs_param.php" method="GET">
    <input type="text" name="nim" placeholder="masukkan NIM">
    <button type="submit">Submit</button>
  </form>

  <h1>List KHS</h1>
  <?php
  require 'get_khs_json.php';
  ?>

</body>

</html>