{******************************************************************************}
{                                                                              }
{                               UNIT WMI.Root                                  }
{                                                                              }
{  ������ ������ �������� ������� ��� ������ �������� � "circular reference". }
{                                                                              }
{                       Copyright � 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ������� ������ / VERSION HISTORY:

  (1.0 | XX.XX.2010)
    ������ ����� ������.
    First unit release.

}

unit WMI.Root;

interface

uses
  Classes,
  WbemScripting_TLB;

type

  /// �����-������ ��� TWMIRoot:
  TWMIComponent = class abstract (TComponent)
    strict private
      FOnDestroy : TNotifyEvent;
    public
      destructor Destroy; override;

      property OnDestroy : TNotifyEvent read FOnDestroy write FOnDestroy;
  end;

  /// �����-������ ��� TWMIBase �� ��������� "circular reference":
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
