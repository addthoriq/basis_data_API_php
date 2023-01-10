<?php

require 'koneksi.php';

$nim = $_GET['nim'];

$sql1 = "CALL get_mhs($nim)";
$getMhs = $koneksi->query($sql1);

?>
<?php
if ($getMhs->num_rows > 0) {
  while ($mhs = $getMhs->fetch_assoc()) {
    $mhsObj = json_decode(implode(" ", $mhs));
?>
    <a href="index.php">Kembali</a>
    <h1>NIM: <?= $mhsObj->nim ?></h1>
    <h2>Nama: <?= $mhsObj->nama ?></h2>
  <?php
  }
}
$getMhs->close();
$koneksi->next_result();

$cmdIPK = "sum_ip($nim)";
$getIPK = $koneksi->query("SELECT " . $cmdIPK);

if ($getIPK->num_rows > 0) {
  while ($resIPK = $getIPK->fetch_assoc()) {
    echo "<h2>IPK: " . $resIPK[$cmdIPK] . "</h2>";
  }
}

$getIPK->close();
$koneksi->next_result();

$khs = "CALL get_mhs_transkip($nim)";
$getKHS = $koneksi->query($khs);
if ($getKHS->num_rows > 0) {
  while ($KHS = $getKHS->fetch_assoc()) {
    $KHSObj = json_decode(implode(" ", $KHS));
  ?>
    <h2>Total SKS: <?= $KHSObj->total_sks ?></h2>
<?php
  }
}
$getKHS->close();
$koneksi->next_result();
$sql = "CALL sp_find_khs($nim)";
$res = $koneksi->query($sql);
?>
<h2>Isi Nilai:</h2>
<form action="isi_nilai.php" method="POST">
  <input type="hidden" name="nim" value="<?= $nim ?>">
  <select name="kode_matkul">
    <?php
    if ($res->num_rows > 0) {
      while ($row = $res->fetch_assoc()) {
        // Convert Array to String
        $rowArr = implode(" ", $row);
        // Convert String to Object
        $obj = json_decode($rowArr);
    ?>
        <option value="<?= $obj->kode_matkul ?>"><?= $obj->mata_kuliah ?></option>
    <?php
      }
    } else {
      echo "KHS tidak ditemukan";
    }
    $res->close();
    $koneksi->next_result();
    ?>
  </select>
  <input type="text" placeholder="Masukkan Nilai:" name="nilai" />
  <button type="submit">Submit</button>
</form>
<table border="1">
  <tr>
    <td>Nama Mata Kuliah</td>
    <td>Semester</td>
    <td>SKS</td>
    <td>Nilai</td>
  </tr>
  <?php
  $res2 = $koneksi->query($sql);
  if ($res2->num_rows > 0) {
    while ($row = $res2->fetch_assoc()) {
  ?>
      <tr>
        <?php
        // Convert Array to String
        $rowArr = implode(" ", $row);
        // Convert String to Object
        $obj = json_decode($rowArr);
        // echo "<td>" . $obj->nim . "</td>";
        // echo "<td>" . $obj->nama . "</td>";
        echo "<td>" . $obj->mata_kuliah . "</td>";
        echo "<td>" . $obj->semester . "</td>";
        echo "<td>" . $obj->sks . "</td>";
        echo "<td>" . $obj->nilai . "</td>";
        ?>
      </tr>
  <?php
    }
  } else {
    echo "KHS tidak ditemukan";
  }
  $res2->close();
  ?>
</table>