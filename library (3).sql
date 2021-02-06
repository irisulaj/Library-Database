-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 06, 2021 at 11:16 AM
-- Server version: 10.4.16-MariaDB
-- PHP Version: 7.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DorezimiLibrit` (IN `p_idAnetarit` VARCHAR(10), IN `p_numriLib` INT(11), IN `p_dataHuamarrjes` DATE, IN `p_dataMbarimit` DATE)  begin
    
   declare v_idLibri int(11);
   declare v_idHuamarrje int(11);
   
   select liber.numriLib into v_idLibri
   from liber
   where liber.numriLib = p_numriLib;
   
   select huamarje.idHua into v_idHuamarrje
   from huamarje
   where huamarje.idAn = p_idAnetarit
   and huamarje.numriLib = v_idLibri
   and huamarje.dataFillimit = p_dataHuamarrjes
   and huamarje.dataMbarimit = p_dataMbarimit;   
    
-- regjistrimi i dorezimit te tabela huamarrje

   update huamarje
   set huamarje.dataDorezimit = now()
   where huamarje.idHua = v_idHuamarrje;   

-- update te kopje fizike 

   update kopjefizike
   set kopjefizike.present = 1, kopjefizike.status = 0
   where kopjefizike.numriLib = v_idLibri
   and kopjefizike.kopje_id in (select huamarje.kopje_id 
                               from huamarje 
                               where huamarje.idHua = v_idHuamarrje 
                              ) ;
                              
   select 'Success';

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertHuamarrje` (`p_numriLib` INT(11), `p_punonjesi` VARCHAR(10), `p_anetar` VARCHAR(10), `p_datafillimit` DATE, `p_datambarimit` DATE)  BEGIN
DECLARE idKopjeGjendje int(11);
Declare idLibriHua int(11);

select numriLib into idLibriHua
from liber
where liber.numriLib = p_numriLib;

select min(kopje_id) into idKopjeGjendje
from kopjefizike
where kopjefizike.numriLib= idLibriHua
and present = 1;

if (idKopjeGjendje > 0)
THEN
insert into huamarje (numriLib, kopje_id, idPu, idAn, dataFillimit, dataMbarimit)
values(idLibriHua, idKopjeGjendje, p_punonjesi, p_anetar, p_datafillimit, p_datambarimit);

update kopjefizike
set present = 0
where kopjefizike.numriLib = idLibriHua
and kopjefizike.kopje_id = idKopjeGjendje;

select 1;

ELSE select 0;

END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `anetar`
--

CREATE TABLE `anetar` (
  `idAn` varchar(10) NOT NULL,
  `emri` varchar(30) NOT NULL,
  `mbiemri` varchar(30) NOT NULL,
  `gjinia` varchar(1) NOT NULL,
  `telefoni` int(11) NOT NULL,
  `adresa` varchar(50) NOT NULL,
  `email` varchar(30) NOT NULL,
  `dob` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `anetar`
--

INSERT INTO `anetar` (`idAn`, `emri`, `mbiemri`, `gjinia`, `telefoni`, `adresa`, `email`, `dob`) VALUES
('a12345p', 'Andrew', 'Parker', 'M', 682385987, '18 Rue de Solar', 'andrew@email.com', '1989-05-13'),
('a12345t', 'Allison', 'Thomas', 'F', 678736435, 'Rue de Ferrari', 'allison@email.com', '2001-07-10'),
('j12345h', 'Jessica', 'Harris', 'F', 678329921, '11 Rue de Rain', 'jessica@email.com', '1993-09-14'),
('j12345s', 'John', 'Smith', 'M', 683214512, '10 Rue de Fransua', 'john@email.com', '1976-08-12'),
('m12345b', 'Mary', 'Brown', 'F', 672342318, '6 Rue de Rose', 'mary@email.com', '1996-01-16');

-- --------------------------------------------------------

--
-- Table structure for table `autor`
--

CREATE TABLE `autor` (
  `idAu` varchar(10) NOT NULL,
  `emri` varchar(30) NOT NULL,
  `mbiemri` varchar(30) NOT NULL,
  `gjinia` varchar(1) NOT NULL,
  `shtetesia` varchar(20) NOT NULL,
  `dob` date NOT NULL,
  `biografi` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `autor`
--

INSERT INTO `autor` (`idAu`, `emri`, `mbiemri`, `gjinia`, `shtetesia`, `dob`, `biografi`) VALUES
('d54321s', 'Danielle', 'Steel', 'F', 'America', '1947-08-14', 'Autorja bestselling bashkekohore'),
('i54321k', 'Ismail', 'Kadare', 'M', 'shqipo', '1940-05-11', 'Shkrimtar i realizimit socialist'),
('j54321r', 'Joane', 'Rowling', 'F', 'England', '1970-08-14', 'autorja qe shkroi harry poter'),
('p54321m', 'Petro', 'Marko', 'M', 'shqipo', '0000-00-00', 'shkrimtar'),
('v54321c', 'Viktor', 'Canosinaj', 'M', 'shqipo', '1965-07-19', 'autor librash per adoleshente'),
('w54321sh', 'William', 'Shakespeare', 'M', 'England', '1500-06-28', 'one of the best writters to have ever lived');

-- --------------------------------------------------------

--
-- Table structure for table `historiturni`
--

CREATE TABLE `historiturni` (
  `idPu` varchar(10) NOT NULL,
  `idTu` int(11) NOT NULL,
  `muaji` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `historiturni`
--

INSERT INTO `historiturni` (`idPu`, `idTu`, `muaji`) VALUES
('b6789h', 10002, 'Korrik'),
('d6789k', 10001, 'Janar'),
('d6789o', 10001, 'Mars'),
('e6789r', 10002, 'Janar');

-- --------------------------------------------------------

--
-- Table structure for table `huamarje`
--

CREATE TABLE `huamarje` (
  `idHua` int(11) NOT NULL,
  `dataFillimit` date NOT NULL,
  `dataMbarimit` date NOT NULL,
  `dataDorezimit` date NOT NULL,
  `idPu` varchar(10) NOT NULL,
  `idAn` varchar(10) NOT NULL,
  `numriLib` int(11) NOT NULL,
  `kopje_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `huamarje`
--

INSERT INTO `huamarje` (`idHua`, `dataFillimit`, `dataMbarimit`, `dataDorezimit`, `idPu`, `idAn`, `numriLib`, `kopje_id`) VALUES
(1, '2021-01-15', '2021-01-30', '0000-00-00', 'e6789r', 'j12345s', 123452, 1),
(1021, '2020-12-14', '2021-01-15', '2021-01-15', 'e6789r', 'j12345s', 123452, 1),
(1022, '2020-12-15', '2021-01-20', '2021-01-20', 'd6789m', 'a12345p', 123452, 3),
(1023, '2020-12-28', '2021-02-14', '2021-02-12', 'd6789m', 'm12345b', 123452, 4),
(1024, '2020-12-29', '2021-02-15', '2021-01-26', 'm6789m', 'a12345t', 123456, 4),
(1025, '2021-01-01', '2021-01-15', '2021-01-16', 'e6789r', 'j12345s', 123457, 3),
(1026, '2021-01-07', '2021-01-17', '2021-01-19', 'd6789m', 'j12345s', 123458, 1),
(1043, '0000-00-00', '0000-00-00', '0000-00-00', 'e6789r', 'a12345t', 123457, 6),
(1044, '0000-00-00', '0000-00-00', '0000-00-00', 'e6789r', 'a12345t', 123454, 2),
(1045, '0000-00-00', '0000-00-00', '0000-00-00', 'e6789r', 'a12345t', 123454, 3),
(1048, '0000-00-00', '0000-00-00', '0000-00-00', 'e6789r', 'j12345s', 123459, 1);

--
-- Triggers `huamarje`
--
DELIMITER $$
CREATE TRIGGER `nrhuazimeve` AFTER INSERT ON `huamarje` FOR EACH ROW BEGIN
   DECLARE huazimecount int(11);
   
       SELECT nrhuazimeve INTO huazimecount
       FROM kartela
       WHERE idAn = NEW.idAn;
       
UPDATE kartela SET nrhuazimeve = (huazimecount + 1)
WHERE idAn = NEW.idAn;
   END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `kartela`
--

CREATE TABLE `kartela` (
  `idKa` int(11) NOT NULL,
  `dataHapjes` date NOT NULL,
  `dataMbylljes` date NOT NULL,
  `tarifa` int(11) NOT NULL,
  `kategoria` varchar(20) NOT NULL,
  `nrhuazimeve` int(11) NOT NULL,
  `idAn` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kartela`
--

INSERT INTO `kartela` (`idKa`, `dataHapjes`, `dataMbylljes`, `tarifa`, `kategoria`, `nrhuazimeve`, `idAn`) VALUES
(1, '2018-05-24', '2021-05-24', 1000, 'Alfa', 0, 'a12345p'),
(2, '2019-03-18', '2022-03-18', 500, 'Delta', 3, 'a12345t'),
(3, '2020-08-15', '2023-08-15', 800, 'Beta', 0, 'j12345h'),
(4, '2020-09-13', '2023-09-13', 600, 'Gama', 1, 'j12345s'),
(5, '2019-04-24', '2022-04-24', 1000, 'Alfa', 0, 'm12345b'),
(6, '2018-01-21', '2021-01-21', 1000, 'Alfa', 0, 'a12345p');

-- --------------------------------------------------------

--
-- Table structure for table `kopjefizike`
--

CREATE TABLE `kopjefizike` (
  `numriLib` int(11) NOT NULL,
  `kopje_id` int(11) NOT NULL,
  `present` tinyint(1) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kopjefizike`
--

INSERT INTO `kopjefizike` (`numriLib`, `kopje_id`, `present`, `status`) VALUES
(123451, 1, 1, 1),
(123451, 2, 1, 0),
(123451, 3, 1, 1),
(123451, 4, 1, 1),
(123451, 5, 1, 1),
(123451, 6, 1, 1),
(123452, 1, 0, 0),
(123452, 2, 0, 1),
(123452, 3, 0, 1),
(123452, 4, 0, 1),
(123452, 5, 0, 1),
(123452, 6, 0, 1),
(123452, 7, 0, 1),
(123452, 8, 0, 1),
(123452, 9, 0, 1),
(123454, 1, 0, 1),
(123454, 2, 0, 1),
(123454, 3, 0, 1),
(123454, 4, 1, 1),
(123455, 1, 1, 1),
(123455, 2, 1, 1),
(123455, 3, 1, 1),
(123455, 4, 1, 1),
(123455, 5, 1, 1),
(123455, 6, 1, 1),
(123455, 7, 1, 1),
(123455, 8, 1, 1),
(123456, 1, 1, 1),
(123456, 2, 1, 1),
(123456, 3, 1, 1),
(123456, 4, 1, 1),
(123457, 1, 0, 1),
(123457, 2, 0, 1),
(123457, 3, 0, 1),
(123457, 4, 0, 1),
(123457, 5, 0, 1),
(123457, 6, 0, 1),
(123457, 7, 1, 1),
(123457, 8, 1, 1),
(123458, 1, 0, 0),
(123458, 2, 1, 0),
(123459, 1, 0, 1),
(123459, 2, 1, 1),
(123459, 3, 1, 1),
(123459, 4, 1, 1),
(123459, 5, 1, 1);

--
-- Triggers `kopjefizike`
--
DELIMITER $$
CREATE TRIGGER `updejtimiKopjeve` AFTER UPDATE ON `kopjefizike` FOR EACH ROW BEGIN
DECLARE kopjecount int(11);
       SELECT nrKopjeve INTO kopjecount
       FROM  liber
       WHERE numriLib = OLD.numriLib;
       


   UPDATE  liber SET nrKopjeve = (kopjecount - 1)
 WHERE numriLib = OLD.numriLib;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `libaut`
--

CREATE TABLE `libaut` (
  `numriLib` int(11) NOT NULL,
  `idAu` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `libaut`
--

INSERT INTO `libaut` (`numriLib`, `idAu`) VALUES
(123451, 'i54321k'),
(123452, 'i54321k'),
(123453, 'w54321sh'),
(123454, 'j54321r'),
(123455, 'd54321s'),
(123456, 'v54321c'),
(123457, 'v54321c'),
(123458, 'p54321m');

-- --------------------------------------------------------

--
-- Table structure for table `liber`
--

CREATE TABLE `liber` (
  `numriLib` int(11) NOT NULL,
  `titulli` varchar(40) NOT NULL,
  `cmimi` int(11) NOT NULL,
  `gjuha` varchar(20) NOT NULL,
  `vitiBotimit` varchar(4) NOT NULL,
  `ISBN` varchar(20) NOT NULL,
  `nrFaqeve` int(5) NOT NULL,
  `Perkthyesi` varchar(30) NOT NULL,
  `nrKopjeve` int(11) NOT NULL,
  `pershkrimi` varchar(200) NOT NULL,
  `nrRaft` int(11) NOT NULL,
  `zhanri` varchar(20) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `idBot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `liber`
--

INSERT INTO `liber` (`numriLib`, `titulli`, `cmimi`, `gjuha`, `vitiBotimit`, `ISBN`, `nrFaqeve`, `Perkthyesi`, `nrKopjeve`, `pershkrimi`, `nrRaft`, `zhanri`, `active`, `idBot`) VALUES
(123451, 'Darka e Gabuar', 400, 'shqip', '2014', 'D1234567EG', 123, '', 5, 'Ky eshte nje liber i bukur bla bla bla ...', 5, 'Intrige', 1, 11),
(123452, 'Dimri i Fundit', 800, 'shqip', '1967', 'D1234567IF', 400, '', 9, 'Libri i pare i Kadarese qe pat shume debate dhe Kadareja desh u burgos.', 7, 'Intrige', 1, 12),
(123453, 'Hamlet', 700, 'anglisht', '2003', 'H1234567PD', 230, 'F.S.Noli', 3, 'Hamleti merr hak ndaj xhaxhait tradhtar', 2, 'drame', 1, 13),
(123454, 'Harry Potter', 1200, 'anglisht', '2005', 'H7654321PT', 860, 'Filani Fisteku', 4, 'Harry potter ishte libri qe beri te famshme Joane Rowling', 5, 'thriller', 1, 14),
(123455, 'The Dark Side', 900, 'anglisht', '2019', 'T1234567DS', 456, 'Beni Molla', 8, 'Dark Side eshte nje bestseller', 4, 'novel', 1, 14),
(123456, 'Endrra e Anijes me Vela', 500, 'shqip', '2008', 'E1234567AV', 180, '', 4, 'Ky eshte nje liber shume interesant dhe prekes', 6, 'drame', 1, 11),
(123457, 'Ata Kerkonin Lumturine', 400, 'shqip', '2007', 'A1234567KL', 240, '', 6, 'Ky eshte nje nder librat me te famshem te autorit', 2, 'drame', 1, 12),
(123458, 'Shpella e Pirateve', 800, 'shqip', '2002', 'SH1234567P', 300, '', 2, 'liber  i bukur', 5, 'per femije', 0, 12),
(123459, 'Lufta dhe Paqja', 900, 'Rusisht', '2005', 'L1234567P', 800, 'Gjon Shllaku', 4, 'Liber per luften dhe paqen', 7, 'Drame', 1, 14);

--
-- Triggers `liber`
--
DELIMITER $$
CREATE TRIGGER `disableKopje` BEFORE UPDATE ON `liber` FOR EACH ROW BEGIN
DECLARE liberstatus INT;

SELECT active INTO liberstatus
FROM liber 
WHERE numriLib = OLD.numriLib;

-- UPDATE kopjefizike SET status = 0 WHERE numriLib = OLD.numriLib;


END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `fshikopjefizike` AFTER DELETE ON `liber` FOR EACH ROW BEGIN

DELETE FROM kopjefizike
WHERE numriLib = OLD.numriLib;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `shtokopjefizike` AFTER INSERT ON `liber` FOR EACH ROW BEGIN
DECLARE kopjecount int(11);
DECLARE i int DEFAULT 0;

       SELECT nrKopjeve INTO kopjecount
       FROM liber
       WHERE numriLib = NEW.numriLib;
       
WHILE i < kopjecount DO
SET i = i+1;

INSERT INTO kopjefizike (numriLib, kopje_id, present, status) 
VALUES(NEW.numriLib, i, 1, 1);

END WHILE;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `punesim`
--

CREATE TABLE `punesim` (
  `idPu` varchar(10) NOT NULL,
  `datapunesim` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `rrogaFillestare` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `punesim`
--

INSERT INTO `punesim` (`idPu`, `datapunesim`, `rrogaFillestare`) VALUES
('a6789st', '2021-01-20 16:11:59', 40000),
('a6789st', '2021-01-20 16:17:19', 70000),
('a6789st', '2021-01-20 16:19:03', 80000),
('c6789p', '2021-01-17 13:18:41', 4000);

-- --------------------------------------------------------

--
-- Table structure for table `punonjes`
--

CREATE TABLE `punonjes` (
  `idPu` varchar(10) NOT NULL,
  `emri` varchar(30) NOT NULL,
  `mbiemri` varchar(30) NOT NULL,
  `gjinia` varchar(1) NOT NULL,
  `dob` varchar(10) NOT NULL,
  `poz` varchar(20) NOT NULL,
  `rroga` int(11) NOT NULL,
  `telefoni` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `adresa` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `punonjes`
--

INSERT INTO `punonjes` (`idPu`, `emri`, `mbiemri`, `gjinia`, `dob`, `poz`, `rroga`, `telefoni`, `email`, `adresa`) VALUES
('a6789st', 'Andy', 'Scott', 'M', '1970-03-12', 'bibliotekar', 80000, 34532532, 'as@email.com', 'Rue la la'),
('b6789h', 'Bardhyl', 'Hoxha', 'M', '1987-09-23', 'pergjegjes', 50000, 686452424, 'bardhyl@email.com', '176 Rue de Pallati'),
('b6789sh', 'Beni', 'Shehu', 'M', '1991-04-23', 'recepsionist', 35000, 673532353, 'beni@email.com', '178 Rue de Rue'),
('d6789k', 'Dorian', 'Kraja', 'M', '1994-12-13', 'recepsionist', 35000, 682331299, 'dorian@email.com', '134 Rue de Parade'),
('d6789m', 'Desara', 'Muco', 'F', '1997-10-15', 'bibliotekare', 40000, 673228744, 'desara@email.com', '123 Rue de Bllok'),
('d6789o', 'Drilona', 'Osmani', 'F', '1996-01-16', 'pergjegjese', 50000, 687835876, 'drilona@email.com', '187 Rue de La la'),
('e6789r', 'Eneid', 'Rama', 'M', '1963-06-05', 'bibliotekar', 40000, 679343482, 'eneid@email.com', '65 Rue de Lelea'),
('m6789h', 'Mentor', 'Haxhiu', 'M', '1985-11-13', 'bibliotekar', 40000, 678923424, 'mentor@email.com', '76 Rue de Black'),
('m6789m', 'Mira', 'Molla', 'F', '1989-05-13', 'bibliotekare', 40000, 688374353, 'mira@email.com', '32 Rue de Milano');

--
-- Triggers `punonjes`
--
DELIMITER $$
CREATE TRIGGER `historiPunesim` AFTER INSERT ON `punonjes` FOR EACH ROW BEGIN
INSERT INTO punesim (idPu, datapunesim, rrogaFillestare)
SELECT NEW.idPu, NOW(), punonjes.rroga
FROM
punonjes
WHERE idPu = NEW.idPu;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updatePunesim` AFTER UPDATE ON `punonjes` FOR EACH ROW BEGIN
INSERT INTO punesim (idPu, datapunesim, rrogaFillestare)
SELECT NEW.idPu, NOW(), punonjes.rroga
FROM punonjes
WHERE idPu = NEW.idPu;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `punonjesturni`
--

CREATE TABLE `punonjesturni` (
  `idPu` varchar(10) NOT NULL,
  `idTu` int(11) NOT NULL,
  `muaji` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `punonjesturni`
--

INSERT INTO `punonjesturni` (`idPu`, `idTu`, `muaji`) VALUES
('b6789h', 10001, 'Gusht'),
('b6789sh', 10002, 'Qershor'),
('d6789k', 10002, 'Shkurt'),
('d6789m', 10002, 'Shtator'),
('d6789o', 10002, 'Prill'),
('e6789r', 10001, 'Mars'),
('m6789h', 10001, 'Maj'),
('m6789m', 10001, 'Shkurt');

--
-- Triggers `punonjesturni`
--
DELIMITER $$
CREATE TRIGGER `historiaTurneve` BEFORE UPDATE ON `punonjesturni` FOR EACH ROW BEGIN

INSERT INTO historiTurni (idPu, idTu, muaji)      
       SELECT idPu, idTu, muaji
         
       FROM punonjesturni
       
       WHERE idPu = old.idPu;
  
      END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shtepibotuese`
--

CREATE TABLE `shtepibotuese` (
  `idBot` int(11) NOT NULL,
  `emri` varchar(30) NOT NULL,
  `adresa` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `telefoni` int(11) NOT NULL,
  `website` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `shtepibotuese`
--

INSERT INTO `shtepibotuese` (`idBot`, `emri`, `adresa`, `email`, `telefoni`, `website`) VALUES
(11, 'Pegi', '13 Rue de la Misere', 'pegi@gmail.com', 671234534, 'www.pegi.com'),
(12, 'Albas', '17 Rue de la Felicita', 'albas@gmail.com', 677654321, 'www.albas.com'),
(13, 'Mediaprint', '16 Rue de Class', 'mediaprint@email.com', 682343453, 'www.mediaprint.com'),
(14, 'shblsh', '325 Rue de Abstract', 'shblsh@email.com', 683252346, 'www.shblsh.com');

-- --------------------------------------------------------

--
-- Table structure for table `turni`
--

CREATE TABLE `turni` (
  `idTu` int(11) NOT NULL,
  `nrTurni` int(11) NOT NULL,
  `oraFillim` time NOT NULL,
  `oraMbarim` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `turni`
--

INSERT INTO `turni` (`idTu`, `nrTurni`, `oraFillim`, `oraMbarim`) VALUES
(10001, 1, '09:00:00', '15:00:00'),
(10002, 2, '15:00:00', '21:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anetar`
--
ALTER TABLE `anetar`
  ADD PRIMARY KEY (`idAn`);

--
-- Indexes for table `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`idAu`);

--
-- Indexes for table `historiturni`
--
ALTER TABLE `historiturni`
  ADD PRIMARY KEY (`idPu`,`idTu`);

--
-- Indexes for table `huamarje`
--
ALTER TABLE `huamarje`
  ADD PRIMARY KEY (`idHua`);

--
-- Indexes for table `kartela`
--
ALTER TABLE `kartela`
  ADD PRIMARY KEY (`idKa`);

--
-- Indexes for table `kopjefizike`
--
ALTER TABLE `kopjefizike`
  ADD PRIMARY KEY (`numriLib`,`kopje_id`);

--
-- Indexes for table `libaut`
--
ALTER TABLE `libaut`
  ADD PRIMARY KEY (`numriLib`,`idAu`);

--
-- Indexes for table `liber`
--
ALTER TABLE `liber`
  ADD PRIMARY KEY (`numriLib`);

--
-- Indexes for table `punesim`
--
ALTER TABLE `punesim`
  ADD PRIMARY KEY (`idPu`,`datapunesim`);

--
-- Indexes for table `punonjes`
--
ALTER TABLE `punonjes`
  ADD PRIMARY KEY (`idPu`);

--
-- Indexes for table `punonjesturni`
--
ALTER TABLE `punonjesturni`
  ADD PRIMARY KEY (`idPu`,`idTu`);

--
-- Indexes for table `shtepibotuese`
--
ALTER TABLE `shtepibotuese`
  ADD PRIMARY KEY (`idBot`);

--
-- Indexes for table `turni`
--
ALTER TABLE `turni`
  ADD PRIMARY KEY (`idTu`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `huamarje`
--
ALTER TABLE `huamarje`
  MODIFY `idHua` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1049;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
