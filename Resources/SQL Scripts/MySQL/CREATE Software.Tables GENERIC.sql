/*

Templates for StringReplace() function:

1) %TABLE_NAME% - имя таблицы.
2) %WMI_INFO% - колонки, в которых будет храниться информация, собранная WMI.

*/

CREATE TABLE IF NOT EXISTS `software_config`.`installed_software` (
  `ID` INT UNSIGNED NULL AUTO_INCREMENT ,
  `RegistrationDateTime` DATETIME NOT NULL COMMENT 'Дата и время постановки на учёт.' ,
  `LicenseType` TINYTEXT NULL COMMENT 'Тип лицензии.' ,
  `LicenseExpires` DATETIME NULL COMMENT 'Дата и время истечения лицензии.' ,
  `WorkstationID` INT UNSIGNED NOT NULL COMMENT 'Рабочая станция, на которой обнаружен объект.' ,
  `InventoryNumberID` INT UNSIGNED NOT NULL COMMENT 'Инвентарный номер.' ,
  `MateriallyAccountableID` INT UNSIGNED NOT NULL COMMENT 'Материально ответственный.' ,
  PRIMARY KEY (`ID`) ,
  KEY `WorkstationID` (`WorkstationID`) ,
  KEY `InventoryNumberID` (`InventoryNumberID`) ,
  KEY `MateriallyAccountableID` (`MateriallyAccountableID`) ,
  INDEX `InstalledSoftware_WorkstationID` (`WorkstationID` ASC) ,
  INDEX `InstalledSoftware_InventoryNumberID` (`InventoryNumberID` ASC) ,
  INDEX `InstalledSoftware_MateriallyAccountableID` (`MateriallyAccountableID` ASC) ,
  CONSTRAINT `InstalledSoftware_WorkstationID`
    FOREIGN KEY (`WorkstationID` )
    REFERENCES `main`.`workstations` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `InstalledSoftware_InventoryNumberID`
    FOREIGN KEY (`InventoryNumberID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `InstalledSoftware_MateriallyAccountableID`
    FOREIGN KEY (`MateriallyAccountableID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `software_config`.`%TABLE_NAME%` (
  `ID` INT UNSIGNED NULL AUTO_INCREMENT ,
  `RegistrationDateTime` DATETIME NOT NULL COMMENT 'Дата и время постановки на учёт.' ,
  `WorkstationID` INT UNSIGNED NOT NULL COMMENT 'Рабочая станция, на которой обнаружен объект.' ,
  `InventoryNumberID` INT UNSIGNED NOT NULL COMMENT 'Инвентарный номер.' ,
  `MateriallyAccountableID` INT UNSIGNED NOT NULL COMMENT 'Материально ответственный.' ,
  %WMI_INFO% /* WMI Tech Info */
  PRIMARY KEY (`ID`) ,
  KEY `WorkstationID` (`WorkstationID`) ,
  KEY `InventoryNumberID` (`InventoryNumberID`) ,
  KEY `MateriallyAccountableID` (`MateriallyAccountableID`) ,
  INDEX `%TABLE_NAME%_WorkstationID` (`WorkstationID` ASC) ,
  INDEX `%TABLE_NAME%_InventoryNumberID` (`InventoryNumberID` ASC) ,
  INDEX `%TABLE_NAME%_MateriallyAccountableID` (`MateriallyAccountableID` ASC) ,
  CONSTRAINT `%TABLE_NAME%_WorkstationID`
    FOREIGN KEY (`WorkstationID` )
    REFERENCES `main`.`workstations` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `%TABLE_NAME%_InventoryNumberID`
    FOREIGN KEY (`InventoryNumberID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `%TABLE_NAME%_MateriallyAccountableID`
    FOREIGN KEY (`MateriallyAccountableID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;