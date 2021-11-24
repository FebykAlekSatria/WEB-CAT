-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 23, 2021 at 07:24 AM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cat`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_admin` (IN `id_param` VARCHAR(13), IN `username_param` VARCHAR(15), IN `password_param` VARCHAR(32), IN `nama_param` VARCHAR(32), IN `no_hp_param` VARCHAR(15))  BEGIN 
INSERT INTO admin VALUES (id_param, username_param, password_param);
INSERT INTO detail_admin VALUES (id_param, nama_param, no_hp_param, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_jawaban_peserta` (IN `no_peserta_param` VARCHAR(13), IN `soal_id_param` VARCHAR(13), IN `jawaban_param` VARCHAR(10))  BEGIN
    IF jawaban_param IS NOT NULL THEN
        IF (SELECT EXISTS(SELECT soal_id
        FROM jawaban_peserta
        WHERE no_peserta = no_peserta_param
        AND soal_id = soal_id_param)) = 1 THEN
            UPDATE jawaban_peserta
                SET jawaban = jawaban_param
            WHERE soal_id = soal_id_param
            AND no_peserta = no_peserta_param;
            ELSE
            INSERT INTO jawaban_peserta
            VALUES (no_peserta_param, soal_id_param, jawaban_param);
            END IF;
    END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_kategori` (IN `id_param` VARCHAR(13), IN `nama_kategori_param` VARCHAR(32), IN `nilai_kategori_param` DOUBLE)  INSERT INTO kategori
VALUES (id_param, nama_kategori_param, nilai_kategori_param, 0)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_peserta` (IN `id_param` VARCHAR(13), IN `username_param` VARCHAR(15), IN `password_param` VARCHAR(32), IN `nama_param` VARCHAR(50), IN `asal_sekolah_param` VARCHAR(50), IN `no_hp_param` VARCHAR(15))  BEGIN
INSERT INTO peserta VALUES (id_param, username_param, password_param);
INSERT INTO detail_peserta VALUES (id_param, nama_param, asal_sekolah_param, no_hp_param, 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_peserta_to_ujian` (IN `no_peserta_param` VARCHAR(13), IN `peserta_id_param` VARCHAR(13), IN `sesi_id_param` VARCHAR(13))  BEGIN
    IF EXISTS(SELECT no_peserta from peserta_ujian 
    WHERE peserta_id = peserta_id_param 
      AND sesi_id = sesi_id_param
        AND trash_id = 1) THEN
        UPDATE peserta_ujian
            SET trash_id = 0
        WHERE peserta_id = peserta_id_param
        AND sesi_id = sesi_id_param;
    ELSE
INSERT INTO peserta_ujian
VALUES (no_peserta_param, peserta_id_param, sesi_id_param, 0);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_sesi` (IN `sesi_id_param` VARCHAR(13), IN `nama_ujian_param` VARCHAR(32), IN `tempat_ujian_param` VARCHAR(50), IN `waktu_mulai_param` DATETIME, IN `durasi_param` INT, IN `passing_grade_param` DECIMAL, IN `kode_sesi_param` VARCHAR(5))  INSERT INTO sesi
VALUES (sesi_id_param, nama_ujian_param, tempat_ujian_param, waktu_mulai_param, (waktu_mulai + interval durasi_param minute) , durasi_param, passing_grade_param, kode_sesi_param,0)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_soal` (IN `soal_id_param` VARCHAR(13), IN `kategori_param` VARCHAR(100), IN `pertanyaan_param` VARCHAR(500), IN `gambar_param` VARCHAR(500), IN `opsi_a_param` VARCHAR(500), IN `opsi_b_param` VARCHAR(500), IN `opsi_c_param` VARCHAR(500), IN `opsi_d_param` VARCHAR(500), IN `opsi_e_param` VARCHAR(500), IN `kunci_param` VARCHAR(20), IN `bobot_a_param` INT, IN `bobot_b_param` INT, IN `bobot_c_param` INT, IN `bobot_d_param` INT, IN `bobot_e_param` INT)  BEGIN
INSERT INTO soal VALUES (soal_id_param, (SELECT kategori.id FROM kategori WHERE nama_kategori LIKE kategori_param), pertanyaan_param, gambar_param, 0);
INSERT INTO jawaban VALUES (soal_id_param, opsi_a_param, opsi_b_param, opsi_c_param, opsi_d_param, opsi_e_param, kunci_param);
INSERT INTO bobot_nilai VALUES  (soal_id_param, bobot_a_param, bobot_b_param, bobot_c_param, bobot_d_param, bobot_e_param);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_soal_to_sesi` (IN `sesi_id_param` VARCHAR(13), IN `kategori_id_param` VARCHAR(13), IN `jumlah_soal_param` INT, IN `urutan_param` INT)  BEGIN
   DELETE FROM jumlah_soal
    WHERE kategori_id = kategori_id_param
    AND sesi_id = sesi_id_param;

    DELETE FROM soal_sesi
    WHERE kategori_id = kategori_id_param
    AND sesi_id = sesi_id_param;

INSERT INTO jumlah_soal
VALUES (sesi_id_param, kategori_id_param, jumlah_soal_param, urutan_param);
       
INSERT INTO soal_sesi(sesi_id, kategori_id, soal_id, urutan)
SELECT sesi_id_param, kategori_id, id, urutan_param
FROM soal
WHERE kategori_id = kategori_id_param
AND soal.trash_id = 0
ORDER BY RAND()
LIMIT jumlah_soal_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_nilai` (IN `no_peserta_param` VARCHAR(13), IN `soal_id_param` VARCHAR(13))  BEGIN
    DECLARE total_nilai_var double;
    DECLARE jawaban_soal_var varchar(20);
    DECLARE jawaban_peserta_var varchar(20);

    DECLARE opsi_a_var int;
    DECLARE opsi_b_var int;
    DECLARE opsi_c_var int;
    DECLARE opsi_d_var int;
    DECLARE opsi_e_var int;

    DECLARE bobot_nilai_a_var double;
    DECLARE bobot_nilai_b_var double;
    DECLARE bobot_nilai_c_var double;
    DECLARE bobot_nilai_d_var double;
    DECLARE bobot_nilai_e_var double;
    DECLARE bobot_kategori_var double;

    SET total_nilai_var = 0;

    SET bobot_nilai_a_var =  (SELECT opsi_a FROM bobot_nilai WHERE soal_id = soal_id_param);
    SET bobot_nilai_b_var =  (SELECT opsi_b FROM bobot_nilai WHERE soal_id = soal_id_param);
    SET bobot_nilai_c_var =  (SELECT opsi_c FROM bobot_nilai WHERE soal_id = soal_id_param);
    SET bobot_nilai_d_var =  (SELECT opsi_d FROM bobot_nilai WHERE soal_id = soal_id_param);
    SET bobot_nilai_e_var =  (SELECT opsi_e FROM bobot_nilai WHERE soal_id = soal_id_param);

    SET bobot_kategori_var = (SELECT nilai_kategori FROM kategori
        INNER JOIN soal s on kategori.id = s.kategori_id
        WHERE s.id =  soal_id_param);

    SET jawaban_soal_var = (SELECT kunci FROM jawaban WHERE soal_id = soal_id_param);
    SET jawaban_peserta_var = (SELECT jawaban FROM jawaban_peserta WHERE soal_id = soal_id_param AND no_peserta = no_peserta_param);

    IF jawaban_soal_var REGEXP 'A' THEN
        SET opsi_a_var = 1;
    END IF;
    IF jawaban_soal_var REGEXP 'B' THEN
        SET opsi_b_var = 1;
    END IF;
    IF jawaban_soal_var REGEXP 'C' THEN
        SET opsi_c_var = 1;
    END IF;
    IF jawaban_soal_var REGEXP 'D' THEN
        SET opsi_d_var = 1;
    END IF;
    IF jawaban_soal_var REGEXP 'E' THEN
        SET opsi_e_var = 1;
    END IF;

    IF opsi_a_var = 1 THEN
        IF jawaban_peserta_var REGEXP 'A' THEN
            SET total_nilai_var =+ bobot_nilai_a_var * bobot_kategori_var;
        END IF;
    END IF;
    IF opsi_b_var = 1 THEN
        IF jawaban_peserta_var REGEXP 'B' THEN
            SET total_nilai_var =+ bobot_nilai_b_var * bobot_kategori_var;
        END IF;
    END IF;
    IF opsi_c_var = 1 THEN
        IF jawaban_peserta_var REGEXP 'C' THEN
            SET total_nilai_var =+ bobot_nilai_c_var * bobot_kategori_var;
        END IF;
    END IF;
    IF opsi_d_var = 1 THEN
        IF jawaban_peserta_var REGEXP 'D' THEN
            SET total_nilai_var =+ bobot_nilai_d_var * bobot_kategori_var;
        END IF;
    END IF;
    IF opsi_e_var = 1 THEN
        IF jawaban_peserta_var REGEXP 'E' THEN
            SET total_nilai_var =+ bobot_nilai_e_var * bobot_kategori_var;
        END IF;
    END IF;

    IF (SELECT nilai FROM nilai WHERE soal_id = soal_id_param AND no_peserta = no_peserta_param) IS NOT NULL THEN
        UPDATE nilai
            SET nilai = total_nilai_var
        WHERE no_peserta = no_peserta_param
        AND soal_id = soal_id_param;
    ELSE
        INSERT INTO nilai
    VALUES (no_peserta_param, soal_id_param, total_nilai_var);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_jumlah_soal_by_kategori` (IN `kategori_id_param` VARCHAR(13))  BEGIN
    SELECT COUNT(id) as jumlah_soal FROM soal
        WHERE kategori_id = kategori_id_param
    AND trash_id = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_admin` (IN `id_param` VARCHAR(13))  BEGIN 
DELETE FROM admin
WHERE id = id_param;
UPDATE detail_admin
    SET trash_id = 1
    WHERE admin_id = id_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_jumlah_soal` (IN `sesi_id_param` VARCHAR(13), IN `kategori_id_param` VARCHAR(13))  DELETE FROM jumlah_soal
WHERE sesi_id = sesi_id_param
AND kategori_id = kategori_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_kategori` (IN `kategori_id_param` VARCHAR(13))  BEGIN

UPDATE kategori
SET trash_id = 1
WHERE id = kategori_id_param;

UPDATE soal
SET trash_id = 1
WHERE kategori_id = kategori_id_param;

# tambahan
DELETE FROM soal_sesi
    WHERE kategori_id = kategori_id_param;

DELETE FROM jumlah_soal
    WHERE kategori_id = kategori_id_param;

UPDATE kategori
    SET nama_kategori = concat('TRASH_', nama_kategori)
WHERE id = kategori_id_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_peserta` (IN `id_param` VARCHAR(13))  BEGIN
    DECLARE username_var varchar(100);
    DECLARE username_trash_var varchar(100);
    
    SET username_var =  (SELECT username FROM peserta WHERE id = id_param);
    SET username_trash_var = concat('T_', username_var);

UPDATE detail_peserta
SET trash_id = 1
WHERE peserta_id = id_param;

IF EXISTS (SELECT username from peserta WHERE username = username_trash_var) THEN
    UPDATE peserta
    SET username = concat(username_trash_var,'#')
    WHERE id = id_param;
    ELSE
    UPDATE peserta
        SET username = username_trash_var
    WHERE id = id_param;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_peserta_from_ujian` (IN `no_peserta_param` VARCHAR(13))  UPDATE peserta_ujian
SET trash_id = 1
WHERE no_peserta = no_peserta_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_sesi` (IN `sesi_id_param` VARCHAR(13))  UPDATE sesi
SET trash_id = 1
WHERE id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_soal` (IN `soal_id_param` VARCHAR(13))  UPDATE soal
SET trash_id = 1
WHERE id = soal_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_soal_from_sesi` (IN `sesi_id_param` VARCHAR(13), IN `kategori_id_param` VARCHAR(13))  BEGIN
    DELETE FROM jumlah_soal
    WHERE kategori_id = kategori_id_param
    AND sesi_id = sesi_id_param;

    DELETE FROM soal_sesi
    WHERE kategori_id = kategori_id_param
    AND sesi_id = sesi_id_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_admin` (IN `id_param` VARCHAR(13), IN `nama_param` VARCHAR(32), IN `no_hp_param` VARCHAR(15), IN `old_password_param` VARCHAR(32), IN `new_password_param` VARCHAR(32))  BEGIN
UPDATE admin
SET password = new_password_param
WHERE id = id_param
AND password = old_password_param;
UPDATE detail_admin
    SET nama = nama_param,
        no_hp = no_hp_param
    WHERE admin_id = id_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_jumlah_soal` (IN `sesi_id_param` VARCHAR(13), IN `kategori_id_param` VARCHAR(13), IN `jumlah_soal_param` INT(255))  UPDATE jumlah_soal
SET jumlah_soal = jumlah_soal_param
WHERE kategori_id = kategori_id_param 
AND sesi_id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_kategori` (IN `kategori_id_param` VARCHAR(13), IN `nama_kategori_param` VARCHAR(32), IN `nilai_kategori_param` DOUBLE)  UPDATE kategori
SET nama_kategori = nama_kategori_param,
nilai_kategori = nilai_kategori_param
WHERE id =kategori_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_peserta` (IN `id_param` VARCHAR(13), IN `new_password_param` VARCHAR(32), IN `nama_param` VARCHAR(32), IN `asal_sekolah_param` VARCHAR(50), IN `no_hp_param` VARCHAR(15))  BEGIN
    IF new_password_param IS NOT NULL THEN
UPDATE peserta
SET password = new_password_param
WHERE id = id_param;
UPDATE detail_peserta
    SET nama = nama_param,
        asal_sekolah = asal_sekolah_param,
        no_hp = no_hp_param
    WHERE peserta_id = id_param;
ELSE
        UPDATE detail_peserta
    SET nama = nama_param,
        asal_sekolah = asal_sekolah_param,
        no_hp = no_hp_param
    WHERE peserta_id = id_param;
END IF;
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_sesi` (IN `sesi_id_param` VARCHAR(13), IN `nama_ujian_param` VARCHAR(32), IN `tempat_ujian_param` VARCHAR(50), IN `waktu_mulai_param` DATETIME, IN `durasi_param` INT, IN `passing_grade_param` DECIMAL)  UPDATE sesi
SET nama_ujian = nama_ujian_param,
tempat_ujian = tempat_ujian_param,
waktu_mulai = waktu_mulai_param,
waktu_selesai = waktu_mulai + interval durasi_param minute ,
    durasi = durasi_param,
    passing_grade = passing_grade_param
WHERE id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_soal` (IN `id_param` VARCHAR(13), IN `kategori_param` VARCHAR(100), IN `pertanyaan_param` VARCHAR(500), IN `gambar_param` VARCHAR(500), IN `opsi_a_param` VARCHAR(500), IN `opsi_b_param` VARCHAR(500), IN `opsi_c_param` VARCHAR(500), IN `opsi_d_param` VARCHAR(500), IN `opsi_e_param` VARCHAR(500), IN `kunci_param` VARCHAR(20), IN `bobot_a_param` INT, IN `bobot_b_param` INT, IN `bobot_c_param` INT, IN `bobot_d_param` INT, IN `bobot_e_param` INT)  BEGIN
UPDATE soal
SET pertanyaan = pertanyaan_param,
    gambar = gambar_param
WHERE id = id_param
AND (SELECT kategori.id FROM kategori WHERE nama_kategori LIKE kategori_param);
UPDATE jawaban
SET opsi_a = opsi_a_param,
    opsi_b = opsi_b_param,
    opsi_c = opsi_c_param,
    opsi_d = opsi_d_param,
    opsi_e = opsi_e_param,
    kunci = kunci_param
WHERE soal_id = id_param;
UPDATE bobot_nilai
    SET opsi_a = bobot_a_param,
        opsi_b = bobot_b_param,
        opsi_c = bobot_c_param,
        opsi_d = bobot_d_param,
        opsi_e = bobot_e_param
    WHERE soal_id = id_param;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_soal_list` (IN `sesi_id_param` VARCHAR(13))  select soal_id, kategori_id from soal_sesi
WHERE sesi_id = sesi_id_param
ORDER BY urutan, kategori_id, rand()$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_bobot_soal` (IN `id_param` VARCHAR(13))  SELECT opsi_a, opsi_b, opsi_c, opsi_d, opsi_e FROM bobot_nilai
WHERE soal_id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_admin` (IN `id_param` VARCHAR(13))  SELECT id, nama, no_hp FROM admin
INNER JOIN detail_admin da on admin.id = da.admin_id
WHERE id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_jumlah_soal` (IN `sesi_id_param` VARCHAR(13))  SELECT sesi_id, kategori_id, jumlah_soal, urutan FROM jumlah_soal WHERE sesi_id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_peserta` (IN `id_param` VARCHAR(13))  SELECT id, username, peserta_id, nama, asal_sekolah, no_hp FROM peserta
INNER JOIN detail_peserta dp on peserta.id = dp.peserta_id
WHERE id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_sesi` (IN `id_param` VARCHAR(13))  SELECT id, nama_ujian, tempat_ujian, waktu_mulai, waktu_selesai, durasi, passing_grade, kode_sesi FROM sesi
WHERE id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_soal` (IN `soal_id_param` VARCHAR(13))  SELECT soal.id, nama_kategori, pertanyaan, gambar, opsi_a, opsi_b, opsi_c, opsi_d, opsi_e FROM soal
INNER join jawaban j on soal.id = j.soal_id
INNER JOIN kategori k on soal.kategori_id = k.id
WHERE soal.id = soal_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_detail_ujian` (IN `peserta_id_param` VARCHAR(13), IN `sesi_id_param` VARCHAR(13))  SELECT detail_peserta.peserta_id, nama, no_peserta, asal_sekolah, no_hp, nama_ujian, waktu_mulai, durasi, passing_grade, waktu_selesai 
FROM detail_peserta
INNER JOIN peserta_ujian pu on detail_peserta.peserta_id = pu.peserta_id
INNER JOIN sesi s on pu.sesi_id = s.id
WHERE detail_peserta.peserta_id = peserta_id_param
AND sesi_id = sesi_id_param
AND detail_peserta.trash_id = 0
AND s.trash_id = 0
AND pu.trash_id = 0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_jawaban_user` (IN `soal_id_param` VARCHAR(13), IN `no_peserta_param` VARCHAR(13))  SELECT jawaban FROM jawaban_peserta
WHERE soal_id = soal_id_param
      AND no_peserta = no_peserta_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_jumlah_soal_by_sesi` (IN `sesi_id_param` VARCHAR(13))  select sum(jumlah_soal)  as jumlah_soal from jumlah_soal
WHERE sesi_id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_jumlah_soal_list` (`sesi_id_param` VARCHAR(13))  select kategori_id, jumlah_soal, urutan from jumlah_soal
WHERE sesi_id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_kategori_list` ()  select id, nama_kategori from kategori
WHERE trash_id = 0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_kode_sesi_list` ()  SELECT kode_sesi
FROM sesi
WHERE trash_id = 0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_kunci_jawaban` (IN `id_param` VARCHAR(13))  SELECT kunci FROM jawaban
WHERE soal_id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_maksimal_soal_by_kategori` (IN `kategori_id_param` VARCHAR(13))  select COUNT(id)  as maksimal_soal from soal
WHERE kategori_id = kategori_id_param
AND trash_id = 0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nilai_list_by_sesi` (IN `sesi_id_param` VARCHAR(13))  SELECT nama_kategori, nama, no_hp, sum(nilai) as nilai FROM hasil_ujian
    LEFT JOIN kategori k on hasil_ujian.kategori_id = k.id
    LEFT JOIN peserta_ujian on hasil_ujian.no_peserta = peserta_ujian.no_peserta
    LEFT JOIN detail_peserta on peserta_ujian.peserta_id = detail_peserta.peserta_id
WHERE hasil_ujian.sesi_id = sesi_id_param
GROUP BY hasil_ujian.no_peserta$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_not_peserta_ujian_list_by_sesi` (IN `sesi_id_param` VARCHAR(13))  BEGIN
SELECT id, nama, asal_sekolah, no_hp FROM peserta
#     SELECT * FROM peserta
    INNER JOIN detail_peserta dp on peserta.id = dp.peserta_id
LEFT JOIN (SELECT * FROM peserta_ujian
    WHERE sesi_id = sesi_id_param) as tabel1 on dp.peserta_id = tabel1.peserta_id
WHERE tabel1.sesi_id IS NULL 
  OR tabel1.trash_id = 1
AND dp.trash_id = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_peserta_ujian_list_by_sesi` (IN `sesi_id_param` VARCHAR(13))  SELECT no_peserta, dp.peserta_id, nama FROM peserta_ujian
INNER JOIN detail_peserta dp on peserta_ujian.peserta_id = dp.peserta_id
WHERE sesi_id = sesi_id_param
AND peserta_ujian.trash_id = 0
AND dp.trash_id = 0
ORDER BY nama, no_peserta$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_result_ujian` (IN `no_peserta_param` VARCHAR(13))  SELECT nilai.no_peserta, nama, asal_sekolah, no_hp, sum(nilai) as total_nilai FROM nilai
    INNER JOIN peserta_ujian pu on nilai.no_peserta = pu.no_peserta
    INNER JOIN detail_peserta dp on pu.peserta_id = dp.peserta_id
WHERE dp.trash_id = 0
  AND pu.trash_id = 0
AND nilai.no_peserta = no_peserta_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_sesi_list` ()  select id,nama_ujian from sesi
WHERE trash_id = 0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_nilai_list` (IN `sesi_id_param` VARCHAR(13))  SELECT nilai.no_peserta, nama, asal_sekolah, no_hp,SUM(nilai) as total_nilai FROM nilai
    INNER JOIN peserta_ujian pu on nilai.no_peserta = pu.no_peserta
    INNER JOIN detail_peserta dp on pu.peserta_id = dp.peserta_id
# SELECT n.no_peserta, nama, asal_sekolah, no_hp, sum (n.nilai) as total_nilai FROM peserta_ujian pu
# INNER JOIN detail_peserta dp on pu.peserta_id = dp.peserta_id
# LEFT JOIN nilai n on pu.no_peserta = n.no_peserta
WHERE dp.trash_id = 0
  AND pu.trash_id = 0
AND sesi_id = sesi_id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `import_excel_peserta_sesi` (IN `kode_sesi_param` VARCHAR(5), IN `nama_peserta_param` VARCHAR(32), IN `username_param` VARCHAR(15), IN `password_param` VARCHAR(32), IN `no_hp_param` VARCHAR(15), IN `asal_sekolah_param` VARCHAR(32), IN `no_peserta_param` VARCHAR(5), IN `user_id_param` VARCHAR(32))  BEGIN
    DECLARE user_id_var varchar(13);
# keadaan belum ada di peserta & peserta sesi
    IF (SELECT COUNT(username) from peserta WHERE username =username_param) = 0 THEN
        call add_peserta(user_id_param,
            username_param,
            password_param,
            nama_peserta_param,
            asal_sekolah_param,
            no_hp_param);

        call add_peserta_to_ujian(no_peserta_param,
        user_id_param,
        (SELECT id FROM sesi WHERE kode_sesi = kode_sesi_param ));
# keadaan udah pernah didelete
    ELSE IF (SELECT COUNT(username) FROM peserta_ujian
    INNER JOIN peserta p on peserta_ujian.peserta_id = p.id
    WHERE username = username_param) = 1 THEN
        UPDATE peserta_ujian
        INNER JOIN peserta p2 on peserta_ujian.peserta_id = p2.id
            SET trash_id = 0
        WHERE username = username_param
        AND sesi_id = (SELECT id FROM sesi WHERE kode_sesi = kode_sesi_param ) ;

        ELSE IF (SELECT COUNT(username) FROM peserta_ujian
    INNER JOIN peserta p on peserta_ujian.peserta_id = p.id
    WHERE username = username_param) = 0
                    AND
                (SELECT COUNT(username) from peserta WHERE username =username_param) = 1 THEN
                    SET user_id_var =  (SELECT id FROM peserta WHERE username = username_param);
            INSERT INTO peserta_ujian
VALUES (no_peserta_param, user_id_var, (SELECT id FROM sesi WHERE kode_sesi = kode_sesi_param ), 0);


END IF;
END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_admin` (IN `id_param` VARCHAR(13))  SELECT EXISTS(SELECT id from admin 
INNER JOIN detail_admin da on admin.id = da.admin_id
WHERE id = id_param
    AND trash_id = 0) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_gambar_exists` (IN `id_param` VARCHAR(13))  SELECT gambar FROM soal WHERE id = id_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_kode_sesi_exists` (IN `kode_sesi_param` VARCHAR(32))  SELECT EXISTS(SELECT kode_sesi from sesi
    WHERE trash_id = 0
    AND kode_sesi = kode_sesi_param
      ) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_peserta` (IN `id_param` VARCHAR(13))  SELECT EXISTS(SELECT id from peserta
INNER JOIN detail_peserta dp on peserta.id = dp.peserta_id
WHERE id = id_param
    AND trash_id = 0
      ) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_peserta_ujian` (IN `id_param` VARCHAR(13), `sesi_id_param` VARCHAR(13))  SELECT EXISTS(SELECT peserta_id from peserta_ujian
WHERE peserta_id = id_param
  AND sesi_id = sesi_id_param
    AND trash_id = 0
      ) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_phone_exists` (IN `no_hp_param` VARCHAR(15))  SELECT EXISTS(SELECT no_hp from detail_peserta WHERE no_hp = no_hp_param AND trash_id = 0) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_sesi_exists` (IN `kode_sesi_param` VARCHAR(5))  SELECT EXISTS(SELECT kode_sesi from sesi WHERE kode_sesi = kode_sesi_param AND trash_id = 0) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_ujian_berlangsung` (IN `kode_sesi_param` VARCHAR(13))  SELECT EXISTS(
    SELECT id from sesi
    WHERE kode_sesi = kode_sesi_param
    AND trash_id = 0
    AND sysdate()
        BETWEEN waktu_mulai - INTERVAL 10 MINUTE 
        AND waktu_selesai + INTERVAL 10 MINUTE 
    ) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `is_username_exists` (IN `username_param` VARCHAR(15))  SELECT EXISTS(SELECT username from peserta WHERE username =username_param) AS RESULT$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_login_admin` (IN `username_param` VARCHAR(15), IN `password_param` VARCHAR(32))  SELECT id FROM admin
WHERE username = username_param
AND password = password_param$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verify_login_user` (IN `username_or_no_hp_param` VARCHAR(15), IN `kode_sesi_param` VARCHAR(5), IN `password_param` VARCHAR(32))  SELECT peserta.id as peserta_id, s.id as sesi_id FROM peserta
INNER JOIN detail_peserta ON peserta.id = detail_peserta.peserta_id
INNER JOIN peserta_ujian pu on peserta.id = pu.peserta_id
INNER JOIN sesi s on pu.sesi_id = s.id
WHERE kode_sesi = kode_sesi_param
AND password = password_param
AND username = username_or_no_hp_param OR no_hp = username_or_no_hp_param
AND detail_peserta.trash_id = 0
AND pu.trash_id = 0
AND detail_peserta.trash_id = 0
AND s.trash_id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` varchar(13) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
('0a5381bd7e69a', 'admin', 'admindc');

-- --------------------------------------------------------

--
-- Table structure for table `bobot_nilai`
--

CREATE TABLE `bobot_nilai` (
  `soal_id` varchar(13) NOT NULL,
  `opsi_a` int(11) NOT NULL DEFAULT 0,
  `opsi_b` int(11) NOT NULL DEFAULT 0,
  `opsi_c` int(11) NOT NULL DEFAULT 0,
  `opsi_d` int(11) NOT NULL DEFAULT 0,
  `opsi_e` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bobot_nilai`
--

INSERT INTO `bobot_nilai` (`soal_id`, `opsi_a`, `opsi_b`, `opsi_c`, `opsi_d`, `opsi_e`) VALUES
('60d190bd3a2d0', 0, 1, 0, 0, 0),
('60d190bd3a2dd', 0, 0, 1, 0, 0),
('60d190bd3a2e8', 1, 0, 0, 0, 0),
('60d190bd3a2f2', 1, 0, 0, 0, 0),
('60d190bd3a2fc', 0, 0, 1, 0, 0),
('60d190bd3a305', 0, 1, 0, 0, 0),
('60d190bd3a30e', 0, 0, 0, 3, 0),
('60d190bd3a318', 0, 0, 1, 0, 0),
('60d190bd3a323', 0, 1, 0, 0, 0),
('60d190bd3a32e', 0, 0, 1, 0, 0),
('60d190bd3a338', 1, 0, 0, 0, 0),
('60d190bd3a341', 1, 0, 0, 0, 0),
('60d190bd3a34b', 0, 0, 1, 0, 0),
('60d190bd3a355', 0, 0, 1, 0, 0),
('60d190bd3a35e', 1, 0, 0, 0, 0),
('60d190bd3a368', 1, 0, 0, 0, 0),
('60d190bd3a371', 1, 0, 0, 0, 0),
('60d190bd3a37b', 0, 1, 0, 0, 0),
('60d190bd3a385', 0, 0, 0, 1, 0),
('60d190bd3a38e', 0, 0, 0, 1, 0),
('60d190bd3a397', 0, 1, 0, 0, 0),
('60d190bd3a3a0', 0, 0, 0, 1, 0),
('60d190bd3a3a9', 1, 0, 0, 0, 0),
('60d190bd3a3b2', 0, 0, 0, 1, 0),
('60d190bd3a3bb', 0, 0, 0, 1, 0),
('60d190bd3a3c4', 0, 0, 0, 1, 0),
('60d190bd3a3cc', 0, 0, 0, 1, 0),
('60d190bd3a3d5', 0, 0, 0, 1, 0),
('60d190bd3a3de', 0, 0, 1, 0, 0),
('60d190bd3a3e7', 1, 0, 0, 0, 0),
('60d190bd3a3f4', 1, 0, 0, 0, 0),
('60d190bd3a406', 0, 0, 1, 0, 0),
('60d190bd3a40f', 0, 0, 1, 0, 0),
('60d190bd3a419', 1, 0, 0, 0, 0),
('60d190bd3a422', 0, 0, 0, 1, 0),
('60d190bd3a42c', 0, 0, 1, 0, 0),
('60d190bd3a435', 0, 0, 1, 0, 0),
('60d190bd3a43d', 0, 0, 0, 1, 0),
('60d190bd3a446', 0, 1, 0, 0, 0),
('60d190bd3a44f', 1, 0, 0, 0, 0),
('60d190bd3a458', 0, 1, 0, 0, 0),
('60d190bd3a461', 1, 0, 0, 0, 0),
('60d190bd3a46a', 0, 0, 1, 0, 0),
('60d190bd3a484', 0, 0, 0, 1, 0),
('60d190bd3a491', 0, 0, 1, 0, 0),
('60d190bd3a49c', 0, 0, 0, 1, 0),
('60d190bd3a4a5', 0, 0, 1, 0, 0),
('60d190bd3a4ae', 0, 0, 0, 1, 0),
('60d190bd3a4b7', 0, 0, 0, 1, 0),
('60d190bd3a4c2', 0, 0, 0, 1, 0),
('60d190bd3a4cb', 0, 0, 0, 1, 0),
('60d190bd3a4d3', 0, 0, 1, 0, 0),
('60d190bd3a4db', 0, 1, 0, 0, 0),
('60d190bd3a4f4', 0, 0, 0, 1, 0),
('60d190bd3a4fc', 0, 1, 0, 0, 0),
('60d190bd3a504', 0, 0, 1, 0, 0),
('60d190bd3a50c', 1, 0, 0, 0, 0),
('60d190bd3a515', 1, 0, 0, 0, 0),
('60d190bd3a51d', 0, 0, 0, 1, 0),
('60d190bd3a525', 0, 0, 0, 1, 0),
('60d190bd3a52d', 0, 0, 0, 1, 0),
('60d190bd3a53b', 0, 0, 0, 1, 0),
('60d190bd3a543', 0, 0, 0, 1, 0),
('60d190bd3a54e', 0, 1, 0, 0, 0),
('60d190bd3a557', 0, 0, 0, 1, 0),
('60d190bd3a55f', 0, 0, 0, 1, 0),
('60d190bd3a568', 0, 0, 0, 1, 0),
('60d190bd3a570', 0, 0, 1, 0, 0),
('60d190bd3a579', 0, 0, 0, 1, 0),
('60d190bd3a582', 0, 0, 1, 0, 0),
('60d190bd3a58a', 1, 0, 0, 0, 0),
('60d190bd3a593', 0, 0, 0, 1, 0),
('60d190bd3a59b', 1, 0, 0, 0, 0),
('60d190bd3a5a3', 0, 0, 1, 0, 0),
('60d190bd3a5ab', 0, 0, 0, 0, 0),
('60d190bd3a5b3', 1, 0, 0, 0, 0),
('60d190bd3a5bb', 0, 0, 0, 1, 0),
('60d190bd3a5c4', 1, 0, 0, 0, 0),
('60d190bd3a5cc', 0, 1, 0, 0, 0),
('60d190bd3a5d5', 0, 0, 0, 1, 0),
('60d190bd3a5dd', 1, 0, 0, 0, 0),
('60d190bd3a5e5', 0, 0, 1, 0, 0),
('60d190bd3a5ed', 0, 0, 1, 0, 0),
('60d190bd3a5f5', 0, 0, 0, 1, 0),
('60d190bd3a5fe', 1, 0, 0, 0, 0),
('60d190bd3a606', 0, 0, 0, 1, 0),
('60d190bd3a60e', 0, 1, 0, 0, 0),
('60d190bd3a616', 0, 0, 1, 0, 0),
('60d190bd3a61e', 0, 0, 1, 0, 0),
('60d190bd3a627', 0, 0, 1, 0, 0),
('60d190bd3a62f', 0, 1, 0, 0, 0),
('60d190bd3a637', 0, 0, 1, 0, 0),
('60d190bd3a63f', 1, 0, 0, 0, 0),
('60d190bd3a64c', 0, 1, 0, 0, 0),
('60d190bd3a655', 0, 0, 0, 1, 0),
('60d190df2c683', 0, 1, 0, 0, 0),
('60d190df2c68f', 1, 0, 0, 0, 0),
('60d190df2c699', 0, 1, 0, 0, 0),
('60d190df2c6a7', 1, 0, 0, 0, 0),
('60d190df2c6af', 0, 0, 0, 1, 0),
('60d190df2c6b8', 0, 1, 0, 0, 0),
('60d190df2c6c1', 0, 0, 1, 0, 0),
('60d190df2c6ca', 0, 1, 0, 0, 0),
('60d190df2c6d5', 0, 0, 1, 0, 0),
('60d190df2c6df', 0, 0, 0, 1, 0),
('60d190df2c6e8', 0, 0, 1, 0, 0),
('60d190df2c6f1', 0, 0, 0, 1, 0),
('60d190df2c6fa', 0, 1, 0, 0, 0),
('60d190df2c703', 0, 1, 0, 0, 0),
('60d190df2c70b', 1, 0, 0, 0, 0),
('60d190df2c714', 1, 0, 0, 0, 0),
('60d190df2c71c', 0, 0, 0, 1, 0),
('60d190df2c725', 0, 0, 1, 0, 0),
('60d190df2c72f', 1, 0, 0, 0, 0),
('60d1914b742f2', 0, 0, 1, 0, 0),
('60d1914b74314', 1, 0, 0, 0, 0),
('60d1914b74346', 0, 0, 0, 1, 0),
('60d1914b74360', 0, 0, 0, 1, 0),
('60d1914b74379', 0, 1, 0, 0, 0),
('60d1914b74391', 0, 1, 0, 0, 0),
('60d1914b743ae', 0, 0, 0, 1, 0),
('60d1914b743cc', 0, 0, 1, 0, 0),
('60d1914b743ea', 0, 1, 0, 0, 0),
('60d1914b74407', 0, 0, 1, 0, 0),
('60d1914b74426', 1, 0, 0, 0, 0),
('60d1914b74444', 0, 0, 0, 1, 0),
('60d1914b74462', 0, 0, 1, 0, 0),
('60d1914b7447e', 0, 0, 1, 0, 0),
('60d1914b7449f', 1, 0, 0, 0, 0),
('60d1914b744c2', 0, 0, 0, 1, 0),
('60d1914b744e4', 0, 1, 0, 0, 0),
('60d1914b74503', 0, 0, 1, 0, 0),
('60d1914b74522', 0, 1, 0, 0, 0),
('60d1914b74541', 0, 0, 0, 1, 0),
('60d1914b7454e', 1, 0, 0, 0, 0),
('60d1914b74559', 1, 0, 0, 0, 0),
('60d1914b74563', 0, 0, 0, 1, 0),
('60d1914b7456e', 0, 1, 0, 0, 0),
('60d1914b74579', 0, 1, 0, 0, 0),
('60d1914b74584', 0, 0, 0, 1, 0),
('60d1914b7458e', 1, 0, 0, 0, 0),
('60d1914b74598', 0, 0, 0, 1, 0),
('60d1914b745a3', 1, 0, 0, 0, 0),
('60d1914b745ae', 0, 1, 0, 0, 0),
('60d191984ed61', 1, 0, 0, 0, 0),
('60d191984ed68', 0, 1, 0, 0, 0),
('60d191984ed6f', 1, 0, 0, 0, 0),
('60d191984ed76', 0, 0, 0, 0, 1),
('60d191984ed7c', 0, 0, 0, 1, 0),
('60d191984ed83', 1, 0, 0, 0, 0),
('60d191984ed8a', 0, 0, 0, 1, 0),
('60d191984ed91', 0, 0, 0, 1, 0),
('60d191984ed97', 0, 1, 0, 0, 0),
('60d191984ed9e', 1, 0, 0, 0, 0),
('60d191984eda5', 1, 0, 0, 0, 0),
('60d191984edab', 0, 0, 0, 1, 0),
('60d191984edb2', 0, 0, 0, 1, 0),
('60d191984edb9', 0, 0, 0, 0, 1),
('60d191984edc0', 0, 1, 0, 0, 0),
('60d191984edc6', 0, 1, 0, 0, 0),
('60d191984edcd', 1, 0, 0, 0, 0),
('60d191984edd4', 0, 0, 0, 0, 1),
('60d191984edda', 0, 0, 1, 0, 0),
('60d191984ede1', 0, 0, 1, 0, 0),
('60d191984ede8', 0, 0, 0, 0, 1),
('60d191984edef', 0, 0, 0, 0, 1),
('60d191984edf6', 0, 1, 0, 0, 0),
('60d191984edfc', 0, 0, 0, 0, 1),
('60d191984ee03', 0, 0, 1, 0, 0),
('60d191984ee09', 0, 0, 0, 0, 1),
('60d191984ee10', 0, 0, 1, 0, 0),
('60d191984ee17', 0, 0, 0, 1, 0),
('60d191984ee1d', 0, 0, 0, 0, 1),
('60d191984ee24', 0, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `detail_admin`
--

CREATE TABLE `detail_admin` (
  `admin_id` varchar(13) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_admin`
--

INSERT INTO `detail_admin` (`admin_id`, `nama`, `no_hp`, `trash_id`) VALUES
('0a5381bd7e69a', 'Admin', '082108210821', 0);

-- --------------------------------------------------------

--
-- Table structure for table `detail_peserta`
--

CREATE TABLE `detail_peserta` (
  `peserta_id` varchar(13) NOT NULL,
  `nama` varchar(32) NOT NULL,
  `asal_sekolah` varchar(50) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_peserta`
--

INSERT INTO `detail_peserta` (`peserta_id`, `nama`, `asal_sekolah`, `no_hp`, `trash_id`) VALUES
('ed7658658476a', 'User Digital Creative', 'Classico', '080908090809', 0);

-- --------------------------------------------------------

--
-- Table structure for table `detail_trash`
--

CREATE TABLE `detail_trash` (
  `id` int(11) NOT NULL,
  `deskripsi` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `detail_trash`
--

INSERT INTO `detail_trash` (`id`, `deskripsi`) VALUES
(0, 'Non-Trash'),
(1, 'Trash');

-- --------------------------------------------------------

--
-- Table structure for table `jawaban`
--

CREATE TABLE `jawaban` (
  `soal_id` varchar(13) NOT NULL,
  `opsi_a` varchar(500) NOT NULL,
  `opsi_b` varchar(500) NOT NULL,
  `opsi_c` varchar(500) NOT NULL,
  `opsi_d` varchar(500) NOT NULL,
  `opsi_e` varchar(500) NOT NULL,
  `kunci` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `jawaban`
--

INSERT INTO `jawaban` (`soal_id`, `opsi_a`, `opsi_b`, `opsi_c`, `opsi_d`, `opsi_e`, `kunci`) VALUES
('60d190bd3a2d0', 'Setelah melaksanakan proses pembelajaran melalui praktik, peserta didik dapat menjelaskan kondisi operasi sistem dan komponen perangkat keras berupa komponen input, proses dan output. ', ' Melalui melaksanakan proses pembelajaran dan menggali informasi melalui diskusi, peserta didik dapat menjelaskan kondisi operasi sistem dan komponen perangkat keras secara benar. ', ' Siswa dapat menjelaskan kondisi operasi sistem dan komponen perangkat keras berupa komponen input, proses, dan output secara benar.', 'Menjelaskan kondisi operasi sistem dan komponen perangkat keras komponen input, proses, dan output tanpa melihat catatan.', '', 'B'),
('60d190bd3a2dd', 'teks ', ' poster', 'video', 'foto', '', 'C'),
('60d190bd3a2e8', ' evaluasi formatif ', 'evaluasi sumatif ', ' evaluasi selektif ', 'evaluasi diagnostik', '', 'A'),
('60d190bd3a2f2', 'Mengidentifikasi aspek-aspek yang terdapat dalam kompetensi inti, kompetensi dasar, dan indikator. ', 'Menganalisis potensi peserta didik; relevansi dengan karakteristik daerah; dan struktur keilmuan', 'Menyesuaikan dengan tingkat perkembangan fisik, intelektual, emosional, sosial, dan spritual peserta didik. ', ' Melihat kebermanfaatan bagi peserta didik; aktualitas, kedalaman, dan keluasan materi pembelajaran.', '', 'A'),
('60d190bd3a2fc', 'identitas, kompetensi dasar, tujuan pembelajaran, dan penilaian', ' kompetensi dasar, langkah pembelajaran, dan penilaian', ' tujuan pembelajaran, langkah pembelajaran, dan penilaian', 'indikator, tujuan pembelajaran, dan langkah pembelajaran', '', 'C'),
('60d190bd3a305', 'cooperatif learning', ' project based learning ', 'contexstual learning', 'discovery learning', '', 'B'),
('60d190bd3a30e', ' ingatan; pemahaman, analisis, aplikasi, sintesis, dan evaluasi;', 'ingatan, pemahaman, aplikasi, analisis, síntesis', 'ingatan, pemahaman, síntesis, aplikasi, analsis, dan evaluasi', 'ingatan, pemahaman, aplikasi, analisis, evaluasi, dan, mencipta', '', 'D'),
('60d190bd3a318', 'role playing', ' inquiry learning', ' problem solving', ' picture and picture', '', 'C'),
('60d190bd3a323', 'silabus', 'RPP', 'kompetensi', 'media', '', 'B'),
('60d190bd3a32e', 'evaluasi hasil implementasi kurikulum', 'evaluasi implementasi kurikulum', ' evaluasi komprehensif', 'evaluasi dokumen kurikulum', '', 'C'),
('60d190bd3a338', ' naturalis ', ' kinestetis ', 'visual spasial ', 'verbal linguistik ', '', 'A'),
('60d190bd3a341', 'penilaian kinerja ', 'penilaian proyek ', 'penilaian portofolio ', 'pertanyaan terbuka', '', 'A'),
('60d190bd3a34b', 'kinerja ', 'portofolio ', 'proyek ', 'jurnal ', '', 'C'),
('60d190bd3a355', ' koginitif', 'sosial', 'emosional', 'moral', '', 'A'),
('60d190bd3a35e', ' sosial emosional', '  kognitif', ' moral ', ' spriritual', '', 'A'),
('60d190bd3a368', 'materi atau bahan ajar berbasis kompetensi', ' pembelajaran dirancang dengan berpusat pada peserta didik', ' RPP bersumber dari silabus', 'Alokasi waktu sesuai dengan jadwal pada setiap satuan pendidikan', '', 'A'),
('60d190bd3a371', 'Soal harus sesuai dengan indikator ', 'Pokok soal harus dirumuskan secara jelas ', 'Pilihan jawaban harus homogen dan logis ', 'Panjang rumusan pilihan jawaban relatif sama', '', 'A'),
('60d190bd3a37b', 'behaviorisme ', 'kognitif ', 'humanistik ', 'sibernetik', '', 'B'),
('60d190bd3a385', 'Media pembelajaran yang paling baik adalah media yang berbasis TIK', 'Sebuah media dapat digunakan untuk semua kegiatan pembelajaran', 'Semua media pembelajaran sama cara pemanfaatannya. ', 'Media dapat digunakan sebagai pembawa pesan dalam suatu kegiatan pembelajaran.', '', 'D'),
('60d190bd3a38e', 'Media pembelajaran yang paling baik adalah media yang berbasis TIK', 'Memberikan tambahan sumber bacaan yang lebih mendalam dan tingkat variasi yang tinggi berikut instrumen tesnya yang sesuai. ', 'Diberi soal serupa untuk memastikan tingkat keberhasilan belajar. ', 'Diberikan materi bahan ajar yang lebih tinggi tingkatannya dan mengerjakan soal-soal yang memiliki kesulitan tinggi.', '', 'D'),
('60d190bd3a397', ' Mendorong siswa untuk membuat keputusan sendiri', 'Memberi balikan dan pengayaan sebagaimana diperlukan.', 'Mengusahakan suasana belajar yang menyenangkan', 'Memasukkan unsur yang tidak diperkirakan sebelumnya.', '', 'B'),
('60d190bd3a3a0', 'standar kompetensi lulusan (SKL)', ' standar batas minimum kelulusan', ' ambang batas minimum lulus', 'kriteria ketuntasan minimal (KKM)', '', 'D'),
('60d190bd3a3a9', ' afektif', 'kognitif', 'psikomotorik', 'emotif', '', 'A'),
('60d190bd3a3b2', 'kompetensi dasar', 'standar kompetensi', 'indikator', 'kompetensi Iulusan', '', 'D'),
('60d190bd3a3bb', 'Memperhatikan perbedaan individu', 'Mendorong partisipasi aktif peserta didik', 'Memberikan umpan balik dan tindak Ianjut', 'Keterkaitan dan keterpaduan isi dengan silabus.', '', 'D'),
('60d190bd3a3c4', 'kompetensi pedagogik', 'kompetensi kepribadian', 'kompetensi profesional', 'kompetensi keahlian', '', 'D'),
('60d190bd3a3cc', 'identitas mata pelajaran', 'standar kompetensi', 'kompetensi dasar', 'presensi peserta didik', '', 'D'),
('60d190bd3a3d5', 'cara belajar siswa aktif (cbsa)', 'guru pamong', 'sistem belajar jarak jauh', 'sekolah bebas', '', 'D'),
('60d190bd3a3de', 'Undang-Undang RI Nomor 9 Tahun 2003', 'Undang-Undang RI Nomor 11 Tahun 2003', 'Undang-Undang RI Nomor 20 Tahun 2003', 'Undang-Undang RI Nomor 14 Tahun 2003', '', 'C'),
('60d190bd3a3e7', 'Standar Penilaian Pendidikan', 'Standar Proses Belajar Mengajar', 'Penilaian Berbasis Kelas', 'Sertifikasi Guru', '', 'A'),
('60d190bd3a3f4', 'Bab ll pasal 3 UU Guru dan Dosen No. 14 Tahun 2005', ' Bab II pasal 3 UU Guru dan Dosen No. 4 Tahun 2005', 'Bab ll pasal 3 UU Guru dan Dosen No. 20 Tahun 2005', 'Bab I pasal 2 UU Guru dan Dosen No. 14 Tahun 2005', '', 'A'),
('60d190bd3a406', 'Memiliki bakat, minat, panggilan jiwa dan idealisme', 'Memiliki komitmen untuk meningkatkan mutu pendidikan, keimanan, ketaqwaan dan akhlak mulia', 'Mampu mengenal karaktetistik setiap siswa / setiap mahasiswa diperguruan tinggi / sekolahan', 'Memiliki kualifikasi akademik dan Iatar belakang pendidikan sesuai dengan bidang tugas', '', 'C'),
('60d190bd3a40f', 'Melaksanakan pendidikan, penelitian, dan pengabdian kepada masyarakat.', 'Memperoleh penghasilan di atas kebutuhan minimum dan jaminan   \n     kesejahteraan sosial\n', 'Mendapatkan promosi dan penghargaan sesuai dengan tugas dan prestasi', 'Memperoleh perlindungan dalam melaksanakan tugas dan hak atas kekayaan  \n     intelektual\n', '', 'C'),
('60d190bd3a419', 'Evaluasi hasil implementasi kurikulum', 'Evaluasi implementasi kurikulum', 'Evaluasi dokumen kurikulum', 'Evaluasi reflektif', '', 'A'),
('60d190bd3a422', 'mahalnya biaya pendidikan', 'korupsi dana pendidikan', 'kurangnya minat masyarakat akan pendidikan', 'kurangnya fasilitas pendidikan', '', 'D'),
('60d190bd3a42c', 'Berwarna gelap', 'Seminimal mungkin', 'Berwarna warni', 'Semaksimal mungkin', '', 'C'),
('60d190bd3a435', 'Membuat kebijakan baru mengenai srategi pembelajaran.', 'Mengkaji kembali apa yang telah dipelajari oleh siswa', 'Memberdayakan semua imelegensi yang dimiliki oleh siswa', 'Menyediakan fasilitas yang Iengkap untuk semua jenis kecerdasan', '', 'C'),
('60d190bd3a43d', 'Siswa berolah raga di lapangan', 'Guru memberi hadiah kepada siswa berprestasi', 'Siswa diajak berkarya wisata', 'Siswa belajar di ruang Iaboratorium bahasa', '', 'D'),
('60d190bd3a446', 'clasical conditioning', 'connectionism', 'behaviorism', 'operant conditioning', '', 'B'),
('60d190bd3a44f', 'Kurikulum', ' Kerangka pembelajaran', 'Sistem', 'Evaluasi', '', 'A'),
('60d190bd3a458', 'Tes obyektif', 'Tes berupa angket', ' Tes kemampuan gerak', 'Tes kemampuan fungsional otot tubuh', '', 'B'),
('60d190bd3a461', ' Menjumlahkan skor-skor yang diperoleh', 'Menentukan jumlah besar nya orang dalam kelas', 'Mencari nilai rata rata dengan pendekatan rumus', 'Menentukan rentang skor terbesar dikurangi skor terkecil', '', 'A'),
('60d190bd3a46a', 'Mampu bermain dalam kelompok', 'Mampu menjadi pemimpin', 'Mudah berkonsentrasi', 'Peka terhadap teman', '', 'C'),
('60d190bd3a484', ' Insight', '  Kognitif', 'Conditioning', 'Connectionism', '', 'D'),
('60d190bd3a491', 'Membagi kelompok diskusi ', 'Menyuruh anak itu mengerjakan soal kedepan dan membimbingnya', 'Mengelompokkan dengan siswa pintar agar bisa ikut terimbas', 'Melakukan pembmbingan di tempat duduk mereka  ', '', 'C'),
('60d190bd3a49c', 'Memajang hasil karya puisi siswa', 'Diajak ke perpustakaan rutin dan membuat mading poster', 'Diajak ke laboratorium sains dan mencari literatur tentang sains', 'Kegiatan membaca rutin setiap pagi sebelum masuk ruangan dan membuat majalah dinding', '', 'D'),
('60d190bd3a4a5', ' portofolio', 'autentik', 'saintifik', 'penemuan', '', 'C'),
('60d190bd3a4ae', 'menggunakan angka-angka tanpa disertai peringkat', 'menggunakan angka-angka dan peringkat sementara siswa dalam kelas', 'dalam bentuk kategori A= sangat baik, B= baik, C=kurang baik, D= kurang sekali', 'dalam bentuk deskripsi tentang KKM yang sudah dicapai dan belum dicapai', '', 'D'),
('60d190bd3a4b7', 'Ditulis oleh guru yang mengajar di kelas.', 'Menuntut jawaban berupa fakta-fakta yang sebenarnya.', 'Ditulis dalam bahasa Indonesia yang baik dan benar.', 'Menuntut jawaban berupa ungkapan pendapat siswa. ', '', 'D'),
('60d190bd3a4c2', 'Menjelaskan konsep mitigasi bencana dengan menggunakan papan tulis dan kapur. ', 'Memfasilitasi siswa mencari informasi berbagai bencana di Indonesia.', 'Memfasilitasi siswa mendiskusikan bencana di Indonesia menuliskan hasilnya di kertas.', 'Meminta siswa berlatih pemecahan masalah mengatasi bencana banjir dengan memanfaatkan yang ada di lingkungan.', '', 'D'),
('60d190bd3a4cb', 'Optics', 'Thermodynamics', 'Stastistical mechanics', ' Biology', '', 'D'),
('60d190bd3a4d3', 'Dangerous', 'Extremist', 'Momentous', 'Militarist', '', 'C'),
('60d190bd3a4db', ' The rocket', 'The atomic bomb', 'The internal combustion engine', 'The computer', '', 'B'),
('60d190bd3a4f4', 'have a high spirit to study', 'solve their own problems', 'care for their environment', ' follow the new rule', '', 'D'),
('60d190bd3a4fc', 'To pay for the trip', ' To go to the teacher’s office', ' To meet the headmaster', 'To bring the changing clothes', '', 'B'),
('60d190bd3a504', 'There are at least 5 activities that the school offers', 'The students should bring their own food', 'The holiday will last for two days', ' The holidays won’t be excited', '', 'C'),
('60d190bd3a50c', 'All interaction between teacher and student is accomplished \"online\" through an Internet or intranet connection.', ' a system of learning on your own by writing letters', 'It is a term we apply to any distance learning course that is done by means of computers', 'a learning system for college and university students', '', 'A'),
('60d190bd3a515', ' easy to do', 'cheaper than face to face learning', 'convenient', 'satisfying', '', 'A'),
('60d190bd3a51d', 'Mebaca Survai', 'Membaca Sekilas', 'Membaca Dangkal', 'Membaca Nyaring', '', 'D'),
('60d190bd3a525', ' Kejadian', 'Tokoh', ' Alur', '. Penulis', '', 'D'),
('60d190bd3a52d', 'kerajaan Aceh', 'Kerajaan Demak ', 'Kerajaan Majapahit ', 'kerajaan Samudra Pasai ', '', 'D'),
('60d190bd3a53b', ' rhizoma ', 'geragih ', 'stolon', 'mengenten ', '', 'D'),
('60d190bd3a543', '4', '8', '5', '10', '', 'D'),
('60d190bd3a54e', 'tarik - menarik', 'tolak - menolak', 'berhimpitan', 'tetap', '', 'B'),
('60d190bd3a557', 'menunjukkan variasi yang besar pada tinggi dan berat badan', 'memiliki keterampilan fisik untuk memainkan permainan ', 'penambahan-penambahan dalam kemampuan motorik halus', 'memiliki kemampuan dalam mengangkat beban yang berat', '', 'D'),
('60d190bd3a55f', 'Rakyat', 'MPR', 'DPR', 'Presiden', '', 'D'),
('60d190bd3a568', 'coba-ralat (trial and error)', 'pendidikan langsung', 'identifikasi', 'observasi', '', 'D'),
('60d190bd3a570', 'Orang pertama', 'Orang kedua', 'Orang ketiga', 'Orang keempat', '', 'C'),
('60d190bd3a579', 'delapan kali jarak Neptunus ke Matahari', 'empat kali jarak Saturnus ke Matahari', 'delapan kali jarak Uranus ke Matahari', 'dua kali jarak Uranus ke Matahari', 'setengah jarak Uranus ke Matahari', '0'),
('60d190bd3a582', 'Selisih energi kinetik di titik E dan energi potensial pegas maksimum', 'Selisih energi mekanik di titik A dan energi kinetik di titik C', 'Selisih energi kinetik di titik E dan energi kinetik di titik C', 'Sama dengan perubahan energi kinetik dari A ke E', 'Selisih energi kinetik di titik E dan energi potensial di titik D', '0'),
('60d190bd3a58a', '6 m/s', '10 m/s', '16 m/s', '20 m/s', '24 m/s', '0'),
('60d190bd3a593', '', '', '', '', '', '0'),
('60d190bd3a59b', '0.21041666666667', '0.12638888888889', '0.20972222222222', '0.085416666666667', '0.12847222222222', '0'),
('60d190bd3a5a3', 'konstanta pegas C dua kali konstanta pegas B', 'konstanta pegas C dua kali konstanta pegas A', 'ketiga diberi gaya 3 N ketiga pegas memiliki stres yang sama', ' ketika diberi gaya 3 N ketiga pegas memiliki strain yang sama', 'ketika diberi gaya 3 N strain pegas A dua kali strain pegas B', '0'),
('60d190bd3a5ab', ' mengalir dari A ke B', ' mengalir dari A ke C', ' mengalir dari A ke B', ' mengalir dari B ke C', ' mengalir dari C ke B', '1'),
('60d190bd3a5b3', '7,0.10-5 T, tegak lurus menuju bidang kertas', '7,0.10-5 T, tegak lurus menjauhi bidang kertas', ' 9,0.10-5 T, tegak lurus menuju bidang kertas', '9,0.10-5 T, tegak lurus menjauhi bidang kertas', '14,0.10-5 T, tegak lurus menuju bidang kertas', '0'),
('60d190bd3a5bb', 'Frekuensi gelombang datang fi sama dengan frekuensi gelombang terhambur ff', 'Panjang gelombang datang lebih panjang dari pada panjang gelombang terhambur', 'Energi gelombang terhambur lebih kecil dari energi elektron terpental', 'Frekuensi gelobang terhambur lebih kecil daripada frekuensi gelombang datang', ' Terjadi kekekalan energi antara gelombang datang dan gelombang terhambur.', '0'),
('60d190bd3a5c4', ' mengaktifkan detektor kebocoran radioaktif', 'penggunaan pil potasium iodida', 'tidak menggunakan zat radioaktif', ' pelarangan terhadap produk radioaktif', 'menggagalkan pembangunan reaktor nuklir', '0'),
('60d190bd3a5cc', 'Nativisme', 'Behaviorisme', 'Kognitivisme', 'Interaksionalisme', '', ''),
('60d190bd3a5d5', ' mengamati gambar tentang peristiwa alam', 'menyimpulkan isi teks tentang peristiwa alam', 'menelaah struktur teks eksplanasi', 'menyusun teks eksplanasi', '', ''),
('60d190bd3a5dd', 'generalisasi\n', '\nmedan semantik\n', 'pemaknaan\n', ' perluasan makna\n\n', '', ''),
('60d190bd3a5e5', 'Bahasa itu relatif.', 'Bahasa itu produktif', 'Bahasa itu arbitrer.', 'Bahasa itu lambang.', '', ''),
('60d190bd3a5ed', 'Memelihara bahasa Indonesia agar mencerminkan nilai-nilai budaya bangsa. ', 'Membina bahasa Indonesia agar bersih dari unsur-unsur bahasa lain. ', 'Berpidato di sidang DPR dan acara-acara resmi.  ', 'Menjaga agar bahasa Indonesia tidak terpengaruh sistem bahasa Daerah', '', ''),
('60d190bd3a5f5', 'Lambang identitas nasional', 'Lambang kebanggaan kebangsaan', 'Alat penghubung antarwarga, antardaerah, dan antarbudaya', 'Sebagai bahasa pengantar dalam dunia pendidikan', '', ''),
('60d190bd3a5fe', 'kreativitas pemakainya', 'pengajaran bahasa', 'pemikiran para ahli bahasa', 'pengaruh politik pemerintah', '', ''),
('60d190bd3a606', 'siang-malam         ', 'tinggi-pendek       ', 'awal-akhir', 'hidup-mati', '', ''),
('60d190bd3a60e', '1', '2', '3', '4', '', ''),
('60d190bd3a616', 'Penulisan huruf kapital pada kata Bali.', 'Kata pandemi seharusnya dicetak miring.', 'Kesalahan penulisan imbuhan ', 'Kesalahan penulisan kata depan ', '', ''),
('60d190bd3a61e', 'Pentingnya menjaga imunitas untuk mencegah Covid-19 saat pandemi', 'Pencegahan Covid-19 sangat erat kaitannya dengan gaya hidup manusia', 'Pencegahan Covid-19 tidak bisa terlepas dari kondisi lingkungan hidup', 'Pentingnya menjaga kesehatan keluarga dalam mengendalikan Covid-19', '', ''),
('60d190bd3a627', 'Sage, fabel, mitos', 'dongeng, legenda, fable ', ' legenda, dongeng, mitos', 'roman, novel, cerpen', '', ''),
('60d190bd3a62f', 'Legenda', 'Mite', 'Dongeng', 'Fabel', '', ''),
('60d190bd3a637', 'isi semua         ', 'sampiran semua          ', 'setiap baris tidak terdiri dari 8-12 suku kata        ', 'sampiran dan isi tidak berhubungan', '', ''),
('60d190bd3a63f', 'dialog secara langsung', 'dialog secara tertulis  ', 'dialog diberi tanda kutip        ', 'dialog diikuti letak menjorok', '', ''),
('60d190bd3a64c', 'penglihatan', 'perasa', 'pendengaran    ', 'penciuman', '', ''),
('60d190bd3a655', 'Fitnah itu ibarat panah, maka jangan sekali-kali ditantang', 'Hendaklah dapat menahan panah agar tidak difitnah orang', 'Janganlah berkata dusta, agar tidak kena fitnah orang', 'Apabila sering memfitnah orang, fitnah itu akan berbalik kepadanya.', '', ''),
('60d190df2c683', 'Tepat tepat karena tujuan menambah tugas supaya 3 anak tersebut ada pekerjaan. ', 'Tepat jika tugas yang diberikan didasarkan pada kebutuhan belajar 3 anak tersebut.', 'Tepat karena dengan menambah tugas merupakan bentuk pelaksanaan pemberian pengayaan.', 'Tepat karena dengan pemberian tugas pada  3 anak tersebut supaya anak tidak menganggu murid lain. ', '', 'B'),
('60d190df2c68f', 'Menumbuhkan displin positif pada anak dengan mebuat kesepakan kelas.', 'Berdiskusi dengan guru lain bagaimana cara mendisiplinkan anak di kelas.', 'Membuat aturan yang tegas agar anak-anak patuh terhadap aturan tersebut. ', 'Melaporkan murid-murid yang tidak disiplin pada guru bimbingan konseling.', '', 'A'),
('60d190df2c699', 'Membiarkan rapat berjalan yang penting pelaksanaan tercapai. (1)', 'Melapor kepada Kepala Sekolah bahwa wakil kepala sekolah dalam keadaan sakit. (4)', 'Menegur wakil kepala sekolah tersebut untuk menjadwalkan ulang rapat staf bidang kurikulum. (3)', 'Meminta wakil kepala sekolah pulang dan mempercayakan tugas tersebut kepada Anda. (2) ', '', 'B '),
('60d190df2c6a7', 'Menahan diri, mencermati kritikan tersebut untuk melakukan perbaikan. (4)', 'Membiarkan kritikan itu, karena pada satu waktu akan hilang dengan sendirinya. (1)', 'Tetap mempertahankan hasil pekerjaan saya dan berargumentasi dengan Kepala Sekolah. (2)', 'Tidak membalas kritikan tersebut dan juga tidak melakukan perbaikan  karena tidak ada gunanya. (3)', '', 'A'),
('60d190df2c6af', 'Menerima keponakan kepala sekolah meskipun mendaftarnya lebih dulu calon peserta didik lainnya. ', 'Menerima peserta didik lainnya karena mendaftar lebih dulu untuk menjaga objektivitas. ', 'Mengikuti apa yang diiinstruksikan kepala sekolah untuk menerima keponakannya sebagai peserta didik. ', 'Membahas dalam rapat panitia agar keputusan yang diambil lebih objektif dan dapat dipertanggungjawabkan. ', '', 'D'),
('60d190df2c6b8', 'Menerima tugas itu dan mengerjakannya setelah tugas-tugas lain yang datang terlebih dahulu.', 'Mengoordinasikan dan bersinergi dengan pihak-pihak yang terlibat dalam kepanitiaan. ', 'Walaupun dengan berat hati akan bekerja dan menjalankan tugas itu apa adanya. ', 'Menolak tugas tersebut, karena sudah ada tugas lain yang harus dikerjakan dan diselesaikan.', '', 'B'),
('60d190df2c6c1', 'Memberikan tugas atau pekerjaan rumah yang lebih banyak dari yang lain untuk meningkatkan prestasi akademik Dika.', 'Membebaskan Dika dari tugas akademik dan memaksimalkan bakat menari Dika agar terus berkembang. ', 'Membimbing Dika untuk meningkatkan prestasi akademiknya disertai bakat menari agar berkembang secara optimal. ', 'Membiarkan saja karena masing-masing peserta didik akan berkembang dengan sendirinya. ', '', 'C'),
('60d190df2c6ca', 'Saya akan lebih aktif dalam memperingatkan peserta didik yang kedapatan sering merokok di kamar mandi. ', 'Bersama seluruh komponen sekolah, untuk memberikan contoh perilaku baik tidak di sekolah.', 'Karena ada petugasnya masing-masing (Guru BK), sebaiknya saya diam saja. ', 'Yang terpenting saya tidak merokok di depan peserta didik.', '', 'B'),
('60d190df2c6d5', 'Memfasilitasi pertemuan anggota kelompok agar tidak ada pemaksaan dan semua ikut berkontribusi. ', 'Menerima laporan tersebut saja dan akan memberikan konsekuensi dalam penilaian tugas tersebut kepada peserta didik yang enggan terlibat dalam kerja kelompok. ', 'Meningkatkan pemantuan proses kerja kelompok dan menginformasikan hasil evaluasi serta keterlibatan setiap anggota dalam kerja akelompok. ', 'Memberikan terguran kepada peserta didik yang enggan terlibat dalam kerja kelompok. ', '', 'C'),
('60d190df2c6df', 'Masyarakat dan sekolah punya perannya masing-masing dan penyelenggaraan pendidikan di sekolah dilakukan oleh sekolah, masyarakat tidak memiliki perannya di sekolah. ', 'Masyarakat dan sekolah perlu bekerja sama dengan membuat kontrak kesepakatan yang nyata dalam dokumen yang dapat dipertanggungjawabkan. ', 'Masyarakat merupakan patner sekolah dalam memajukan pendidikan peserta didik, sehingga perlu ditingkatkan dalam perencanaan sekolah. ', 'Masyarakat memiliki potensi-potensi yang dapat dikolaborasikan dengan kegiatan sekolah sesuai prosedur dan aturan yang berlaku. ', '', 'D'),
('60d190df2c6e8', 'Membiarkannya ', 'Memanggilnya setelah rapat ', 'Membiarkannya menerima telepon ', 'Menegurnya supaya keluar dari rapat ', '', 'C'),
('60d190df2c6f1', 'Menyewa mobil yang dapat mengangkut sampah untuk mengangkut sampah yang sudah menumpuk. ', 'Membiarkan warga melalukan apa yang mereka ingin lakukan sampai mobil pengangkut sampah beroperasi kembali. ', 'Mengingatkan warga agar tidak membuang sampah ke sungan karena akan menimbulkan banjir. ', 'Membicarakan persoalan tersebut dengan ketua RT dan tokoh masyarakat untuk mencarikan solusi. ', '', 'D'),
('60d190df2c6fa', 'Menegurnya agar tidak terlambat lagi ', 'Menyilakan masuk dan mengikuti rapat ', 'Membiarkan tanpa komentar ', 'Mencatat ketidakdisiplinan tersebut ', '', 'B'),
('60d190df2c703', 'Melaporkan kepada kepala sekolah bahwa ada guru yang tidak hadir tanpa memberi tugas. ', 'Memberi tugas kepada murid setelah menanyakan materi terakhir yang dipelajari dan melanjutkannya. ', 'Memberi tugas kepada murid sesuai mata pelajaran yang Anda diampu daripada murid tidak belajar. ', 'Menunggui kelas tersebut dan meminta murid untuk diam dan tidak rebut. ', '', 'B'),
('60d190df2c70b', 'Menerima koreksi dan memperbaiki proposal tersebut. ', 'Menolak memperbaiki karena proposal sudah disusun secara maksimal. ', 'Menerima koreksi, namun tidak mau memperbaiki proposal tersebut. ', 'Meminta kepala sekolah menugaskan guru lain memperbaiki proposal tersebut.', '', 'A'),
('60d190df2c714', 'Memberi penjelasan bahwa penilaian yang dilakukan objektif.', 'Melaporkan wali kelas kepada kepala sekolah. ', 'Menolak secara tegas permintaan tersebut. ', 'Menerima permintaan tersebut dengan mengubah nilai.', '', 'A'),
('60d190df2c71c', 'a.         Merasa tersinggung dan memarahi Sari karena mengerjakan tugas lain (2)', 'b.        Menyuruh Sari keluar kelas dan tetap mengerjakan tugas yang diberikan. (3)', 'c.         Melaporkan tindakan Sari kepada wali kelas dan meminta memanggil orang tua. (1)', 'd.        Meminta Sari untuk fokus pada mata pelajaran dan mengerjakan tugas dengan baik. (4)', '', 'D'),
('60d190df2c725', 'Meminta keluar dari barisan dan  membuat barisan tersendiri. ', 'Menegur beberapa murid tersebut sambil memelotot. ', 'Mendekati beberapa murid tersebut, sikap sempurna, tetap menyanyikan Indonesia Raya. ', 'Membiarkan beberapa murid tersebut, setelah selesai upacara memberi sanksi dengan menyuruhnya lari keliling lapangan. ', '', 'C'),
('60d190df2c72f', 'Menuntun, karena setiap murid mempunyai kebutuhan belajar. ', 'Mengayomi, karena murid berasal dari berbagai latar belakang. ', 'Memberi contoh dalam bersikap dan bertindak. ', 'Mengajar dengan baik menerapkan berbagai metode pembelajaran. ', '', 'A'),
('60d1914b742f2', 'UU No.36 tahun 1999 ', 'UU No.23 tahun 2002', 'UUD 1945 ', 'Pancasila ', '', 'C'),
('60d1914b74314', 'Primordialisme ', 'Etnosentrisme', 'Diskriminatif', 'Stereotipe', '', 'A'),
('60d1914b74346', 'Pembangunan untuk lebih maju ', 'Pembangunan suatu Negara', 'Pembangunan menyeluruh ', 'Pembangunan yang berbudaya', '', 'D'),
('60d1914b74360', 'Mencari dengan seksama siapa yang turut bertanggung jawab terhadap kegagalan', 'Saya mengambil waktu untuk menenangkan diri ', 'Bersedih hati ', 'Melakukan introspeksi dan memperbaiki kegagalan tersebut ', '', 'D'),
('60d1914b74379', 'Patrilineal', 'Parental', 'Matrilineal ', 'Parenting ', '', 'B'),
('60d1914b74391', 'Stereotipe', 'Fanatisme ', 'Etnosentrisme', 'Diskriminatif', '', 'B'),
('60d1914b743ae', 'Perpecahan dalam masyarakat ', 'Dominasi', 'Kerugian harta benda ', 'Rasa saling menghargai ', '', 'D'),
('60d1914b743cc', 'Peralatan ', 'Bahasa dan Tarian ', 'Bahasa dan Kesenian ', 'Tempat wisata dan Sistem keagamaan ', '', 'C'),
('60d1914b743ea', 'Akomodasi ', 'Kompromi ', 'Kolaborasi ', 'Kompetisi ', '', 'B'),
('60d1914b74407', 'Tidak masuk kerja dan memberikan surat izin ', 'Bekerja ke kantor seperti biasa dan menghubungi orang tua setiap waktu dari tempat kerja ', 'Berusaha membereskan pekerjaan dan meminta izin kepada atasan jika memang itu diperlukan ', 'Mengurus orang tua dan mengirimkan surat sakit dari dokter ', '', 'C'),
('60d1914b74426', 'Terbuka, ingin belajar tentang perbedaan /kemajemukan masyarakat', 'Mampu bekerja sama dengan rekan kerja yang berbeda latar belakang kebudayaan', 'Peka dan memahami perbedaan latar belakang kebudayaan/kemajemukan masyarakat', 'Mampu memahami, menerima, dan peka terhadap perbedaan latar belakang kebudayaan/kemajemukan masyarakat', '', 'A'),
('60d1914b74444', 'Budaya belajar dari negara maju yang bekerja sama dengan mesin', 'Budaya melintas ke masa depan', 'Budaya yang berorientasi masa lampau', 'Budaya mengerjakan segala sesuatu dengan sebaik mungkin', '', 'D'),
('60d1914b74462', 'Melarang siswa mengenal dan mempelajari budaya asing', 'Berkunjung ke negara lain untuk mempelajari budaya asing', 'Membelajarkan nilai-nilai Pancasila dan proses seleksi sistem nilai kepada siswa', 'Meniru budaya asing yang sedang populer dan terkenal', '', 'C'),
('60d1914b7447e', 'Mengajaknya mengenal budaya dengan mengenalkan sejarah di tempat-tempat yang dilewati', 'Mengajaknya main ke tempat-tempat ibadah', 'Menjadi wakil orang tua nya untuk mendidik mengenai keberagaman', 'Mengajak orang-orang di sekitar lingkungan tempat tinggal Anda untuk memperkenalkan keberagaman kepada anak tersebut.', '', 'C'),
('60d1914b7449f', 'Orang cenderung melakukan hal-hal yang lebih fragmatis untuk berinteraksi sosial', 'Hilangnya budaya silaturahmi yang ada di dalam masyarakat', 'Pergerakan manusia dan barang lebih cepat', 'Banyaknya toko tradisional yang gulung tikar', '', 'A'),
('60d1914b744c2', 'Emosional', 'Situasional', 'Relasional', 'Kolegial', '', 'D'),
('60d1914b744e4', 'Tidak mau memberikan petunjuk kerja kepada rekan sejawat', 'Merawat hubungan sesama rekan sejawat dengan saling bekerja sama dalam mengerjakan tugas', 'Merasa diri paling mampu dalam mengerjakan tugas sehingga tidak mau berkoordinasi dengan rekan sejawat dalam menyelesaikan tugas bersama', 'Hanya mau memberikan bantuan kepada rekan kerja yang memiliki jabatan lebih tinggi saja', '', 'B'),
('60d1914b74503', 'Bekerja dengan berpedoman pada target yang telah ditentukan', 'Berusaha untuk memberikan setiap usulan untuk dilaksanakan kelompok kerja', 'Menghargai dan melaksanakan setiap keputusan yang telah disepakati dalam kelompok kerja.', 'Mengabaikan kesepakatan kelompok kerja yang bertentangan dengan usulan diri', '', 'C'),
('60d1914b74522', 'Akan memfasilitasi tempat beribadah mereka di lingkungan sekolah', 'Mendiskusikan hal ini dengan jajaran pimpinan sekolah dan Komite Sekolah untuk dicari solusinya', 'Memberikan kebijakan yang toleran kepada rekan yang berbeda kepercayaan', 'Menyediakan fasilitas ibadah sesuai dengan kepercayaan yang dianut kepala sekolah', '', 'B'),
('60d1914b74541', 'Mencari dengan seksama siapa yang bertanggung jawab terhadap kegagalan yang terjadi', 'Mengambil waktu untuk menenangkan diri', 'Bersedih hati', 'Melakukan instropeksi dan memperbaiki kegagalan tersebut', '', 'D'),
('60d1914b7454e', 'Mengkomunikasikan hal tersebut kepada kepala suku, bahwa pemerintah sedang menggalakkan program untuk menyayangi hewan.', 'Melaporkan kepada pihak terkait untuk segera diusut', 'Memfoto kemudian mengupload ke instagram dan mengadakan petisi', 'Ikut melakukan adat tersebut sebagai upaya menghormati adat', '', 'A'),
('60d1914b74559', 'Mengganti acara dengan yang lebih cocok untuk lingkungan tersebut', 'Tetap mengadakan pentas musik seperti rencana semula', 'Membatalkan dan tidak jadi mengadakan acara', 'Tetap mengadakan pentas musik dengan pengisi acara yang disesuaikan dengan selera lingkungan sekitar', '', 'A'),
('60d1914b74563', 'Tetap membuang sampah di depan rumah, masalah TPA merupakan masalah tukang sampah.', 'Membuat pengelolaan sampah sederhana di lingkungan rumah untuk mengurangi masalah sampah', 'Mengurangi jumlah sampah yang dibuang', 'Mencari informasi TPA yang dapat digunakan untuk membuang sampah dari perumahan saya', '', 'D'),
('60d1914b7456e', 'Tetap masuk sekolah meskipun tidak seharian penuh sebagaimana hari-hari biasa', 'Tetap masuk sekolah sebagaimana hari biasa meskipun banyak guru yang izin', 'Menyarankan kepada para guru yang berencana tidak masuk sekolah untuk tetap masuk sekolah.', 'Menyampaikan kepada kepala sekolah untuk menghimbau para guru untuk tetap masuk sekolah', '', 'B'),
('60d1914b74579', 'Memberikan ucapan belasungkawa melalui pesan singkat kepada siswa tersebut', 'Mengajak siswa di kelas untuk mengumpulkan donasi dan mengajak perwakilan siswa untuk kunjungan ke rumah siswa tersebut', 'Memberikan penguman kepada siswa untuk mengumpulkan donasi untuk siswa tersebut', 'Memberitahukan kabar duka tersebut kepada siswa lainnya melalui whatsapp grup', '', 'B'),
('60d1914b74584', 'Membatasi penggunaan limbah plastik dalam kegiatan sehari-hari', 'Membuang sampah pada tempatnya', 'Mematikan peralatan listrik yang tidak penting', 'Menggunakan transportasi umum untuk bepergian', '', 'D'),
('60d1914b7458e', 'a.       Mengkoordinasikan dan bersinergi dengan pihak-pihak yang terlibat dalam kepanitiaan yang disusun sebelumnya', 'b.      Menerima tugas itu dan melaksanakannya setelah selesai mengerjakan tugas-tugas lain yang telah datang terlebih dahulu', 'c.       walaupun dengan berat hati akan bekerja dan menjalankan tugas itu apa adanya', 'd.      Merombak dengan kepanitiaan baru yang anda pilih sendiri karena anda percaya dengan kompetensinya yang baik', '', 'A'),
('60d1914b74598', 'a.       Menerima itu sebagai konsekuensi ada anggota yang hamil', 'b.      Menanyakan kepada teman itu dan meminta menaikkan tempo kerjanya', 'c.       Mengecek keadaan teman tersebut dan meminta menaikkan tempo kerjanya agar tidak tertinggal dari tim lain', 'd.      Hal tersebut tidak terhindarkan dan mengapresiasi teman itu karena masih bekerja dengan semangat meskipun sedang hamil', '', 'D'),
('60d1914b745a3', 'Berlapang dada menerima penolakan itu dan menghargai perbedaan pendapat', 'Tidak terima dan langsung meninggalkan tempat rapat', 'Berusaha keras meyakinkan peserta rapat untuk menerima pendapat saya', 'Dengan berat hati menerima penolakan dan mengikuti rapat hingga selesai', '', 'A'),
('60d1914b745ae', 'Bersikap terbuka terhadap kritik atau masukkan', 'Menjadikan kritikan sebagai masukan yang membangun agar Anda bisa menjadi pribadi yang lebih baik lagi', 'Menjadikan kritikan sebagai bahan evaluasi diri', 'Memahami karakter setiap orang yang Anda temui', '', 'B'),
('60d191984ed61', ' Saya mencatat untuk pertimbangan, sasaran dan deadline', 'Saya jarang mencatat tetapi terekam selalu dalam pikiran saya', 'Saya tidak membutuhkan daftar harian dan melakukan sesuai dengan yang terdekat dan terpenting', 'Saya selalu mencatat untuk pertimbangan mengambil keputusan', 'Saya kadang mencatatnya kadang tidak..', 'A'),
('60d191984ed68', 'Saya tidak merasa terganggu dengan itu', 'Saya selalu menyortir seberapa penting hal tersebut terlebih dahulu', ' Saya selalu menolak dan menjauhi hal tersebut agar pekerjaan selesai dengan baik', 'Tergantung situasi apakah dipenuhi atau tidak', 'Saya merasa terganggu dengan hal itu', 'B'),
('60d191984ed6f', 'Selalu, gagasan saya cemerlang dan selalu diterima', 'Kadang- kadang, jika ide baik itu muncul', 'Sering, kebanyakan gagasan saya unik sehingga dapat diterima', 'Saya jarang mengemukakan ide', 'Kadang- kadang ide diterima', 'A'),
('60d191984ed76', 'Tidak terlalu penting karena yang terpenting adalah target tercapai', 'Penting tapi bukan yang utama', 'Biasa saja karena kita di dunia profesional tidak begitu perlu kedekatan', 'Cukup penting karena merupakan dorongan untuk mencapai tujuan', 'Penting tapi yang utama adalah target', 'E'),
('60d191984ed7c', 'Saya menganggap masalah tim adalah masalah saya juga sehingga saya akan menyelesaikannya', 'Ketua tim adalah penanggungjawab terbesar masalah  tersebut', 'Orang yang membuat masalah itu adalah penanggungjawab terbesar', 'Masalah tim adalah masalah bersama yang harus diselesaikan oleh tim', 'Masalah tim adalah masalah bersama yang harus diselesaikan oleh ketua tim', 'D'),
('60d191984ed83', 'Saya mudah melakukan apreseasi positit terhadap rekan kerja', 'Saya akan memberikan apreseasi positif kepada rekan kerja yang memang progressnya luar biasa', 'Saya akan memberikan apreseasi sekedarnya , jika baik aya katakan baik dan jika tidak saya katakan tidak', 'Saya jarang memberikan apreseasi kepada rekan kerja kecuali memang luarbiasa', 'Saya akan memberikan apreseasi kepada rekan kerja', 'A'),
('60d191984ed8a', 'Merasa sulit karena tidak ingin memberatkan orang lain atas tugas saya', 'Jika dalam kondisi benar- benar mendesak maka saya akan meminta tolong pada orang lain', 'Tergantung situasi dan urgensi terkadang saya minta tolong, terkadang tidak jika tidak\ndibutuhkan\n', 'Jarang meminta tolong karena tugas tersebut sudah menjadi tanggungjawab saya', 'Selalu meminta tolong meskipun tugas tersebut sudah menjadi tanggungjawab saya', 'D'),
('60d191984ed91', 'Target individu tercapai, maka target tim akan tercapai', 'Target tim utama, meskipun target individu tidak tercapai', 'Sebisa mungkin kedua target tercapai meskipun tidak bisa mencapai 100% ', 'Mencapai target tim dulu lalu menyelesaikan target individu', 'Hanya mendahulukan target tim, jika waktu cukup baru mengerjakan target individu', 'D'),
('60d191984ed97', 'Tergantung hal tersebut dapat ditoleransi atau tidak?', 'Jelas, karena keadilan adalah utama dan mutlak', 'Tidak masalah jika kedua pihak puas walaupun bukan dalam posisi adil', 'Tidak masalah walaupun tidak adil, proporsinya cukup dan dapat berjalan dengan baik', 'Jelas, karena keadilan adalah yang utama', 'B'),
('60d191984ed9e', 'Saya selalu aktif berpendapat dan mengarahkan teman- teman untuk aktif juga', 'Jika perlui bicara maka saya ungkapkan, jika tidak maka saya cukup mendengar', 'Saya menjadi pengamat sejenak kemudian aktif berpendapat', 'Saya lebih banyak diam dan berbicara sekedaarnya', 'Saya aktif berpendapat dan mengarahkan teman- teman untuk mengikuti pendapat saya', 'A'),
('60d191984eda5', 'Saya selalu menjukkan inisiatif dalam bekerja', 'Terkadang jika saya terpikirkan ide maka saya akan berinisiatif melakukan sesuatu', 'Tergantung keadaan dan kondisi saya', 'Saya tidak pernah berinisiatif tetapi selalu mengerjakan tugas dengan baik', 'Saya kadang berinisiatif jika diperlukan', 'A'),
('60d191984edab', 'Tidak mempermasalahkan apakah orang lain mau bekerja dengan baik atau tidak', 'Mendorong orang lain untuk bekerja dengan baik jika situasi memungkinkan', 'Mendorong orang lain bekerja dengan baik jika diperlukan', 'Menstimulasi orang lain untuk mau bekerja dengan baik', 'Mengajak orang lain bersama-sama untuk bekerja dengan baik', 'D'),
('60d191984edb2', 'Menolak tugas tersebut karena dirasa mustahil untuk dilaksanakan', 'Menerima tugas tersebut dengan berbagai syarat yang harus dipenuhi', 'Menolak tugas dengan mengemukakan kekurangan – kekurangan diri, dan meminta atasan untuk menugaskan kepada orang lain.', 'Menerima tugas tersebut kemudian mengajak rekan- rekan kerja untuk mendiskusikan berbagai alternatif cara menyelesaikan tugas tersebut', 'Menerima tugas tersebut kemudian mencoba menyelesaikannya sendiri', 'D'),
('60d191984edb9', 'Meskipun berbelit- belit selalu mengikuti proedur yang telah ditetapkan', 'Sesuai dengan perintah dan arahan atasan', 'Menerapkan prosedur baru agar tidak ketinggalan zaman', 'Menerapkan prosedur baru yang lebih maju', 'Melakukan inovasi secara berkelanjutan agar prosedur kerja semakin efektif dan efisien', 'E'),
('60d191984edc0', 'Mampu menyelesaikan berbagai tugas sulit dalam waktu yang singkat', 'Senang menghasilkan karya- karya intelektual yang bermanfaat', 'Memiliki cara pandang yang unik dan kontroversial', 'Mempunyai ide- ide baru yang belum pernah dilakukan sebelumnya', 'Senang menghasilkan karya- karya baru', 'B'),
('60d191984edc6', 'Bersedia memenuhi semua permintaan sehingga dapat memuaskan klien', 'Bernegosiasi dengan klien bahwa tidak semua permintaannya dapat dipenuhi ', 'Melaporkan sikap klien tersebut kepada atasan', 'Meminta atasan untuk menambah pegawai yang dapat membantu klien tersebut', 'Meminta atasan untuk menambah pegawai  khusus', 'B'),
('60d191984edcd', 'Membaca buku- buku yang dapat mendukung pekerjaan saya', 'Menawarkan bantuan kepada rekan kerja', 'Meneliti kembali hasil pekerjaan saya Bersosialisasi', 'dengan rekan- rekan sekantor Bersosialisasi dengan', 'rekan- rekan dari tim berbeda', 'A'),
('60d191984edd4', ' Comunication', 'Konseptual', ' Teknis', 'Simpati', 'Interpersonal', 'E'),
('60d191984edda', 'Organizing', 'Top management', 'Lower management', 'Middle management', 'Personalia', 'C'),
('60d191984ede1', 'Coordinating', 'Planning', 'Organizing', 'Actuating', 'Controlling', 'C'),
('60d191984ede8', 'Actuating', 'Forcasting', 'Planning', 'Controlling', 'Organizing', 'E'),
('60d191984edef', 'Ilmu perencanaan, pengaturan dan pelaksanaan hubungan antar manusia dengan organisasi', 'Ilmu dan seni tentang penggunaan sumber daya yang terbatas untuk pemenuhan kebutuhan manusia yang tak terbatas.', 'Ilmu untuk mendapatkan hasil kerja yang maksimal dalam rangka pemenuhan kabutuhan organisasi untuk mencapai tujuan misi dan visi perusahaan.', 'Ilmu dan seni dalam memimpin orang atau SDM', 'IImu dan seni tentang upaya untuk memanfaatkan semua sumber daya yang dimiliki untuk mencapai tujuan secara efektif dan efisien.', 'E'),
('60d191984edf6', 'Bertanggung jawab pada lower', 'Menetapkan kebijakan operasional', 'Melakukan semua pekerjaan tingkat operasional', 'Mengawasi pada pekerja.', 'Bertanggung jawab pada Middle Management.', 'B'),
('60d191984edfc', 'Perencanaan, organisasi dan evaluasi', 'ormal, informal dan teksnis', 'Konseptual, formal dan teknis', 'Formal, teknis dan manajerial', 'Konseptual, Kemanusian dan teknis', 'E'),
('60d191984ee03', 'Controlling', 'Planning', 'Organizing', 'Actuating(tindakan utk mengusahakan agar semua kelompok berusaha untuk mencapai sasaran sesuai yang direncanakan)', ' Motivating', 'C'),
('60d191984ee09', '1, 2, 3 ', '1, 2, 4 ', '2, 3, 4 ', '4,5,6', '1,2,6', 'E'),
('60d191984ee10', '1, 2, 3 ', '1, 2, 4 ', '3, 4, 5 ', '1, 4, 5 ', '2,3,4', 'C'),
('60d191984ee17', 'Kemampuan personalia, teknis, dan konseptual dibawah lower management', 'Kemampuan teknis melebihi lower management', 'Teknis melebihi lower management dan top management dan tidak ada ketrampilan manusiawi', 'Konseptual melebihi lower management dan menekankan pada ketrampilan manusiawi', 'Konseptual melebihi top management', 'D'),
('60d191984ee1d', ' Manajemen Administrasi', 'Manajemen Produk', 'Manajemen Keuangan', 'Manajemen Pemasaran', 'Manajemen Personalia', 'E'),
('60d191984ee24', 'Adil', 'Otoriter', 'bebas', 'Demokratis', 'personal', 'B');

-- --------------------------------------------------------

--
-- Table structure for table `jawaban_peserta`
--

CREATE TABLE `jawaban_peserta` (
  `no_peserta` varchar(13) NOT NULL,
  `soal_id` varchar(13) DEFAULT NULL,
  `jawaban` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `jumlah_soal`
--

CREATE TABLE `jumlah_soal` (
  `sesi_id` varchar(13) NOT NULL,
  `kategori_id` varchar(13) NOT NULL,
  `jumlah_soal` int(255) NOT NULL DEFAULT 0,
  `urutan` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id` varchar(13) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `nilai_kategori` double NOT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id`, `nama_kategori`, `nilai_kategori`, `trash_id`) VALUES
('60d18aa6cbcc4', 'KOMPETENSI TEKNIS', 3, 0),
('60d18fddea7af', 'KOMPETENSI WAWANCARA', 3, 0),
('60d19003e3bbc', 'KOMPETENSI SOSIO KULTURAL', 2, 0),
('60d1908037e4a', 'KOMPETENSI MANAJERIAL', 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `nilai`
--

CREATE TABLE `nilai` (
  `no_peserta` varchar(13) NOT NULL,
  `soal_id` varchar(13) NOT NULL,
  `nilai` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `peserta`
--

CREATE TABLE `peserta` (
  `id` varchar(13) NOT NULL,
  `username` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `peserta`
--

INSERT INTO `peserta` (`id`, `username`, `password`) VALUES
('ed7658658476a', 'user', 'userdc');

-- --------------------------------------------------------

--
-- Table structure for table `peserta_ujian`
--

CREATE TABLE `peserta_ujian` (
  `no_peserta` varchar(13) NOT NULL,
  `peserta_id` varchar(13) NOT NULL,
  `sesi_id` varchar(13) NOT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sesi`
--

CREATE TABLE `sesi` (
  `id` varchar(13) NOT NULL,
  `nama_ujian` varchar(32) NOT NULL,
  `tempat_ujian` varchar(50) NOT NULL,
  `waktu_mulai` datetime NOT NULL,
  `waktu_selesai` datetime NOT NULL,
  `durasi` int(255) NOT NULL,
  `passing_grade` decimal(10,0) NOT NULL,
  `kode_sesi` varchar(5) NOT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `soal`
--

CREATE TABLE `soal` (
  `id` varchar(13) NOT NULL,
  `kategori_id` varchar(13) NOT NULL,
  `pertanyaan` varchar(500) NOT NULL,
  `gambar` varchar(500) DEFAULT NULL,
  `trash_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `soal`
--

INSERT INTO `soal` (`id`, `kategori_id`, `pertanyaan`, `gambar`, `trash_id`) VALUES
('60d190bd3a2d0', '60d18aa6cbcc4', 'Pada sebuah rancangan pembelajaran (RPP) tertulis contoh rumusan indikator kompetensi yaitu “menjelaskan kondisi operasi sistem dan komponen perangkat keras”. Jika seorang pendidik akan menyusun menjadi tujuan pembelajaran, maka rumusan yang tepat adalah…', '', 0),
('60d190bd3a2dd', '60d18aa6cbcc4', 'Saat merancang pembelajaran, seorang guru memetakan profil belajar peserta didikya berdasarkan karakter belajar. Hasilnya 50% peserta didik adalah visual, 30% audio, dan 20%  adalah kinestetik. Agar memenuhi kebutuhan peserta didik, media pembelajaran yang bisa digunakan adalah …. ', '', 0),
('60d190bd3a2e8', '60d18aa6cbcc4', 'Seorang guru merancang evaluasi dengan mendasarkan pada indikator dan tujuan pembelajaran yang sudah ditentukan di RPP. Evaluasi tersebut dimaksudkan untuk menentukan hasil dan kemajuan belajar peserta didik, maka jenis evalausi yang tepat dipilih oleh guru adalah…. ', '', 0),
('60d190bd3a2f2', '60d18aa6cbcc4', 'Seorang guru mencari materi dan media dari internet saat menyusun rencana pembelajaran (RPP), materi dan media tersebut akan disampaikan pada proses pembelajaran dengan maksud agar peserta didik tidak mengalami kesulitan memahami materi yang disampaikan. Hal-hal yang harus dilakukan oleh guru tersebut dalam memilih materi ajar adalah…. ', '', 0),
('60d190bd3a2fc', '60d18aa6cbcc4', 'Berdasarkan Surat Edaran Mendikbud Nomor 14 Tahun 2019 tentang Penyederhanaan RPP, hal yang menjadi komponen inti dalam penyusunan RPP adalah….', '', 0),
('60d190bd3a305', '60d18aa6cbcc4', 'Seorang guru mengajar peserta didik dengan metode diskusi dan menggunakan media gambar yang sudah berlangsung dari tahun ke tahun. Pada awal semester baru 2020, peserta didik di kelas 7 tersebut diketahui sebanyak 70% memiliki preferensi belajar kinestetik. Akibatnya, mereka tidak fokus saat pembelajaran dan diskusi berlangsung dan peserta didik lebih senang jika mengerjakan tugas yang diberikan oleh guru. Berdasarkan kasus tersebut, strategi pembelajaran yang bisa digunakan guru… ', '', 0),
('60d190bd3a30e', '60d18aa6cbcc4', 'Urutan ranah kognitif Anderson dan Krathwol setelah menyempurnakan taksonomi Benjamin S. Bloom adalah…', '', 0),
('60d190bd3a318', '60d18aa6cbcc4', 'Model pembelajaran yang mempunyai keunggulan antara lain; berpikir dan bertindak kreatif, memecahkan masalah yang dihadapi secara realistis, merangsang perkembangan kemajuan berpikir peserta didik untuk menyelesaikan masalah yang dihadapi dengan tepat adalah….', '', 0),
('60d190bd3a323', '60d18aa6cbcc4', 'Tujuan pembelajaran yang menggambarkan proses dan hasil belajar yang diharapkan dicapai oleh peserta didik sesuai dengan kompetesinya dimuat dalam…', '', 0),
('60d190bd3a32e', '60d18aa6cbcc4', 'Hal yang tidak termasuk aspek evaluasi kurikulum adalah….', '', 0),
('60d190bd3a338', '60d18aa6cbcc4', 'Di sekolah, seorang guru menuliskan beberapa aturan, seperti ajakan untuk tidak menginjak rumput dan menjaga meja agar tidak dicoret-coret. Kecerdasan yang ingin dikembangkan guru dalam menerapkan pembiasaan kepada peserta didik adalah…. ', '', 0),
('60d190bd3a341', '60d18aa6cbcc4', 'Seorang guru ingin mengetahui kemampuan peserta didik dalam mengatur dan mengelola perbedaan pendapat saat diskusi kelompok berlangsung. Lalu, guru tersebut membuat lembar daftar cek (check list) dalam bentuk skala yang harus diisikan oleh peserta didik dalam menilai teman di kelompoknya. Pada ilustrasi tersebut, jenis penilaian otentik-holistik yang dapat dipilih oleh guru adalah penilaian….  ', '', 0),
('60d190bd3a34b', '60d18aa6cbcc4', 'Guru ingin memberikan penugasan kepada peserta didik yang bertujuan untuk mengukur  kemampuan dalam menghasilkan karya tertentu dan dilakukan secara berkelompok. Jenis penilaian otentik yang tepat yang bisa digunakan adalah…. ', '', 0),
('60d190bd3a355', '60d18aa6cbcc4', 'Kemampuan peserta didik untuk membina hubungan dan kemampuan memotivasi diri termasuk kecerdasan….', '', 0),
('60d190bd3a35e', '60d18aa6cbcc4', 'Seorang peserta didik selalu ingin mendominasi dalam suatu kelompok belajar. Dia tidak memberi kesempatan anggota lain untuk mengemukakan pendapat. Jika teman lain yang memimpin dan mengendalikan jalannya diskusi, ia memisahkan diri dan cenderung belajar sendiri. Peserta didik tersebut mengalami permasalahan dalam perkembangan….', '', 0),
('60d190bd3a368', '60d18aa6cbcc4', 'Salah satu prinsip dalam penyusunan rencana pelaksanaan pembelajaran (RPP) adalah….', '', 0),
('60d190bd3a371', '60d18aa6cbcc4', 'Sebagian siswa mengalami kesulitan menjawab soal tes pilihan ganda yang disusun oleh guru hal tersebut disebabkan materi dalam soal sebagian belum dipelajari oleh peserta didik karena materi tersebut seharusnya diberikan pada pertemuan berikutnya. Hal yang seharusnya dilakukan guru dalam menyusun soal tes pilihan ganda pada aspek materi ….', '', 0),
('60d190bd3a37b', '60d18aa6cbcc4', 'Teori ini memandang belajar sebagai hasil dari pembentukan hubungan antara rangsangan dari luar (stimulus) dan balasan dari siswa (respons) yang dapat diamati. Semakin sering hubungan (bond) antara rangsangan dan balasan terjadi, maka akan semakin kuatlah hubungan keduanya (law of exercise). Teori belajar yang dimaksud adalah…. ', '', 0),
('60d190bd3a385', '60d18aa6cbcc4', 'Seorang guru harus mampu memanfaatkan media pembelajaran dan sumber belajar untuk mencapai tujuan pembelajaraan utuh. Pernyataan berikut yang benar terkait dengan media pembelajaran adalah... ', '', 0),
('60d190bd3a38e', '60d18aa6cbcc4', 'Upaya merancang pengayaan bagi perserta didik yang mencapai ketuntasan belajar optimal tampak dalam kegiatan guru sebagai berikut…. ', '', 0),
('60d190bd3a397', '60d18aa6cbcc4', 'Dalam proses pembelajaran, agar proses pembelajaran dapat berjalan dengan efektif maka guru perlu mempunyai sikap sebagai berikut, kecuali…', '', 0),
('60d190bd3a3a0', '60d18aa6cbcc4', 'Kriteria atau acuan atau pedoman dasar dalam menentukan pencapaian minimal hasil belajar peserta didik dinamakan…', '', 0),
('60d190bd3a3a9', '60d18aa6cbcc4', ' Aspek yang berkaitan dengan perasaan, emosi, sikap, dan derajat penerimaan atau penolakan terhadap suatu objek peserta didik….', '', 0),
('60d190bd3a3b2', '60d18aa6cbcc4', 'Kemampuan yang dapat dilakukan atau ditampilkan untuk satu mata pelajaran atau kompetensi dalam mata pelajaran tertentu harus dimiliki oleh siswa disebut ….', '', 0),
('60d190bd3a3bb', '60d18aa6cbcc4', 'Berikut ini adalah prinsip-prinsip dalam penyusunan RPP (Rencana Pelaksanaan Pembelajaran), kecuali…', '', 0),
('60d190bd3a3c4', '60d18aa6cbcc4', 'Yang tidak termasuk dalam 4 kompetensi yang harus dimiliki oleh guru profesional adalah', '', 0),
('60d190bd3a3cc', '60d18aa6cbcc4', 'Komponen RPP terdiri dari beberapa hal berikut ini, kecuali …..', '', 0),
('60d190bd3a3d5', '60d18aa6cbcc4', 'Berikut ini adaiah beberapa inovasi pendidikan yang pernah dicetuskan oleh pemerintah, kecuali….', '', 0),
('60d190bd3a3de', '60d18aa6cbcc4', 'Undang-Undang yang mengatur tentang Sistem Pendidikan Nasional adalah….', '', 0),
('60d190bd3a3e7', '60d18aa6cbcc4', 'Peraturan Menteri Pendidikan Nomor 20 Tahun 2007 mengatur tentang…', '', 0),
('60d190bd3a3f4', '60d18aa6cbcc4', 'Kedudukan dosen sebagai tenaga profesional ditetapkan dalam…', '', 0),
('60d190bd3a406', '60d18aa6cbcc4', 'Prinsip profesionalitas yang harus dimiliki dosen atau guru sesuai uu guru dan dosen adalah sebagai berikut, kecuali …', '', 0),
('60d190bd3a40f', '60d18aa6cbcc4', 'Yang termasuk kewajiban seorang guru dan dosen adalah…', '', 0),
('60d190bd3a419', '60d18aa6cbcc4', 'Yang tidak termasuk aspek evaluasi kurikulum adalah…', '', 0),
('60d190bd3a422', '60d18aa6cbcc4', 'Berikut ini merupakan permasalahan dalam pendidikan yang mendasar, kecuali ….', '', 0),
('60d190bd3a42c', '60d18aa6cbcc4', 'Agar siswa bereaksi terhadap materi yang kita berikan, maka gambar yang akan digunakan sebagai media pembelajaran dalam proses belajar S – R haruslah…', '', 0),
('60d190bd3a435', '60d18aa6cbcc4', 'Dalam menerapkan strategi pembelajaran berbasis multipel intelegensi, ada langkah-Iangkah yang dapat digunakan antara lain…', '', 0),
('60d190bd3a43d', '60d18aa6cbcc4', 'Kegiatan berikut adalah salah satu cara untuk mengaktifkan indra anak didik kita agar dapat berkembang secara maksimal, yaitu…', '', 0),
('60d190bd3a446', '60d18aa6cbcc4', 'Pada waktu mengajar, guru memberikan hadiah atau pujian kepaada siswa yang berhasil menjawab atau menyelesaikan satu soal. Dalam hal ini guru menerapkan teori belajar…', '', 0),
('60d190bd3a44f', '60d18aa6cbcc4', 'Ada tahap tahap yang harus dilalui guru pada waktu mengembangkan strategi pembelajaran. Salah satunya adalah guru menetapkan atau merumuskan tujuan untuk mengukur keberhasilan dari proses pembelajaran tersebut. Apa yang dilakukan oleh guru tersebut ada pada tahap pengembangan …. ..', '', 0),
('60d190bd3a458', '60d18aa6cbcc4', 'Alat ukur yang digunakan untuk mengukur kemampuan efektif siswa, digunakan…', '', 0),
('60d190bd3a461', '60d18aa6cbcc4', 'Langkah pertaama dalam mencari nilai rata rata yang tidak dikelompokkan yaitu…', '', 0),
('60d190bd3a46a', '60d18aa6cbcc4', 'Yang tidak termasuk dalam karakteristik kecerdasan interpersonal adalah ….', '', 0),
('60d190bd3a484', '60d18aa6cbcc4', 'Suatu teori belajar dikembangkan untuk membangun prinsip prinsip belajar secara ilmiah. Ini merupakan tujuan dari teori belajar ….. ', '', 0),
('60d190bd3a491', '60d18aa6cbcc4', 'Dalam pembelajaran di kelas anda terdapat dua siswa anda yang berkebutuhan khusus, pembelajaran apa yang tepat dilakukan dalam menghadapi kondisi ini…', '', 0),
('60d190bd3a49c', '60d18aa6cbcc4', 'Jika ingin membangkitkan rasa ingin tahu dan gemar membaca maka cara efektif yang akan anda lakukan adalah…', '', 0),
('60d190bd3a4a5', '60d18aa6cbcc4', 'Dalam mengawali pembelajaran Pak Hendra merumuskan pertanyaan, mengumpulkan data (informasi) dengan berbagai teknik, mengasosiasi/menganalisis/ mengelola data (informasi) dan menarik kesimpulan serta mengomunikasikan hasil yang terdiri dari kesimpulan untuk memperoleh pengetahuan, keterampilan dan sikap. Langkah yang dilakukan Pak Ali itu merupakan bagian dari model pembelajaran…', '', 0),
('60d190bd3a4ae', '60d18aa6cbcc4', 'Cara yang paling efektif dan bermakna dalam mengomunikasikan hasil penilaian harian atau capaian sementara kepada siswa dan orangtua adalah…', '', 0),
('60d190bd3a4b7', '60d18aa6cbcc4', 'Salah satu indikator yang dapat menunjukkan kualitas butir tes uraian yang baik adalah…', '', 0),
('60d190bd3a4c2', '60d18aa6cbcc4', 'Sekolah Bu Santi termasuk di daerah yang rawan banjir. Sekolah tidak memiliki peralatan laboratorium yang memadai. Di sekolah itu ada kapur, papan tulis, pipa-pipa paralon yang tidak terpakai, kertas, dan penggaris. Sampah daun cukup banyak di sekitar sekolah. Bila Bu Santi hendak melakukan pembelajaran IPA topik pencegahan banjir. Pembelajaran Bu Santi sebaiknya…', '', 0),
('60d190bd3a4cb', '60d18aa6cbcc4', 'Quantum Theory\n\nAwarded the Nobel prize for physics in 1918, German physics Max Planck is best remembered as the originator of the quantum theory. His work helped user in a new era in theoretical physics and revolutionized the scientific community’s understanding of atomic and sub-atomic processes.\nPlanck intriduced an idea that led to the quantum theory, which became the foundation of twentieth century physics. In December 1900, Plnck worked out an equation that described the distribution of ra', '', 0),
('60d190bd3a4d3', '60d18aa6cbcc4', 'The word “revolutionary” as used in line 13, means…', '', 0),
('60d190bd3a4db', '60d18aa6cbcc4', 'It can inferred from the passage that Planck’s work led to the development of which of the following …', '', 0),
('60d190bd3a4f4', '60d18aa6cbcc4', 'The following text is for the question number 7 -8\nSCHOOL ANNOUNCEMENT\nTo : All students\n\nWe would like to inform you, that we would be having the school holiday from Thursday 8th to Saturday 10th August 2015.\nDuring the holiday, our school has already made plans! We want to go camping in the Highlands to a place called Aviemore. It’s an outdoor centre where you can learn to climb, canoe and fish and do all sorts of exciting things.\nOf course, we have to take you to Edinburgh Castle and the Fest', '', 0),
('60d190bd3a4fc', '60d18aa6cbcc4', 'What should the students do to join the activity?', '', 0),
('60d190bd3a504', '60d18aa6cbcc4', 'From the text we know that ….', '', 0),
('60d190bd3a50c', '60d18aa6cbcc4', 'The Following text is for the question number 9 - 10\n\nOnline Distance Learning\nOnline distance learning is an instructional system which connects learners with educational resources. Students work on their own at home, at work, or at school and communicate with faculty and other students via e-mail, electronic forums, videoconferencing, chat rooms, bulletin boards, instant messaging and other forms of computer-based communication. There are both advantages and disadvantages to online distance le', '', 0),
('60d190bd3a515', '60d18aa6cbcc4', 'There are many good and bad aspects of online distance learning. One good thing about it is?', '', 0),
('60d190bd3a51d', '60d18aa6cbcc4', 'Membaca jenis ini biasanya dilakukan seseorang membaca demi kesenangan, membaca bacaan ringan yang mendatangkan kesenangan, kegembiraan sebagai pengisi waktu senggang. Berdasarkan karakteristik diatas, kegiatan tersebut termasuk ke dalam membaca jenis', '', 0),
('60d190bd3a525', '60d18aa6cbcc4', 'Unsur-unsur penting dalam sebuah narasi adalah, kecuali...', '', 0),
('60d190bd3a52d', '60d18aa6cbcc4', 'Kerajaan Islam pertama di Indonesia', '', 0),
('60d190bd3a53b', '60d18aa6cbcc4', 'Berikut ini yang termasuk cara perkembangbiakan vegetatif buatan pada tumbuhan yaitu . . . . ', '', 0),
('60d190bd3a543', '60d18aa6cbcc4', 'Sumbu simetri lipat pada segilima beraturan adalah .... ', '', 0),
('60d190bd3a54e', '60d18aa6cbcc4', 'Kutub magnet yang senama apabila didekatkan akan . . . . ', '', 0),
('60d190bd3a557', '60d18aa6cbcc4', 'Pernyataan di bawah ini merupakan karakteristik perkembangan peserta didik SD/MI ditinjau dari aspek fisik, kecuali ....', '', 0),
('60d190bd3a55f', '60d18aa6cbcc4', 'Dalam menjalankan tugasnya, presiden dibantu oleh wakil presiden dan para menteri. Siapakah yang menentukan dan memilih para menteri?', '', 0),
('60d190bd3a568', '60d18aa6cbcc4', 'Perkembangan perilaku moral dan perkembangan konsep moral merupakan fase-fase perkembangan moral yang harus dicapai seorang anak. Pada fase perkembangan perilaku moral, seorang anak belajar melalui cara-cara berikut, kecuali ….', '', 0),
('60d190bd3a570', '60d18aa6cbcc4', 'Pada suatu sore, datanglah tiga anak kecil ke Salemba dalam langkah malu-malu. Mereka menyerahkan sebuah karangan bunga yang berpita hitam. Karangan bunga itu diserahkan sebagai tanda ikut berduka cita terhadap kakak mereka (orang yang mereka anggap kakak), yang telah ditembak mati pada siang hari itu.                                    Sudut pandang prose diatas adalah', '', 0),
('60d190bd3a579', '60d18aa6cbcc4', 'Data periode revolusi planet dan jaraknya ke matahari ditunjukkan oleh Tabel berikut.\nNama Planet   Periode (T) x  10-7 s   Jarak ke Matahari (r2) x 10-11 m  (T2/r3) x 10-23 \nJupiter                6.99                                3.74                                    2.97\nSaturnus            5.82                                9.29                                    2.95\nUranus               2.54                                2.65                                    2.97\nNeptunus          ', '', 0),
('60d190bd3a582', '60d18aa6cbcc4', 'Benda dilepas dari titik A menempuh lintasan ABCDEF, menumpuk pegas tak bermassa di titik E dan berhenti dititik F. Lintasan BC dan DEF licin, lintasan CD kasar. Usaha yang dilakukan oleh gaya gesek pada sistem adalah', '', 0),
('60d190bd3a58a', '60d18aa6cbcc4', 'Perhatikan grafik!  Bola kasti massanya 200 gr, dilempar ke kiri dengan laju 10 m/s, kemudian dipukul ke kanan dengan gaya yang berubah terhadap wakrtu seperti pada grafik. Kecepatan bola kasti sesaat setelah dipukul adalah ….', '', 0),
('60d190bd3a593', '60d18aa6cbcc4', 'Sebuah benda digantung diujung pegas dan digetarkan seperti gambar di bawah ini !                                                                                                                                                                                                                                                                                                                                                                 Untuk dapat bergetar, maka posisi awal benda seperti gambar di ata', '', 0),
('60d190bd3a59b', '60d18aa6cbcc4', 'Dua buah bola memiliki diameter dan massa yang sama, tetapi yang pertama bola pejal sedang yang kedua adalah bola berongga. Kedua bola semula dalam keadaan diam, lalu diputar pada sumbu rotasinya dengan gaya F. Perbandingan kecepatan sudut bola pejal dan bola berongga ketika keduanya sudah berputar selama t sekon adalah ….', '', 0),
('60d190bd3a5a3', '60d18aa6cbcc4', ' Grafik di bawah ini menunjukkan hasil percobaan hubungan antara gaya (F) dan pertambahan panjang pegas (∆L) dari 3 jenis pegas yang panjang dan luas pegas mula- mula sama.                                                           Berdasarkan data tersebut, dapat disimpulkan ….', '', 0),
('60d190bd3a5ab', '60d18aa6cbcc4', 'Perhatikan pipa venturi berikut ini!                                                                                                                                                                                                         Jika selisih ketinggian raksa pada gambar di atas adalah h, dan massa jenisnya maka kecepatan aliran fluida dan arahnya adalah ….', '', 0),
('60d190bd3a5b3', '60d18aa6cbcc4', 'Kawat lurus dialiri arus listrik 7A diletakkan seperti pada Gambar.\n \nBesar dan arah induksi magnetik di titik Q adalah … .\n', '', 0),
('60d190bd3a5bb', '60d18aa6cbcc4', 'Perhatikan grafik peristiwa efek compton berikut ini:\n \nBerdasarkan grafik ini, hubungan antara gelombang datang i, gelombang terhambur f, dan elektron e adalah …..\n', '', 0),
('60d190bd3a5c4', '60d18aa6cbcc4', 'Meskipun bahan radioaktif memberikan manfaat yang cukup besar bagi kehidupan manusia, tetapi dampak yang ditimbulkan dapat membahayakan manusia itu sendiri. Untuk meminimalisasi dampak negatif penggunaan bahan radioaktif dapat dilakukan dengan ….', '', 0),
('60d190bd3a5cc', '60d18aa6cbcc4', 'Andi berusaha menirukan ucapan kata-kata dari ibunya. Dari usahanya ini, ia mendapatkan pujian dari ibunya yang membuat Andi sangat senang, lalu peniruan itu dillakukan secara berkelanjutan untuk kata-kata yang lain.\nTeori pemerolehan bahasa yang tepat sesuai dengan ilustrasi tersebut adalah….\n', '', 0),
('60d190bd3a5d5', '60d18aa6cbcc4', 'Dalam RPP tentang menulis, terdapat rumusan tujuan pembelajaran sebagai berikut: \nMelalui gambar tentang peristiwa alam, peserta didik dapat menyusun teks eksplanasi sesuai struktur.\nFokus penilaian kemampuan pada rumusan tujuan pembelajaran tersebut adalah….\n', '', 0),
('60d190bd3a5dd', '60d18aa6cbcc4', 'Kemampuan  untuk menyatakan bahwa sendok, garpu, piring, mangkok, gelas,  cangkir, kompor, ember, baskom merupakan perabot dapur dapat dikuasai oleh anak ketika mereka sudah berada pada pemerolehan semantik tahap…', '', 0),
('60d190bd3a5e5', '60d18aa6cbcc4', 'Di Indonesia orang menyebut “air” untuk menunjuk pada sebuah benda yang bersifat cair, bisa direbus, bisa dipakai untuk mandi dan mencuci. Namun, di Inggris orang menyebutnya “water”, sedangkan di Saudi Arabia orang menyebutkan “ma’an”. Orang Jawa punya sebutan lain lagi, yakni “banyu”. Sementara Orang Sunda menyebutnya “cai”. \n      Hal itu membuktikan bahwa…\n', '', 0),
('60d190bd3a5ed', '60d18aa6cbcc4', 'Kita harus terus berupaya agar bahasa Indonesia memiliki kedudukan yang kuat baik sebagai bahasa negara maupun bahasa nasional. Upaya yang menunjukkan kegiatan memperkuat kedudukan bahasa Indonesia sebagai bahasa negara adalah ...         ', '', 0),
('60d190bd3a5f5', '60d18aa6cbcc4', 'Banyak warga Indonesia yang tinggal di negara lain, seperti Amerika Serikat, Inggris, Jerman, dan negara lainnya. Mereka memilih jauh dari tanah airnya demi pekerjaan, studi, bisnis, karier, dan alasan lainnya. Meskipun demikian, jauh dari tanah air tidak berarti terputus silaturahmi dan tidak peduli terhadap permasalahan bangsanya. Untuk mengobati kerinduan pada tanah air, mereka memprakarsai acara-acara yang bernuansa Indonesia. Mereka secara leluasa berbahasa Indonesia, menyajikan makanan kha', '', 0),
('60d190bd3a5fe', '60d18aa6cbcc4', 'Selama masa perkembangannya sebagai bahasa nasional, bahasa Indonesia telah mengalami banyak perbedaan dengan bahasa Melayu. Selain pengaruh dari bahasa lain, penyebabnya….', '', 0),
('60d190bd3a606', '60d18aa6cbcc4', 'Pasangan kata berikut yang berantonim secara mutlak adalah….     ', '', 0),
('60d190bd3a60e', '60d18aa6cbcc4', 'Bacalah teks berita berikut!\nPredikat Kota Yogyakarta bukan sekadar (1) kota pelajar dan pariwisata, melainkan gudangnya industri kecil. Ribuan industri kecil kerajinan berkembang di daerah ini, misalnya souvenir (2) hasil industri rumah tangga hingga skala besar yang bertaraf (3) internasional. Model-model yang dihasilkan juga sesuai dengan tren (4) dunia.\nKata tidak baku dalam teks tersebut ditandai nomor ….\n', '', 0),
('60d190bd3a616', '60d18aa6cbcc4', '“Sebelum pandemi, kita biasa di Bali tiga tahun itulah menciptakan rumah lumbung ramai permintaan disana, kemudian saat pandemi mulai ada penurunan sekitar 20-40 persen,” terangnya.\nKesalahan berbahasa dalam teks tersebut disebabkan ...\n', '', 0),
('60d190bd3a61e', '60d18aa6cbcc4', 'Praktik pencegahan dan pengendalian Covid-19 tidak bisa terlepas dari kondisi lingkungan hidup. Semakin baik kualitas lingkungan hidup, maka semakin tinggi pula ketangguhan diri keluarga dan imunitas. Beberapa studi menginformasikan buruknya kualitas udara juga berpengaruh terhadap tingkat imunitas seseorang. Artinya, semakin buruk imunitas seseorang maka semakin rentan terhadap virus di sekitarnya. \nGagasan umum yang tepat dari kutipan teks tersebut adalah ….\n', '', 0),
('60d190bd3a627', '60d18aa6cbcc4', 'Ditinjau dari periodisasi dan jenisnya, prosa terbagi menjadi prosa lama dan baru. Berikut ini yang termasuk prosa lama adalah....', '', 0),
('60d190bd3a62f', '60d18aa6cbcc4', 'Bacalah kutipan teks berikut ini.\nSaat Sri beranjak dewasa, ia tumbuh menjadi gadis yang semakin cantik dan memiliki hati yang baik. Karena kecantikan dan kebaikannya, sang raja jatuh hati dan berniat mempersuntingnya. Para dewa dan dewi sangat khawatir akan hal tersebut karena akan menyebabkan perpecahan di khayangan. Para dewa berniat untuk membunuh Sri dengan cara meracuninya melalui minuman. Niat jahat para dewa pun terpenuhi hingga akhirnya Sri meninggal. Namun, para dewa tersebut panik dan', '', 0),
('60d190bd3a637', '60d18aa6cbcc4', 'Cermati pantun berikut ini.                                                                                                                   \nPergi  ke Jepara\nJangan lupa beli ukiran\njika ingin jadi juara\nBerlatih terus jangan bosan\nKelemahan pantun ini berdasarkan syarat pantun adalah ....                                                     \n                                                                                                                   ', '', 0),
('60d190bd3a63f', '60d18aa6cbcc4', 'Drama adalah bentuk karya sastra yang sekaligus karya seni. Yang tergolong karya sastra yaitu  naskah drama , sedangkan pementasannya tergolong karya seni pertunjukan. Hakikat drama terdapat pada dialog dan gerak.\nCiri yang membedakan naskah drama dan novel, yaitu:     \n', '', 0),
('60d190bd3a64c', '60d18aa6cbcc4', 'Cermatilah puisi karya W. S. Rendra berikut.                                                                                    \n\nBetapa dinginnya air sungai                                                                                                    \n\nDinginnya! Dinginnya!                                                                                                                           \n\nBetapa dinginnya daging duka\n\nYang membaluti tulang-tulangku.    \n\nCitraan yang dominan pada pu', '', 0),
('60d190bd3a655', '60d18aa6cbcc4', 'Cermatilah gurindam berikut ini\n\nBarang siapa berbuat fitnah\n\nIbarat dirinya menentang panah\n\nMaksud gurindam tersebut adalah … .\n', '', 0),
('60d190df2c683', '60d18fddea7af', 'Teman Anda adalah guru dengan jumlah murid sebanyak 32 murid. Di antara 32 murid di kelas tersebut, Teman Anda memperhatikan bahwa 3 murid selalu selesai lebih dahulu saat diberikan tugas menyelesaikan soal-soal perkalian. Karena Teman Anda tidak ingin ketiga anak ini tidak ada pekerjaan dan malah mengganggu murid lainnya, akhirnya Teman Anda berinisiatif untuk menyiapkan lembar kerja tambahan untuk 3 anak tersebut. Apakah tindakan yang dilakukan Teman Anda sudah tepat? Mengapa?', '', 0),
('60d190df2c68f', '60d18fddea7af', 'Seorang guru bertahun-tahun merasa bahwa hukuman paling efektif dalam mendidik murid. Hal ini terbukti dari murid-murid guru tersebut yang dirasa dulu “nakal” berubah sikap menjadi murid yang patuh di kelas. Namun, suatu hari dia mendapatkan laporan jika murid-muridnya susah diatur guru lain. Guru tersebut merasa murid-muridnya hanya patuh ketika ada beliau di kelas. Apa yang seharusnya dilakukan guru tersebut daam mendisiplinkan murid?', '', 0),
('60d190df2c699', '60d18fddea7af', 'Anda merupakan seorang guru dengan tugas tambahan sebagai staf bidang kurikulum, yang bertugas membantu wakil kepala sekolah dalam proses akademik. Saat itu Anda ditugaskan untuk membantu wakil kepala sekolah dalam rapat staf bidang kurikulum menyusun jadwal pembagian tugas kegiatan belajar mengajar, namun Anda mengetahui bahwa wakil kepala sekolah tersebut dalam keadaan sakit. Apakah tindakan yang Anda lakukan?', '', 0),
('60d190df2c6a7', '60d18fddea7af', 'Suatu ketika hasil pekerjaan yang sudah Anda kerjakan dengan susah payah dikritik tajam oleh Kepala Sekolah. Menghadapi kritikan tersebut, pernyataan paling mendekati reaksi Anda adalah ….', '', 0),
('60d190df2c6af', '60d18fddea7af', 'Anda diberikan amanah sebagai ketua panitia penerimaan peserta didik baru dengan sistem zonasi. Daya tampung sekolah Anda 120 peserta didik, kebetulan peserta didik urutan ke 120 ada dua calon peserta didik yang skornya sama. Salah satunya adalah keponakan kepala sekolah, tetapi pada saat pendaftarannya kalah dulu dengan siswa yang bukan keponakan kepala sekolah. Hal apa yang akan Anda lakukan ….', '', 0),
('60d190df2c6b8', '60d18fddea7af', 'Sebagai guru yang dianggap kompeten, Anda diminta menggantikan guru lain yang kebetulan sakit, untuk mengoordinasikan panitia kegiatan peringatan HUT kemerdekaan RI di sekolah. Yang akan Anda lakukan atas permintaan tersebut adalah ….', '', 0),
('60d190df2c6c1', '60d18fddea7af', 'Dika adalah peserta didik yang pendiam dan memiliki prestasi akademik yang rendah, namun memiliki bakat yang sangat baik dalam bidang seni tari. Sebagai guru, saya menghadapi peserta didik seperti Dika dengan ….', '', 0),
('60d190df2c6ca', '60d18fddea7af', 'Di sekolah tempat Anda bekerja masih sering dijumpai beberapa peserta didik yang merokok di kamar mandi, padahal sekolah sudah memberikan tulisan peringatan serta aturan untuk tidak merokok dan tidak membawa rokok ke dalam area sekolah. Sebagai guru yang berkewajiban memberikan teladan, berikan solusi atas permasalah tersebut!', '', 0),
('60d190df2c6d5', '60d18fddea7af', 'Terdapat peserta didik yang mengeluhkan kepada guru bahwa dalam tugas-tugas kelompok sering kali dipaksakan teman-temanya untuk menyelesaikan tugas itu sendirian. Hal ini karena peserta didik tersebut selain pandai, juga anak orang berada sehinga kebutuhan-kebutuhan dalam mengerjakan tugas mudah dipenuhi. Menanggapai hal tersebut, Anda .... ', '', 0),
('60d190df2c6df', '60d18fddea7af', 'Pandangan Anda tetang keterlibatan masyarakat dalam penyelenggaraan pendidikan di sekolah adalah ….', '', 0),
('60d190df2c6e8', '60d18fddea7af', 'Anda ditunjuk sebagai ketua rapat dan ketika rapat sedang berlangsung ada salah seorang peserta rapat yang menerima telepon. Apakah tindakan yang akan Anda lakukan?', '', 0),
('60d190df2c6f1', '60d18fddea7af', 'Sudah seminggu sampah di depan rumah Anda tidak diambil oleh petuugas pengambil sampah karena mobil pengangkut sampah rusak. Beberapa warga di sekitar Anda tidak sabar lalu mewadahi sampahnya pada wadah plastik kemudian dibuangnya sampah dalam bungkusan plastik itu satu demi satu ke sungai yang ada diantara kampung. Hal apa yang Anda lakukan sebagai guru ….', '', 0),
('60d190df2c6fa', '60d18fddea7af', 'Anda ditunjuk untuk menjadi koordinator kegiatan ekstrakurikuler di  sekolah. Tugas awal yang harus Anda kerjakan adalah mengadakan rapat penyusunan program kegiatan. Ketika rapat sudah dimulai, ada pembina ekstrakurikuler yang datang terlambat. Apa yang akan Anda lakukan terhadap pembina ekstrakurikuler tersebut…', '', 0),
('60d190df2c703', '60d18fddea7af', 'Hari itu Anda pas giliran menjadi guru piket di sekolah. Setelah tanda masuk kelas dibunyikan dan aktivitas pembelajaran dimulai sehingga suasana kelas menjadi tenang. Namun ada satu kelas yang masih rebut. Ternyata, guru yang seharusnya mengajar di kelas tersebut tidak hadir dan tidak memberi tugas. Hal yang akan Anda lakukan di kelas yang diajar guru tersebut adalah …', '', 0),
('60d190df2c70b', '60d18fddea7af', 'Anda diberi tugas oleh kepala sekolah untuk membuat proposal kegiatan akbar lomba dan pentas seni antarsekolah dalam rangka promosi sekolah. Anda berusaha secara maksimal menyusun proposal. Setelah selesai proposal tersebut Anda serahkan kepada kepala sekolah. Setelah dikoreksi ternyata banyak yang harus diperbaiki. Sikap Anda setelah proposal dikoreksi dan harus diperbaiki adalah ….', '', 0),
('60d190df2c714', '60d18fddea7af', 'Anda diminta oleh seorang wali kelas untuk mengubah nilai seorang murid. Menurut wali kelas, murid tersebut adalah putra tokoh masyarakat setempat. Hal yang akan Anda lakukan menanggapi permintaan wali kelas tersebut adalah …', '', 0),
('60d190df2c71c', '60d18fddea7af', '11.   Dengan penuh semangat Anda menjelaskan materi pada pertemuan hari itu disertai dengan memberi contoh-contoh, Harapan Anda murid dapat dengan materi pelajaran tersebut. Kemudian Anda meminta murid untuk mengerjakan tugas. Saat Anda berkeliling kelas Anda menjumpai Sari mengerjakan tugas mata pelajaran lain. Hal yang akan Anda lakukan terhadap Sari adalah…', '', 0),
('60d190df2c725', '60d18fddea7af', 'Saat menyanyikan lagu kebangsaan “Indonesia Raya” dalam upacara bendera, ada beberapa murid menunjukkan sikap tidak serius  dan main-main. Sementara murid yang lain menyanyikan dengan penuh khidmat dan sikap sempurna. Hal yang Anda lakukan terhadap beberapa murid tersebut adalah …', '', 0),
('60d190df2c72f', '60d18fddea7af', 'Menurut Anda, peran guru dalam pembelajaran di kelas itu seperti apa?', '', 0),
('60d1914b742f2', '60d19003e3bbc', 'Kebudayaan Nasional Indonesia berlandasan pada … ', '', 0),
('60d1914b74314', '60d19003e3bbc', 'Sikap yang berpegang teguh pada pandangan atau paham yang melekat pada individu, seperti suku bangsa, rasa tau agama disebut …', '', 0),
('60d1914b74346', '60d19003e3bbc', 'Yang disebut dengan pembangunan nasional yaitu …', '', 0),
('60d1914b74360', '60d19003e3bbc', 'Ketika gagal mencapai sesuatu yang saya inginkan, saya ... ', '', 0),
('60d1914b74379', '60d19003e3bbc', 'Sistem kekerabatan menarik garis keturunan dari kedua belah pihak (ayah dan ibu), kedudukan laki-laki dan perempuan sama disebut sistem kekerabatan …', '', 0),
('60d1914b74391', '60d19003e3bbc', 'Keyakinan terhadap sesuatu yang dianggap benar secara mutlak, tanpa memastikan kebenaran disebut …', '', 0),
('60d1914b743ae', '60d19003e3bbc', 'Yang tidak termasuk akibat terjadinya konflik dalam masyarakat adalah … ', '', 0),
('60d1914b743cc', '60d19003e3bbc', 'Yang termasuk unsur-unsur kebudayaan yaitu … ', '', 0),
('60d1914b743ea', '60d19003e3bbc', 'Pemecahan masalah dengan cara perundingan yaitu dengan metode …. ', '', 0),
('60d1914b74407', '60d19003e3bbc', 'Orang tua saya sakit keras, akan tetapi di kantor pekerjaan tidak bisa ditinggalkan. Sikap saya adalah … ', '', 0),
('60d1914b74426', '60d19003e3bbc', 'Mencari tahu budaya daerah setempat pada saat akan ditempatkan/ditugaskan ke daerah tersebut adalah contoh perilaku dalam indikator ..', '', 0),
('60d1914b74444', '60d19003e3bbc', 'Ada beberapa siswa yang terkesan acak-acakan dan kurang fokus dalam mengerjakan tugas-tugas sekolah sehingga hasilnya tidak sesuai harapan. Wawasan budaya yang dapat diberikan oleh guru dalam konteks situasi tersebut adalah adanya nilai budaya bangsa lain dapat diserap untuk mendukung kemajuan bangsa, yaitu ...', '', 0),
('60d1914b74462', '60d19003e3bbc', 'Masuknya budaya asing dalam kehidupan masyarakat Indonesia dewasa ini merupakan hal yang tidak dapat dihindari karena dampak globalisasi yang ditandai misalnya dengan menggunakan media massa seperti sosial media. Terkait dengan hal tersebut, yang dapat dilakukan guru adalah ...', '', 0),
('60d1914b7447e', '60d19003e3bbc', 'Anda memiliki keluarga di luar negeri, dan hari ini salah satu anak dari keluargamu tersebut akan liburan ke Indonesia dan dititipkan di rumahmu. Apa yang akan anda lakukan untuk menjelaskan padanya mengenai keberagaman di Indonesia?', '', 0),
('60d1914b7449f', '60d19003e3bbc', 'Perkembangan teknologi komunikasi seperti handphone dan internet dengan berbagai aplikasinya telah membawa perubahan pada kehidupan manusia. Hal ini berdampak pada munculnya fenomena sosial yaitu ...', '', 0),
('60d1914b744c2', '60d19003e3bbc', 'Hubungan kerja antar guru di sekolah merupakan hubungan yang didasari atas kesadaran untuk bersama-sama mendidik, membelajarkan, dan membimbing peserta didik. Oleh karena itu, bagi guru hubungan tersebut harus dipahami sebagai hubungan yang bersifat …', '', 0),
('60d1914b744e4', '60d19003e3bbc', 'Bagaimana menerapkan indikator mampu menjalin interaksi sosial untuk penyelesaian tugas …', '', 0),
('60d1914b74503', '60d19003e3bbc', 'Pada saat melakukan kerjasama, hal yang dapat dilakukan agar dapat berpartisipasi dengan baik sebagai anggota tim yaitu', '', 0),
('60d1914b74522', '60d19003e3bbc', 'Kita hidup di negara yang memiliki ragam kepercayaan, budaya, dan adat istiadat yang berbeda-beda. Di sekolah Anda terdiri dari orang-orang yang berbeda kepercayaan. Sikap Anda sebaiknya adalah …', '', 0),
('60d1914b74541', '60d19003e3bbc', 'Ketika mendapatkan kegagalan dalam penyelesaian tugas, yang harus dilakukan adalah …', '', 0),
('60d1914b7454e', '60d19003e3bbc', 'Suatu hari Anda pergi ke suatu daerah yang di sana ada sebuah kebudayaan di mana salah satu binatang dianggap membawa aura negatif bagi warga suku tersebut yaitu anjing sebagai binatang yang membawa aura negatif. Maka kepala suku biasanya memerintahkan untuk membunuh anjing-anjing tersebut. Namun anda ingat saat ini pemerintah saat ini sedang menggalangkan kampanye menyayangi hewan. Sedangkan pembunuhan terhadap hewan atau eksploitasi hewan merupakan suatu pelanggaran hukum. Sikap Anda adalah ..', '', 0),
('60d1914b74559', '60d19003e3bbc', 'Anda baru saja pindah ke lingkungan yang baru dan ingin mengadakan syukuran dengan mengundang pentas musik. Seorang tetangga mengingatkan Anda kalau budaya di lingkungan tersebut menganggap pentas musik adalah sesuatu yang kurang baik. Yang Anda lakukan adalah ...', '', 0),
('60d1914b74563', '60d19003e3bbc', 'Masalah sampah sedang menjadi persoalan serius di kota Anda. Sebagian besar TPA ditutup, dan tukang sampah kesulitan membuang sampah, termasuk di perumahan Anda. Yang Anda lakukan adalah …', '', 0),
('60d1914b7456e', '60d19003e3bbc', 'Sekolah Anda pada akhir libur semester mengadakan study tour ke luar kota selama tiga hari dan anda menjadi salah satu guru pendamping kegiatan study tour ini. Sesuai rencana, rombongan study tour akan tiba kembali di sekolah pada hari minggu sore pukul 17.00 karena hari Senin adalah hari pertama masuk sekolah. Tetapi karena sesuatu dan lain hal, rombongan baru tiba kembali ke sekolah hari Senin pukul 03.00 pagi. Beberapa guru berencana untuk ijin tidak masuk sekolah pada hari pertama karena kel', '', 0),
('60d1914b74579', '60d19003e3bbc', 'Suatu hari orang tua siswa yang rumah tempat tinggalnya tidak begitu jauh dari lingkungan sekolah meninggal dunia. Sebagai wali kelas, yang harus dilakukan adalah', '', 0),
('60d1914b74584', '60d19003e3bbc', 'Terdapat himbauan dan ajakan dari pemerintah kepada masyarakat terutama aparatur sipil negara untuk mengurangi pemanasan global akibat dari efek gas rumah kaca yang sudah terjadi hampir di seluruh belahan dunia. Kontribusi yang dapat anda lakukan untuk mendukung program pemerintah tersebut sebagai seorang ASN P3K yang setiap harinya berangkat untuk bekerja adalah ...', '', 0),
('60d1914b7458e', '60d19003e3bbc', '17.  Sebagai guru yang dianggap kompeten, Anda diminta menggantikan guru lain yang kebetulan sakit, untuk mengkoordinasikan panitia kegiatan peringatan HUT Kemerdekaan RI di sekolah. Yang akan anda lakukan atas permintaan ini adalah …', '', 0),
('60d1914b74598', '60d19003e3bbc', '18.  Anda bersama tim anda melakukan survey di suatu daerah, salah satu anggota adalah ibu hamil yang mebuat kinerja tim anda lebih lamban dari tim lainnya. Anda akan melakukan …', '', 0),
('60d1914b745a3', '60d19003e3bbc', 'Dalam suatu rapat, pendapat anda ditolak oleh peserta rapat.  Anda akan…', '', 0),
('60d1914b745ae', '60d19003e3bbc', 'Dalam dunia kerja, Anda akan bertemu dengan orang-orang dari latar belakang yang berbeda. Terkadang ada orang yang cuek dan tidak mau tau, ada juga yang sangat aktif mengkritik dan menyuarakan pendapatnya terhadap Anda. Sikap Anda…', '', 0),
('60d191984ed61', '60d1908037e4a', 'Apakah Anda membuat daftar harian urgensi dan prioritas dan pekerjaan', '', 0),
('60d191984ed68', '60d1908037e4a', 'Seberapa seringkah Anda berusaha dengan aktif untuk mecegah gangguan( tamu, rapat, telepon) yang biasanya selalu mengacaukan hari kerja Anda', '', 0),
('60d191984ed6f', '60d1908037e4a', 'Seberapa sering gagasan Anda diterima dan dijalankan dengan baik oleh tim atau rekan kerja', '', 0),
('60d191984ed76', '60d1908037e4a', 'Seberapa pentingkah kekompakan tim bagi Anda?', '', 0),
('60d191984ed7c', '60d1908037e4a', 'Bagaimana pendapat Anda tentang masalah yang sedang dihadap tim?', '', 0),
('60d191984ed83', '60d1908037e4a', 'Bagaimana Anda merespon target pencapaian rekan kerja Anda?', '', 0),
('60d191984ed8a', '60d1908037e4a', 'Apakah Anda merasa sulit meminta tolong pada seorang teman untuk melakukan sesuatu untuk Anda?', '', 0),
('60d191984ed91', '60d1908037e4a', 'Bagaimana pendapat Anda tentang pencapaian target tim Anda dan individu?', '', 0),
('60d191984ed97', '60d1908037e4a', 'Apakah Anda bersikeras agar orang lain melakukan pembagian tugas secara adil? ', '', 0),
('60d191984ed9e', '60d1908037e4a', 'Apa yang Anda lakukan dalam sebuah diskusi dengan sekelompok kecil teman-teman Anda sekantor?', '', 0),
('60d191984eda5', '60d1908037e4a', 'Apakah Anda menunjukkan inisiatif dan berusaha untuk mengejar prestasi kerja?', '', 0),
('60d191984edab', '60d1908037e4a', 'Untuk mencapai tujuan kelompok yang telah ditetapkan saya :', '', 0),
('60d191984edb2', '60d1908037e4a', 'Dengan dana terbatas anda diminta oleh atasan untuk mengadakan kegiatan di kantor. Beberapa pendahulu anda tidak terlalu sukses melaksanakan kegiatan tersebut, karena adanya right budget policy . Reaksi anda ketika menerima tugas tersebut? ', '', 0),
('60d191984edb9', '60d1908037e4a', 'Prosedur kerja yang baik menurut anda adalah....', '', 0),
('60d191984edc0', '60d1908037e4a', 'Saya tergolong orang yang kreatif, karena saya...', '', 0),
('60d191984edc6', '60d1908037e4a', 'Anda mendapat klien yang sangat kritis terhadap hasil kerja anda, menghadapi klien tersebut;', '', 0),
('60d191984edcd', '60d1908037e4a', 'Saya mampu menuntaskan tugas sebelum batas waktu yang ditetapkan. Saya memiliki waktu senggang pada jam kerja. Biasanya waktu tersebut digunakan untuk :', '', 0),
('60d191984edd4', '60d1908037e4a', 'Keahlian untuk berkomunikasi, bekerjasama dan memotivasi orang lain disebut ... ', '', 0),
('60d191984edda', '60d1908037e4a', 'Tingkat manajemen yang bertugas memimpin dan mengawasi tenaga-tenaga operasional adalah', '', 0),
('60d191984ede1', '60d1908037e4a', 'Dapat menjalani hubungan baik antar anggota organisasi, struktur anggota dapat mengetahui tugas, kewajiban dan tanggung jawabnya, spesialisasi dalam melakukan tugas.\nMerupakan manfaat ..\n', '', 0),
('60d191984ede8', '60d1908037e4a', 'Pak Husnil adalah seorang manajer personalia di suatu Lembaga Pendidikan Favorit. Ia merencanakan penerimaan pegawai baru. Untuk itu, ia melakukan berbagai aktivitas mulai dari menetukan panitia, menetapkan tugas, dan tanggung jawab masing-masing individu, serta pendelegasian wewenang kepada bawahan. Kegiatan Berbagai aktivitas yang dilakukan tersebut sesuai dengan fungsi manajemen, yaitu ...', '', 0),
('60d191984edef', '60d1908037e4a', 'Apa yang dimaksud dengan manajemen .....', '', 0),
('60d191984edf6', '60d1908037e4a', 'Salah satu tugas dari Manajemen puncak adalah .... ', '', 0),
('60d191984edfc', '60d1908037e4a', 'Keterampilan yang harus dimiliki oleh seorang manajer adalah ...', '', 0),
('60d191984ee03', '60d1908037e4a', 'Prinsip “the right man on the right place” yang digunakan dalam menetapkan seseorang untuk menempati suatu jabatan dalam organisasi merupakan pelaksanaan dari fungsi ... \n\n', '', 0),
('60d191984ee09', '60d1908037e4a', 'Perhatikan fungsi-fungsi manajemen di bawah ini!\n1) Mengetahui hasil pekerjaan\n2) Mengetahui jalannya program\n3) Memberi motivasi kerja\n4) Mengembangkan ketrampilan dan kemampuan staff\n5) Membagi pekerjaan\n6) Memperbaiki kesalahan yang dibuat pegawai\nBerdasarkan uraian di atas, hal-hal yang termasuk tujuan dari fungsi manajemen controlling ditunjukkan oleh nomor ...\n', '', 0),
('60d191984ee10', '60d1908037e4a', 'Perhatikan hal-hal yang dibahas dalam manajemen berikut ini!\n1) Sumber dana\n2) Promosi dan mutasi\n3) Penerimaan pegawai\n4) Pengawasan penggunaan dana\n5) Penggunaan dana\nBerdasarkan uraian di atas, hal-hal yang termasuk ruang lingkup manajemen keuangan ditunjukkan oleh nomor ...\n', '', 0),
('60d191984ee17', '60d1908037e4a', 'Salah satu kemampuan yang harus dimiliki oleh manajemen tingkat menengah yaitu ...', '', 0),
('60d191984ee1d', '60d1908037e4a', 'Perencanaan, pengorganisasian, pengarahan, dan pengendalian atas pengadaan tenaga kerja, pengembangan, kompensasi, integrasi, pemeliharaan, dan pemutusan hubungan kerja (PHK) dengan sumber daya manusia untuk mencapai sasaran perorangan disebut ...', '', 0),
('60d191984ee24', '60d1908037e4a', 'Pemimpin yang mengambil keputusan tanpa melibatkan bawahan disebut ...', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `soal_sesi`
--

CREATE TABLE `soal_sesi` (
  `sesi_id` varchar(13) NOT NULL,
  `kategori_id` varchar(13) NOT NULL,
  `soal_id` varchar(13) NOT NULL,
  `urutan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_admin_list`
-- (See below for the actual view)
--
CREATE TABLE `view_admin_list` (
`admin_id` varchar(13)
,`nama` varchar(32)
,`no_hp` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_kategori_list`
-- (See below for the actual view)
--
CREATE TABLE `view_kategori_list` (
`id` varchar(13)
,`nama_kategori` varchar(100)
,`nilai_kategori` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_peserta_list`
-- (See below for the actual view)
--
CREATE TABLE `view_peserta_list` (
`peserta_id` varchar(13)
,`nama` varchar(32)
,`asal_sekolah` varchar(50)
,`no_hp` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_peserta_ujian_list`
-- (See below for the actual view)
--
CREATE TABLE `view_peserta_ujian_list` (
`no_peserta` varchar(13)
,`peserta_id` varchar(13)
,`sesi_id` varchar(13)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_sesi_list`
-- (See below for the actual view)
--
CREATE TABLE `view_sesi_list` (
`id` varchar(13)
,`nama_ujian` varchar(32)
,`tempat_ujian` varchar(50)
,`waktu_mulai` datetime
,`waktu_selesai` datetime
,`durasi` int(255)
,`passing_grade` decimal(10,0)
,`kode_sesi` varchar(5)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_soal_list`
-- (See below for the actual view)
--
CREATE TABLE `view_soal_list` (
`id` varchar(13)
,`nama_kategori` varchar(100)
,`pertanyaan` varchar(500)
,`gambar` varchar(500)
,`kunci` varchar(20)
);

-- --------------------------------------------------------

--
-- Structure for view `view_admin_list`
--
DROP TABLE IF EXISTS `view_admin_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_admin_list`  AS SELECT `detail_admin`.`admin_id` AS `admin_id`, `detail_admin`.`nama` AS `nama`, `detail_admin`.`no_hp` AS `no_hp` FROM `detail_admin` WHERE `detail_admin`.`trash_id` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `view_kategori_list`
--
DROP TABLE IF EXISTS `view_kategori_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_kategori_list`  AS SELECT `kategori`.`id` AS `id`, `kategori`.`nama_kategori` AS `nama_kategori`, `kategori`.`nilai_kategori` AS `nilai_kategori` FROM `kategori` WHERE `kategori`.`trash_id` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `view_peserta_list`
--
DROP TABLE IF EXISTS `view_peserta_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_peserta_list`  AS SELECT `detail_peserta`.`peserta_id` AS `peserta_id`, `detail_peserta`.`nama` AS `nama`, `detail_peserta`.`asal_sekolah` AS `asal_sekolah`, `detail_peserta`.`no_hp` AS `no_hp` FROM `detail_peserta` WHERE `detail_peserta`.`trash_id` = 0 ORDER BY `detail_peserta`.`nama` ASC, `detail_peserta`.`peserta_id` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `view_peserta_ujian_list`
--
DROP TABLE IF EXISTS `view_peserta_ujian_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_peserta_ujian_list`  AS SELECT `peserta_ujian`.`no_peserta` AS `no_peserta`, `peserta_ujian`.`peserta_id` AS `peserta_id`, `peserta_ujian`.`sesi_id` AS `sesi_id` FROM (`peserta_ujian` left join `detail_peserta` `dp` on(`peserta_ujian`.`peserta_id` = `dp`.`peserta_id`)) WHERE `peserta_ujian`.`trash_id` = 0 AND `dp`.`trash_id` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `view_sesi_list`
--
DROP TABLE IF EXISTS `view_sesi_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_sesi_list`  AS SELECT `sesi`.`id` AS `id`, `sesi`.`nama_ujian` AS `nama_ujian`, `sesi`.`tempat_ujian` AS `tempat_ujian`, `sesi`.`waktu_mulai` AS `waktu_mulai`, `sesi`.`waktu_selesai` AS `waktu_selesai`, `sesi`.`durasi` AS `durasi`, `sesi`.`passing_grade` AS `passing_grade`, `sesi`.`kode_sesi` AS `kode_sesi` FROM `sesi` WHERE `sesi`.`trash_id` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `view_soal_list`
--
DROP TABLE IF EXISTS `view_soal_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_soal_list`  AS SELECT `soal`.`id` AS `id`, `k`.`nama_kategori` AS `nama_kategori`, `soal`.`pertanyaan` AS `pertanyaan`, `soal`.`gambar` AS `gambar`, `j`.`kunci` AS `kunci` FROM ((`soal` left join `kategori` `k` on(`soal`.`kategori_id` = `k`.`id`)) left join `jawaban` `j` on(`soal`.`id` = `j`.`soal_id`)) WHERE `soal`.`trash_id` = 0 AND `k`.`trash_id` = 0 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_uindex` (`username`);

--
-- Indexes for table `bobot_nilai`
--
ALTER TABLE `bobot_nilai`
  ADD KEY `bobot_nilai__soal_fk` (`soal_id`);

--
-- Indexes for table `detail_admin`
--
ALTER TABLE `detail_admin`
  ADD KEY `detail_admin__detail_admin_fk` (`admin_id`),
  ADD KEY `detail_admin__detail_trash_fk` (`trash_id`);

--
-- Indexes for table `detail_peserta`
--
ALTER TABLE `detail_peserta`
  ADD KEY `detail_peserta__detail_trash_fk` (`trash_id`),
  ADD KEY `detail_peserta__peserta_fk` (`peserta_id`);

--
-- Indexes for table `detail_trash`
--
ALTER TABLE `detail_trash`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jawaban`
--
ALTER TABLE `jawaban`
  ADD KEY `jawaban__soal_fk` (`soal_id`);

--
-- Indexes for table `jawaban_peserta`
--
ALTER TABLE `jawaban_peserta`
  ADD KEY `hasil_ujian__peserta_fk` (`no_peserta`),
  ADD KEY `hasil_ujian__soal_fk` (`soal_id`);

--
-- Indexes for table `jumlah_soal`
--
ALTER TABLE `jumlah_soal`
  ADD KEY `jumlah_soal__kategori_fk` (`kategori_id`),
  ADD KEY `jumlah_soal__sesi_fk` (`sesi_id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kategori__detail_trash_fk` (`trash_id`);

--
-- Indexes for table `nilai`
--
ALTER TABLE `nilai`
  ADD KEY `nilai__peserta_ujian_fk` (`no_peserta`),
  ADD KEY `nilai__soal_fk` (`soal_id`);

--
-- Indexes for table `peserta`
--
ALTER TABLE `peserta`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `peserta_username_uindex` (`username`);

--
-- Indexes for table `peserta_ujian`
--
ALTER TABLE `peserta_ujian`
  ADD PRIMARY KEY (`no_peserta`),
  ADD KEY `fk_peserta` (`peserta_id`),
  ADD KEY `peserta_ujian__sesi_fk` (`sesi_id`);

--
-- Indexes for table `sesi`
--
ALTER TABLE `sesi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sesi_kode_sesi_uindex` (`kode_sesi`),
  ADD KEY `sesi__detail_trash_fk` (`trash_id`);

--
-- Indexes for table `soal`
--
ALTER TABLE `soal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `soal__kategori_fk` (`kategori_id`),
  ADD KEY `soal__detail_trash_fk` (`trash_id`);

--
-- Indexes for table `soal_sesi`
--
ALTER TABLE `soal_sesi`
  ADD KEY `soal_sesi__sesi_fk` (`sesi_id`),
  ADD KEY `soal_sesi__kategori_fk` (`kategori_id`),
  ADD KEY `soal_sesi__soal_fk` (`soal_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bobot_nilai`
--
ALTER TABLE `bobot_nilai`
  ADD CONSTRAINT `bobot_nilai__soal_fk` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `detail_admin`
--
ALTER TABLE `detail_admin`
  ADD CONSTRAINT `detail_admin__detail_admin_fk` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_admin__detail_trash_fk` FOREIGN KEY (`trash_id`) REFERENCES `detail_trash` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `detail_peserta`
--
ALTER TABLE `detail_peserta`
  ADD CONSTRAINT `detail_peserta__detail_trash_fk` FOREIGN KEY (`trash_id`) REFERENCES `detail_trash` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_peserta__peserta_fk` FOREIGN KEY (`peserta_id`) REFERENCES `peserta` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `jawaban`
--
ALTER TABLE `jawaban`
  ADD CONSTRAINT `jawaban__soal_fk` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `jawaban_peserta`
--
ALTER TABLE `jawaban_peserta`
  ADD CONSTRAINT `hasil_ujian__peserta_ujian_fk` FOREIGN KEY (`no_peserta`) REFERENCES `peserta_ujian` (`no_peserta`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hasil_ujian__soal_fk` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `jumlah_soal`
--
ALTER TABLE `jumlah_soal`
  ADD CONSTRAINT `jumlah_soal__kategori_fk` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `jumlah_soal__sesi_fk` FOREIGN KEY (`sesi_id`) REFERENCES `sesi` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `kategori`
--
ALTER TABLE `kategori`
  ADD CONSTRAINT `kategori__detail_trash_fk` FOREIGN KEY (`trash_id`) REFERENCES `detail_trash` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `nilai`
--
ALTER TABLE `nilai`
  ADD CONSTRAINT `nilai__peserta_ujian_fk` FOREIGN KEY (`no_peserta`) REFERENCES `peserta_ujian` (`no_peserta`) ON UPDATE CASCADE,
  ADD CONSTRAINT `nilai__soal_fk` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `peserta_ujian`
--
ALTER TABLE `peserta_ujian`
  ADD CONSTRAINT `peserta_ujian__peserta_fk` FOREIGN KEY (`peserta_id`) REFERENCES `peserta` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `peserta_ujian__sesi_fk` FOREIGN KEY (`sesi_id`) REFERENCES `sesi` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `sesi`
--
ALTER TABLE `sesi`
  ADD CONSTRAINT `sesi__detail_trash_fk` FOREIGN KEY (`trash_id`) REFERENCES `detail_trash` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `soal`
--
ALTER TABLE `soal`
  ADD CONSTRAINT `soal__detail_trash_fk` FOREIGN KEY (`trash_id`) REFERENCES `detail_trash` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `soal__kategori_fk` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `soal_sesi`
--
ALTER TABLE `soal_sesi`
  ADD CONSTRAINT `soal_sesi__kategori_fk` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `soal_sesi__sesi_fk` FOREIGN KEY (`sesi_id`) REFERENCES `sesi` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `soal_sesi__soal_fk` FOREIGN KEY (`soal_id`) REFERENCES `soal` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
