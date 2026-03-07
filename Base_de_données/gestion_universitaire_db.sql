-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 05 mars 2026 à 00:09
-- Version du serveur : 8.0.31
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `gestion_universitaire_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `emplois_du_temps`
--

DROP TABLE IF EXISTS `emplois_du_temps`;
CREATE TABLE IF NOT EXISTS `emplois_du_temps` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `heureDebut` time(6) NOT NULL,
  `heureFin` time(6) NOT NULL,
  `jour` enum('FRIDAY','MONDAY','SATURDAY','SUNDAY','THURSDAY','TUESDAY','WEDNESDAY') NOT NULL,
  `salle` varchar(500) DEFAULT NULL,
  `matiere_id` bigint NOT NULL,
  `professeur_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqbnvkut7fq3kdmimsthdgwtwa` (`matiere_id`),
  KEY `FK8l525fgqrtyaiocrtgfvsm2ii` (`professeur_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `etudiants`
--

DROP TABLE IF EXISTS `etudiants`;
CREATE TABLE IF NOT EXISTS `etudiants` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `dateCreation` datetime(6) NOT NULL,
  `derniereConnexion` datetime(6) DEFAULT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `niveau` enum('L1','L2','L3','M1','M2') NOT NULL,
  `numeroEtudiant` varchar(255) DEFAULT NULL,
  `premierConnexion` bit(1) NOT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `telephoneParent` varchar(255) DEFAULT NULL,
  `filiere_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_28gbsstpf8tpc298hhmpffi99` (`email`),
  KEY `FK7eq6v2ircv32llkvdvg6wsom6` (`filiere_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `etudiants`
--

INSERT INTO `etudiants` (`id`, `email`, `nom`, `prenom`, `adresse`, `dateCreation`, `derniereConnexion`, `motDePasse`, `niveau`, `numeroEtudiant`, `premierConnexion`, `telephone`, `telephoneParent`, `filiere_id`) VALUES
(9, 'bayane437@gmail.com', 'Kevines', 'Princy', 'Alasora', '2026-03-04 11:04:45.125588', NULL, '07480fb9e85b9396af06f006cf1c95024af2531c65fb505cfbd0add1e2f31573', 'L1', 'SE20260000', b'0', '0348349886', '0342190466', 2),
(10, 'franco@gmail.com', 'Franco', 'Madataly', 'Ivato', '2026-03-04 12:27:29.979814', NULL, '63763d73e7ac254f2829e5475b592157dfb73cf8009d603d1fe12b714b395ab4', 'L1', 'SE20260001', b'1', '0345698745', '0342190466', 2);

-- --------------------------------------------------------

--
-- Structure de la table `filieres`
--

DROP TABLE IF EXISTS `filieres`;
CREATE TABLE IF NOT EXISTS `filieres` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_4n35hh7nn62m2xc2yuwj349i7` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `filieres`
--

INSERT INTO `filieres` (`id`, `code`, `description`, `nom`) VALUES
(2, 'IRD', 'Informatique Risque et Décision', 'Informatique');

-- --------------------------------------------------------

--
-- Structure de la table `inscriptions`
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `inscriptions`
--

INSERT INTO `inscriptions` (`id`, `date_inscription`, `statut`, `etudiant_id`, `matiere_id`) VALUES
(3, '2026-03-04', 'EN_COURS', 9, 2);

-- --------------------------------------------------------

--
-- Structure de la table `matieres`
--

DROP TABLE IF EXISTS `matieres`;
CREATE TABLE IF NOT EXISTS `matieres` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coefficient` int NOT NULL,
  `nom` varchar(255) NOT NULL,
  `professeur_id` bigint DEFAULT NULL,
  `programme_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKnqp8fhplfckdvokv3n1ps4njj` (`professeur_id`),
  KEY `FKdca36y3ifp0bnxhdnkw8unhfc` (`programme_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `matieres`
--

INSERT INTO `matieres` (`id`, `coefficient`, `nom`, `professeur_id`, `programme_id`) VALUES
(2, 5, 'PHP', 3, NULL),
(3, 4, 'Python', 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `notes`
--

DROP TABLE IF EXISTS `notes`;
CREATE TABLE IF NOT EXISTS `notes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `semestre` enum('S1','S2') NOT NULL DEFAULT 'S1',
  `typeEvaluation` varchar(100) DEFAULT NULL,
  `valeur` double DEFAULT NULL,
  `inscription_id` bigint NOT NULL,
  `matiere_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK65h0joma61x0fb6xwp8ougfia` (`inscription_id`),
  KEY `FKedgqpeywue1wqqlpcc82k8pex` (`matiere_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(6) NOT NULL,
  `message` varchar(255) NOT NULL,
  `readFlag` bit(1) NOT NULL,
  `inscription_id` bigint DEFAULT NULL,
  `etudiant_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6lsnn5tn5ecfrsar31gx472f1` (`inscription_id`),
  KEY `FK1kh74cjd2gtf9cpksrthc1rk7` (`etudiant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`id`, `createdAt`, `message`, `readFlag`, `inscription_id`, `etudiant_id`) VALUES
(1, '2026-03-04 14:03:18.677414', 'retard ecollage du mois de mars', b'1', 3, NULL),
(2, '2026-03-05 03:03:20.395441', 'rappelle retard ecollage du mois de mars', b'1', NULL, 9);

-- --------------------------------------------------------

--
-- Structure de la table `professeurs`
--

DROP TABLE IF EXISTS `professeurs`;
CREATE TABLE IF NOT EXISTS `professeurs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_314wk1y4k10ewhew4fcu0w0pb` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `professeurs`
--

INSERT INTO `professeurs` (`id`, `email`, `nom`, `prenom`, `telephone`) VALUES
(1, 'fabrice@gmail.com', 'Fabrice', 'Razafy', '0345698745'),
(3, 'tsinjo@gmail.com', 'Tsinjo', 'Tony', '0348349886');

-- --------------------------------------------------------

--
-- Structure de la table `programmes`
--

DROP TABLE IF EXISTS `programmes`;
CREATE TABLE IF NOT EXISTS `programmes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(1000) DEFAULT NULL,
  `niveau` enum('L1','L2','L3','M1','M2') NOT NULL,
  `semestre` enum('S1','S2') NOT NULL,
  `filiere_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcc7gijrav6u74csngir7qv1kl` (`filiere_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_ofx66keruapi6vyqpv6f2or37` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'ADMIN'),
(2, 'USER');

-- --------------------------------------------------------

--
-- Structure de la table `tranches_paiement`
--

DROP TABLE IF EXISTS `tranches_paiement`;
CREATE TABLE IF NOT EXISTS `tranches_paiement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dateEcheance` date NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `libelle` varchar(255) NOT NULL,
  `montant` double NOT NULL,
  `obligatoire` bit(1) NOT NULL,
  `datePaiement` date DEFAULT NULL,
  `referencePaiement` varchar(100) DEFAULT NULL,
  `statut` enum('ANNULEE','A_PAYER','EN_RETARD','PAYEE') NOT NULL,
  `inscription_id` bigint DEFAULT NULL,
  `etudiant_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1k2nege3qtm6nlpx73y2lt074` (`inscription_id`),
  KEY `FKaq085qmjth8agbqaeimrbxh27` (`etudiant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `tranches_paiement`
--

INSERT INTO `tranches_paiement` (`id`, `dateEcheance`, `description`, `libelle`, `montant`, `obligatoire`, `datePaiement`, `referencePaiement`, `statut`, `inscription_id`, `etudiant_id`) VALUES
(1, '2026-03-05', NULL, 'Écolage', 200000, b'1', '2026-03-05', 'PAYEE', 'PAYEE', NULL, 9),
(2, '2026-04-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(3, '2026-05-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(4, '2026-06-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(5, '2026-07-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(6, '2026-08-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(7, '2026-09-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(8, '2026-10-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(9, '2026-11-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(10, '2026-12-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 9),
(11, '2026-03-05', NULL, 'Écolage', 200000, b'1', '2026-03-05', 'PAYEE', 'PAYEE', NULL, 10),
(12, '2026-04-05', NULL, 'Écolage', 200000, b'1', '2026-03-05', 'PAYEE', 'PAYEE', NULL, 10),
(13, '2026-05-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(14, '2026-06-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(15, '2026-07-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(16, '2026-08-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(17, '2026-09-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(18, '2026-10-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(19, '2026-11-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10),
(20, '2026-12-05', NULL, 'Écolage', 200000, b'1', NULL, NULL, 'A_PAYER', NULL, 10);

-- --------------------------------------------------------

--
-- Structure de la table `users`
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `passwordHash`, `username`, `role_id`) VALUES
(1, '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', 1),
(2, '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Rakoto@gmail.com', 1);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `emplois_du_temps`
--
ALTER TABLE `emplois_du_temps`
  ADD CONSTRAINT `FK8l525fgqrtyaiocrtgfvsm2ii` FOREIGN KEY (`professeur_id`) REFERENCES `professeurs` (`id`),
  ADD CONSTRAINT `FKqbnvkut7fq3kdmimsthdgwtwa` FOREIGN KEY (`matiere_id`) REFERENCES `matieres` (`id`);

--
-- Contraintes pour la table `etudiants`
--
ALTER TABLE `etudiants`
  ADD CONSTRAINT `FK7eq6v2ircv32llkvdvg6wsom6` FOREIGN KEY (`filiere_id`) REFERENCES `filieres` (`id`);

--
-- Contraintes pour la table `inscriptions`
--
ALTER TABLE `inscriptions`
  ADD CONSTRAINT `FKp0doegdcvf1xjchrqlfuc0phy` FOREIGN KEY (`matiere_id`) REFERENCES `matieres` (`id`),
  ADD CONSTRAINT `FKrbdv2i5mc55pqxpuwt4fgxdbh` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiants` (`id`);

--
-- Contraintes pour la table `matieres`
--
ALTER TABLE `matieres`
  ADD CONSTRAINT `FKdca36y3ifp0bnxhdnkw8unhfc` FOREIGN KEY (`programme_id`) REFERENCES `programmes` (`id`),
  ADD CONSTRAINT `FKnqp8fhplfckdvokv3n1ps4njj` FOREIGN KEY (`professeur_id`) REFERENCES `professeurs` (`id`);

--
-- Contraintes pour la table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `FK65h0joma61x0fb6xwp8ougfia` FOREIGN KEY (`inscription_id`) REFERENCES `inscriptions` (`id`),
  ADD CONSTRAINT `FKedgqpeywue1wqqlpcc82k8pex` FOREIGN KEY (`matiere_id`) REFERENCES `matieres` (`id`);

--
-- Contraintes pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `FK1kh74cjd2gtf9cpksrthc1rk7` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiants` (`id`),
  ADD CONSTRAINT `FK6lsnn5tn5ecfrsar31gx472f1` FOREIGN KEY (`inscription_id`) REFERENCES `inscriptions` (`id`);

--
-- Contraintes pour la table `programmes`
--
ALTER TABLE `programmes`
  ADD CONSTRAINT `FKcc7gijrav6u74csngir7qv1kl` FOREIGN KEY (`filiere_id`) REFERENCES `filieres` (`id`);

--
-- Contraintes pour la table `tranches_paiement`
--
ALTER TABLE `tranches_paiement`
  ADD CONSTRAINT `FK1k2nege3qtm6nlpx73y2lt074` FOREIGN KEY (`inscription_id`) REFERENCES `inscriptions` (`id`),
  ADD CONSTRAINT `FKaq085qmjth8agbqaeimrbxh27` FOREIGN KEY (`etudiant_id`) REFERENCES `etudiants` (`id`);

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
