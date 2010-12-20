unit MySQLHelpers;

interface

uses
  SysUtils, TypInfo;

  function MySQLDataType(const TypeKind : TTypeKind) : String;

implementation

/// <summary>
///  ������� ��� ����������� MySQL'��� �������� ����� ������ �� Delphi.
/// </summary>
/// <param name="TypeKind">
///  ��� ������ ��� ���������������.
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

{ TODO : tkVariant ��������� � ��������� ���� � �������������� varSingle � �.�. }
  End;
end;

end.
