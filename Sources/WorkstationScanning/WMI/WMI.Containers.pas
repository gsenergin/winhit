{******************************************************************************}
{                                                                              }
{                            UNIT WMI.Containers                               }
{                                                                              }
{  � ������ ������ ����������� ���������� ��� �������� ������ WMI-�������.     }
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

unit WMI.Containers;

interface

uses
  SysUtils, Generics.Collections;

type

  /// ��������� �������� WMI-������:
  TWMIProperty = record
    Name : String;
    Value : Variant;
    UseInQuery : Boolean; // ����������� ��� �������� � WQL SELECT �������?
  end;

  /// ��������� WMI-�����:
  TWMIClass = class
    strict private
      FProperties : TList<TWMIProperty>;
    public
      constructor Create;
      destructor Destroy; override;

      property Properties : TList<TWMIProperty> read FProperties;
  end;

implementation

//------------------------------{ TWMIClass }-----------------------------------

constructor TWMIClass.Create;
begin
  Inherited Create;
  FProperties := TList<TWMIProperty>.Create;
end;

destructor TWMIClass.Destroy;
begin
  FreeAndNil(FProperties);
  Inherited Destroy;
end;

end.
