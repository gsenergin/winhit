unit MySQLHelpers;

interface

uses
  SysUtils, TypInfo;

  function MySQLDataType(const TypeKind : TTypeKind) : String;

implementation

/// <summary>
///  Функция для определения MySQL'ных аналогов типов данных из Delphi.
/// </summary>
/// <param name="TypeKind">
///  Тип данных для конвертирования.
/// </param>
function MySQLDataType(const TypeKind : TTypeKind) : String;
begin
  // Not included: tkClass, tkMethod, tkInterface, tkClassRef, tkProcedure
  // tkEnumeration & tkSet - couldn't convert to ENUM() & SET()
  Case TypeKind of
    tkInteger: Result := 'INT';
    tkInt64, tkPointer: Result := 'BIGINT';

    tkChar, tkWChar: Result := 'CHAR';
    tkString: Result := 'VARCHAR(255)';
    tkLString, tkWString, tkUString: Result := 'LONGTEXT';

    tkFloat: Result := 'FLOAT';

    tkDynArray: Result := 'LONGBINARY';

    tkEnumeration, tkSet, tkArray, tkRecord, tkVariant, tkUnknown:
      Result := 'BINARY';

{ TODO : tkVariant расширить в отдельный кейс с использованием varSingle и т.д. }
  End;
end;

end.
