unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,system.json,REST.Json,
  Vcl.StdCtrls, Vcl.Imaging.jpeg, System.ImageList, Vcl.ImgList,REST.Types,
  Vcl.Imaging.pngimage, Vcl.Buttons, Datasnap.DBClient, Data.DB, Vcl.Grids,
  Vcl.DBGrids, System.IniFiles;

type
  TFPrincipal = class(TForm)
    tMonitora: TTimer;
    Memo2: TMemo;
    Panel1: TPanel;
    Image1: TImage;
    ImageList1: TImageList;
    imgStatusTaaki: TImage;
    Panel2: TPanel;
    Image3: TImage;
    imgStatusiFood: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbRetornoTaaki: TLabel;
    lbHoraTaaki: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure tMonitoraTimer(Sender: TObject);
  private
    procedure Horarios;
    procedure ProcessaResponse;
    procedure AtualizaPainel(iEmpresa, iStatus: Integer);
    procedure Categorias;
    procedure Produtos;
    procedure Imagem;
    function FormataSaida(strRetorno: string; iTipo: Integer): string;
    procedure Estabelecimento;
    procedure ProcessaResponseEstab;
    procedure EstabelecimentoAlt;
    procedure AtualizaTokens;
    procedure VerificaNovos;
    procedure ProcessaResponseNovos;
    procedure BuscaPedido;
    procedure ProcessaResponsePedido;
    procedure MudaStatus;
    procedure CancelarPedido;
    procedure FormaPagamento;
    procedure ProducaoStatus;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;
  mTokenTaaki,mTokenInteg:string;
  jsonDir,mProcesso:string;

implementation

uses
  udmAcesso, Funcoes, UEstabelecimentoRet, uPedidosNovos;

{$R *.dfm}

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  AtualizaPainel(0,0); //Coloca todos como inativos

  Funcoes.FKey := 'xK@2';
  jsonDir := ExtractFilePath(Application.ExeName)+'JSON\';
  ForceDirectories(jsonDir);

  dmAcesso.qryTaaki.open;
  mTokenTaaki := CriptoHexToText(dmAcesso.qryTaakiSENHA_TAAKI.AsString);
  mTokenInteg := CriptoHexToText(dmAcesso.qryTaakiSENHA_INTEGRACAO.AsString);
  if dmAcesso.qryTaakiATIVO.AsString = 'S' then
    AtualizaPainel(1,1);

  dmAcesso.qryTaaki.Close;
  mProcesso := '';

  //atualiza Token de Integração
  dmAcesso.HTTPBasicAuthenticator1.Username := mTokenInteg;

  tMonitora.Enabled := True;
end;

procedure TFPrincipal.Horarios;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Horarios';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'horarios.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQhorario.Params[0].Value := mTokenTaaki;
      dmAcesso.REQhorario.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQhorario.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'horarios.json');
  end;
end;

procedure TFPrincipal.Estabelecimento;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin

  try
    try
      mProcesso := 'Estabelecimento';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'estabelecimento.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQestabelecimento.Params[0].Value := JSonValue.ToString;

      dmAcesso.REQestabelecimento.ExecuteAsync(ProcessaResponseEstab, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'estabelecimento.json');
  end;
end;

procedure TFPrincipal.tMonitoraTimer(Sender: TObject);
begin
  try
    tMonitora.Enabled := False;

    AtualizaTokens;

    if FileExists(jsonDir+'verificanovos.json') then
      VerificaNovos;

    if FileExists(jsonDir+'buscapedido.json') then
      BuscaPedido;

    if FileExists(jsonDir+'mudastatus.json') then
      MudaStatus;

    if FileExists(jsonDir+'cancelarpedido.json') then
      CancelarPedido;

    if FileExists(jsonDir+'estabelecimento.json') then
      Estabelecimento;
    if FileExists(jsonDir+'estabelecimentoalt.json') then
      EstabelecimentoAlt;
    if FileExists(jsonDir+'horarios.json') then
      Horarios;
    if FileExists(jsonDir+'categorias.json') then
      Categorias;
    if FileExists(jsonDir+'produtos.json') then
      Produtos;
    if FileExists(jsonDir+'formapagamento.json') then
      FormaPagamento;
    if FileExists(jsonDir+'producaostatus.json') then
      ProducaoStatus;

  finally
    tMonitora.Enabled := True;
  end;
end;

procedure TFPrincipal.ProcessaResponse;
var
  jsonObj : TJsonObject;
  json, sucesso, erro : string;
  httpcode, content: string;
begin
  if dmAcesso.RESPResponse.JSONValue = nil then
  begin
      lbRetornoTaaki.Caption := 'Erro ao validar (JSON Inválido)';
      CriarLog(mProcesso,'','Erro ao validar (JSON Inválido)');
      exit;
  end;

  try
    json    := dmAcesso.RESPResponse.JSONValue.ToString;
    jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    sucesso  := jsonObj.GetValue('msg').Value;
    httpcode := jsonObj.GetValue('httpCode').Value;
    content  := jsonObj.GetValue('content').Value;

    if httpcode <> '200' then
    begin
      lbRetornoTaaki.Caption := 'Erro: ' + #10 + httpcode + #10 +content;
      CriarLog(mProcesso+': '+sucesso,httpcode,content);
      exit;
    end
    else
    begin
      if httpcode = '200' then
        lbRetornoTaaki.Caption := 'Processado com Sucesso'
      else
      begin
        lbRetornoTaaki.Caption := 'Erro: ' + httpcode + #10 +content;
        CriarLog(mProcesso+': '+sucesso,httpcode,content);
      end;
    end;
    DeleteFile(jsonDir+'jsonresp.json');
    Memo2.Clear;
    Memo2.Lines.Add(FormataSaida(sucesso,1));
    Memo2.Lines.Add(FormataSaida(httpcode,2));
    Memo2.Lines.Add(content);
    Memo2.Lines.SaveToFile(jsonDir+'jsonresptmp.json');
    RenameFile(jsonDir+'jsonresptmp.json',jsonDir+'jsonresp.json');
  finally
    jsonObj.DisposeOf;
  end;
end;

procedure TFPrincipal.ProcessaResponseEstab;
var
  jsonObj : TJsonObject;
  json, sucesso, erro, httpcode, content : string;
  mTaakiToken,mAuthToken:string;
  cdsTemp: TClientDataSet;
//  mEstabRet: TEstabelecimentoRetDTO;
begin
  if dmAcesso.RESPResponse.JSONValue = nil then
  begin
      lbRetornoTaaki.Caption := 'Erro ao validar (JSON Inválido)';
      CriarLog(mProcesso,'','Erro ao validar (JSON Inválido)');
      exit;
  end;

  try
    content     := '';
    mTaakiToken := '';
    mAuthToken  := '';

//    Memo2.Lines.Clear;
//    Memo2.Lines.LoadFromFile(jsonDir+'tokenret.json');
//    json      := Memo2.text;

    json      := dmAcesso.RESPResponse.JSONValue.ToString;
    jsonObj   := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

    sucesso  := jsonObj.GetValue('msg').Value;
    httpcode := jsonObj.GetValue('httpCode').Value;
    if httpcode <> '200' then
      content  := jsonObj.GetValue('content').Value
    else
    begin
      mTaakiToken := jsonObj.GetValue<string>('content.taakiToken');
      mAuthToken  := jsonObj.GetValue<string>('content.token');
    end;


{    mEstabRet := TJson.JsonToObject<TEstabelecimentoRetDTO>(json);
    sucesso     := mEstabRet.Msg;
    httpcode    := mEstabRet.HttpCode;
    mTaakiToken := mEstabRet.Content.TaakiToken;
    mAuthToken  := mEstabRet.Content.Token;
}
    if httpcode <> '200' then
    begin
      lbRetornoTaaki.Caption := 'Erro: ' + #10 + httpcode + #10 +content;
      CriarLog(mProcesso+': '+sucesso,httpcode,content);
      exit;
    end
    else
    begin
      if httpcode = '200' then
        lbRetornoTaaki.Caption := 'Processado com Sucesso'
      else
      begin
        lbRetornoTaaki.Caption := 'Erro: ' + httpcode + #10 +content;
        CriarLog(mProcesso+': '+sucesso,httpcode,content);
      end;
    end;
    DeleteFile(jsonDir+'jsonresp.json');
    Memo2.Clear;
    Memo2.Lines.Add(FormataSaida(sucesso,1));
    Memo2.Lines.Add(FormataSaida(httpcode,2));
    Memo2.Lines.Add(content);
    Memo2.Lines.SaveToFile(jsonDir+'jsonresptmp.json');
    RenameFile(jsonDir+'jsonresptmp.json',jsonDir+'jsonresp.json');

    DeleteFile(jsonDir+'token.json');
    try
      cdsTemp := TClientDataSet.Create(Self);
      cdsTemp.Close;
      cdsTemp.FieldDefs.Clear;
      cdsTemp.FieldDefs.add('tokentaaki',ftString,200);
      cdsTemp.FieldDefs.add('tokenauth',ftString,200);
      cdsTemp.CreateDataSet;

      cdsTemp.Append;
      cdsTemp.FieldByName('tokentaaki').AsString := TextToCriptoHex(mTaakiToken);
      cdsTemp.FieldByName('tokenauth').AsString  := TextToCriptoHex(mAuthToken);
      cdsTemp.Post;

      cdsTemp.SaveToFile(jsonDir+'tokentmp.json');
      RenameFile(jsonDir+'tokentmp.json',jsonDir+'token.json')
    finally
      cdsTemp.DisposeOf;
    end;
  finally
    jsonObj.DisposeOf;
//      mEstabRet.DisposeOf;
  end;
end;

procedure TFPrincipal.AtualizaPainel(iEmpresa,iStatus:Integer);
var
  mDescStatus:string;
begin
  case iStatus of
    0 : mDescStatus := 'Inativo';
    1 : mDescStatus := 'Ativo';
  end;

  if (iEmpresa = 0) or (iEmpresa = 1) then //0 Atualizar Todos
  begin
    //Taaki
    ImageList1.GetBitmap(iStatus, imgStatusTaaki.Picture.Bitmap);
    Label1.Caption := mDescStatus;
  end;

  if (iEmpresa = 0) or (iEmpresa = 2) then //0 Atualizar Todos
  begin
    //iFood
    ImageList1.GetBitmap(iStatus, imgStatusiFood.Picture.Bitmap);
    Label2.Caption := mDescStatus;
  end;
end;

procedure TFPrincipal.Categorias;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Categorias';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'categorias.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQcategoria.Params[0].Value := mTokenTaaki;
      dmAcesso.REQcategoria.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQcategoria.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'categorias.json');
  end;
end;

procedure TFPrincipal.FormaPagamento;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Formas de Pagamento';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'formapagamento.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQformapg.Params[0].Value := mTokenTaaki;
      dmAcesso.REQformapg.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQformapg.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'formapagamento.json');
  end;
end;

procedure TFPrincipal.ProducaoStatus;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Gravar Status Produção';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'producaostatus.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQproducaostatus.Params[0].Value := mTokenTaaki;
      dmAcesso.REQproducaostatus.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQproducaostatus.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'producaostatus.json');
  end;
end;

procedure TFPrincipal.Produtos;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
  myThreadProd : TThread;
begin
  try
    myThreadProd := TThread.CreateAnonymousThread(
    procedure
    begin
      try
        try
          mProcesso := 'Produtos';
          lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

          jsonString := TStringList.Create;
          jsonString.LoadFromFile(jsonDir+'produtos.json');

          JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

          dmAcesso.REQproduto.Params[0].Value := mTokenTaaki;
          dmAcesso.REQproduto.Params[1].Value := JSonValue.ToString;

          dmAcesso.REQproduto.ExecuteAsync(ProcessaResponse, true, true);

        except on ex:exception do
          begin
            lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
            CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
          end;
        end;
      finally
        jsonString.DisposeOf;
        JsonValue.DisposeOf;
        DeleteFile(jsonDir+'produtos.json');
      end;

    end);

    myThreadProd.start();
  finally
    //myThreadProd.DisposeOf;
    if FileExists(jsonDir+'imagem.json') then Imagem;
  end;
end;

procedure TFPrincipal.Imagem;
var
  myThread : TThread;
  cdsTemp: TClientDataSet;
begin
  try
    myThread := TThread.CreateAnonymousThread(

    procedure
    begin
      try
        mProcesso := 'Imagens';
        lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso + mTokenInteg ;

        cdsTemp := TClientDataSet.Create(Self);
        cdsTemp.LoadFromFile(jsonDir+'imagem.json');
        cdsTemp.Open;
        cdsTemp.First;
        //cdsTemp.Prior;;

        Memo1.Lines.Clear;

        while not cdsTemp.Eof do
        begin
          with dmAcesso do
          begin
            try
              if not FileExists(cdsTemp.FieldByName('caminho').AsString) then
                memo1.Lines.Add('[-] '+cdsTemp.FieldByName('caminho').AsString );

//              REQimagem.Params.Clear;
//              REQimagem.AddParameter('taakiToken',mTokenTaaki,TRESTRequestParameterKind.pkHTTPHEADER);
//              REQimagem.AddParameter('idproduto',cdsTemp.FieldByName('id').AsString,TRESTRequestParameterKind.pkGETorPOST);
//              REQimagem.AddParameter('imagem0',cdsTemp.FieldByName('caminho').AsString,TRESTRequestParameterKind.pkFILE);

              REQimagem.Params[0].Value := mTokenTaaki;
              REQimagem.Params[1].Value := cdsTemp.FieldByName('id').AsString;
              REQimagem.Params[2].Value := cdsTemp.FieldByName('caminho').AsString;
//              REQimagem.Params[3].Value := '';
//              REQimagem.Params[4].Value := '';
//              REQimagem.Params[5].Value := '';
//              REQimagem.Params[6].Value := '';

//              REQimagem.ExecuteAsync(ProcessaResponse, true, true);
              REQimagem.Execute;
              ProcessaResponse;
            except on ex:exception do
              begin
                lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
                CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
              end;
            end;
          end;
          Sleep(1000);
          Memo1.Lines.Add(cdsTemp.FieldByName('id').AsString+'-'+cdsTemp.FieldByName('caminho').AsString);
          DeleteFile(cdsTemp.FieldByName('caminho').AsString);
          cdsTemp.Next;
        end;
      finally
        cdsTemp.Close;
        cdsTemp.Free;
        DeleteFile(jsonDir+'imagem.json');
      end;
    end);

    myThread.start();
  finally
//    myThread.DisposeOf;
  end;
end;


function TFPrincipal.FormataSaida(strRetorno:string;iTipo:Integer):string;
begin
  Result := strRetorno;
  if iTipo = 1 then //sucesso
  begin
    if strRetorno = 'Ok' then
      Result := strRetorno+' - Enviado ao servidor'
    else
      Result := strRetorno+' - Erro. Dados não enviados';
  end;

  if iTipo = 2 then //httpcode
  begin
    if (Copy(strRetorno,1,1) = '1') or (Copy(strRetorno,1,1) = '2') then
      Result := strRetorno+' - Dados recebidos'
    else
      Result := strRetorno+' - Erro. Não recebido';
  end;
end;

procedure TFPrincipal.EstabelecimentoAlt;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Estabelecimento Alt';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'estabelecimentoalt.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQestabelecimentoAlt.Params[0].Value := mTokenTaaki;
      dmAcesso.REQestabelecimentoAlt.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQestabelecimentoAlt.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'estabelecimentoalt.json');
  end;
end;

procedure TFPrincipal.AtualizaTokens;
begin
  dmAcesso.AtualizaConexao;

  dmAcesso.qryTaaki.open;
  mTokenTaaki := CriptoHexToText(dmAcesso.qryTaakiSENHA_TAAKI.AsString);
  mTokenInteg := CriptoHexToText(dmAcesso.qryTaakiSENHA_INTEGRACAO.AsString);
  if dmAcesso.qryTaakiATIVO.AsString = 'S' then
    AtualizaPainel(1,1);

  dmAcesso.qryTaaki.Close;

  //atualiza Token de Integração
  dmAcesso.HTTPBasicAuthenticator1.Username := mTokenInteg;
end;

procedure TFPrincipal.VerificaNovos;
begin
  try
    try
      mProcesso := 'Verifica Pedidos Novos';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      dmAcesso.REQnovos.Params[0].Value := mTokenTaaki;

      dmAcesso.REQnovos.ExecuteAsync(ProcessaResponseNovos, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    DeleteFile(jsonDir+'verificanovos.json');
  end;
end;

procedure TFPrincipal.MudaStatus;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Altera Status do Pedido';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'mudastatus.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQstatus.Params[0].Value := mTokenTaaki;
      dmAcesso.REQstatus.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQstatus.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    DeleteFile(jsonDir+'mudastatus.json');
  end;
end;

procedure TFPrincipal.CancelarPedido;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Cancelar Pedido';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'cancelarpedido.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQcancelar.Params[0].Value := mTokenTaaki;
      dmAcesso.REQcancelar.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQcancelar.ExecuteAsync(ProcessaResponse, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    DeleteFile(jsonDir+'cancelarpedido.json');
  end;
end;

procedure TFPrincipal.BuscaPedido;
var
  JSonValue: TJSONValue;
  jsonString: TStringList;
begin
  try
    try
      mProcesso := 'Busca Pedido';
      lbHoraTaaki.Caption := TimeToStr(Now)+' - '+mProcesso;

      jsonString := TStringList.Create;
      jsonString.LoadFromFile(jsonDir+'buscapedido.json');

      JsonValue := TJSonObject.ParseJSONValue(jsonString.Text);

      dmAcesso.REQpedido.Params[0].Value := mTokenTaaki;
      dmAcesso.REQpedido.Params[1].Value := JSonValue.ToString;

      dmAcesso.REQpedido.ExecuteAsync(ProcessaResponsePedido, true, true);

    except on ex:exception do
      begin
        lbRetornoTaaki.Caption := 'Erro ao enviar requisição: ' + #10 + ex.Message;
        CriarLog(mProcesso,'','Erro ao enviar requisição: ' + #10 + ex.Message);
      end;
    end;
  finally
    jsonString.DisposeOf;
    JsonValue.DisposeOf;
    DeleteFile(jsonDir+'buscapedido.json');
  end;
end;

procedure TFPrincipal.ProcessaResponseNovos;
var
  jsonObj : TJsonObject;
  jsonPedido : TPedidosNovosDTO;
  sucesso, httpcode, content: string;
  i:Integer;
  cdsTemp : TClientDataSet;
begin
  if dmAcesso.RESPResponse.JSONValue = nil then
  begin
    lbRetornoTaaki.Caption := 'Erro ao validar (JSON Inválido)';
    CriarLog(mProcesso,'','Erro ao validar (JSON Inválido)');
    exit;
  end;

  try
    jsonObj   := TJSONObject.ParseJSONValue(dmAcesso.RESPResponse.Content) as TJSONObject;

    sucesso  := jsonObj.GetValue('msg').Value;
    httpcode := jsonObj.GetValue('httpCode').Value;
    content  := jsonObj.GetValue('content').ToString;

    if httpcode <> '200' then
    begin
      lbRetornoTaaki.Caption := 'Erro: ' + #10 + httpcode + #10 +content;
      CriarLog(mProcesso+': '+sucesso,httpcode,content);
      exit;
    end
    else
    begin
      if httpcode = '200' then
        lbRetornoTaaki.Caption := 'Processado com Sucesso'
      else
      begin
        lbRetornoTaaki.Caption := 'Erro: ' + httpcode + #10 +content;
        CriarLog(mProcesso+': '+sucesso,httpcode,content);
      end;

      //primeiro crio a resposta da requisição
      DeleteFile(jsonDir+'jsonresp.json');
      Memo2.Clear;
      Memo2.Lines.Add(FormataSaida(sucesso,1));
      Memo2.Lines.Add(FormataSaida(httpcode,2));
      Memo2.Lines.Add(content);
      Memo2.Lines.SaveToFile(jsonDir+'jsonresptmp.json');
      RenameFile(jsonDir+'jsonresptmp.json',jsonDir+'jsonresp.json');

      //em caso de sucesso, crio o json dos pedidos
      if (httpcode = '200') and (content <> '[]') then
      begin
        jsonPedido := TJson.JsonToObject<TPedidosNovosDTO>(jsonObj);

        DeleteFile(jsonDir+'pedidostmp.json');
        DeleteFile(jsonDir+'pedidos.json');
        try
          cdsTemp := TClientDataSet.Create(Self);
          cdsTemp.Close;
          cdsTemp.FieldDefs.Clear;
          cdsTemp.FieldDefs.add('idpedido',ftInteger ,0);
          cdsTemp.CreateDataSet;
          cdsTemp.Open;

          for i := 0 to Length(jsonPedido.Content) - 1 do
          begin
            cdsTemp.Append;
            cdsTemp.FieldByName('idpedido').AsString := jsonPedido.Content[i].Id.ToString;
            cdsTemp.Post;
          end;

          cdsTemp.SaveToFile(jsonDir+'pedidostmp.json');
          RenameFile(jsonDir+'pedidostmp.json',jsonDir+'pedidos.json')
        finally
          cdsTemp.DisposeOf;
        end;
      end;
    end;
  finally
    jsonObj.DisposeOf;
    jsonPedido.DisposeOf;
  end;
end;

procedure TFPrincipal.ProcessaResponsePedido;
var
  jsonObj : TJsonObject;
  jsonPedido : TPedidosNovosDTO;
  sucesso, httpcode, content: string;
  i:Integer;
  json2:TStringList;
  cdsTemp : TClientDataSet;
begin
  if dmAcesso.RESPResponse.JSONValue = nil then
  begin
    lbRetornoTaaki.Caption := 'Erro ao validar (JSON Inválido)';
    CriarLog(mProcesso,'','Erro ao validar (JSON Inválido)');
    exit;
  end;

  try
    jsonObj   := TJSONObject.ParseJSONValue(dmAcesso.RESPResponse.Content) as TJSONObject;

    sucesso  := jsonObj.GetValue('msg').Value;
    httpcode := jsonObj.GetValue('httpCode').Value;
    content  := jsonObj.GetValue('content').ToString;

    if httpcode <> '200' then
    begin
      lbRetornoTaaki.Caption := 'Erro: ' + #10 + httpcode + #10 +content;
      CriarLog(mProcesso+': '+sucesso,httpcode,content);
      exit;
    end
    else
    begin
      if httpcode = '200' then
        lbRetornoTaaki.Caption := 'Processado com Sucesso'
      else
      begin
        lbRetornoTaaki.Caption := 'Erro: ' + httpcode + #10 +content;
        CriarLog(mProcesso+': '+sucesso,httpcode,content);
      end;

      //primeiro crio a resposta da requisição
      DeleteFile(jsonDir+'jsonresp.json');
      Memo2.Clear;
      Memo2.Lines.Add(FormataSaida(sucesso,1));
      Memo2.Lines.Add(FormataSaida(httpcode,2));
      Memo2.Lines.Add(content);
      Memo2.Lines.SaveToFile(jsonDir+'jsonresptmp.json');
      RenameFile(jsonDir+'jsonresptmp.json',jsonDir+'jsonresp.json');

      DeleteFile(jsonDir+'dadospedidotmp.json');
      DeleteFile(jsonDir+'dadospedido.json');

      //em caso de sucesso, crio o json dos pedidos
      if (httpcode = '200') and (content <> '[]') then
      begin
        json2 := TStringList.Create;
        json2.Add(dmAcesso.RESPResponse.Content);
        json2.SaveToFile(jsonDir+'dadospedidotmp.json');
        RenameFile(jsonDir+'dadospedidotmp.json',jsonDir+'dadospedido.json')
      end;
    end;
  finally
    jsonObj.DisposeOf;
    jsonPedido.DisposeOf;
  end;
end;

end.
