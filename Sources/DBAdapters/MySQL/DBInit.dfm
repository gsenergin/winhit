object dtmdlDBInit: TdtmdlDBInit
  OldCreateOrder = False
  Height = 80
  Width = 658
  object ZConnection: TZConnection
    Protocol = 'mysql-5'
    Left = 40
    Top = 16
  end
  object zqCreateSchemas: TZQuery
    SQL.Strings = (
      
        'CREATE SCHEMA IF NOT EXISTS `main` DEFAULT CHARACTER SET utf8 CO' +
        'LLATE utf8_unicode_ci;'
      
        'CREATE SCHEMA IF NOT EXISTS `hardware_config` DEFAULT CHARACTER ' +
        'SET utf8 COLLATE utf8_unicode_ci;'
      
        'CREATE SCHEMA IF NOT EXISTS `software_config` DEFAULT CHARACTER ' +
        'SET utf8 COLLATE utf8_unicode_ci;')
    Params = <>
    Left = 128
    Top = 16
  end
  object zqCreateMainTables: TZQuery
    SQL.Strings = (
      '/* -------------------------'
      '   '#1058#1072#1073#1083#1080#1094#1099' '#1074' '#1089#1093#1077#1084#1077' `main`'
      '-------------------------- */'
      ''
      'USE `main`;'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`notifications` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `NotificationDateTime` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103 +
        ' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103'.'#39' ,'
      
        '  `Priority` ENUM('#39'low'#39', '#39'medium'#39', '#39'high'#39', '#39'ultra'#39') NOT NULL COM' +
        'MENT '#39#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103'.'#39' ,'
      '  `Message` LONGTEXT NOT NULL COMMENT '#39#1058#1077#1082#1089#1090' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103'.'#39' ,'
      
        '  `WasSent` BOOLEAN NOT NULL COMMENT '#39#1060#1083#1072#1075' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103'.' +
        #39' ,'
      '  PRIMARY KEY (`ID`) )'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1081'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`inventory_numbers` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      '  `Number` VARCHAR(255) NOT NULL COMMENT '#39#1048#1085#1074#1077#1085#1090#1072#1088#1085#1099#1081' '#1085#1086#1084#1077#1088'.'#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  UNIQUE INDEX `Number_UNIQUE` (`Number` ASC) )'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1080#1085#1074#1077#1085#1090#1072#1088#1085#1099#1093' '#1085#1086#1084#1077#1088#1086#1074'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`divisions` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      '  `Name` TEXT NOT NULL COMMENT '#39#1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'.'#39' ,'
      
        '  `Location` TEXT NULL COMMENT '#39#1052#1077#1089#1090#1086' '#1088#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103 +
        '.'#39' ,'
      '  PRIMARY KEY (`ID`) )'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`users` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      '  `FirstName` TEXT NOT NULL COMMENT '#39#1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103'.'#39' ,'
      '  `SecondName` TEXT NOT NULL COMMENT '#39#1060#1072#1084#1080#1083#1080#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103'.'#39' ,'
      
        '  `AdditionalName` TEXT NULL COMMENT '#39#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1077' '#1087#1086#1083#1077' '#1076#1083#1103' '#1089#1083 +
        #1086#1078#1085#1099#1093' '#1080' '#1076#1083#1080#1085#1085#1099#1093' '#1080#1084#1105#1085'.'#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `Users_DivisionID` (`ID` ASC) ,'
      '  CONSTRAINT `Users_DivisionID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`divisions` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`repairs` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `RepairDateTime` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1088#1077#1084#1086#1085 +
        #1090#1072'.'#39' ,'
      '  `Description` LONGTEXT NOT NULL COMMENT '#39#1054#1087#1080#1089#1072#1085#1080#1077' '#1088#1077#1084#1086#1085#1090#1072'.'#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `Repairs_InventoryNumberID` (`ID` ASC) ,'
      '  INDEX `Repairs_SpecialistID` (`ID` ASC) ,'
      '  CONSTRAINT `Repairs_InventoryNumberID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`inventory_numbers` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE RESTRICT,'
      '  CONSTRAINT `Repairs_SpecialistID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1088#1077#1084#1086#1085#1090#1086#1074' '#1080' '#1079#1072#1084#1077#1085'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`workstations` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `IPv4_Address` VARCHAR(12) NULL COMMENT '#39'IPv4-'#1072#1076#1088#1077#1089' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090 +
        #1072#1085#1094#1080#1080'.'#39' ,'
      
        '  `IPv6_Address` VARCHAR(39) NULL COMMENT '#39'IPv6-'#1072#1076#1088#1077#1089' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090 +
        #1072#1085#1094#1080#1080'.'#39' ,'
      '  `Name` TINYTEXT NULL COMMENT '#39#1048#1084#1103' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090#1072#1085#1094#1080#1080'.'#39' ,'
      
        '  `DomainOrWorkgroup` TINYTEXT NULL COMMENT '#39#1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1086#1084#1077#1085#1072'/'#1088#1072#1073 +
        #1086#1095#1077#1081' '#1075#1088#1091#1087#1087#1099'.'#39' ,'
      
        '  `Comments` TINYTEXT NULL COMMENT '#39#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080' '#1082' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090#1072#1085#1094#1080 +
        #1080#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `Workstations_InventoryNumberID` (`ID` ASC) ,'
      '  INDEX `Workstations_DivisionID` (`ID` ASC) ,'
      '  INDEX `Workstations_MateriallyAccountableID` (`ID` ASC) ,'
      '  CONSTRAINT `Workstations_InventoryNumberID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`inventory_numbers` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE RESTRICT,'
      '  CONSTRAINT `Workstations_DivisionID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`divisions` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE,'
      '  CONSTRAINT `Workstations_MateriallyAccountableID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1088#1072#1073#1086#1095#1080#1093' '#1089#1090#1072#1085#1094#1080#1081'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`tables_dictionary` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `SchemaName` VARCHAR(64) NOT NULL COMMENT '#39#1048#1084#1103' '#1089#1093#1077#1084#1099', '#1082#1086#1090#1086#1088#1086#1081' ' +
        #1087#1088#1080#1085#1072#1076#1083#1077#1078#1080#1090' '#1080#1089#1082#1086#1084#1072#1103' '#1090#1072#1073#1083#1080#1094#1072'.'#39' ,'
      
        '  `TableName` VARCHAR(64) NOT NULL COMMENT '#39#1048#1084#1103' '#1080#1089#1082#1086#1084#1086#1081' '#1090#1072#1073#1083#1080#1094#1099'.' +
        #39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  UNIQUE INDEX `TableName_UNIQUE` (`TableName` ASC) )'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1057#1083#1086#1074#1072#1088#1100' '#1089#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103' '#1090#1072#1073#1083#1080#1094' '#1089#1093#1077#1084#1072#1084'.'#39';'
      ''
      'CREATE TABLE IF NOT EXISTS `main`.`inventory_history` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `DateTimeStarted` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1089#1090#1072#1088 +
        #1090#1072' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'.'#39' ,'
      
        '  `DateTimeFinished` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1079#1072#1074 +
        #1077#1088#1096#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'.'#39' ,'
      
        '  `Status` ENUM('#39'deprecated'#39', '#39'actual'#39', '#39'verified'#39', '#39'missing'#39', '#39 +
        'new'#39') NOT NULL COMMENT '#39#1057#1090#1072#1090#1091#1089' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080'.'#39' ,'
      
        '  `TableRecordID` INT UNSIGNED NULL COMMENT '#39'ID '#1079#1072#1087#1080#1089#1080' '#1074' '#1090#1072#1073#1083#1080#1094#1077 +
        ', '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1084#1086#1081' '#1087#1086' FK TablesDictionaryID'#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `SupervisorID` (`ID` ASC) ,'
      '  INDEX `TablesDictionaryID` (`ID` ASC) ,'
      '  CONSTRAINT `SupervisorID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE,'
      '  CONSTRAINT `TablesDictionaryID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`tables_dictionary` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB'
      'COMMENT = '#39#1058#1072#1073#1083#1080#1094#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1086#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1081'.'#39';')
    Params = <>
    Left = 232
    Top = 16
  end
  object zqCreateHardwareTables: TZQuery
    SQL.Strings = (
      '/*'
      ''
      'Templates for StringReplace() function:'
      ''
      '1) %TABLE_NAME% - '#1080#1084#1103' '#1090#1072#1073#1083#1080#1094#1099'.'
      
        '2) %WMI_INFO% - '#1082#1086#1083#1086#1085#1082#1080', '#1074' '#1082#1086#1090#1086#1088#1099#1093' '#1073#1091#1076#1077#1090' '#1093#1088#1072#1085#1080#1090#1100#1089#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103', '#1089 +
        #1086#1073#1088#1072#1085#1085#1072#1103' WMI.'
      ''
      '*/'
      ''
      'CREATE TABLE IF NOT EXISTS `hardware_config`.`%TABLE_NAME%` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `RegistrationDateTime` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103 +
        ' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080' '#1085#1072' '#1091#1095#1105#1090'.'#39' ,'
      
        '  `WarrantiedLifetime` DOUBLE NULL COMMENT '#39#1043#1072#1088#1072#1085#1090#1080#1081#1085#1099#1081' '#1089#1088#1086#1082' '#1089#1083#1091 +
        #1078#1073#1099'.'#39' ,'
      
        '  `EstimatedLifetime` DOUBLE NULL COMMENT '#39#1056#1072#1089#1095#1105#1090#1085#1099#1081' ('#1086#1078#1080#1076#1072#1077#1084#1099#1081')' +
        ' '#1089#1088#1086#1082' '#1089#1083#1091#1078#1073#1099'.'#39' ,'
      '  %WMI_INFO% /* WMI Tech Info */'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `%TABLE_NAME%_WorkstationID` (`ID` ASC) ,'
      '  INDEX `%TABLE_NAME%_InventoryNumberID` (`ID` ASC) ,'
      '  INDEX `%TABLE_NAME%_MateriallyAccountableID` (`ID` ASC) ,'
      '  CONSTRAINT `%TABLE_NAME%_WorkstationID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`workstations` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE,'
      '  CONSTRAINT `%TABLE_NAME%_InventoryNumberID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`inventory_numbers` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE RESTRICT,'
      '  CONSTRAINT `%TABLE_NAME%_MateriallyAccountableID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB;')
    Params = <>
    Left = 352
    Top = 16
  end
  object zqCreateSoftwareTables: TZQuery
    SQL.Strings = (
      '/*'
      ''
      'Templates for StringReplace() function:'
      ''
      '1) %TABLE_NAME% - '#1080#1084#1103' '#1090#1072#1073#1083#1080#1094#1099'.'
      
        '2) %WMI_INFO% - '#1082#1086#1083#1086#1085#1082#1080', '#1074' '#1082#1086#1090#1086#1088#1099#1093' '#1073#1091#1076#1077#1090' '#1093#1088#1072#1085#1080#1090#1100#1089#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103', '#1089 +
        #1086#1073#1088#1072#1085#1085#1072#1103' WMI.'
      ''
      '*/'
      ''
      
        'CREATE TABLE IF NOT EXISTS `software_config`.`installed_software' +
        '` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `RegistrationDateTime` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103 +
        ' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080' '#1085#1072' '#1091#1095#1105#1090'.'#39' ,'
      '  `LicenseType` TINYTEXT NULL COMMENT '#39#1058#1080#1087' '#1083#1080#1094#1077#1085#1079#1080#1080'.'#39' ,'
      
        '  `LicenseExpires` DATETIME NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1080#1089#1090#1077#1095#1077#1085#1080#1103 +
        ' '#1083#1080#1094#1077#1085#1079#1080#1080'.'#39' ,'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `InstalledSoftware_WorkstationID` (`ID` ASC) ,'
      '  INDEX `InstalledSoftware_InventoryNumberID` (`ID` ASC) ,'
      '  INDEX `InstalledSoftware_MateriallyAccountableID` (`ID` ASC) ,'
      '  CONSTRAINT `InstalledSoftware_WorkstationID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`workstations` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE,'
      '  CONSTRAINT `InstalledSoftware_InventoryNumberID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`inventory_numbers` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE RESTRICT,'
      '  CONSTRAINT `InstalledSoftware_MateriallyAccountableID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB;'
      ''
      'CREATE TABLE IF NOT EXISTS `software_config`.`%TABLE_NAME%` ('
      '  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,'
      
        '  `RegistrationDateTime` DATETIME NOT NULL COMMENT '#39#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103 +
        ' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080' '#1085#1072' '#1091#1095#1105#1090'.'#39' ,'
      '  %WMI_INFO% /* WMI Tech Info */'
      '  PRIMARY KEY (`ID`) ,'
      '  INDEX `%TABLE_NAME%_WorkstationID` (`ID` ASC) ,'
      '  INDEX `%TABLE_NAME%_InventoryNumberID` (`ID` ASC) ,'
      '  INDEX `%TABLE_NAME%_MateriallyAccountableID` (`ID` ASC) ,'
      '  CONSTRAINT `%TABLE_NAME%_WorkstationID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`workstations` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE,'
      '  CONSTRAINT `%TABLE_NAME%_InventoryNumberID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`inventory_numbers` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE RESTRICT,'
      '  CONSTRAINT `%TABLE_NAME%_MateriallyAccountableID`'
      '    FOREIGN KEY (`ID` )'
      '    REFERENCES `main`.`users` (`ID` )'
      '    ON DELETE RESTRICT'
      '    ON UPDATE CASCADE)'
      'ENGINE = InnoDB;')
    Params = <>
    Left = 488
    Top = 16
  end
  object zsqlmonDBInit: TZSQLMonitor
    Active = True
    AutoSave = True
    FileName = 'DBInit.log'
    MaxTraceCount = 100
    Left = 592
    Top = 16
  end
end
