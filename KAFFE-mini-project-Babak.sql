 -- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET SQL_SAFE_UPDATES=0;
-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF  Exists `mydb`;
-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Medarbejdere`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Medarbejdere` (
  `MedarbejderID` INT NOT NULL AUTO_INCREMENT,
  `Navn` VARCHAR(45) NOT NULL,
  `ErAutoriseret` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`MedarbejderID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Drikkelse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Drikkelse` (
  `DrinkID` INT NOT NULL AUTO_INCREMENT,
  `navn` VARCHAR(45) NOT NULL,
   `Pris` DECIMAL(6,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`DrinkID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`IngrediensLager`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`IngrediensLager` (
  `IngrediensID` INT NOT NULL,
  `Navn` VARCHAR(45) NOT NULL,
  `Mængde` DECIMAL(8,2) NOT NULL,
  `Enhed` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`IngrediensID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Kasseaperat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Kasseaperat` (
  `KasseaperatID` INT NOT NULL,
  `Beløb` DECIMAL(8,2) NOT NULL,
  `Tømnings_grænse` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`KasseaperatID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Transaktioner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Transaktioner` (
  `TransaktionsID` INT NOT NULL,
  `Tidspunkt` DATETIME NOT NULL,
  `Type` VARCHAR(45) NOT NULL,
  `Metode` VARCHAR(45) NOT NULL,
  `Beløb` DECIMAL(6,2) NOT NULL DEFAULT 0.00,
  `Medarbejdere_MedarbejderID` INT NOT NULL,
  `Drikkelse_DrinkID` INT NULL,
  `Kasseaperat_KasseaperatID` INT NOT NULL,
  PRIMARY KEY (`TransaktionsID`),
  INDEX `fk_Transaktioner_Medarbejdere_idx` (`Medarbejdere_MedarbejderID` ASC),
  INDEX `fk_Transaktioner_Drikkelse1_idx` (`Drikkelse_DrinkID` ASC),
  INDEX `fk_Transaktioner_Kasseaperat1_idx` (`Kasseaperat_KasseaperatID` ASC),
  CONSTRAINT `fk_Transaktioner_Medarbejdere`
    FOREIGN KEY (`Medarbejdere_MedarbejderID`)
    REFERENCES `mydb`.`Medarbejdere` (`MedarbejderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaktioner_Drikkelse1`
    FOREIGN KEY (`Drikkelse_DrinkID`)
    REFERENCES `mydb`.`Drikkelse` (`DrinkID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transaktioner_Kasseaperat1`
    FOREIGN KEY (`Kasseaperat_KasseaperatID`)
    REFERENCES `mydb`.`Kasseaperat` (`KasseaperatID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lagerhistorik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lagerhistorik` (
  `LagerhistorikID` INT NOT NULL AUTO_INCREMENT,
  `Ændring` Decimal(6,2) NOT NULL,
  `IngrediensLager_IngrediensID` INT NOT NULL,
  PRIMARY KEY (`LagerhistorikID`),
  INDEX `fk_Lagerhistorik_IngrediensLager1_idx` (`IngrediensLager_IngrediensID` ASC),
  CONSTRAINT `fk_Lagerhistorik_IngrediensLager1`
    FOREIGN KEY (`IngrediensLager_IngrediensID`)
    REFERENCES `mydb`.`IngrediensLager` (`IngrediensID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rengøringshistorik`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rengøringshistorik` (
  `RengøringshistorikID` INT NOT NULL,
  `TiD` DATETIME NOT NULL,
  `Medarbejdere_MedarbejderID` INT NOT NULL,
  PRIMARY KEY (`RengøringshistorikID`),
  INDEX `fk_Rengøringshistorik_Medarbejdere1_idx` (`Medarbejdere_MedarbejderID` ASC),
  CONSTRAINT `fk_Rengøringshistorik_Medarbejdere1`
    FOREIGN KEY (`Medarbejdere_MedarbejderID`)
    REFERENCES `mydb`.`Medarbejdere` (`MedarbejderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Opskrift`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Opskrift` (
  `OpskriftID` INT NOT NULL,
  `Mængde` DECIMAL(6,2) NULL,
  `IngrediensLager_IngrediensID` INT NOT NULL,
  `Drikkelse_DrinkID` INT NOT NULL,
  PRIMARY KEY (`OpskriftID`),
  INDEX `fk_Opskrift_IngrediensLager1_idx` (`IngrediensLager_IngrediensID` ASC),
  INDEX `fk_Opskrift_Drikkelse1_idx` (`Drikkelse_DrinkID` ASC),
  CONSTRAINT `fk_Opskrift_IngrediensLager1`
    FOREIGN KEY (`IngrediensLager_IngrediensID`)
    REFERENCES `mydb`.`IngrediensLager` (`IngrediensID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Opskrift_Drikkelse1`
    FOREIGN KEY (`Drikkelse_DrinkID`)
    REFERENCES `mydb`.`Drikkelse` (`DrinkID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE mydb;
-- Trigger til Autorition
DELIMITER //
CREATE TRIGGER Autorisering
Before Insert ON Transaktioner
FOR EACH ROW
BEGIN
DECLARE autoriseret_status TINYINT;
SELECT ErAutoriseret INTO autoriseret_status
FROM Medarbejdere
WHERE MedarbejderID=NEW.Medarbejdere_MedarbejderID;
IF NEW.Type='Træk' AND autoriseret_status=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Medarbejder har ikke tilladelse';
END IF;
END //
-- Trigger til automatisk Lageropdatering
DELIMITER //
CREATE TRIGGER OpdaterLager_og_kasse
After INSERT ON Transaktioner
FOR EACH ROW
BEGIN
IF NEW.Type='køb' AND NEW.Drikkelse_DrinkID IS NOT NULL THEN
UPDATE IngrediensLager IL
JOIN Opskrift O ON IL.IngrediensID=O.IngrediensLager_IngrediensID
SET IL.Mængde= IL.Mængde-O.Mængde
WHERE O.Drikkelse_DrinkID=NEW.Drikkelse_DrinkID;
INSERT INTO Lagerhistorik(Ændring, IngrediensLager_IngrediensID)
SELECT O.Mængde,O.IngrediensLager_IngrediensID
FROM Opskrift O
WHERE O.Drikkelse_DrinkID=NEW.Drikkelse_DrinkID;
END IF;
-- Opdatere kassen
IF NEW.Type='køb' AND NEW.metode='kontant' Then
UPDATE Kasseaperat
SET Beløb=Beløb+NEW.Beløb
WHERE KasseaperatID=NEW.Kasseaperat_KasseaperatID;
END IF;
IF NEW.Type='Træk' THEN
UPDATE Kasseaperat
SET Beløb=Beløb-NEW.Beløb
WHERE KasseaperatID=NEW.Kasseaperat_KasseaperatID;
END IF;
END//
DELIMITER ;
-- Sætte kassen op
INSERT INTO Kasseaperat(KasseaperatID,Beløb,Tømnings_grænse)
VALUES (1,1000.00,5000.00);
-- Medarbejderne der kan bruge maskinen
INSERT INTO Medarbejdere(Navn,ErAutoriseret) VALUES('Mand',0);
INSERT INTO Medarbejdere(Navn,ErAutoriseret) VALUES('kvinde',1);
-- Lave menuen
INSERT INTO Drikkelse (navn) VALUES('Espresso');
INSERT INTO Drikkelse (navn) VALUES('Americano');
INSERT INTO Drikkelse (navn) VALUES('Cappuccino');
-- Putte de forskellige ingredienser i largeret (IngrediensLager)
INSERT INTO IngrediensLager(IngrediensID,Navn,Mængde,Enhed) VALUES (1, 'Kaffebønner',5000.00,'Gram');
INSERT INTO IngrediensLager(IngrediensID,Navn,Mængde,Enhed) VALUES (2, 'Vand',10000.00,'ml');
-- Programmere,altså skriv opskriften ind
INSERT INTO Opskrift(OpskriftID,Mængde,IngrediensLager_IngrediensID,Drikkelse_DrinkID) VALUES(1,15.00,1,1);
INSERT INTO Opskrift(OpskriftID,Mængde,IngrediensLager_IngrediensID,Drikkelse_DrinkID) VALUES(2,30.00,2,1);
-- En medarbejder,nummer 1, køber en Ekspresso med kort
INSERT INTO Transaktioner(TransaktionsID,Tidspunkt,Type,Metode,Beløb,Medarbejdere_MedarbejderID,Drikkelse_DrinkID, Kasseaperat_KasseaperatID) 
Values(1,'2022-05-01 07:30:00', 'køb','Kort',25.00,1,1,1);
-- En medarbejder trækker penge
INSERT INTO Transaktioner(TransaktionsID,Tidspunkt,Type,Metode,Beløb,Medarbejdere_MedarbejderID,Drikkelse_DrinkID,Kasseaperat_KasseaperatID) 
Values(2,'2022-05-01 12:30:00', 'Træk','Kontant',500.00,2,NULL,1);
-- Medarbejder nummer 1 renser maskinen
INSERT INTO Rengøringshistorik(RengøringshistorikID,TID,Medarbejdere_MedarbejderID) 
Values(1,'2022-05-01 17:30:00',1);
-- querie 1 om at udlæse transaktioner
Select t.Tidspunkt,t.Type,t.metode,d.navn AS Drik, m.Navn AS Medarbejdere
FROM Transaktioner t
LEFT JOIN Drikkelse d ON t.Drikkelse_DrinkID=d.DrinkID
LEFT JOIN Medarbejdere m ON t.Medarbejdere_MedarbejderID = m.MedarbejderID
WHERE t.tidspunkt>='2022-05-01 00:00:00' And t.type='Køb';
-- querie 2 om at vise lagerindholdsstatus
SELECT Navn,Mængde,Enhed FROM IngrediensLager;
SELECT Beløb AS 'kontanter' FROM kasseaperat;
-- querie 3 om at rengøringshistorik
SELECT r.TID AS Dato_og_Tid, m.Navn AS Udført
FROM Rengøringshistorik r
JOIN Medarbejdere m ON r.Medarbejdere_MedarbejderID=m.MedarbejderID;
