unit WMIDataCollector;

{$I 'GlobalDefines.inc'}
{$I 'SharedUnitDirectives.inc'}

interface

uses
  Windows, Classes, SysUtils, CWMIBase, OtlEventMonitor, OtlTaskControl, OtlTask,
  SyncObjs, OtlThreadPool;

  procedure CollectWMIData(const TargetHost : String; const DM : TDataModule);

implementation

type

  TEventMonitor = class (TOmniEventMonitor)
    private
      FThreadPool : IOmniThreadPool;
      FEvent : TSimpleEvent;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;

      procedure HandleTaskTerminated(const task: IOmniTaskControl);

      property ThreadPool : IOmniThreadPool read FThreadPool;
      property Event : TSimpleEvent read FEvent;
  end;

{ TEventMonHelper }

constructor TEventMonitor.Create(AOwner: TComponent);
begin
  Inherited;
  FEvent := TSimpleEvent.Create;

  Randomize;
  FThreadPool := CreateThreadPool(IntToStr(Random(High(Integer)))).MonitorWith(Self);

  OnTaskTerminated := HandleTaskTerminated;
end;

destructor TEventMonitor.Destroy;
begin
  FThreadPool.CancelAll;
  FThreadPool := nil;
  FreeAndNil(FEvent);
  Inherited;
end;

procedure TEventMonitor.HandleTaskTerminated(const task: IOmniTaskControl);
begin
  If (FThreadPool.CountQueued = 0) And (FThreadPool.CountExecuting = 0) Then
    FEvent.SetEvent;
end;

//------------------------------------------------------------------------------

procedure CollectWMIData(const TargetHost : String; const DM : TDataModule);
  var
    Cmp : TComponent;
    EventMon : TEventMonitor;
begin
  EventMon := TEventMonitor.Create(DM);

  Try
    For Cmp in DM do
    begin
      If Cmp is TWMIBase Then
      begin
        With (Cmp as TWMIBase) do
        begin
          Host := Host;

          // Collect data in separate thread:
          CreateTask(
            procedure (const task: IOmniTask)
            begin
              Active := False;  // Это очистит компоненты от старых данных
              Active := True;
            end){.Unobserved}.Schedule(EventMon.ThreadPool);

          // Это должно гарантировать, что процедура дождётся
          // окончания последнего запущенного потока:
          EventMon.Event.ResetEvent;
        end;
      end;
    end;

    WaitForSingleObject(EventMon.Event.Handle, INFINITE);

  Finally
    FreeAndNil(EventMon);
  End;
end;

end.
