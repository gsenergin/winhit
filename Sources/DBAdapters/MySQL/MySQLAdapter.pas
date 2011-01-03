unit MySQLAdapter;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Classes, SysUtils, Generics.Collections, RTTI, SysUtilsEx, MySQLHelpers;

  function InsertQuery(const Schema, Table : String; const Columns : TStrings;
                       const Values : TList<TValue>) : String;
  function SelectAllJoinFKQuery(const Table : String) : String;

implementation

function InsertQuery(const Schema, Table : String; const Columns : TStrings;
                     const Values : TList<TValue>) : String;
  const
    STR_QUERYBASE = 'INSERT INTO `%s`.`%s` (%s) VALUES (%s);';

  var
    S, sColumns, sValues : String;
    Val : TValue;
begin
{
INSERT INTO `main`.`divisions` (`Name`, `Location`)
VALUES ('Отдел продаж', '1-ый этаж');
}

  For S in Columns do
    sColumns := AddToken(sColumns, '`' + S + '`', ',');

  For Val in Values do
    sValues := AddToken(sValues, '`' + Val.AsVariant + '`', ',');

  Result := Format(STR_QUERYBASE, [Schema, Table, sColumns, sValues]);
end;

function SelectAllJoinFKQuery(const Table : String) : String;
  const
    STR_QUERYBASE = 'SELECT * FROM `%s`.`%s` JOIN `%s`.`%s` ON %s';
    STR_QUERYPART = '(`%s`.`%s`.`%s` = `%s`.`%s`.`%s`)';
    STR_DELIM = ' AND ';

  var
    FKInfo : TForeignKeyInfo;
begin
{
SELECT * FROM `main`.`users` JOIN `main`.`divisions`
ON `main`.`users`.`divisionid` = `main`.`divisions`.`id`;
}
end;

end.
