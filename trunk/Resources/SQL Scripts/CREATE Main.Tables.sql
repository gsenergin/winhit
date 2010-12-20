/* -------------------------
   Таблицы в схеме `main`
-------------------------- */

USE `main`;

CREATE TABLE IF NOT EXISTS `main`.`notifications` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `NotificationDateTime` DATETIME NOT NULL COMMENT 'Дата и время создания уведомления.' ,
  `Priority` ENUM('low', 'medium', 'high', 'ultra') NOT NULL COMMENT 'Приоритет уведомления.' ,
  `Message` LONGTEXT NOT NULL COMMENT 'Текст уведомления.' ,
  `WasSent` BOOLEAN NOT NULL COMMENT 'Флаг отправки уведомления.' ,
  PRIMARY KEY (`ID`) )
ENGINE = InnoDB
COMMENT = 'Таблица уведомлений.';

CREATE TABLE IF NOT EXISTS `main`.`inventory_numbers` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `Number` VARCHAR(255) NOT NULL COMMENT 'Инвентарный номер.' ,
  PRIMARY KEY (`ID`) ,
  UNIQUE INDEX `Number_UNIQUE` (`Number` ASC) )
ENGINE = InnoDB
COMMENT = 'Таблица инвентарных номеров.';

CREATE TABLE IF NOT EXISTS `main`.`divisions` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `Name` TEXT NOT NULL COMMENT 'Название подразделения.' ,
  `Location` TEXT NULL COMMENT 'Место расположения подразделения.' ,
  PRIMARY KEY (`ID`) )
ENGINE = InnoDB
COMMENT = 'Таблица подразделений предприятия.';

CREATE TABLE IF NOT EXISTS `main`.`users` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `FirstName` TEXT NOT NULL COMMENT 'Имя пользователя.' ,
  `SecondName` TEXT NOT NULL COMMENT 'Фамилия пользователя.' ,
  `AdditionalName` TEXT NULL COMMENT 'Дополнительное поле для сложных и длинных имён.' ,
  PRIMARY KEY (`ID`) ,
  INDEX `Users_DivisionID` (`ID` ASC) ,
  CONSTRAINT `Users_DivisionID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`divisions` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица пользователей.';

CREATE TABLE IF NOT EXISTS `main`.`repairs` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `RepairDateTime` DATETIME NOT NULL COMMENT 'Дата и время ремонта.' ,
  `Description` LONGTEXT NOT NULL COMMENT 'Описание ремонта.' ,
  PRIMARY KEY (`ID`) ,
  INDEX `Repairs_InventoryNumberID` (`ID` ASC) ,
  INDEX `Repairs_SpecialistID` (`ID` ASC) ,
  CONSTRAINT `Repairs_InventoryNumberID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `Repairs_SpecialistID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица ремонтов и замен.';

CREATE TABLE IF NOT EXISTS `main`.`workstations` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `IPv4_Address` VARCHAR(15) NULL COMMENT 'IPv4-адрес рабочей станции.' ,
  `IPv6_Address` VARCHAR(39) NULL COMMENT 'IPv6-адрес рабочей станции.' ,
  `Name` TINYTEXT NULL COMMENT 'Имя рабочей станции.' ,
  `DomainOrWorkgroup` TINYTEXT NULL COMMENT 'Название домена/рабочей группы.' ,
  `Comments` TINYTEXT NULL COMMENT 'Комментарии к рабочей станции' ,
  PRIMARY KEY (`ID`) ,
  INDEX `Workstations_InventoryNumberID` (`ID` ASC) ,
  INDEX `Workstations_DivisionID` (`ID` ASC) ,
  INDEX `Workstations_MateriallyAccountableID` (`ID` ASC) ,
  CONSTRAINT `Workstations_InventoryNumberID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`inventory_numbers` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `Workstations_DivisionID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`divisions` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `Workstations_MateriallyAccountableID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица рабочих станций.';

CREATE TABLE IF NOT EXISTS `main`.`tables_dictionary` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `SchemaName` VARCHAR(64) NOT NULL COMMENT 'Имя схемы, которой принадлежит искомая таблица.' ,
  `TableName` VARCHAR(64) NOT NULL COMMENT 'Имя искомой таблицы.' ,
  PRIMARY KEY (`ID`) ,
  UNIQUE INDEX `TableName_UNIQUE` (`TableName` ASC) )
ENGINE = InnoDB
COMMENT = 'Словарь соответствия таблиц схемам.';

CREATE TABLE IF NOT EXISTS `main`.`inventory_history` (
  `ID` INT UNSIGNED NOT NULL DEFAULT 0 AUTO_INCREMENT ,
  `DateTimeStarted` DATETIME NOT NULL COMMENT 'Дата и время старта процесса инвентаризации.' ,
  `DateTimeFinished` DATETIME NOT NULL COMMENT 'Дата и время завершения процесса инвентаризации.' ,
  `Status` ENUM('deprecated', 'actual', 'verified', 'missing', 'new') NOT NULL COMMENT 'Статус конфигурации.' ,
  `TableRecordID` INT UNSIGNED NULL COMMENT 'ID записи в таблице, определяемой по FK TablesDictionaryID' ,
  PRIMARY KEY (`ID`) ,
  INDEX `SupervisorID` (`ID` ASC) ,
  INDEX `TablesDictionaryID` (`ID` ASC) ,
  CONSTRAINT `SupervisorID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`users` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `TablesDictionaryID`
    FOREIGN KEY (`ID` )
    REFERENCES `main`.`tables_dictionary` (`ID` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица результатов инвентаризаций.';