unit WMIDataCollector;

interface

uses
  Windows, Classes, SysUtils, CWMIBase, OtlEventMonitor, OtlTaskControl, OtlTask,
  SyncObjs;

  procedure CollectWMIData(const TargetHost : String; const DM : TDataModule);

implementation

procedure CollectWMIData(const TargetHost : String; const DM : TDataModule);
  var
    Cmp : TComponent;
    EventMon : TOmniEventMonitor;
    iThreads : Integer;
    Event : TSimpleEvent;

  procedure HandleTaskTerminated(const task: IOmniTaskControl);
  begin
    Dec(iThreads);
    If (iThreads <= 0) Then Event.SetEvent;
  end;

begin
  EventMon := TOmniEventMonitor.Create(DM);
  EventMon.OnTaskTerminated := HandleTaskTerminated;
  Event := TSimpleEvent.Create;
  iThreads := 0;

  Try
    For Cmp in DM do
    begin
      If Cmp is TWMIBase Then
      begin
        With (Cmp as TWMIBase) do
        begin
          Host := Host;

          // Collect data in separate thread:
          EventMon.Monitor(
            CreateTask(
              procedure (const task: IOmniTask)
              begin
                Active := False;  // Это очистит от старых данных
                Active := True;
                Inc(iThreads);
              end)).Run;

          // Это должно гарантировать, что процедура дождётся
          // окончания последнего запущенного потока:
          Event.ResetEvent;
        end;
      end;
    end;

    WaitForSingleObject(Event.Handle, INFINITE);

  Finally
    FreeAndNil(EventMon);
    FreeAndNil(Event);
  End;
end;

end.
