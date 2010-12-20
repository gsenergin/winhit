{******************************************************************************}
{                                                                              }
{                            UNIT WMI.Exceptions                               }
{                                                                              }
{  Данный модуль содержит классы исключительных ситуаций, возникающих при      }
{  работе с WMI.                                                               }
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

unit WMI.Exceptions;

interface

uses
  SysUtils,
  WMI.Constants;

type

  /// Base exception:
  EWMIException = class (Exception);

  { WMIBase.pas }

  /// Исключение типа "уже подключён к указанной службе WMI":
  EAlreadyConnected = class (EWMIException)
    public
      constructor Create;
  end;

  /// Исключение типа "не удалось подключиться к указанной службе WMI":
  EConnectFailed = class (EWMIException)
    public
      constructor Create(const Host, NameSpace, User, Password : String);
  end;

  /// Исключение типа "запрашиваемый WMI-класс не найден":
  EClassNotFound = class (EWMIException)
    public
      constructor Create(const WMIClass : String);
  end;

  /// Исключение типа "параметр неизменяем пока установлено подключение":
  EParamIsReadOnlyWhileConnected = class (EWMIException)
    public
      constructor Create;
  end;

  { WQL.pas }

  /// Базовое исключение при работе с WQL-запросами:
  EWQLException = class (EWMIException);

  /// Исключение типа "не удалось выполнить WQL-запрос":
  EQueryFailed = class (EWQLException)
    public
      constructor Create(const Query : String);
  end;

implementation

//------------------------------------------------------------------------------

/// Вспомогательная функция для получения информации об эксепшене:
function GetExceptionInfo : String;
begin
  If (ExceptObject <> nil) Then
    With ExceptObject do
      Result := sLineBreak + ClassName + sLineBreak + ToString;
end;

//------------------------------------------------------------------------------

{$REGION 'WMIBase.pas'}

constructor EAlreadyConnected.Create;
begin
  Inherited CreateRes(@SAlreadyConnected);
end;

constructor EConnectFailed.Create(const Host, NameSpace, User, Password : String);
begin
  Inherited CreateResFmt(@SConnectFailed, [Host, NameSpace, User, Password,
                                           GetExceptionInfo]);
end;

constructor EClassNotFound.Create(const WMIClass : String);
begin
  Inherited CreateResFmt(@SClassNotFound, [WMIClass, GetExceptionInfo]);
end;

constructor EParamIsReadOnlyWhileConnected.Create;
begin
  Inherited CreateRes(@SParamIsReadOnlyWhileConnected);
end;

{$ENDREGION}

{$REGION 'WQL.pas'}

constructor EQueryFailed.Create(const Query : String);
begin
  Inherited CreateResFmt(@SQueryFailed, [Query, GetExceptionInfo]);
end;

{$ENDREGION}

end.
