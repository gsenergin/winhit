unit MySQLAdapter;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Classes, SysUtils, Generics.Collections, RTTI, SysUtilsEx;

  function InsertQuery(const Schema, Table : String; const Columns : TStrings;
                       const Values : TList<TValue>) : String;

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
INSERT INTO `main`.`divisions` (`Name`, `Location`) VALUES ('Отдел продаж', '1-ый этаж');
}

  For S in Columns do
    sColumns := AddToken(sColumns, '`' + S + '`', ',');

  For Val in Values do
    sValues := AddToken(sValues, '`' + Val.AsVariant + '`', ',');

  Result := Format(STR_QUERYBASE, [Schema, Table, sColumns, sValues]);
end;

end.
