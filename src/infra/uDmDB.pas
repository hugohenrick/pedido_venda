unit uDmDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  System.IniFiles, Vcl.Dialogs, FireDAC.Phys.ODBCBase, Winapi.Windows,
  System.StrUtils;

type
  TDmDB = class(TDataModule)
    FConn: TFDConnection;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FConfigFile: string;
    procedure ConfigureConnection;
    function GetConfigPath: string;
  public
    function TestConnection: Boolean;
    procedure ReconnectIfNeeded;
  end;

var
  DmDB: TDmDB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDmDB }

procedure TDmDB.DataModuleCreate(Sender: TObject);
begin
  FConfigFile := GetConfigPath;
  ConfigureConnection;
end;

procedure TDmDB.DataModuleDestroy(Sender: TObject);
begin
  if FConn.Connected then
    FConn.Close;
end;

function TDmDB.GetConfigPath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'config.ini';
end;

procedure TDmDB.ConfigureConnection;
var
  IniFile: TIniFile;
  LibPath: string;
begin
  if not FileExists(FConfigFile) then
    Exit;

  IniFile := TIniFile.Create(FConfigFile);
  try
    LibPath := IniFile.ReadString('DATABASE', 'LibraryPath', '');
    if (LibPath <> '') and Assigned(FDPhysMySQLDriverLink) then
    begin
      FDPhysMySQLDriverLink.VendorLib := LibPath;
    end;

    FConn.Params.Values['Server'] := IniFile.ReadString('DATABASE', 'Server', 'localhost');
    FConn.Params.Values['Port'] := IniFile.ReadString('DATABASE', 'Port', '3306');
    FConn.Params.Values['Database'] := IniFile.ReadString('DATABASE', 'Database', 'pedidos');
    FConn.Params.Values['User_Name'] := IniFile.ReadString('DATABASE', 'Username', 'root');
    FConn.Params.Values['Password'] := IniFile.ReadString('DATABASE', 'Password', '');
    FConn.Params.Values['CharacterSet'] := 'utf8mb4';
    FConn.Params.Values['Pooled'] := 'False';

    FConn.DriverName := 'MySQL';
    FConn.Params.Values['DriverID'] := 'MySQL';
    FConn.LoginPrompt := False;
  finally
    IniFile.Free;
  end;
end;


function TDmDB.TestConnection: Boolean;
begin
  try
    if not FConn.Connected then
      FConn.Open;
    Result := FConn.Connected;
  except
    on E: Exception do
    begin
      ShowMessage('Teste de conexão falhou: ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TDmDB.ReconnectIfNeeded;
begin
  if not FConn.Connected then
  begin
    try
      FConn.Open;
    except
      on E: Exception do
        ShowMessage('Erro ao reconectar: ' + E.Message);
    end;
  end;
end;

end.
