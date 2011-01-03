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
    STR_QUERYBASE = 'SELECT * FROM `%s`.`%s` %s ;';
    STR_QUERYPART = 'JOIN `%s`.`%s` ON (`%s`.`%s`.`%s` = `%s`.`%s`.`%s`) ';

  var
    FKInfo : TForeignKeyInfo;
    sLeftTableSchema, {sLeftTableName,} sLeftTableColumn,
    sRightTableSchema, sRightTableName, sRightTableColumn : String;
    sQueryPart : String;
begin
{
SELECT * FROM `main`.`users` JOIN `main`.`divisions`
ON `main`.`users`.`divisionid` = `main`.`divisions`.`id`;
}
  Assert(Length(Table) > 0);

  Result := '';
  sQueryPart := '';
  sLeftTableSchema := TablesDictionary.Items[Table];

  For FKInfo in FKDictionary.Items[Table] do
  begin
    sLeftTableColumn := FKInfo.ColumnName;

    sRightTableSchema := TablesDictionary.Items[FKInfo.ReferencesTable]; //FKInfo.ReferencesSchema
    sRightTableName := FKInfo.ReferencesTable;
    sRightTableColumn := FKInfo.ReferencesColumn;

    sQueryPart := sQueryPart +
                  Format(STR_QUERYPART,
                         [sRightTableSchema, sRightTableName,
                          sLeftTableSchema, Table, sLeftTableColumn,
                          sRightTableSchema, sRightTableName, sRightTableColumn]);
  end;

  Result := Format(STR_QUERYBASE, [sLeftTableSchema, Table, sQueryPart]);
end;

end.
