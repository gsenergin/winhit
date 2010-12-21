unit MySQLHelpers;

interface

uses
  SysUtils, RTTI, TypInfo;

  function MySQLDataType(const Source : TRTTIMember;
                         const Instance : Pointer) : String;

implementation

/// <summary>
///  Функция для определения MySQL'ных аналогов типов данных из Delphi.
/// </summary>
/// <param name="TypeKind">
///  Тип данных для конвертирования.
/// </param>
function MySQLDataType(const Source : TRTTIMember;
                       const Instance : Pointer) : String;
  var
    Fld  : TRTTIField;
    Prop : TRTTIProperty;
    DataType : TRTTIType;
    Value : TValue;
    vTmp : Variant;

  function UniversalType(const DataType : TRTTIType;
                         const DataSize : Integer = 0) : String;
  begin
    Assert(Assigned(DataType));
    If DataSize = 0 Then
      Result := 'VARBINARY(' + IntToStr(DataType.TypeSize) + ')'
    Else
      Result := Format('VARBINARY(%d)', [DataSize]);
  end;

begin
  Result := '';
  Fld  := nil;
  Prop := nil;
  Assert((Source is TRTTIField) Or (Source is TRTTIProperty));

  If Source is TRTTIField    Then Fld  := (Source as TRTTIField);
  If Source is TRTTIProperty Then Prop := (Source as TRTTIProperty);

  If Assigned(Fld)  Then DataType := Fld.FieldType;
  If Assigned(Prop) Then DataType := Prop.PropertyType;

  // Unused: tkClass, tkMethod, tkInterface, tkClassRef, tkProcedure
  Case DataType.TypeKind of
    tkFloat:                         Result := 'DOUBLE';

    tkInteger:                       Result := 'INT';
    tkPointer:                       Result := 'UNSIGNED INT';
    tkInt64:                         Result := 'BIGINT';

    tkChar, tkWChar:                 Result := 'CHAR(1)';
    tkString:                        Result := 'VARCHAR(255)';
    tkLString, tkWString, tkUString: Result := 'LONGTEXT';

    tkEnumeration, tkSet:            Result := 'VARBINARY(255)';
    tkArray, tkDynArray:             Result := 'LONGBLOB';

    tkRecord:
      begin
        If DataType.IsManaged Then   Result := 'LONGBLOB'
                              Else   Result := UniversalType(DataType);
      end;

    tkVariant, tkUnknown:
      begin
        If Assigned(Fld)  Then Value := Fld.GetValue(Instance);
        If Assigned(Prop) Then Value := Prop.GetValue(Instance);
        vTmp := Value.AsVariant;

        Case TVarData(vTmp).VType of
          varEmpty, varNull: Result := UniversalType(DataType, Value.DataSize);
          varBoolean:        Result := 'BOOLEAN';
          varShortInt:       Result := 'TINYINT';
          varSmallint:       Result := 'SMALLINT';
          varInteger:        Result := 'INT';
          varSingle:         Result := 'FLOAT';
          varDouble:         Result := 'DOUBLE';
          varCurrency:       Result := 'DOUBLE';
          varDate:           Result := 'DOUBLE';
          varOleStr:         Result := 'LONGTEXT';
          varDispatch:       Result := UniversalType(DataType, Value.DataSize);
          varError:          Result := 'INT';
          varUnknown:        Result := UniversalType(DataType, Value.DataSize);
          varByte:           Result := 'UNSIGNED TINYINT';
          varWord:           Result := 'UNSIGNED SMALLINT';
          varLongWord:       Result := 'UNSIGNED INT';
          varInt64:          Result := 'BIGINT';
          varUInt64:         Result := 'UNSIGNED BIGINT';
          varString:         Result := 'LONGTEXT';
          varUString:        Result := 'LONGTEXT';
        End;
      end;
  End;
end;

end.
