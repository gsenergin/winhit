{******************************************************************************}
{                                                                              }
{                               UNIT WMI.Root                                  }
{                                                                              }
{  Данный модуль является костылём для обхода проблемы с "circular reference". }
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

unit WMI.Root;

interface

uses
  Classes,
  WbemScripting_TLB;

type

  /// Класс-предок для TWMIRoot:
  TWMIComponent = class abstract (TComponent)
    strict private
      FOnDestroy : TNotifyEvent;
    public
      destructor Destroy; override;

      property OnDestroy : TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  /// Класс-предок для TWMIBase во избежание "circular reference":
  TWMIRoot = class abstract (TWMIComponent)
    strict protected
      function GetConnected : Boolean; virtual; abstract;
    protected
      FWMIService : ISWbemServices;
    public
      property Connected : Boolean read GetConnected;
      property WMIService : ISWbemServices read FWMIService;
  end;

implementation

//----------------------------{ TWMIComponent }---------------------------------

destructor TWMIComponent.Destroy;
begin
  If Assigned(FOnDestroy) Then FOnDestroy(Self);
  Inherited Destroy;
end;

end.
