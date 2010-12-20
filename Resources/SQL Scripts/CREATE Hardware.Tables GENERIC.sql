/*

Templates for StringReplace() function:

1) %TABLE_NAME% - имя таблицы.
2) %WMI_INFO% - колонки, в которых будет храниться информация, собранная WMI.

*/

CREATE TABLE IF NOT EXISTS `hardware_config`.`%TABLE_NAME%` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `RegistrationDateTime` DATETIME NOT NULL COMMENT 'Дата и время постановки на учёт.' ,
  `WarrantiedLifetime` DOUBLE NULL COMMENT 'Гарантийный срок службы.' ,
  `EstimatedLifetime` DOUBLE NULL COMMENT 'Расчётный (ожидаемый) срок службы.' ,
  %WMI_INFO% /* WMI Tech Info */
  PRIMARY KEY (`ID`) ,
  INDEX `%TABLE_NAME%_WorkstationID` (`ID` ASC) ,
  INDEX `%TABLE_NAME%_InventoryNumberID` (`ID` ASC) ,
  INDEX `%TABLE_NAME%_MateriallyAccountableID` (`ID` ASC) ,
  CONSTRAINT `%TABLE_NAME%_WorkstationID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`workstations` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `%TABLE_NAME%_InventoryNumberID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `%TABLE_NAME%_MateriallyAccountableID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;