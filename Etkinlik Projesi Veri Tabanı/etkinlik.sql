-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 27 Ara 2023, 13:49:08
-- Sunucu sürümü: 8.0.31
-- PHP Sürümü: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `etkinlik`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `GetMekanByAlkolIzin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMekanByAlkolIzin` (IN `izinDurumu` VARCHAR(255))   BEGIN
    SELECT mekanlar.MekanID, mekanlar.MekanAdi
    FROM mekanlar
    JOIN alkolizinleri_mekanlar ON mekanlar.MekanID = alkolizinleri_mekanlar.MekanID
    JOIN alkolizinleri ON alkolizinleri_mekanlar.AlkolIzinID = alkolizinleri.AlkolIzinID
    WHERE alkolizinleri.Izınli = 'izinli';
END$$

DROP PROCEDURE IF EXISTS `GetMekanByEtkinlikTur`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMekanByEtkinlikTur` (IN `etkinlikTurAdi` VARCHAR(255))   BEGIN
    SELECT mekanlar.MekanID, mekanlar.MekanAdi
    FROM mekanlar
    JOIN etkinlik_etkinliktur ON mekanlar.MekanID = etkinliktur_mekanlar.MekanID
    JOIN etkinlikturleri ON etkinliktur_mekanlar.EtkinlikTuruID = etkinlikturleri.EtkinlikTuruID
    WHERE ET.EtkinlikTuruAdi = etkinlikTurAdi;
END$$

DROP PROCEDURE IF EXISTS `GetMekanByYasSinirlama`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMekanByYasSinirlama` (IN `minYas` INT)   BEGIN
    SELECT mekanlar.MekanID, mekanlar.MekanAdi
    FROM mekanlar
    JOIN yassinirlamalari_mekanlar ON mekanlar.MekanID = yassinirlamalari_mekanlar.MekanID
    JOIN yassinirlamalari ON yassinirlamalari_mekanlar.YasSinirlamaID = yassinirlamalari.YasSinirlamaID
    WHERE yassinirlamalari.MinYas >= minYas;
END$$

DROP PROCEDURE IF EXISTS `GetMekanRezervasyonlar`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMekanRezervasyonlar` (IN `mekanId` INT)   BEGIN
    SELECT M.MekanID, M.MekanAdi
    FROM Mekanlar M
    WHERE M.MekanID = mekanId;

    SELECT R.RezervasyonID, R.KatilimciAdi, R.KatilimciSoyad, R.RezervasyonTarihi
    FROM rezervasyonlar R
    INNER JOIN mekanlar_rezervasyon MR ON R.RezervasyonID = MR.RezervasyonID
    WHERE MR.MekanID = mekanId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `alkolizinleri`
--

DROP TABLE IF EXISTS `alkolizinleri`;
CREATE TABLE IF NOT EXISTS `alkolizinleri` (
  `AlkolIzınID` int NOT NULL,
  `Izınli` enum('izinli','izin_yok') CHARACTER SET utf8mb3 COLLATE utf8mb3_turkish_ci DEFAULT NULL,
  PRIMARY KEY (`AlkolIzınID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `alkolizinleri`
--

INSERT INTO `alkolizinleri` (`AlkolIzınID`, `Izınli`) VALUES
(1, 'izin_yok'),
(2, 'izinli');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `alkolizinleri_mekanlar`
--

DROP TABLE IF EXISTS `alkolizinleri_mekanlar`;
CREATE TABLE IF NOT EXISTS `alkolizinleri_mekanlar` (
  `AlkolIzınID` int NOT NULL,
  `MekanID` int NOT NULL,
  PRIMARY KEY (`AlkolIzınID`,`MekanID`),
  KEY `MekanID` (`MekanID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `alkolizinleri_mekanlar`
--

INSERT INTO `alkolizinleri_mekanlar` (`AlkolIzınID`, `MekanID`) VALUES
(2, 1),
(1, 2),
(1, 3),
(2, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 9),
(2, 10),
(1, 11),
(2, 12),
(2, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(2, 18);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `biletler`
--

DROP TABLE IF EXISTS `biletler`;
CREATE TABLE IF NOT EXISTS `biletler` (
  `BiletID` int NOT NULL AUTO_INCREMENT,
  `Fiyat` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`BiletID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `biletler`
--

INSERT INTO `biletler` (`BiletID`, `Fiyat`) VALUES
(1, '50.00'),
(2, '150.00'),
(3, '250.00'),
(4, '1500.00'),
(5, '75.00'),
(6, '120.00'),
(7, '30.00'),
(8, '150.00'),
(10, '750.00'),
(11, '1200.00'),
(12, '250.00'),
(13, '700.00'),
(14, '200.00'),
(15, '1500.00'),
(16, '85.00'),
(17, '100.00'),
(18, '750.00');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `etkinlikler`
--

DROP TABLE IF EXISTS `etkinlikler`;
CREATE TABLE IF NOT EXISTS `etkinlikler` (
  `EtkinlikID` int NOT NULL AUTO_INCREMENT,
  `EtkinlikAdi` varchar(255) COLLATE utf8mb3_turkish_ci DEFAULT NULL,
  PRIMARY KEY (`EtkinlikID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `etkinlikler`
--

INSERT INTO `etkinlikler` (`EtkinlikID`, `EtkinlikAdi`) VALUES
(1, 'Çocuk Tiyatro Gösterisi'),
(2, 'Bar Gecesi'),
(3, 'Konser'),
(4, 'Futbol Maçı'),
(5, 'Sanat Sergisi'),
(6, 'Sinema'),
(7, 'Çocuk Resim Atölyesi'),
(8, 'Gece Kulübü'),
(9, 'Uzmanlar Yanıtlıyor'),
(10, 'Tiyatro Gösterisi'),
(11, 'Lunapark');

--
-- Tetikleyiciler `etkinlikler`
--
DROP TRIGGER IF EXISTS `etkinlik_ekleme_sonrası_toplam_etkinlik_sayisi`;
DELIMITER $$
CREATE TRIGGER `etkinlik_ekleme_sonrası_toplam_etkinlik_sayisi` AFTER INSERT ON `etkinlikler` FOR EACH ROW INSERT INTO toplam_etkinlik_sayisi (ToplamEtkinlikSayisi)
    VALUES ((SELECT ToplamEtkinlikSayisi + 1 FROM toplam_etkinlik_sayisi))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `etkinlikturleri`
--

DROP TABLE IF EXISTS `etkinlikturleri`;
CREATE TABLE IF NOT EXISTS `etkinlikturleri` (
  `EtkinlikTuruID` int NOT NULL AUTO_INCREMENT,
  `TurAdi` varchar(255) COLLATE utf8mb3_turkish_ci NOT NULL,
  PRIMARY KEY (`EtkinlikTuruID`),
  KEY `idx_turadi` (`TurAdi`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `etkinlikturleri`
--

INSERT INTO `etkinlikturleri` (`EtkinlikTuruID`, `TurAdi`) VALUES
(7, 'Çocuk Etkinlikleri'),
(6, 'Eğlence Mekanları'),
(4, 'Film Gösterimi'),
(5, 'Konferans'),
(1, 'Konser'),
(3, 'Sanat'),
(2, 'Spor Etkinliği');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `etkinliktur_mekanlar`
--

DROP TABLE IF EXISTS `etkinliktur_mekanlar`;
CREATE TABLE IF NOT EXISTS `etkinliktur_mekanlar` (
  `EtkinlikTuruID` int NOT NULL,
  `MekanID` int NOT NULL,
  PRIMARY KEY (`EtkinlikTuruID`,`MekanID`),
  KEY `MekanID` (`MekanID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `etkinliktur_mekanlar`
--

INSERT INTO `etkinliktur_mekanlar` (`EtkinlikTuruID`, `MekanID`) VALUES
(2, 2),
(2, 6),
(2, 14),
(3, 15),
(4, 3),
(4, 16),
(5, 5),
(5, 9),
(5, 17),
(6, 1),
(6, 4),
(6, 10),
(6, 12),
(6, 13),
(6, 18),
(7, 7),
(7, 11);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `etkinlik_etkinliktur`
--

DROP TABLE IF EXISTS `etkinlik_etkinliktur`;
CREATE TABLE IF NOT EXISTS `etkinlik_etkinliktur` (
  `EtkinlikID` int NOT NULL,
  `EtkinlikTuruID` int NOT NULL,
  PRIMARY KEY (`EtkinlikID`,`EtkinlikTuruID`),
  KEY `EtkinlikTuruID` (`EtkinlikTuruID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `etkinlik_etkinliktur`
--

INSERT INTO `etkinlik_etkinliktur` (`EtkinlikID`, `EtkinlikTuruID`) VALUES
(3, 1),
(4, 2),
(5, 3),
(6, 4),
(10, 4),
(9, 5),
(2, 6),
(8, 6),
(1, 7),
(7, 7),
(11, 7);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `mekanlar`
--

DROP TABLE IF EXISTS `mekanlar`;
CREATE TABLE IF NOT EXISTS `mekanlar` (
  `MekanID` int NOT NULL AUTO_INCREMENT,
  `MekanAdi` varchar(255) COLLATE utf8mb3_turkish_ci NOT NULL,
  PRIMARY KEY (`MekanID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `mekanlar`
--

INSERT INTO `mekanlar` (`MekanID`, `MekanAdi`) VALUES
(1, 'Ooze Venue'),
(2, 'Vodafone PARK'),
(3, 'Karaca Sineması'),
(4, 'Bios BAR'),
(5, 'Sabancı Kültür Merkezi'),
(6, 'Şükrü Saraçoğlu Stadyumu'),
(7, 'Karşıyaka Belediyesi Evrensel Çocuk Müzesi'),
(9, 'Bornova Kültür Merkezi'),
(10, 'Jolly Joker'),
(11, 'Gençlik Tiyatrosu'),
(12, 'Gastro PUB'),
(13, 'Hangout PSM'),
(14, 'Rams PARK'),
(15, 'İzmir Sanat Galerisi'),
(16, 'CineMAXIMUM'),
(17, 'Atatürk Kültür Merkezi'),
(18, 'Tac Mahal');

--
-- Tetikleyiciler `mekanlar`
--
DROP TRIGGER IF EXISTS `mekan_ekleme_sonrası_toplam_mekan_sayısı`;
DELIMITER $$
CREATE TRIGGER `mekan_ekleme_sonrası_toplam_mekan_sayısı` AFTER INSERT ON `mekanlar` FOR EACH ROW INSERT INTO toplam_mekan_sayisi (ToplamMekanSayisi)
SELECT COUNT(*) + 1 FROM mekanlar
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `mekanlar_biletler`
--

DROP TABLE IF EXISTS `mekanlar_biletler`;
CREATE TABLE IF NOT EXISTS `mekanlar_biletler` (
  `BiletID` int NOT NULL AUTO_INCREMENT,
  `MekanID` int DEFAULT NULL,
  `Fiyat` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`BiletID`),
  KEY `MekanID` (`MekanID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `mekanlar_biletler`
--

INSERT INTO `mekanlar_biletler` (`BiletID`, `MekanID`, `Fiyat`) VALUES
(1, 11, '50.00'),
(2, 12, '150.00'),
(3, 13, '250.00'),
(4, 14, '1500.00'),
(5, 15, '75.00'),
(6, 16, '120.00'),
(7, 17, '30.00'),
(8, 18, '150.00'),
(10, 1, '750.00'),
(11, 2, '1200.00'),
(12, 3, '250.00'),
(13, 4, '700.00'),
(14, 5, '200.00'),
(15, 6, '1500.00'),
(16, 7, '85.00'),
(17, 9, '100.00'),
(18, 10, '750.00');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `mekanlar_rezervasyon`
--

DROP TABLE IF EXISTS `mekanlar_rezervasyon`;
CREATE TABLE IF NOT EXISTS `mekanlar_rezervasyon` (
  `MekanID` int NOT NULL,
  `RezervasyonID` int NOT NULL,
  PRIMARY KEY (`MekanID`,`RezervasyonID`),
  KEY `RezervasyonID` (`RezervasyonID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `mekanlar_rezervasyon`
--

INSERT INTO `mekanlar_rezervasyon` (`MekanID`, `RezervasyonID`) VALUES
(1, 1),
(2, 2),
(3, 3),
(10, 4),
(13, 5),
(15, 6),
(5, 7),
(7, 8),
(6, 9),
(4, 10),
(16, 11),
(12, 12),
(14, 13),
(17, 15),
(9, 16),
(18, 17),
(11, 18);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `rezervasyonlar`
--

DROP TABLE IF EXISTS `rezervasyonlar`;
CREATE TABLE IF NOT EXISTS `rezervasyonlar` (
  `RezervasyonID` int NOT NULL AUTO_INCREMENT,
  `KatilimciAdi` varchar(255) COLLATE utf8mb3_turkish_ci DEFAULT NULL,
  `KatilimciSoyad` varchar(255) COLLATE utf8mb3_turkish_ci DEFAULT NULL,
  `RezervasyonTarihi` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `Yas` int DEFAULT NULL,
  PRIMARY KEY (`RezervasyonID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `rezervasyonlar`
--

INSERT INTO `rezervasyonlar` (`RezervasyonID`, `KatilimciAdi`, `KatilimciSoyad`, `RezervasyonTarihi`, `Yas`) VALUES
(1, 'Ali', 'Yılmaz', '2023-12-10 21:00:00', 25),
(2, 'Ayşe', 'Kaya', '2023-12-11 21:00:00', 30),
(3, 'Mehmet', 'Demir', '2023-12-12 21:00:00', 17),
(4, 'Zeynep', 'Ergün', '2023-12-13 21:00:00', 21),
(5, 'Ahmet', 'Şahin', '2023-12-14 21:00:00', 29),
(6, 'Elif', 'Çelik', '2023-12-15 21:00:00', 40),
(7, 'Cem', 'Yıldız', '2023-12-16 21:00:00', 5),
(8, 'Melis', 'Arslan', '2023-12-17 21:00:00', 3),
(9, 'Eren', 'Koç', '2023-12-18 21:00:00', 33),
(10, 'Sevil', 'Aydın', '2023-12-19 21:00:00', 18),
(11, 'Burak', 'Yavuz', '2023-12-20 21:00:00', 15),
(12, 'Esra', 'Öztürk', '2023-12-21 21:00:00', 45),
(13, 'Gökhan', 'Güzel', '2023-12-22 21:00:00', 27),
(14, 'Ceren', 'Kurt', '2023-12-23 21:00:00', 38),
(15, 'Canan', 'Uçar', '2023-12-24 21:00:00', 16),
(16, 'Şeyma', 'Turan', '2023-12-25 21:00:00', 20),
(17, 'Emre', 'Albayrak', '2023-12-26 21:00:00', 28),
(18, 'İrem', 'Akar', '2023-12-27 21:00:00', 2);

--
-- Tetikleyiciler `rezervasyonlar`
--
DROP TRIGGER IF EXISTS `rezervasyon_eklenme_sonrası_toplam_bilet_sayısı`;
DELIMITER $$
CREATE TRIGGER `rezervasyon_eklenme_sonrası_toplam_bilet_sayısı` AFTER UPDATE ON `rezervasyonlar` FOR EACH ROW INSERT INTO toplam_bilet_sayisi (ToplamBiletSayisi)
SELECT COUNT(*) + 1 FROM biletler
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `toplam_bilet_sayisi`
--

DROP TABLE IF EXISTS `toplam_bilet_sayisi`;
CREATE TABLE IF NOT EXISTS `toplam_bilet_sayisi` (
  `ToplamBiletSayisi` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `toplam_bilet_sayisi`
--

INSERT INTO `toplam_bilet_sayisi` (`ToplamBiletSayisi`) VALUES
(18);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `toplam_etkinlik_sayisi`
--

DROP TABLE IF EXISTS `toplam_etkinlik_sayisi`;
CREATE TABLE IF NOT EXISTS `toplam_etkinlik_sayisi` (
  `ToplamEtkinlikSayisi` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `toplam_etkinlik_sayisi`
--

INSERT INTO `toplam_etkinlik_sayisi` (`ToplamEtkinlikSayisi`) VALUES
(0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `toplam_mekan_sayisi`
--

DROP TABLE IF EXISTS `toplam_mekan_sayisi`;
CREATE TABLE IF NOT EXISTS `toplam_mekan_sayisi` (
  `ToplamMekanSayisi` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `toplam_mekan_sayisi`
--

INSERT INTO `toplam_mekan_sayisi` (`ToplamMekanSayisi`) VALUES
(0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `yassinirlamalari`
--

DROP TABLE IF EXISTS `yassinirlamalari`;
CREATE TABLE IF NOT EXISTS `yassinirlamalari` (
  `YasSinirlamaID` int NOT NULL AUTO_INCREMENT,
  `MinYas` int DEFAULT NULL,
  PRIMARY KEY (`YasSinirlamaID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `yassinirlamalari`
--

INSERT INTO `yassinirlamalari` (`YasSinirlamaID`, `MinYas`) VALUES
(1, 0),
(2, 18),
(3, 7),
(5, 4),
(6, 5);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `yassinirlamalari_mekanlar`
--

DROP TABLE IF EXISTS `yassinirlamalari_mekanlar`;
CREATE TABLE IF NOT EXISTS `yassinirlamalari_mekanlar` (
  `MekanID` int NOT NULL,
  `YasSinirlamaID` int NOT NULL,
  PRIMARY KEY (`MekanID`,`YasSinirlamaID`),
  KEY `YasSinirlamaID` (`YasSinirlamaID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `yassinirlamalari_mekanlar`
--

INSERT INTO `yassinirlamalari_mekanlar` (`MekanID`, `YasSinirlamaID`) VALUES
(7, 1),
(9, 1),
(11, 1),
(1, 2),
(4, 2),
(10, 2),
(12, 2),
(13, 2),
(18, 2),
(2, 3),
(6, 3),
(14, 3),
(16, 3),
(17, 3),
(3, 5),
(15, 5),
(5, 6);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `alkolizinleri_mekanlar`
--
ALTER TABLE `alkolizinleri_mekanlar`
  ADD CONSTRAINT `alkolizinleri_mekanlar_ibfk_1` FOREIGN KEY (`AlkolIzınID`) REFERENCES `alkolizinleri` (`AlkolIzınID`),
  ADD CONSTRAINT `alkolizinleri_mekanlar_ibfk_2` FOREIGN KEY (`MekanID`) REFERENCES `mekanlar` (`MekanID`);

--
-- Tablo kısıtlamaları `etkinlik_etkinliktur`
--
ALTER TABLE `etkinlik_etkinliktur`
  ADD CONSTRAINT `etkinlik_etkinliktur_ibfk_2` FOREIGN KEY (`EtkinlikTuruID`) REFERENCES `etkinlikturleri` (`EtkinlikTuruID`),
  ADD CONSTRAINT `etkinlik_etkinliktur_ibfk_3` FOREIGN KEY (`EtkinlikID`) REFERENCES `etkinlikler` (`EtkinlikID`),
  ADD CONSTRAINT `etkinlik_etkinliktur_ibfk_4` FOREIGN KEY (`EtkinlikTuruID`) REFERENCES `etkinlikturleri` (`EtkinlikTuruID`);

--
-- Tablo kısıtlamaları `mekanlar_biletler`
--
ALTER TABLE `mekanlar_biletler`
  ADD CONSTRAINT `mekanlar_biletler_ibfk_1` FOREIGN KEY (`MekanID`) REFERENCES `mekanlar` (`MekanID`),
  ADD CONSTRAINT `mekanlar_biletler_ibfk_2` FOREIGN KEY (`BiletID`) REFERENCES `biletler` (`BiletID`);

--
-- Tablo kısıtlamaları `mekanlar_rezervasyon`
--
ALTER TABLE `mekanlar_rezervasyon`
  ADD CONSTRAINT `mekanlar_rezervasyon_ibfk_1` FOREIGN KEY (`MekanID`) REFERENCES `mekanlar` (`MekanID`),
  ADD CONSTRAINT `mekanlar_rezervasyon_ibfk_2` FOREIGN KEY (`RezervasyonID`) REFERENCES `rezervasyonlar` (`RezervasyonID`);

--
-- Tablo kısıtlamaları `yassinirlamalari_mekanlar`
--
ALTER TABLE `yassinirlamalari_mekanlar`
  ADD CONSTRAINT `yassinirlamalari_mekanlar_ibfk_1` FOREIGN KEY (`MekanID`) REFERENCES `mekanlar` (`MekanID`),
  ADD CONSTRAINT `yassinirlamalari_mekanlar_ibfk_2` FOREIGN KEY (`YasSinirlamaID`) REFERENCES `yassinirlamalari` (`YasSinirlamaID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
