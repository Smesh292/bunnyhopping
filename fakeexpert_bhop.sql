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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cp`
--

LOCK TABLES `cp` WRITE;
/*!40000 ALTER TABLE `cp` DISABLE KEYS */;
INSERT INTO `cp` VALUES (1,1,-6446,-4160,-204,-6966,-4399,-204,'bhop_lego_rnm'),(2,2,-902,-9552,744,-614,-9328,744,'bhop_lego_rnm'),(3,3,2260,-2937,-670,2612,-3440,-670,'bhop_lego_rnm'),(4,1,1720,48,96,2216,246,96,'bhop_twisted'),(5,2,4680,48,96,4184,240,96,'bhop_twisted'),(6,1,-3500,-875,226,-3730,-1108,226,'bhop_japan'),(7,2,-7511,150,0,-7274,-22,0,'bhop_japan'),(8,3,-6760,5083,480,-7000,5318,480,'bhop_japan'),(9,4,5041,-3792,480,4840,-3913,480,'bhop_japan'),(10,1,247,1072,48,48,1424,48,'bhop_eazy_v2'),(11,2,2487,1072,48,2288,1424,48,'bhop_eazy_v2'),(12,3,246,2960,48,48,3312,48,'bhop_eazy_v2'),(13,4,2484,2960,48,2288,3312,48,'bhop_eazy_v2'),(15,1,4624,816,96,4144,1047,96,'bhop_danmark'),(16,2,11792,816,96,11312,1042,96,'bhop_danmark'),(17,1,2565,-2858,202,2221,-3326,202,'bhop_blackrockshooter'),(18,2,2668,-8004,-173,2324,-8472,-173,'bhop_blackrockshooter'),(19,1,-4621,-6535,2366,-4872,-6287,2366,'bhop_tropic_V2');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
INSERT INTO `records` VALUES (1,120192594,139.3,27,85,10,45.8096,100.84,0,0,0,0,0,0,0,2,'bhop_lego_rnm',1637076235),(2,120192594,203.829,1,1,48.0898,111.889,0,0,0,0,0,0,0,0,2,'bhop_danmark',1637180707),(3,120192594,176.02,1,1,49.2998,113.17,0,0,0,0,0,0,0,0,1,'bhop_blackrockshooter',1637182339),(4,120192594,106.059,1,1,34.8682,113.17,0,0,0,0,0,0,0,0,1,'bhop_tropic_V2',1637185030),(5,120192594,62.3203,9,19,11.0293,20.6191,30.2393,46.1094,0,0,0,0,0,0,1,'bhop_eazy_v2',1637187682);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tier`
--

LOCK TABLES `tier` WRITE;
/*!40000 ALTER TABLE `tier` DISABLE KEYS */;
INSERT INTO `tier` VALUES (1,2,'bhop_lego_rnm'),(2,3,'bhop_twisted'),(3,3,'bhop_japan'),(4,1,'bhop_eazy_v2'),(6,2,'bhop_danmark'),(7,1,'bhop_blackrockshooter'),(8,1,'bhop_tropic_V2');
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'RECORD Nick Jurevich',0,1636971152,1637188952,0),(2,'Nick Jurevich',120192594,1636971154,1637188953,7),(3,'Твоя бывшая ♥♥♥',181387862,1636973636,1636973636,0),(4,'blood',1228437631,1636974592,1636974592,0),(5,'DeadSurfer',460862006,1636984983,1637019134,0),(6,'[00FFFF]M-95 | [FFA500]Found',456802729,1636986199,1636986199,0),(7,'jorma kalevi',482618815,1636989322,1636989322,0),(8,'✪ LG™',243888707,1636990598,1636990598,0),(9,'shadow of israphel',75291890,1636990603,1636990603,0),(10,'Drug Addicts',121483330,1637000362,1637000362,0),(11,'rikardholm',16017866,1637001840,1637001840,0),(12,'Viskis',1149538657,1637006655,1637006655,0),(13,'Fats',192415477,1637020753,1637020753,0),(14,'̶6̶6̶6̶',240547149,1637022473,1637022645,0),(15,'????Hikigaya????',359326643,1637162804,1637162804,0),(16,'High Explosiv',19400344,1637173606,1637173606,0),(17,'一',182076104,1637177306,1637177306,0),(18,'Новый Пират',121985622,1637186462,1637186462,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones`
--

LOCK TABLES `zones` WRITE;
/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
INSERT INTO `zones` VALUES (1,'bhop_lego_rnm',0,-5390,338,-128,-4718,-145,-128),(2,'bhop_lego_rnm',1,4064,-1065,-992,4336,-697,-984),(3,'bhop_twisted',0,56,48,96,552,247,96),(4,'bhop_twisted',1,8808,936,96,8312,272,96),(5,'bhop_japan',0,2420,-7179,480,2188,-7475,480),(6,'bhop_japan',1,6095,-7487,480,6339,-7690,480),(7,'bhop_eazy_v2',0,246,-176,48,-38,176,48),(8,'bhop_eazy_v2',1,4528,1744,48,5047,2240,48),(9,'bhop_danmark',0,96,144,96,544,588,96),(10,'bhop_danmark',1,7824,3856,96,9040,4592,96),(11,'bhop_blackrockshooter',0,-3308,337,63,-2629,-130,64),(12,'bhop_blackrockshooter',1,6193,-10835,-255,6967,-11583,-255),(13,'bhop_tropic_V2',0,-337,1072,64,-576,464,64),(14,'bhop_tropic_V2',1,3712,-1894,72,2744,-2862,76);
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

-- Dump completed on 2021-11-18  0:45:04
