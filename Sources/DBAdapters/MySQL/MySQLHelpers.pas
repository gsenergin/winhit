unit MySQLHelpers;

interface

uses
  SysUtils, RTTI, TypInfo;

  function MySQLDataType(const Value : TValue) : String;

implementation

/// <summary>
///  Функция для определения MySQL'ных аналогов типов данных из Delphi.
/// </summary>
/// <param name="Value">
///  RTTI-значение, по которому будет определяться тип данных.
/// </param>
function MySQLDataType(const Value : TValue) : String;
begin
  // Not included: tkClass, tkMethod, tkInterface, tkClassRef, tkProcedure
  // tkEnumeration & tkSet - couldn't convert to ENUM() & SET()
  Case Value.Kind of
    tkInteger: Result := 'INT';
    tkInt64, tkPointer: Result := 'BIGINT';

    tkChar, tkWChar: Result := 'CHAR';
    tkString: Result := 'VARCHAR(255)';
    tkLString, tkWString, tkUString: Result := 'LONGTEXT';

    tkFloat: Result := 'FLOAT';

    tkDynArray:
      Result := 'VARBINARY(' + IntToStr(Value.DataSize
                             + Value.TypeData.ArrayData.Size) + ')';

    tkEnumeration, tkSet, tkArray, tkRecord, tkVariant, tkUnknown:
      Result := 'VARBINARY(' + IntToStr(Value.DataSize) + ')';

{ TODO : tkVariant расширить в отдельный кейс с использованием varSingle и т.д. }
  End;
end;

end.
