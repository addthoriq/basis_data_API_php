-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for tugas_pbd
CREATE DATABASE IF NOT EXISTS `tugas_pbd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `tugas_pbd`;

-- Dumping structure for function tugas_pbd.fun_find_mhs_transkip
DELIMITER //
CREATE FUNCTION `fun_find_mhs_transkip`(
	`vr_nim` CHAR(9)
) RETURNS tinyint
    DETERMINISTIC
BEGIN
DECLARE sks TINYINT;
select sum(mata_kuliah.sks) INTO sks FROM khs
join mata_kuliah on mata_kuliah.kode_mk = khs.kode_mk
WHERE khs.nim = vr_nim;
RETURN sks;
END//
DELIMITER ;

-- Dumping structure for function tugas_pbd.fun_jk_mhs
DELIMITER //
CREATE FUNCTION `fun_jk_mhs`(
	`vr_nim` CHAR(9)
) RETURNS varchar(30) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
DECLARE jk CHAR(1);
DECLARE jk_long VARCHAR(30);
SELECT jenis_kelamin INTO jk FROM mahasiswa WHERE nim = vr_nim;
IF jk = 'L' THEN
SET jk_long = 'Laki-Laki';
ELSEIF jk = 'l' THEN
SET jk_long = 'Laki-Laki';
ELSEIF jk = 'p' THEN
SET jk_long = 'Perempuan';
ELSEIF jk = 'P' THEN
SET jk_long = 'Perempuan';
ELSE SET jk_long = 'invalid';
END IF;
RETURN jk_long;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_all_mhs
DELIMITER //
CREATE PROCEDURE `get_all_mhs`()
BEGIN
SELECT JSON_OBJECT('nim', nim, 'nama', nama, 'jenis_kelamin', fun_jk_mhs(nim))
FROM mahasiswa;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_all_mk
DELIMITER //
CREATE PROCEDURE `get_all_mk`()
BEGIN
SELECT JSON_OBJECT('kode_matkul', kode_mk, 'nama_matkul', nama_mk, 'sks', sks)
FROM mata_kuliah;
END//
DELIMITER ;

-- Dumping structure for function tugas_pbd.get_kode_matkul
DELIMITER //
CREATE FUNCTION `get_kode_matkul`(
	`vr_nama_mk` VARCHAR(100)
) RETURNS char(5) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
DECLARE result CHAR(5);
SELECT kode_mk INTO result FROM mata_kuliah WHERE nama_mk = vr_nama_mk;
RETURN result;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_krs_json
DELIMITER //
CREATE PROCEDURE `get_krs_json`()
BEGIN
SELECT JSON_OBJECT('nim', nim, 'nama', nama, 'mata_kuliah', nama_mk, 'semester', semester, 'ditambahkan_pada', ditambahkan_pada)
FROM v_krs_mhs;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_list_transkip
DELIMITER //
CREATE PROCEDURE `get_list_transkip`()
BEGIN
	SELECT JSON_OBJECT('nim', nim, 'nama', nama, 'total_sks', sks_yang_diambil)
	FROM v_list_transkip;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_mhs
DELIMITER //
CREATE PROCEDURE `get_mhs`(
	IN `vr_nim` CHAR(9)
)
BEGIN
SELECT JSON_OBJECT
('nim', nim, 'nama', nama, 'jenis_kelamin', fun_jk_mhs(vr_nim)) 
FROM mahasiswa WHERE nim = vr_nim;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.get_mhs_transkip
DELIMITER //
CREATE PROCEDURE `get_mhs_transkip`(
	IN `vr_nim` CHAR(9)
)
BEGIN
SELECT JSON_OBJECT('nim', khs.nim, 'nama', mahasiswa.nama, 'total_sks', fun_find_mhs_transkip(khs.nim)) 
FROM khs
JOIN mahasiswa ON mahasiswa.nim = khs.nim
JOIN mata_kuliah ON mata_kuliah.kode_mk = khs.kode_mk
WHERE khs.nim = vr_nim
GROUP BY khs.nim, mahasiswa.nama;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.isi_nilai
DELIMITER //
CREATE PROCEDURE `isi_nilai`(
	IN `vr_nim` CHAR(9),
	IN `vr_nilai` CHAR(2),
	IN `vr_kd_mk` CHAR(5)
)
BEGIN
UPDATE khs SET nilai = vr_nilai WHERE nim = vr_nim AND kode_mk = vr_kd_mk;
END//
DELIMITER ;

-- Dumping structure for table tugas_pbd.khs
CREATE TABLE IF NOT EXISTS `khs` (
  `nim` char(9) NOT NULL,
  `kode_mk` char(5) NOT NULL,
  `semester` char(2) DEFAULT NULL,
  `nilai` char(2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`nim`,`kode_mk`),
  KEY `FK_mk_krs` (`kode_mk`),
  CONSTRAINT `FK_mk_krs` FOREIGN KEY (`kode_mk`) REFERENCES `krs` (`kode_mk`),
  CONSTRAINT `FK_nim_krs` FOREIGN KEY (`nim`) REFERENCES `krs` (`nim`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table tugas_pbd.khs: ~9 rows (approximately)
INSERT INTO `khs` (`nim`, `kode_mk`, `semester`, `nilai`, `created_at`, `updated_at`) VALUES
	('201055001', 'MK001', '5', 'B+', '2023-01-09 05:30:07', NULL),
	('201055001', 'MK003', '5', 'A-', '2023-01-09 05:30:54', NULL),
	('201055001', 'MK004', '5', 'B', '2023-01-09 05:31:28', NULL),
	('201055001', 'MK010', '3', 'A', '2023-01-09 16:41:23', NULL),
	('201055002', 'MK003', '3', 'B-', '2023-01-09 14:54:43', NULL),
	('201055002', 'MK005', '6', 'C', '2023-01-09 15:27:16', NULL),
	('201055003', 'MK002', '5', 'A', '2023-01-09 05:30:41', NULL),
	('201055003', 'MK004', '5', NULL, '2023-01-09 17:01:46', NULL),
	('201055005', 'MK005', '6', NULL, '2023-01-10 06:10:30', NULL);

-- Dumping structure for function tugas_pbd.konversi_nilai
DELIMITER //
CREATE FUNCTION `konversi_nilai`(
	`vr_nilai` CHAR(2)
) RETURNS double
    DETERMINISTIC
BEGIN
DECLARE kredit double;
IF vr_nilai = 'A' THEN
SET kredit = 4.0;
ELSEIF vr_nilai = 'A-' THEN
SET kredit =  3.5;
ELSEIF vr_nilai = 'B+' THEN
SET kredit =  3.0;
ELSEIF vr_nilai = 'B' THEN
SET kredit =  2.5;
ELSEIF vr_nilai = 'B-' THEN
SET kredit =  2.0;
ELSEIF vr_nilai = 'C' THEN
SET kredit =  1.5;
ELSEIF vr_nilai = 'D' THEN
SET kredit =  1.0;
ELSE SET kredit =  0.0;
END IF;
RETURN kredit;
END//
DELIMITER ;

-- Dumping structure for table tugas_pbd.krs
CREATE TABLE IF NOT EXISTS `krs` (
  `nim` char(9) NOT NULL,
  `kode_mk` char(5) NOT NULL,
  `semester` char(2) NOT NULL,
  `tahun_ajaran` char(8) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`nim`,`kode_mk`,`semester`,`tahun_ajaran`),
  KEY `FK_krs_mk` (`kode_mk`),
  CONSTRAINT `FK_krs_mhs` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_krs_mk` FOREIGN KEY (`kode_mk`) REFERENCES `mata_kuliah` (`kode_mk`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table tugas_pbd.krs: ~9 rows (approximately)
INSERT INTO `krs` (`nim`, `kode_mk`, `semester`, `tahun_ajaran`, `created_at`, `updated_at`) VALUES
	('201055001', 'MK001', '5', '20222023', '2023-01-09 05:20:33', NULL),
	('201055001', 'MK003', '5', '20222023', '2023-01-09 05:21:08', NULL),
	('201055001', 'MK004', '5', '20222023', '2023-01-09 05:19:57', NULL),
	('201055001', 'MK010', '3', '20212022', '2023-01-09 16:41:23', NULL),
	('201055002', 'MK003', '3', '20222023', '2023-01-09 05:22:50', NULL),
	('201055002', 'MK005', '6', '20222023', '2023-01-09 14:56:06', NULL),
	('201055003', 'MK002', '5', '20222023', '2023-01-09 05:21:48', NULL),
	('201055003', 'MK004', '5', '20222023', '2023-01-09 17:01:46', NULL),
	('201055005', 'MK005', '6', '20222023', '2023-01-10 06:10:30', NULL);

-- Dumping structure for table tugas_pbd.mahasiswa
CREATE TABLE IF NOT EXISTS `mahasiswa` (
  `nim` char(9) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `jenis_kelamin` char(1) DEFAULT NULL,
  PRIMARY KEY (`nim`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table tugas_pbd.mahasiswa: ~5 rows (approximately)
INSERT INTO `mahasiswa` (`nim`, `nama`, `jenis_kelamin`) VALUES
	('201055001', 'Thoriq', 'L'),
	('201055002', 'Kuma', 'P'),
	('201055003', 'Kanon', 'P'),
	('201055004', 'sayurin', 'p'),
	('201055005', 'Bambang', 'L');

-- Dumping structure for table tugas_pbd.mata_kuliah
CREATE TABLE IF NOT EXISTS `mata_kuliah` (
  `kode_mk` char(5) NOT NULL,
  `nama_mk` varchar(100) DEFAULT NULL,
  `sks` tinyint DEFAULT NULL,
  PRIMARY KEY (`kode_mk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table tugas_pbd.mata_kuliah: ~7 rows (approximately)
INSERT INTO `mata_kuliah` (`kode_mk`, `nama_mk`, `sks`) VALUES
	('MK001', 'Basis Data', 4),
	('MK002', 'Kecerdasan Artifisal', 2),
	('MK003', 'Etika Profesi', 2),
	('MK004', 'Pemrograman Mobile', 4),
	('MK005', 'TBO', 3),
	('MK006', 'Kalkulus', 3),
	('MK007', 'Fisika', 3),
	('MK010', 'Interaksi Manusia Komputer', 3);

-- Dumping structure for procedure tugas_pbd.sp_find_khs
DELIMITER //
CREATE PROCEDURE `sp_find_khs`(
	IN `vr_nim` CHAR(9)
)
BEGIN
SELECT 
JSON_OBJECT(
'kode_matkul', khs.kode_mk, 'mata_kuliah', mata_kuliah.nama_mk, 'sks', mata_kuliah.sks, 'nilai', nilai, 'semester', semester
)
FROM khs
JOIN mata_kuliah ON khs.kode_mk = mata_kuliah.kode_mk
WHERE khs.nim = vr_nim;
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.sp_tambah_mhs
DELIMITER //
CREATE PROCEDURE `sp_tambah_mhs`(
	IN `vr_nim` CHAR(9),
	IN `vr_nama` VARCHAR(50),
	IN `vr_jk` CHAR(1)
)
BEGIN
INSERT INTO mahasiswa VALUES (vr_nim, vr_nama, vr_jk);
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.sp_tambah_mk
DELIMITER //
CREATE PROCEDURE `sp_tambah_mk`(
	IN `kd_mk` CHAR(5),
	IN `nm_mk` VARCHAR(100),
	IN `vr_sks` TINYINT
)
BEGIN
INSERT INTO mata_kuliah (kode_mk, nama_mk, sks) VALUES (kd_mk, nm_mk, vr_sks);
END//
DELIMITER ;

-- Dumping structure for function tugas_pbd.sum_ip
DELIMITER //
CREATE FUNCTION `sum_ip`(
	`vr_nim` CHAR(9)
) RETURNS float
    DETERMINISTIC
BEGIN
DECLARE res FLOAT;
SELECT SUM(mata_kuliah.sks * konversi_nilai(nilai)) / SUM(mata_kuliah.sks) INTO res
FROM khs
JOIN mata_kuliah ON khs.kode_mk = mata_kuliah.kode_mk
WHERE nim = vr_nim;
RETURN ROUND(res, 2);
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.tambah_krs
DELIMITER //
CREATE PROCEDURE `tambah_krs`(
	IN `vr_nim` CHAR(9),
	IN `vr_kd_mk` CHAR(5),
	IN `vr_smt` CHAR(2),
	IN `vr_ta` CHAR(8)
)
BEGIN
INSERT INTO krs (nim, kode_mk, semester, tahun_ajaran) VALUES (vr_nim, vr_kd_mk, vr_smt, vr_ta);
END//
DELIMITER ;

-- Dumping structure for procedure tugas_pbd.update_smt_khs
DELIMITER //
CREATE PROCEDURE `update_smt_khs`(
	IN `vr_nim` CHAR(9),
	IN `vr_kd_mk` CHAR(5)
)
BEGIN
DECLARE smt CHAR(2);
SELECT semester INTO smt FROM krs WHERE kode_mk = vr_kd_mk AND nim = vr_nim;
UPDATE khs SET semester = smt WHERE kode_mk = vr_kd_mk AND nim = vr_nim;
END//
DELIMITER ;

-- Dumping structure for view tugas_pbd.v_krs_mhs
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `v_krs_mhs` (
	`nim` CHAR(9) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`nama` VARCHAR(50) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`nama_mk` VARCHAR(100) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`semester` CHAR(2) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`ditambahkan_pada` TIMESTAMP NULL
) ENGINE=MyISAM;

-- Dumping structure for view tugas_pbd.v_list_transkip
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `v_list_transkip` (
	`nim` CHAR(9) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`nama` VARCHAR(50) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`sks_yang_diambil` DECIMAL(25,0) NULL
) ENGINE=MyISAM;

-- Dumping structure for trigger tugas_pbd.tr_khs_baru
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_khs_baru` AFTER INSERT ON `krs` FOR EACH ROW BEGIN
INSERT INTO khs (nim, kode_mk, semester, created_at) VALUES (NEW.nim, NEW.kode_mk, NEW.semester, CURRENT_TIMESTAMP());
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for trigger tugas_pbd.tr_krs_baru
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `tr_krs_baru` BEFORE INSERT ON `krs` FOR EACH ROW BEGIN
SET NEW.created_at = CURRENT_TIMESTAMP();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Dumping structure for view tugas_pbd.v_krs_mhs
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `v_krs_mhs`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_krs_mhs` AS select `krs`.`nim` AS `nim`,`mahasiswa`.`nama` AS `nama`,`mata_kuliah`.`nama_mk` AS `nama_mk`,`krs`.`semester` AS `semester`,`krs`.`created_at` AS `ditambahkan_pada` from ((`krs` join `mahasiswa` on((`mahasiswa`.`nim` = `krs`.`nim`))) join `mata_kuliah` on((`mata_kuliah`.`kode_mk` = `krs`.`kode_mk`)));

-- Dumping structure for view tugas_pbd.v_list_transkip
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `v_list_transkip`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_list_transkip` AS select `khs`.`nim` AS `nim`,`mahasiswa`.`nama` AS `nama`,sum(`mata_kuliah`.`sks`) AS `sks_yang_diambil` from ((`khs` join `mahasiswa` on((`mahasiswa`.`nim` = `khs`.`nim`))) join `mata_kuliah` on((`mata_kuliah`.`kode_mk` = `khs`.`kode_mk`))) group by `khs`.`nim`,`mahasiswa`.`nama`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
