-- MariaDB dump 10.19  Distrib 10.4.19-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: fakeexpert_bhop
-- ------------------------------------------------------
-- Server version	10.4.19-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cp`
--

DROP TABLE IF EXISTS `cp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cpnum` int(11) DEFAULT NULL,
  `cpx` int(11) DEFAULT NULL,
  `cpy` int(11) DEFAULT NULL,
  `cpz` int(11) DEFAULT NULL,
  `cpx2` int(11) DEFAULT NULL,
  `cpy2` int(11) DEFAULT NULL,
  `cpz2` int(11) DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cp`
--

LOCK TABLES `cp` WRITE;
/*!40000 ALTER TABLE `cp` DISABLE KEYS */;
INSERT INTO `cp` VALUES (1,1,-6446,-4160,-204,-6966,-4399,-204,'bhop_lego_rnm'),(2,2,-902,-9552,744,-614,-9328,744,'bhop_lego_rnm'),(3,3,2260,-2937,-670,2612,-3440,-670,'bhop_lego_rnm'),(4,1,1720,48,96,2216,246,96,'bhop_twisted'),(5,2,4680,48,96,4184,240,96,'bhop_twisted'),(6,1,-3500,-875,226,-3730,-1108,226,'bhop_japan'),(7,2,-7511,150,0,-7274,-22,0,'bhop_japan'),(8,3,-6760,5083,480,-7000,5318,480,'bhop_japan'),(9,4,5041,-3792,480,4840,-3913,480,'bhop_japan'),(10,1,247,1072,48,48,1424,48,'bhop_eazy_v2'),(11,2,2487,1072,48,2288,1424,48,'bhop_eazy_v2'),(12,3,246,2960,48,48,3312,48,'bhop_eazy_v2'),(13,4,2484,2960,48,2288,3312,48,'bhop_eazy_v2'),(15,1,4624,816,96,4144,1047,96,'bhop_danmark'),(16,2,11792,816,96,11312,1042,96,'bhop_danmark'),(17,1,2565,-2858,202,2221,-3326,202,'bhop_blackrockshooter'),(18,2,2668,-8004,-173,2324,-8472,-173,'bhop_blackrockshooter'),(19,1,-4621,-6535,2366,-4872,-6287,2366,'bhop_tropic_V2'),(20,1,-496,496,512,496,-496,512,'bhop_temple_ruins_v2'),(22,2,5072,576,-3968,4336,1120,-3968,'bhop_temple_ruins_v2');
/*!40000 ALTER TABLE `cp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playerid` int(11) DEFAULT NULL,
  `time` float DEFAULT NULL,
  `finishes` int(11) DEFAULT NULL,
  `tries` int(11) DEFAULT NULL,
  `cp1` float DEFAULT NULL,
  `cp2` float DEFAULT NULL,
  `cp3` float DEFAULT NULL,
  `cp4` float DEFAULT NULL,
  `cp5` float DEFAULT NULL,
  `cp6` float DEFAULT NULL,
  `cp7` float DEFAULT NULL,
  `cp8` float DEFAULT NULL,
  `cp9` float DEFAULT NULL,
  `cp10` float DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  `date` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (1,120192594,139.3,28,89,10,45.8096,100.84,0,0,0,0,0,0,0,2,'bhop_lego_rnm',1637076235),(2,120192594,169.57,10,13,40.8281,103.02,0,0,0,0,0,0,0,0,6,'bhop_danmark',1637315710),(3,120192594,118.055,6,8,30.1641,77.6094,0,0,0,0,0,0,0,0,1,'bhop_blackrockshooter',1637327693),(4,120192594,106.059,1,1,34.8682,113.17,0,0,0,0,0,0,0,0,1,'bhop_tropic_V2',1637185030),(5,120192594,62.3203,14,26,11.0293,20.6191,30.2393,46.1094,0,0,0,0,0,0,3,'bhop_eazy_v2',1637187682),(6,120192594,151.709,2,2,20.3105,107.431,33.0508,46.8896,0,0,0,0,0,0,3,'bhop_twisted',1637193389),(7,97826675,67.9883,4,49,11,23.0781,35.5508,49.8477,0,0,0,0,0,0,1,'bhop_eazy_v2',1637250943),(8,911225620,115.578,1,1,13.2969,30,47.4297,77.9375,0,0,0,0,0,0,1,'bhop_eazy_v2',1637249010),(9,61148119,210.53,1,2,36.4014,122.08,0,0,0,0,0,0,0,0,3,'bhop_danmark',1637259584),(10,25736400,346.389,1,1,50.7393,203.51,138.05,0,0,0,0,0,0,0,2,'bhop_danmark',1637264949),(11,120192594,436.562,1,1,82.9688,337.672,0,0,0,0,0,0,0,0,3,'bhop_temple_ruins_v2',1637515531);
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tier`
--

DROP TABLE IF EXISTS `tier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tier` int(11) DEFAULT NULL,
  `map` varchar(192) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tier`
--

LOCK TABLES `tier` WRITE;
/*!40000 ALTER TABLE `tier` DISABLE KEYS */;
INSERT INTO `tier` VALUES (1,2,'bhop_lego_rnm'),(2,3,'bhop_twisted'),(3,3,'bhop_japan'),(4,1,'bhop_eazy_v2'),(6,2,'bhop_danmark'),(7,1,'bhop_blackrockshooter'),(8,1,'bhop_tropic_V2'),(9,3,'bhop_temple_ruins_v2');
/*!40000 ALTER TABLE `tier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `steamid` int(11) DEFAULT NULL,
  `firstjoin` int(11) DEFAULT NULL,
  `lastjoin` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Pat',0,1636971152,1637621565,0),(2,'Nick Jurevich',120192594,1636971154,1637621563,19),(3,'Твоя бывшая ♥♥♥',181387862,1636973636,1636973636,0),(4,'blood',1228437631,1636974592,1636974592,0),(5,'DeadSurfer',460862006,1636984983,1637019134,0),(6,'[00FFFF]M-95 | [FFA500]Found',456802729,1636986199,1636986199,0),(7,'jorma kalevi',482618815,1636989322,1636989322,0),(8,'✪ LG™',243888707,1636990598,1636990598,0),(9,'shadow of israphel',75291890,1636990603,1636990603,0),(10,'Drug Addicts',121483330,1637000362,1637000362,0),(11,'rikardholm',16017866,1637001840,1637001840,0),(12,'Viskis',1149538657,1637006655,1637006655,0),(13,'Fats',192415477,1637020753,1637020753,0),(14,'̶6̶6̶6̶',240547149,1637022473,1637195853,0),(15,'????Hikigaya????',359326643,1637162804,1637162804,0),(16,'High Explosiv',19400344,1637173606,1637173606,0),(17,'一',182076104,1637177306,1637177306,0),(18,'Новый Пират',121985622,1637186462,1637186462,0),(19,'hifalln',1236839747,1637195926,1637195946,0),(20,'КОРАБЛИК ЛЮБВИ',77029426,1637196688,1637197448,0),(21,'Sw4t9n.',90736352,1637197286,1637197324,0),(22,'0',911334754,1637241599,1637241599,0),(23,'unnamed',97826675,1637242111,1637251780,1),(24,'Abadan',911225620,1637248881,1637248881,1),(25,'antonica20',363501234,1637253786,1637257389,0),(26,'Żaba',1132655240,1637255397,1637255397,0),(27,'EleCTroxXx',88982752,1637258119,1637258119,0),(28,'FL3PPY',61148119,1637259312,1637259312,3),(29,'wekz',25736400,1637264597,1637264962,2),(30,'Tweek',312522530,1637265177,1637265177,0),(31,'Кек Кеков',164116599,1637285213,1637285213,0),(32,'Ferrari',1072325380,1637325695,1637325695,0),(33,'law.',51225778,1637335643,1637335643,0),(34,'БАТЯ КАЕС',107261885,1637354123,1637354123,0),(35,'Philip',67188458,1637368454,1637368454,0),(36,'The Force',887151382,1637403966,1637403966,0),(37,'nexus',1070836069,1637404853,1637404853,0),(38,'Виталик Забивной',448106084,1637411883,1637411883,0),(39,'this._regularTem',358710520,1637430374,1637430374,0),(40,'ys-faw',294392396,1637435900,1637435900,0),(41,'vj',1111305629,1637491443,1637491443,0),(42,'GenaKrokodil',1168262628,1637504797,1637504797,0),(43,'^1*spaghetti',72535823,1637615196,1637615196,0),(44,'Tomke Tomkec',161848938,1637618049,1637618049,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zones`
--

DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `map` varchar(128) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `possition_x` int(11) DEFAULT NULL,
  `possition_y` int(11) DEFAULT NULL,
  `possition_z` int(11) DEFAULT NULL,
  `possition_x2` int(11) DEFAULT NULL,
  `possition_y2` int(11) DEFAULT NULL,
  `possition_z2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones`
--

LOCK TABLES `zones` WRITE;
/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
INSERT INTO `zones` VALUES (1,'bhop_lego_rnm',0,-5390,338,-128,-4718,-145,-128),(2,'bhop_lego_rnm',1,4064,-1065,-992,4336,-697,-984),(3,'bhop_twisted',0,56,48,96,552,247,96),(4,'bhop_twisted',1,8808,936,96,8312,272,96),(5,'bhop_japan',0,2420,-7179,480,2188,-7475,480),(6,'bhop_japan',1,6095,-7487,480,6339,-7690,480),(7,'bhop_eazy_v2',0,246,-176,48,-38,176,48),(8,'bhop_eazy_v2',1,4528,1744,48,5047,2240,48),(9,'bhop_danmark',0,96,144,96,544,588,96),(10,'bhop_danmark',1,7824,3856,96,9040,4592,96),(11,'bhop_blackrockshooter',0,-3308,337,63,-2629,-130,64),(12,'bhop_blackrockshooter',1,6193,-10835,-255,6967,-11583,-255),(13,'bhop_tropic_V2',0,-337,1072,64,-576,464,64),(14,'bhop_tropic_V2',1,3712,-1894,72,2744,-2862,76),(15,'bhop_temple_ruins_v2',0,2900,483,1536,3063,304,1536),(16,'bhop_temple_ruins_v2',1,8851,7076,-4728,9000,7411,-4728);
/*!40000 ALTER TABLE `zones` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-11-23  1:05:36
