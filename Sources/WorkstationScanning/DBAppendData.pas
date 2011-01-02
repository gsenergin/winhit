unit DBAppendData;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Classes, SysUtils, JvDBComponents, WMIHardware, WMISoftware, CWMIBase,
  RTTI, TypInfo, StrUtils, Generics.Collections, MySQLAdapter;

  procedure AppendHardwareData;
  procedure AppendSoftwareData;

implementation

procedure FillWMIPropValues(const WMIComponent: TWMIBase;
                            const WMIPropValues: TList<TValue>);
  var
    Context, Context2 : TRTTIContext;
    Prop, Prop2 : TRTTIProperty;
    Val : TValue;
    S : String;
begin
  Assert(Assigned(WMIComponent));
  Assert(Assigned(WMIPropValues));

  WMIPropValues.Clear;

  For Prop in Context.GetType(WMIComponent.ClassType).GetProperties do
  begin
    If (Not Prop.IsReadable) Or (Prop.Visibility <> mvPublished) Then Continue;

    Val := Prop.GetValue(WMIComponent);
    If Val.Kind = tkClass Then
    begin
      If AnsiContainsText(Val.AsObject.ClassName, 'properties') Then
      begin

        For Prop2 in Context2.GetType(Val.AsObject.ClassType).GetDeclaredProperties do
        begin
          If Prop2.IsReadable And (Prop2.Visibility = mvPublished) Then
          begin
            Try
              // if too much exceptions try to use Prop2.PropertyType in condition above
              WMIPropValues.Add(Prop2.GetValue(Val.AsObject));
            Except
              Continue;
            End;
          end;
        end;

      end;
    end;
  end;
end;

procedure AppendHardwareData;
  var
    Cmp : TComponent;
    PropVals : TList<TValue>;
    Columns : TStringList;
begin
  PropVals := TList<TValue>.Create;
  Columns := TStringList.Create;

  For Cmp in dtmdlWMIHardware do
  begin
    If Cmp is TWMIBase Then
    begin
      FillWMIPropValues(TWMIBase(Cmp), PropVals);
      dtmdlJvDBComponents.ZConnection.GetColumnNames(TWMIBase(Cmp).Name, '%', Columns);

      dtmdlJvDBComponents.ZConnection.ExecuteDirect(
        InsertQuery(TablesDictionary.Items[TWMIBase(Cmp).Name],
                    TWMIBase(Cmp).Name, Columns, PropVals));

        { TODO : необходимо учитывать FK колонки }
    end;
  end;

  FreeAndNil(PropVals);
  FreeAndNil(Columns);
end;

procedure AppendSoftwareData;
  var
    Cmp : TComponent;
    PropVals : TList<TValue>;
    Columns : TStringList;
begin
  PropVals := TList<TValue>.Create;
  Columns := TStringList.Create;

  For Cmp in dtmdlWMISoftware do
  begin
    If Cmp is TWMIBase Then
    begin
      FillWMIPropValues(TWMIBase(Cmp), PropVals);
      dtmdlJvDBComponents.ZConnection.GetColumnNames(TWMIBase(Cmp).Name, '%', Columns);

      dtmdlJvDBComponents.ZConnection.ExecuteDirect(
        InsertQuery(TablesDictionary.Items[TWMIBase(Cmp).Name],
                    TWMIBase(Cmp).Name, Columns, PropVals));
    end;
  end;

  FreeAndNil(PropVals);
  FreeAndNil(Columns);
end;

end.
