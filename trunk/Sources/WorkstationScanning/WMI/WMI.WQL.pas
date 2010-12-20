{******************************************************************************}
{                                                                              }
{                                UNIT WMI.WQL                                  }
{                                                                              }
{  В данном модуле реализована работа с запросами на языке WQL.                }
{                                                                              }
{                       Copyright © 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ИСТОРИЯ ВЕРСИЙ / VERSION HISTORY:

  (1.0 | XX.XX.2010)
    Первый релиз модуля.
    First unit release.

}

unit WMI.WQL;

interface

uses
  Classes, SysUtils, RTTI,
  WbemScripting_TLB, SysUtilsEx,
  WMI.Root, WMI.Containers, WMI.Exceptions, WMI.Constants;

type

  /// Класс для построения WQL-запросов:
  TWQLQueryBuilder = class sealed
    strict private
      { Fields }
      FOwner : TWMIRoot;
      { Events }
      procedure OnOwnerDestroy(Sender : TObject);
    public
      constructor Create(const Owner : TWMIRoot);

      function ExecQuery(const Query : String) : ISWbemObjectSet;
      function Select(const WMIClassName : String;
                      const Properties : TStringList) : ISWbemObjectSet;
  end;

implementation

//---------------------------{ TWQLQueryBuilder }-------------------------------

constructor TWQLQueryBuilder.Create(const Owner : TWMIRoot);
begin
  Inherited Create;
  Assert(Assigned(Owner));
  FOwner := Owner;
end;

/// Выполнение WQL-запроса:
function TWQLQueryBuilder.ExecQuery(const Query : String) : ISWbemObjectSet;
begin
  With FOwner do
  begin
    If Connected Then
    begin
      Try
        { TODO : нужен ли флаг wbemFlagReturnImmediately? все ли данные придут при нём? }
        Result := WMIService.ExecQuery(Query, STR_WMI_QUERYLANG,
                                       wbemFlagForwardOnly Or
                                       wbemFlagReturnImmediately Or
                                       wbemFlagUseAmendedQualifiers, nil);
      Except
        on E:Exception do
          raise EQueryFailed.Create(Query);
      End;
    end;
  end;
end;

/// Объект не может существовать без владельца, поскольку использует его:
procedure TWQLQueryBuilder.OnOwnerDestroy(Sender : TObject);
begin
  Self.Free;
end;

/// Выборка указанных свойств всех экземпляров указанного WMI-класса:
function TWQLQueryBuilder.Select(const WMIClassName : String;
                                 const Properties : TStringList) : ISWbemObjectSet;
  var
    sProp, sQueriedProps : String;
begin
  Assert(Assigned(Properties));

  For sProp in Properties do
    sQueriedProps := AddToken(sQueriedProps, sProp, CHR_WQL_PROPS_SEPARATOR);

  Result := ExecQuery('SELECT ' + sQueriedProps + ' FROM ' + WMIClassName);
end;

end.
