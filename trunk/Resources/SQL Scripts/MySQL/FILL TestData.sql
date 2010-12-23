INSERT INTO `main`.`notifications` (`NotificationDateTime`, `Priority`, `Message`, `WasSent`) VALUES
  ('1945-05-08 12:00', 'ultra', 'War is over.', true);

INSERT INTO `main`.`divisions` (`Name`, `Location`) VALUES
  ('Отдел продаж', '1-ый этаж'),
  ('Бухгалтерия', '2-ой этаж'),
  ('Техническая поддержка', 'Мрачное подземелье');

INSERT INTO `main`.`users` (`FirstName`, `SecondName`, `AdditionalName`, `DivisionID`) VALUES
  -- Чуваки из отдела продаж
  ('Иван', 'Иванов', '', '1'),
  ('Игорь', 'Петров', 'Парфенович', '1'),
  ('Аристарх', 'Каллистратов', 'Сигизмундович', '1'),
  ('Квазимодо', 'Лысоухов', '', '1'),
  -- Чуваки их бухгалтерии
  ('Зинаида', 'Квадроциклова', '', '2'),
  ('Аделаида', 'Ларисовна', 'Варум', '2'),
  ('Отчёта', 'Годовая', 'Несходитовна', '2'),
  -- Чуваки из техотдела
  ('ололо', 'трололо', '', '3'),
  ('Мастер', 'Витухи', 'И Обжимника', '3'),
  ('RJ', '45', '', '3');

INSERT INTO `main`.`inventory_numbers` (`number`) VALUES
  ('1234567890'),
  ('0987654321'),
  ('12345687'),
  ('stringnumber'),
  ('100500');

INSERT INTO `main`.`repairs` (`RepairDateTime`, `Description`, `InventoryNumberID`, `SpecialistID`) VALUES
  ('2010-10-10 00:00', 'Принтерама поломаласяма насяльника. Замена фотобарабана.', '1', '7');

INSERT INTO `main`.`workstations` (`IPv4_Address`, `Name`, `DomainOrWorkgroup`, `Comments`, `InventoryNumberID`, `DivisionID`, `MateriallyAccountableID`) VALUES
  ('10.0.0.1', 'комп в отделе продаж', 'WORKGROUP', 'no comments', '2', '1', '3'),
  ('10.0.0.2', 'комп в бухгалтерии', 'WORKGROUP', 'no comments', '3', '2', '5'),
  ('10.0.0.3', 'комп в техотделе', 'WORKGROUP', 'no comments', '4', '3', '9');

INSERT INTO `main`.`tables_dictionary` (`SchemaName`, `TableName`) VALUES
  ('software_config', 'installed_software');

INSERT INTO `software_config`.`installed_software` (`RegistrationDateTime`, `LicenseType`, `LicenseExpires`, `WorkstationID`, `InventoryNumberID`, `MateriallyAccountableID`) VALUES
  ('2010-10-10 15:30', 'Trial', '2012-12-23 23:59', '1', '5', '1');

INSERT INTO `main`.`inventory_history` (`DateTimeStarted`, `DateTimeFinished`, `Status`, `TableRecordID`, `SupervisorID`, `TablesDictionaryID`) VALUES
  ('2010-10-10 15:00', '2010-10-10 17:00', 'actual', '1', '9', '1');