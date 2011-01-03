unit MySQLHelpers;

interface

uses
  Windows, SysUtils, RTTI, TypInfo, Spring.DesignPatterns, Generics.Collections,
  StrUtils, SysUtilsEx;

type

  /// <summary>
  ///  Структура для работы с FK в базе данных.
  /// </summary>
  /// <comments>
  ///  Хранит информацию о том, какая колонка данной таблицы ссылается
  ///  на какую колонку какой таблицы какой схемы.
  /// </comments>
  TForeignKeyInfo = record
    ColumnName : String;
    ReferencesSchema, ReferencesTable, ReferencesColumn : String;
  end;

  /// <summary>
  ///  Словарь для хранения FK-связей конкретной таблицы.
  ///  В качестве Values (значений) возвращаются списки записей типа TForeignKeyInfo.
  /// </summary>
  /// <remarks>
  ///  Наследник дженерика-словаря для использования в качестве синглтона.
  ///  Сделано так, потому что синглтону требуется конструктор без параметров.
  /// </remarks>
  TForeignKeyDict = class (TDictionary<String, TList<TForeignKeyInfo>>)
    public
      constructor Create;
  end;

  /// <summary>
  ///  Словарь соответсвий таблиц и их схем.
  /// </summary>
  /// <remarks>
  ///  Наследник дженерика-словаря для использования в качестве синглтона.
  ///  Сделано так, потому что синглтону требуется конструктор без параметров.
  /// </remarks>
  TTableDict = class (TDictionary<String, String>)
    public
      constructor Create;
  end;

  { Standalone methods }

  procedure FillFKInfo(const CreateTableQuery : String;
                       const FKInfoList : TList<TForeignKeyInfo>);
  function  FKDictionary : TForeignKeyDict;
  function  MySQLDataType(const Source : TRTTIMember;
                          const Instance : Pointer) : String;
  function  TablesDictionary : TTableDict;

implementation

/// <summary>
///  Процедура, парсящая SQL-запрос CREATE TABLE на предмет FK constraint'ов.
///  Обнаруженная информация возвращается в параметре FKInfoList.
/// </summary>
/// <param name="CreateTableQuery">
///  SQL-запрос CREATE TABLE.
/// </param>
/// <param name="FKInfoList">
///  Дженерик-список записей, хранящих информацию об FK-связи.
/// </param>
procedure FillFKInfo(const CreateTableQuery : String;
                     const FKInfoList : TList<TForeignKeyInfo>);
  var
    S : String;
    FKInfo : TForeignKeyInfo;
begin
  Assert(Assigned(FKInfoList));

  ZeroMemory(@FKInfo, SizeOf(TForeignKeyInfo));  // на всякий пожарный
  S := CreateTableQuery;

  If AnsiContainsText(S, 'CREATE TABLE') Then
    While AnsiContainsText(S, 'FOREIGN KEY') do
    begin
      // Удалить всё включительно до буквы F в подстроке FOREIGN KEY,
      // что сделает не выполняющимся условие цикла.
      S := DeleteEx(S, 1, AnsiPosEx('FOREIGN KEY', S));

      With FKInfo do
      begin
        ColumnName := GetToken(S, 2, '`'); { TODO : dangerous }

        S := DeleteEx(S, 1, AnsiPosEx('REFERENCES', S));

        ReferencesSchema := GetToken(S, 2, '`');  { TODO : dangerous }
        ReferencesTable  := GetToken(S, 4, '`');  { TODO : dangerous }
        ReferencesColumn := GetToken(S, 6, '`');  { TODO : dangerous }
      end;

      FKInfoList.Add(FKInfo);
    end;
end;

/// <summary>
///  Функция, возвращающая словарь для хранения FK-связей таблицы.
/// </summary>
/// <returns>
///  Возвращает словарь в виде синглтона.
/// </returns>
function FKDictionary : TForeignKeyDict;
begin
  Result := TSingleton.GetInstance<TForeignKeyDict>;
end;

/// <summary>
///  Функция, возвращающая словарь соответствия таблиц и схем (БД).
/// </summary>
/// <returns>
///  Возвращает словарь в виде синглтона.
/// </returns>
function TablesDictionary : TTableDict;
begin
  Result := TSingleton.GetInstance<TTableDict>;
end;

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
  DataType := nil;
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

//------------------------------------------------------------------------------

{ TTableDict }

constructor TTableDict.Create;
begin
  Inherited Create;
end;

{ TForeignKeyDict }

constructor TForeignKeyDict.Create;
begin
  Inherited Create;
end;

end.
