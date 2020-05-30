object dmAcesso: TdmAcesso
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 444
  Width = 749
  object RESTTaaki: TRESTClient
    Authenticator = HTTPBasicAuthenticator1
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://api.taakisolucoes.com.br/api/erp/v1'
    ContentType = 
      'multipart/form-data; boundary=-------Embt-Boundary--078380BF75F0' +
      '41BD'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 88
    Top = 8
  end
  object HTTPBasicAuthenticator1: THTTPBasicAuthenticator
    Left = 80
    Top = 336
  end
  object REQhorario: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'estabelecimento/horariofuncionamento'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 88
    Top = 128
  end
  object REQcategoria: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'produto/categoria'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 192
    Top = 192
  end
  object REQproduto: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'produto'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 88
    Top = 184
  end
  object RESPResponse: TRESTResponse
    Left = 224
    Top = 336
  end
  object REQpedido: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'pedido'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 336
    Top = 120
  end
  object REQstatus: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'pedido/alterarstatusproducao'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 336
    Top = 192
  end
  object conexao: TFDConnection
    Params.Strings = (
      'Database=C:\MAXXIVAREJO\MAXXIVAREJO_DOMPEDRO.APISYS'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 536
    Top = 32
  end
  object qryTaaki: TFDQuery
    Connection = conexao
    SQL.Strings = (
      'SELECT '
      '    INTEGRACAO_TAAKI.CONTADOR,'
      '    INTEGRACAO_TAAKI.SENHA_TAAKI,'
      '    INTEGRACAO_TAAKI.SENHA_INTEGRACAO,'
      '    INTEGRACAO_TAAKI.ATIVO,'
      '    INTEGRACAO_TAAKI.DOM_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.DOM_HORA_FIM,'
      '    INTEGRACAO_TAAKI.SEG_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.SEG_HORA_FIM,'
      '    INTEGRACAO_TAAKI.TER_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.TER_HORA_FIM,'
      '    INTEGRACAO_TAAKI.QUA_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.QUA_HORA_FIM,'
      '    INTEGRACAO_TAAKI.QUI_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.QUI_HORA_FIM,'
      '    INTEGRACAO_TAAKI.SEX_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.SEX_HORA_FIM,'
      '    INTEGRACAO_TAAKI.SAB_HORA_INICIO,'
      '    INTEGRACAO_TAAKI.SAB_HORA_FIM,'
      '    INTEGRACAO_TAAKI.ID_CATEGORIA,'
      '    INTEGRACAO_TAAKI.ID_SUBCATEGORIA1,'
      '    INTEGRACAO_TAAKI.ID_SUBCATEGORIA2'
      'FROM INTEGRACAO_TAAKI')
    Left = 536
    Top = 96
    object qryTaakiCONTADOR: TIntegerField
      FieldName = 'CONTADOR'
      Origin = 'CONTADOR'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryTaakiSENHA_TAAKI: TStringField
      FieldName = 'SENHA_TAAKI'
      Origin = 'SENHA_TAAKI'
      Size = 200
    end
    object qryTaakiSENHA_INTEGRACAO: TStringField
      FieldName = 'SENHA_INTEGRACAO'
      Origin = 'SENHA_INTEGRACAO'
      Size = 200
    end
    object qryTaakiATIVO: TStringField
      FieldName = 'ATIVO'
      Origin = 'ATIVO'
      Size = 1
    end
    object qryTaakiDOM_HORA_INICIO: TStringField
      FieldName = 'DOM_HORA_INICIO'
      Origin = 'DOM_HORA_INICIO'
      Size = 5
    end
    object qryTaakiDOM_HORA_FIM: TStringField
      FieldName = 'DOM_HORA_FIM'
      Origin = 'DOM_HORA_FIM'
      Size = 5
    end
    object qryTaakiSEG_HORA_INICIO: TStringField
      FieldName = 'SEG_HORA_INICIO'
      Origin = 'SEG_HORA_INICIO'
      Size = 5
    end
    object qryTaakiSEG_HORA_FIM: TStringField
      FieldName = 'SEG_HORA_FIM'
      Origin = 'SEG_HORA_FIM'
      Size = 5
    end
    object qryTaakiTER_HORA_INICIO: TStringField
      FieldName = 'TER_HORA_INICIO'
      Origin = 'TER_HORA_INICIO'
      Size = 5
    end
    object qryTaakiTER_HORA_FIM: TStringField
      FieldName = 'TER_HORA_FIM'
      Origin = 'TER_HORA_FIM'
      Size = 5
    end
    object qryTaakiQUA_HORA_INICIO: TStringField
      FieldName = 'QUA_HORA_INICIO'
      Origin = 'QUA_HORA_INICIO'
      Size = 5
    end
    object qryTaakiQUA_HORA_FIM: TStringField
      FieldName = 'QUA_HORA_FIM'
      Origin = 'QUA_HORA_FIM'
      Size = 5
    end
    object qryTaakiQUI_HORA_INICIO: TStringField
      FieldName = 'QUI_HORA_INICIO'
      Origin = 'QUI_HORA_INICIO'
      Size = 5
    end
    object qryTaakiQUI_HORA_FIM: TStringField
      FieldName = 'QUI_HORA_FIM'
      Origin = 'QUI_HORA_FIM'
      Size = 5
    end
    object qryTaakiSEX_HORA_INICIO: TStringField
      FieldName = 'SEX_HORA_INICIO'
      Origin = 'SEX_HORA_INICIO'
      Size = 5
    end
    object qryTaakiSEX_HORA_FIM: TStringField
      FieldName = 'SEX_HORA_FIM'
      Origin = 'SEX_HORA_FIM'
      Size = 5
    end
    object qryTaakiSAB_HORA_INICIO: TStringField
      FieldName = 'SAB_HORA_INICIO'
      Origin = 'SAB_HORA_INICIO'
      Size = 5
    end
    object qryTaakiSAB_HORA_FIM: TStringField
      FieldName = 'SAB_HORA_FIM'
      Origin = 'SAB_HORA_FIM'
      Size = 5
    end
    object qryTaakiID_CATEGORIA: TSmallintField
      FieldName = 'ID_CATEGORIA'
      Origin = 'ID_CATEGORIA'
    end
    object qryTaakiID_SUBCATEGORIA1: TSmallintField
      FieldName = 'ID_SUBCATEGORIA1'
      Origin = 'ID_SUBCATEGORIA1'
    end
    object qryTaakiID_SUBCATEGORIA2: TSmallintField
      FieldName = 'ID_SUBCATEGORIA2'
      Origin = 'ID_SUBCATEGORIA2'
    end
  end
  object REQestabelecimento: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'estabelecimento'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 88
    Top = 72
  end
  object REQestabelecimentoAlt: TRESTRequest
    Client = RESTTaaki
    Method = rmPUT
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
      end
      item
        Kind = pkREQUESTBODY
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'estabelecimento'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 200
    Top = 64
  end
  object REQimagem: TRESTRequest
    Accept = 'multipart/form-data'
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'idproduto'
        Value = '1118'
      end
      item
        Kind = pkFILE
        Name = 'imagem0'
        ContentType = ctMULTIPART_FORM_DATA
      end>
    Resource = 'produto/imagens'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 88
    Top = 248
  end
  object REQnovos: TRESTRequest
    Client = RESTTaaki
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end>
    Resource = 'pedido/novos'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 336
    Top = 48
  end
  object cdsPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 192
    object cdsPedidoid: TIntegerField
      FieldName = 'id'
    end
    object cdsPedidoobservacao: TStringField
      FieldName = 'observacao'
      Size = 100
    end
    object cdsPedidovalortotal: TFloatField
      FieldName = 'valortotal'
    end
    object cdsPedidovalorfrete: TFloatField
      FieldName = 'valorfrete'
    end
    object cdsPedidoidstatus: TIntegerField
      FieldName = 'idstatus'
    end
    object cdsPedidodescricaoendereco: TStringField
      FieldName = 'descricaoendereco'
      Size = 40
    end
    object cdsPedidonumero: TStringField
      FieldName = 'numero'
      Size = 10
    end
    object cdsPedidocomplemento: TStringField
      FieldName = 'complemento'
      Size = 40
    end
    object cdsPedidobairro: TStringField
      FieldName = 'bairro'
      Size = 60
    end
    object cdsPedidocidade: TStringField
      FieldName = 'cidade'
      Size = 60
    end
    object cdsPedidouf: TStringField
      FieldName = 'uf'
      Size = 2
    end
    object cdsPedidocep: TStringField
      FieldName = 'cep'
      Size = 8
    end
    object cdsPedidopontoreferencia: TStringField
      FieldName = 'pontoreferencia'
      Size = 100
    end
    object cdsPedidoibge: TIntegerField
      FieldName = 'ibge'
    end
    object cdsPedidopontos: TIntegerField
      FieldName = 'pontos'
    end
    object idpedidoproducaostatus: TIntegerField
      FieldName = 'idcliente'
    end
    object cdsPedidoidpedidoproducaostatus: TIntegerField
      FieldName = 'idpedidoproducaostatus'
    end
    object cdsPedidocliente_nome: TStringField
      FieldName = 'cliente_nome'
      Size = 70
    end
    object cdsPedidocliente_name: TStringField
      FieldName = 'cliente_name'
      Size = 70
    end
    object cdsPedidocliente_cpf: TStringField
      FieldName = 'cliente_cpf'
    end
    object cdsPedidocliente_email: TStringField
      FieldName = 'cliente_email'
      Size = 70
    end
  end
  object REQcancelar: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'taakiToken'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'pedido/cancelar'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 336
    Top = 256
  end
  object REQFormapg: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'tokenTaaki'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'pedido/formapagamento'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 200
    Top = 128
  end
  object REQproducaostatus: TRESTRequest
    Client = RESTTaaki
    Method = rmPOST
    Params = <
      item
        Kind = pkHTTPHEADER
        Name = 'tokenTaaki'
        Value = '$2y$10$78j6eFTqb7UDwFf291IIqeppOfeGRTt/M8Q.yb14GLpuqkhu2/B52'
      end
      item
        Name = 'body'
        Options = [poDoNotEncode]
        ContentType = ctAPPLICATION_JSON
      end>
    Resource = 'pedido/producaostatus'
    Response = RESPResponse
    SynchronizedEvents = False
    Left = 192
    Top = 264
  end
end
