unit Constants;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

const

  { AppSettingsSource.pas }

  STR_DBSETTINGS_FILE = 'DBSettings.ini';

  { DBInit.pas }

  STR_REPLACE_TABLENAME = '%TABLE_NAME%';
  STR_REPLACE_WMIINFO = '%WMI_INFO%';
  STR_SEPARATOR = '|';

  { PassWord.pas }

  STR_PASSWORD_FILE = 'Password.ini';

  { JvDBComponents.pas }

  STR_DB_MAIN = 'main';
  STR_DB_SOFTWARE = 'software_config';
  STR_DB_HARDWARE = 'hardware_config';

implementation

end.
