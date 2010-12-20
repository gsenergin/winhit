{******************************************************************************}
{                                                                              }
{                               UNIT WMI.Base                                  }
{                                                                              }
{  Данный модуль содержит базовые классы для работы с WMI.                     }
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

unit WMI.Base;

interface

uses
  Classes, SysUtils,
  WbemScripting_TLB,
  WMI.Root, WMI.WQL, WMI.Exceptions, WMI.Constants;

type

  /// Базовый класс для работы с WMI:
  TWMIBase = class abstract (TWMIRoot)
    strict private
      { Fields }
      FHost, FNameSpace, FUser, FPassword : String;
      FWMILocator : TSWbemLocator;
      { Events }
      FOnConnected : TNotifyEvent;
      FOnDisconnected : TNotifyEvent;
    strict protected
      function  GetConnected : Boolean; override;
      procedure SetHost(Value : String);
      procedure SetNameSpace(Value : String);
      procedure SetUser(Value : String);
      procedure SetPassword(Value : String);
    protected
      function  GetWMIClass(const WMIClassName : String) : ISWbemObject;
      function  GetWMIObjectSet(const WMIClassName : String) : ISWbemObjectSet;
    public
      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure Connect;
      procedure Disconnect;

      { Properties }
      property Host : String read FHost write SetHost;
      property NameSpace : String read FNameSpace write SetNameSpace;
      property User : String read FUser write SetUser;
      property Password : String read FPassword write SetPassword;
      { Events }
      property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
      property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
  end;

implementation

//------------------------------{ TWMIBase }------------------------------------

constructor TWMIBase.Create;
begin
  Inherited Create(nil);
  FWMILocator := TSWbemLocator.Create(Self);
  FHost      := STR_WMI_DEFAULT_HOST;
  FNameSpace := STR_WMI_DEFAULT_NAMESPACE;
  FUser      := STR_WMI_DEFAULT_USER;
  FPassword  := STR_WMI_DEFAULT_PASSWORD;
end;

destructor TWMIBase.Destroy;
begin
  Disconnect;
  FreeAndNil(FWMILocator);
  Inherited Destroy;
end;

/// Подключение к службе WMI на целевой машине:
procedure TWMIBase.Connect;
begin
  If Connected Then raise EAlreadyConnected.Create;
  Try
    FWMIService := FWMILocator.ConnectServer(FHost, FNameSpace, FUser, FPassword,
                                             '', '', wbemConnectFlagUseMaxWait, nil);
  Except
    on E:Exception do
      raise EConnectFailed.Create(FHost, FNameSpace, FUser, FPassword);
  End;
  If Assigned(FOnConnected) Then FOnConnected(Self);
end;

/// Отключение от службы WMI на целевой машине:
procedure TWMIBase.Disconnect;
begin
  If Connected Then
  begin
    FWMIService := nil;
    FWMILocator.Disconnect;
    If Assigned(FOnDisconnected) Then FOnDisconnected(Self);
  end;
end;

/// Connected property getter:
function TWMIBase.GetConnected : Boolean;
begin
  Result := Assigned(FWMIService);
end;

/// Получение WMI-класса:
function TWMIBase.GetWMIClass(const WMIClassName : String) : ISWbemObject;
begin
  If Connected Then
    Try
      Result := FWMIService.Get(WMIClassName, wbemFlagUseAmendedQualifiers, nil);
    Except
      on E:Exception do
        raise EClassNotFound.Create(WMIClassName);
    End;
end;

/// Получение набора объектов определённого WMI-класса:
function TWMIBase.GetWMIObjectSet(const WMIClassName : String) : ISWbemObjectSet;
begin
  If Connected Then Result := GetWMIClass(WMIClassName).Instances_(0, nil);
end;

/// Host property setter:
procedure TWMIBase.SetHost(Value : String);
begin
  If Not Connected Then FHost := Value
  Else
    raise EParamIsReadOnlyWhileConnected.Create;
end;

/// NameSpace property setter:
procedure TWMIBase.SetNameSpace(Value : String);
begin
  If Not Connected Then FNameSpace := Value
  Else
    raise EParamIsReadOnlyWhileConnected.Create;
end;

/// User property setter:
procedure TWMIBase.SetUser(Value : String);
begin
  If Not Connected Then FUser := Value
  Else
    raise EParamIsReadOnlyWhileConnected.Create;
end;

/// Password property setter:
procedure TWMIBase.SetPassword(Value : String);
begin
  If Not Connected Then FPassword := Value
  Else
    raise EParamIsReadOnlyWhileConnected.Create;
end;

end.
