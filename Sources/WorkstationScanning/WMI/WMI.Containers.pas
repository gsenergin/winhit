{******************************************************************************}
{                                                                              }
{                            UNIT WMI.Containers                               }
{                                                                              }
{  В данном модуле реализованы контейнеры для хранения данных WMI-классов.     }
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

unit WMI.Containers;

interface

uses
  SysUtils, Generics.Collections;

type

  /// Единичное свойство WMI-класса:
  TWMIProperty = record
    Name : String;
    Value : Variant;
    UseInQuery : Boolean; // Запрашивать это свойство в WQL SELECT запросе?
  end;

  /// Единичный WMI-класс:
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
