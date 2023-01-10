<?php

require 'koneksi.php';

$sql = "CALL get_krs_json";
$res = $koneksi->query($sql);


?>
<table border="1">
  <tr>
    <td>NIM</td>
    <td>Nama</td>
    <td>Mata Kuliah</td>
    <td>Semester</td>
    <td>Ditambahkan Pada</td>
  </tr>
<?php
if ($res->num_rows > 0) {
  while ($row = $res->fetch_assoc()) {
?>
<tr>
  <?php
      // Convert Array to String
      $rowArr = implode(" ", $row);
      // Convert String to Object
      $obj = json_decode($rowArr);

      $date = new DateTime($obj->ditambahkan_pada);

      echo "<td>" . $obj->nim . "</td>";
      echo "<td>" . $obj->nama . "</td>";
      echo "<td>" . $obj->mata_kuliah . "</td>";
      echo "<td>" . $obj->semester . "</td>";
      echo "<td>" . $date->format('d F Y : H.i') . " WIB</td>";
  ?>
</tr>
<?php
  }
}
?>
</table>