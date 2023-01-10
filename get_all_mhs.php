<?php

require 'koneksi.php';

$sql = "CALL get_all_mhs()";
$res = $koneksi->query($sql);

?>
<table border="1">
  <tr>
    <td>NIM</td>
    <td>Nama</td>
    <td>Jenis Kelamin</td>
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
        echo "<td>" . $obj->nim . "</td>";
        echo "<td>" . $obj->nama . "</td>";
        echo "<td>" . $obj->jenis_kelamin . "</td>";
        ?>
      </tr>
  <?php
    }
  }
  ?>
</table>