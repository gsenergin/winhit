/*

Templates for Format() function:

1: %s - table name
2: %s - wmi tech info columns
3, 4, 5: %s - unique indexes names (%s part - from table name) which are also used in 6, 7, 8.

*/

CREATE TABLE IF NOT EXISTS `software_config`.`installed_software` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `RegistrationDateTime` DATETIME NOT NULL COMMENT 'Дата и время постановки на учёт.' ,
  `LicenseType` TINYTEXT NULL COMMENT 'Тип лицензии.' ,
  `LicenseExpires` DATETIME NULL COMMENT 'Дата и время истечения лицензии.' ,
  PRIMARY KEY (`ID`) ,
  INDEX `InstalledSoftware_WorkstationID` (`ID` ASC) ,
  INDEX `InstalledSoftware_InventoryNumberID` (`ID` ASC) ,
  INDEX `InstalledSoftware_MateriallyAccountableID` (`ID` ASC) ,
  CONSTRAINT `InstalledSoftware_WorkstationID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`workstations` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `InstalledSoftware_InventoryNumberID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `InstalledSoftware_MateriallyAccountableID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `software_config`.`%s` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
  `RegistrationDateTime` DATETIME NOT NULL COMMENT 'Дата и время постановки на учёт.' ,
  %s /* WMI Tech Info */
  PRIMARY KEY (`ID`) ,
  INDEX `%s_WorkstationID` (`ID` ASC) ,
  INDEX `%s_InventoryNumberID` (`ID` ASC) ,
  INDEX `%s_MateriallyAccountableID` (`ID` ASC) ,
  CONSTRAINT `%s_WorkstationID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`workstations` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `%s_InventoryNumberID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `%s_MateriallyAccountableID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;