<?php

require 'koneksi.php';

$sql = "CALL get_all_mk()";
$res = $koneksi->query($sql);

?>
<table border="1">
  <tr>
    <td>Kode Mata Kuliah</td>
    <td>Nama Mata Kuliah</td>
    <td>SKS</td>
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
        echo "<td>". $obj->kode_matkul . "</td>";
        echo "<td>" . $obj->nama_matkul . "</td>";
        echo "<td>" . $obj->sks . "</td>";
        ?>
      </tr>
  <?php
    }
  }
  ?>
</table>