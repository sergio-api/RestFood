{.$DEFINE NOTE}
{.$DEFINE API}
{$DEFINE TAAKI}
unit udmAcesso;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Client, Vcl.Forms,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.IniFiles;

type
  TdmAcesso = class(TDataModule)
    RESTTaaki: TRESTClient;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    REQhorario: TRESTRequest;
    REQcategoria: TRESTRequest;
    REQproduto: TRESTRequest;
    RESPResponse: TRESTResponse;
    REQpedido: TRESTRequest;
    REQstatus: TRESTRequest;
    conexao: TFDConnection;
    qryTaaki: TFDQuery;
    qryTaakiCONTADOR: TIntegerField;
    qryTaakiSENHA_TAAKI: TStringField;
    qryTaakiSENHA_INTEGRACAO: TStringField;
    qryTaakiATIVO: TStringField;
    qryTaakiDOM_HORA_INICIO: TStringField;
    qryTaakiDOM_HORA_FIM: TStringField;
    qryTaakiSEG_HORA_INICIO: TStringField;
    qryTaakiSEG_HORA_FIM: TStringField;
    qryTaakiTER_HORA_INICIO: TStringField;
    qryTaakiTER_HORA_FIM: TStringField;
    qryTaakiQUA_HORA_INICIO: TStringField;
    qryTaakiQUA_HORA_FIM: TStringField;
    qryTaakiQUI_HORA_INICIO: TStringField;
    qryTaakiQUI_HORA_FIM: TStringField;
    qryTaakiSEX_HORA_INICIO: TStringField;
    qryTaakiSEX_HORA_FIM: TStringField;
    qryTaakiSAB_HORA_INICIO: TStringField;
    qryTaakiSAB_HORA_FIM: TStringField;
    qryTaakiID_CATEGORIA: TSmallintField;
    qryTaakiID_SUBCATEGORIA1: TSmallintField;
    qryTaakiID_SUBCATEGORIA2: TSmallintField;
    REQestabelecimento: TRESTRequest;
    REQestabelecimentoAlt: TRESTRequest;
    REQimagem: TRESTRequest;
    REQnovos: TRESTRequest;
    cdsPedido: TFDMemTable;
    cdsPedidoid: TIntegerField;
    cdsPedidoobservacao: TStringField;
    cdsPedidovalortotal: TFloatField;
    cdsPedidovalorfrete: TFloatField;
    cdsPedidoidstatus: TIntegerField;
    cdsPedidodescricaoendereco: TStringField;
    cdsPedidonumero: TStringField;
    cdsPedidocomplemento: TStringField;
    cdsPedidobairro: TStringField;
    cdsPedidocidade: TStringField;
    cdsPedidouf: TStringField;
    cdsPedidocep: TStringField;
    cdsPedidopontoreferencia: TStringField;
    cdsPedidoibge: TIntegerField;
    cdsPedidopontos: TIntegerField;
    idpedidoproducaostatus: TIntegerField;
    cdsPedidoidpedidoproducaostatus: TIntegerField;
    cdsPedidocliente_nome: TStringField;
    cdsPedidocliente_name: TStringField;
    cdsPedidocliente_cpf: TStringField;
    cdsPedidocliente_email: TStringField;
    REQcancelar: TRESTRequest;
    REQFormapg: TRESTRequest;
    REQproducaostatus: TRESTRequest;
    procedure DataModuleCreate(Sender: TObject);
    procedure AtualizaConexao;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmAcesso: TdmAcesso;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdmAcesso.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
    {$IFDEF NOTE}
      RESTTaaki.BaseURL := 'https://webhook.site/138fbbe2-b15c-49f4-839a-680c9929a2bd';
    {$ENDIF}
    {$IFDEF API}
      RESTTaaki.BaseURL := 'https://webhook.site/1ada5388-f380-4438-b4a5-a8e904278a0d';
    {$ENDIF}
    {$IFDEF TAAKI}
      RESTTaaki.BaseURL := 'https://api.taakisolucoes.com.br/api/erp/v1';
    {$ENDIF}
  {$ELSE}
    RESTTaaki.BaseURL := 'https://api.taakisolucoes.com.br/api/erp/v1';
  {$ENDIF}
  AtualizaConexao;
end;

procedure TdmAcesso.AtualizaConexao;
var
  mBanco,mSenha,mPath:string;
  mIni: TIniFile;
  mPasso,nA:Integer;
begin
  mPath  := ExtractFilePath(application.ExeName);
  mIni   := TIniFile.Create(mPath + 'MAXXIVAREJO.INI');
  mBanco := mIni.ReadString('Banco de Dados', 'Caminho','C:\MAXXIVAREJO\MAXXIVAREJO.FDB');
  mSenha := mIni.ReadString('Banco de Dados', 'Senha','masterkey');
  mIni.Free;

  try
    Conexao.Connected := False;
    Conexao.Params.Values['database'] := mBanco;
    Conexao.Params.Values['password'] := mSenha;
    Conexao.Connected := True;
  except
    Conexao.Connected := False;
    Application.Terminate;
    Exit;
  end;
end;

end.
//taaki
//https://api.taakisolucoes.com.br/api/erp/v1

//webhok NOTE
//https://webhook.site/138fbbe2-b15c-49f4-839a-680c9929a2bd

//API
//https://webhook.site/1ada5388-f380-4438-b4a5-a8e904278a0d
