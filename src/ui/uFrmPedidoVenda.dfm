object FormPedidoVenda: TFormPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedidos'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 120
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    object gbCliente: TGroupBox
      Left = 8
      Top = 8
      Width = 884
      Height = 104
      Caption = ' Dados do Cliente '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object edtNumeroPedido: TLabeledEdit
        Left = 16
        Top = 32
        Width = 121
        Height = 21
        EditLabel.Width = 76
        EditLabel.Height = 13
        EditLabel.Caption = 'N'#250'mero Pedido:'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = '0'
      end
      object edtCodigoCliente: TLabeledEdit
        Left = 152
        Top = 32
        Width = 80
        Height = 21
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = 'C'#243'digo Cliente: *'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnExit = edtCodigoClienteExit
        OnKeyPress = edtCodigoClienteKeyPress
      end
      object edtNomeCliente: TLabeledEdit
        Left = 248
        Top = 32
        Width = 300
        Height = 21
        Color = clBtnFace
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'Nome Cliente:'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object edtCidade: TLabeledEdit
        Left = 152
        Top = 72
        Width = 280
        Height = 21
        Color = clBtnFace
        EditLabel.Width = 37
        EditLabel.Height = 13
        EditLabel.Caption = 'Cidade:'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object edtUF: TLabeledEdit
        Left = 448
        Top = 72
        Width = 100
        Height = 21
        Color = clBtnFace
        EditLabel.Width = 17
        EditLabel.Height = 13
        EditLabel.Caption = 'UF:'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = [fsBold]
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
    end
  end
  object pnlProduct: TPanel
    Left = 0
    Top = 120
    Width = 900
    Height = 80
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 1
    object gbProduto: TGroupBox
      Left = 8
      Top = 8
      Width = 884
      Height = 64
      Caption = ' Entrada de Produtos '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object edtCodigoProduto: TLabeledEdit
        Left = 16
        Top = 32
        Width = 80
        Height = 21
        EditLabel.Width = 87
        EditLabel.Height = 13
        EditLabel.Caption = 'C'#243'digo Produto: *'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnExit = edtCodigoProdutoExit
        OnKeyPress = edtCodigoProdutoKeyPress
      end
      object edtDescricaoProduto: TLabeledEdit
        Left = 112
        Top = 32
        Width = 250
        Height = 21
        Color = clBtnFace
        EditLabel.Width = 106
        EditLabel.Height = 13
        EditLabel.Caption = 'Descri'#231#227'o do Produto:'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edtQuantidade: TLabeledEdit
        Left = 376
        Top = 32
        Width = 80
        Height = 21
        EditLabel.Width = 69
        EditLabel.Height = 13
        EditLabel.Caption = 'Quantidade: *'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnKeyPress = edtQuantidadeKeyPress
      end
      object edtValorUnitario: TLabeledEdit
        Left = 472
        Top = 32
        Width = 100
        Height = 21
        EditLabel.Width = 77
        EditLabel.Height = 13
        EditLabel.Caption = 'Valor Unit'#225'rio: *'
        EditLabel.Font.Charset = DEFAULT_CHARSET
        EditLabel.Font.Color = clWindowText
        EditLabel.Font.Height = -11
        EditLabel.Font.Name = 'Tahoma'
        EditLabel.Font.Style = []
        EditLabel.ParentFont = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnKeyPress = edtValorUnitarioKeyPress
      end
      object btnAdicionarItem: TButton
        Left = 584
        Top = 30
        Width = 120
        Height = 25
        Caption = 'Adicionar/Atualizar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = btnAdicionarItemClick
      end
      object btnLimparItem: TButton
        Left = 720
        Top = 30
        Width = 75
        Height = 25
        Caption = 'Limpar'
        TabOrder = 5
        OnClick = btnLimparItemClick
      end
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 200
    Width = 900
    Height = 300
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 2
    object gbItens: TGroupBox
      Left = 8
      Top = 8
      Width = 884
      Height = 284
      Caption = ' Itens do Pedido '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object gridItens: TStringGrid
        Left = 2
        Top = 15
        Width = 880
        Height = 267
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 20
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        OnDblClick = gridItensDblClick
        OnKeyDown = gridItensKeyDown
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 500
    Width = 900
    Height = 100
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 3
    object gbAcoes: TGroupBox
      Left = 8
      Top = 8
      Width = 600
      Height = 84
      Caption = ' A'#231#245'es '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object btnGravarPedido: TButton
        Left = 16
        Top = 24
        Width = 120
        Height = 35
        Caption = 'Gravar Pedido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnGravarPedidoClick
      end
      object btnCarregarPedido: TButton
        Left = 152
        Top = 24
        Width = 120
        Height = 35
        Caption = 'Carregar Pedido'
        TabOrder = 1
        OnClick = btnCarregarPedidoClick
      end
      object btnCancelarPedido: TButton
        Left = 288
        Top = 24
        Width = 120
        Height = 35
        Caption = 'Cancelar Pedido'
        TabOrder = 2
        OnClick = btnCancelarPedidoClick
      end
      object btnNovoPedido: TButton
        Left = 424
        Top = 24
        Width = 120
        Height = 35
        Caption = 'Novo Pedido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = btnNovoPedidoClick
      end
    end
    object gbTotal: TGroupBox
      Left = 624
      Top = 8
      Width = 268
      Height = 84
      Caption = ' Total do Pedido '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object lblValorTotal: TLabel
        Left = 160
        Top = 24
        Width = 92
        Height = 29
        Alignment = taRightJustify
        Caption = 'R$ 0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -24
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblQuantidadeItens: TLabel
        Left = 220
        Top = 56
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = '0 itens'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
