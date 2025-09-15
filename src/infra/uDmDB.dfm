object DmDB: TDmDB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object FConn: TFDConnection
    Params.Strings = (
      'CharacterSet=utf8mb4'
      'Database=pedidos'
      'User_Name=root'
      'Password=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 32
    Top = 16
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Program Files\MySQL\MySQL Server 8.0\lib\libmysql.dll'
    Left = 120
    Top = 16
  end
end
