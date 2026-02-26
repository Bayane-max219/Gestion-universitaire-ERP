-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 26, 2026 at 08:59 AM
-- Server version: 8.0.31
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gestion_universitaire_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `etudiants`
--

DROP TABLE IF EXISTS `etudiants`;
CREATE TABLE IF NOT EXISTS `etudiants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_28gbsstpf8tpc298hhmpffi99` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `etudiants`
--

INSERT INTO `etudiants` (`id`, `email`, `nom`, `prenom`) VALUES
(2, 'miguelsingcol@gmail.com', 'Bayane', 'Miguel'),
(3, 'james@gmail.com', 'James', 'Maillard');

-- --------------------------------------------------------

--
-- Table structure for table `inscriptions`
--

DROP TABLE IF EXISTS `inscriptions`;
CREATE TABLE IF NOT EXISTS `inscriptions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date_inscription` date DEFAULT NULL,
  `statut` enum('ANNULEE','EN_COURS','VALIDEE') DEFAULT NULL,
  `etudiant_id` bigint NOT NULL,
  `matiere_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKrbdv2i5mc55pqxpuwt4fgxdbh` (`etudiant_id`),
  KEY `FKp0doegdcvf1xjchrqlfuc0phy` (`matiere_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inscriptions`
--

INSERT INTO `inscriptions` (`id`, `date_inscription`, `statut`, `etudiant_id`, `matiere_id`) VALUES
(1, '2026-02-26', 'ANNULEE', 2, 1),
(2, '2026-02-26', 'VALIDEE', 3, 2);

-- --------------------------------------------------------

--
-- Table structure for table `matieres`
--

DROP TABLE IF EXISTS `matieres`;
CREATE TABLE IF NOT EXISTS `matieres` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coefficient` int NOT NULL,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `matieres`
--

INSERT INTO `matieres` (`id`, `coefficient`, `nom`) VALUES
(1, 4, 'Javascript'),
(2, 4, 'PHP');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ofx66keruapi6vyqpv6f2or37` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'ADMIN'),
(2, 'USER');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `passwordHash` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_r43af9ap4edm43mmtq01oddj6` (`username`),
  KEY `FKp56c1712k691lhsyewcssf40f` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `passwordHash`, `username`, `role_id`) VALUES
(1, '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD CONSTRAINT `FKp0doegdcvf1xjchrqlfuc0phy` FOREIGN KEY (`matiere_id`) REFERENCES `matieres` (`id`),
  ADD CONSTRAINT `FKrbdv2i5mc55pqxpuwt4fgxdbh` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiants` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
