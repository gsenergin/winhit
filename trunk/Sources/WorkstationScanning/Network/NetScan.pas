unit NetScan;

interface

uses
  Windows, Classes, SysUtils, Forms, ComCtrls, WinSock;

type

  TScanThread = class(TThread)
    private
      TreeNetWrk : TTreeNode;
      TreeDomain : TTreeNode;
      TreeServer : TTreeNode;
      TreeShares : TTreeNode;
      Param_dwType : Byte;
      Param_dwDisplayType : Byte;
      Param_lpRemoteName : String;
      Param_lpIP : String;
    protected
      procedure Execute; override;
      procedure Scan(Res : TNetResource; Root : boolean);
      procedure AddElement;
      procedure Stop;
  end;

implementation

uses Main;

function GetIPAddress(NetworkName : String) : String;
var
  Error : DWORD;
  HostEntry : PHostEnt;
  Data : WSAData;
  Address : In_Addr;
begin
  Delete(NetworkName, 1, 2);
  Error := WSAStartup(MakeWord(1, 1), Data);
  if Error = 0 then
  begin
    HostEntry := gethostbyname(PAnsiChar(AnsiString(NetworkName)));
    Error := GetLastError;
    if Error = 0 then
    begin
      Address := PInAddr(HostEntry^.h_addr_list^)^;
      Result := String(AnsiString(inet_ntoa(Address)));
    end
    else
      Result := 'Unknown';
  end
  else
    Result := 'Error';
  WSACleanup;
end;

{ TScanThread }

procedure TScanThread.Execute;
  var
    R : TNetResource;
begin
  Priority := tpHigher;
  FreeOnTerminate := True;
  Suspended := False;
  Scan(R, True);
  TreeDomain := nil;
  TreeServer := nil;
  Synchronize(Stop);
end;

procedure TScanThread.Scan(Res : TNetResource; Root : boolean);
var
  hEnum : Cardinal;
  nrResource : array [0 .. 512] of TNetResource;
  dwSize : DWORD;
  numEntries : DWORD;
  I : DWORD;
  dwResult : DWORD;
begin
  if Root then
    dwResult := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0,
      nil, hEnum)
  else
    dwResult := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0,
      @Res, hEnum);
  if dwResult = NO_ERROR then
  begin
    dwSize := SizeOf(nrResource);
    numEntries := DWORD( - 1); // ERROR_NO_MORE_ITEMS
    if WNetEnumResource(hEnum, numEntries, @nrResource, dwSize) = NO_ERROR then
    begin
      for I := 0 to numEntries - 1 do
      begin
        if Terminated then
          Break;
        with nrResource[I] do
        begin
          Param_dwType := dwType;
          Param_dwDisplayType := dwDisplayType;
          Param_lpRemoteName := lpRemoteName;
          if Param_dwDisplayType = RESOURCEDISPLAYTYPE_SERVER then
            Param_lpIP := GetIPAddress(Param_lpRemoteName);
        end;
        if Assigned(nrResource[I].lpRemoteName) then
          Synchronize(AddElement);
        Scan(nrResource[I], false);
      end;
      WNetCloseEnum(hEnum);
    end;
  end;
end;

procedure TScanThread.AddElement;
begin
  Application.ProcessMessages;
  case Param_dwDisplayType of
    RESOURCEDISPLAYTYPE_NETWORK :
      begin
        TreeNetWrk := frmMain.jvtrvWorkgroups.Items.Add(nil, Param_lpRemoteName);
        TreeNetWrk.StateIndex := 1;
      end;
    RESOURCEDISPLAYTYPE_DOMAIN :
      begin
        TreeDomain := frmMain.jvtrvWorkgroups.Items.AddChild(TreeNetWrk,
          Param_lpRemoteName);
        TreeDomain.StateIndex := 2;
      end;
    RESOURCEDISPLAYTYPE_SERVER :
      begin
        TreeServer := frmMain.jvtrvWorkgroups.Items.AddChild(TreeDomain,
          Param_lpRemoteName + ' IP: ' + Param_lpIP);
        TreeServer.StateIndex := 3;

        With frmMain.lvWorkstations.Items.Add do
        begin
          Caption := Param_lpRemoteName;
          Subitems.Add(TreeDomain.Text);
          Subitems.Add(Param_lpIP);
        end;
      end;
    RESOURCEDISPLAYTYPE_SHARE :
      begin
        TreeShares := frmMain.jvtrvWorkgroups.Items.AddChild(TreeServer,
          Param_lpRemoteName);
        TreeShares.StateIndex := 3 + Param_dwType;
      end;
  end;
end;

procedure TScanThread.Stop;
begin
  //
end;

end.
