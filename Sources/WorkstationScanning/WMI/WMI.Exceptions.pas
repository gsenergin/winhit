{******************************************************************************}
{                                                                              }
{                            UNIT WMI.Exceptions                               }
{                                                                              }
{  ������ ������ �������� ������ �������������� ��������, ����������� ���      }
{  ������ � WMI.                                                               }
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

unit WMI.Exceptions;

interface

uses
  SysUtils,
  WMI.Constants;

type

  /// Base exception:
  EWMIException = class (Exception);

  { WMIBase.pas }

  /// ���������� ���� "��� ��������� � ��������� ������ WMI":
  EAlreadyConnected = class (EWMIException)
    public
      constructor Create;
  end;

  /// ���������� ���� "�� ������� ������������ � ��������� ������ WMI":
  EConnectFailed = class (EWMIException)
    public
      constructor Create(const Host, NameSpace, User, Password : String);
  end;

  /// ���������� ���� "������������� WMI-����� �� ������":
  EClassNotFound = class (EWMIException)
    public
      constructor Create(const WMIClass : String);
  end;

  /// ���������� ���� "�������� ���������� ���� ����������� �����������":
  EParamIsReadOnlyWhileConnected = class (EWMIException)
    public
      constructor Create;
  end;

  { WQL.pas }

  /// ������� ���������� ��� ������ � WQL-���������:
  EWQLException = class (EWMIException);

  /// ���������� ���� "�� ������� ��������� WQL-������":
  EQueryFailed = class (EWQLException)
    public
      constructor Create(const Query : String);
  end;

implementation

//------------------------------------------------------------------------------

/// ��������������� ������� ��� ��������� ���������� �� ���������:
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
