-- Base de données E-LLUSION (SAE 203)
-- Basée sur le MCD du lot 2 + noms de colonnes utilisés par le code PHP.
-- Import : phpMyAdmin (MAMP) > Importer, ou : mysql -u root -proot < sae-203.sql

DROP DATABASE IF EXISTS `sae-203`;
CREATE DATABASE `sae-203` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `sae-203`;

CREATE TABLE utilisateurs (
  id_user     INT AUTO_INCREMENT PRIMARY KEY,
  prenom      VARCHAR(45)  NOT NULL,
  nom         VARCHAR(45)  NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE,
  code_unique VARCHAR(20)  NOT NULL DEFAULT '',
  password    VARCHAR(200) NULL,
  profil      VARCHAR(45)  NOT NULL, -- enseignant, etudiant_mmi, personnel_usmb, professionnel, visiteur
  role        VARCHAR(45)  NOT NULL DEFAULT 'util' -- util | admin
);

CREATE TABLE salles (
  id_salles INT AUTO_INCREMENT PRIMARY KEY,
  nom_salle VARCHAR(45) NOT NULL,
  jauge     INT NOT NULL DEFAULT 12
);

CREATE TABLE creneaux (
  id_creneaux INT AUTO_INCREMENT PRIMARY KEY,
  jour        DATE NOT NULL,
  heure       TIME NOT NULL
);

CREATE TABLE inscriptions (
  id_inscriptions      INT AUTO_INCREMENT PRIMARY KEY,
  nb_personnes         INT NOT NULL DEFAULT 1,
  buffet               TINYINT(1) NOT NULL DEFAULT 0,
  date_inscrip         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  utilisateurs_id_user INT NOT NULL,
  salles_id_salles     INT NOT NULL,
  creneaux_id_creneaux INT NOT NULL,
  FOREIGN KEY (utilisateurs_id_user) REFERENCES utilisateurs(id_user) ON DELETE CASCADE,
  FOREIGN KEY (salles_id_salles)     REFERENCES salles(id_salles),
  FOREIGN KEY (creneaux_id_creneaux) REFERENCES creneaux(id_creneaux)
);

-- inscription.php insère code_unique = '' et attend que la BDD le génère
DELIMITER //
CREATE TRIGGER gen_code_unique BEFORE INSERT ON utilisateurs
FOR EACH ROW
BEGIN
  IF NEW.code_unique IS NULL OR NEW.code_unique = '' THEN
    SET NEW.code_unique = CONCAT('ELL-', UPPER(SUBSTRING(MD5(RAND()), 1, 6)));
  END IF;
END//
DELIMITER ;

-- Les id doivent correspondre aux tableaux idSalles / idCreneaux de inscription.php
INSERT INTO salles (id_salles, nom_salle) VALUES
  (1, 'Societ-e (021)'),
  (2, 'Horizon (001)'),
  (3, 'L''Envers du Décor (002)'),
  (4, 'La Pépinière (005)');

INSERT INTO creneaux (id_creneaux, jour, heure) VALUES
  (1,  '2026-06-18', '15:00'), (2,  '2026-06-18', '15:30'),
  (3,  '2026-06-18', '16:00'), (4,  '2026-06-18', '16:30'),
  (5,  '2026-06-18', '17:00'), (6,  '2026-06-18', '17:30'),
  (7,  '2026-06-18', '18:00'), (8,  '2026-06-18', '19:00'),
  (9,  '2026-06-18', '19:30'), (10, '2026-06-18', '20:00'),
  (11, '2026-06-19', '09:30'), (12, '2026-06-19', '10:00'),
  (13, '2026-06-19', '10:30'), (14, '2026-06-19', '11:00');
