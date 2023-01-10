<?php

require 'koneksi.php';

$sql = "CALL get_list_transkip()";
$res = $koneksi->query($sql);

?>
<table border="1">
  <tr>
    <td>NIM</td>
    <td>Nama</td>
    <td>Total SKS</td>
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
        echo "<td><a href=post_khs_param.php?nim=" . $obj->nim . ">". $obj->nim ."</a></td>";
        echo "<td>" . $obj->nama . "</td>";
        echo "<td>" . $obj->total_sks . "</td>";
        ?>
      </tr>
  <?php
    }
  }
  ?>
</table>