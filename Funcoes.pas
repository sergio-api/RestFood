unit Funcoes;

interface
  uses
    SysUtils, WinProcs, Messages, Classes, Graphics, Controls, ComCtrls,
    Forms, Dialogs, StdCtrls, DB, DBCtrls, StrUtils;

  var
    //cripto
    FKey: string;
    FText: string;
    FCriptoBin: string;
    FCriptoHex: string;

function HexToDec(Number: string): Byte;
function CriptoHexToText(SText: string): string;
function CriptoBinToText(SText: string): string;
function Invert(SText: string): string;
function TextToCriptoBin(SText: string): string;
function TextToCriptoHex(SText: string): string;
function DecToHex(Number: Byte): string;
procedure CriarLog(sucesso,httpcode,content:string);

//const
//  GLOBAL_CHAVE_CRYPTO: String = '$&/';  //Chave utilizada atualamente para encryptar e desencryptar

implementation

function HexToDec(Number: string): Byte;
begin
  Number := UpperCase(Number);
  Result := (Pos(Number[1], '0123456789ABCDEF') - 1) * 16;
  Result := Result + (Pos(Number[2], '0123456789ABCDEF') - 1);
end;

function CriptoHexToText(SText: string): string;
var
  SPos: Integer;
begin
  Result := '';
  for SPos := 1 to (Length(SText) div 2) do
    Result := Result + Chr(HexToDec(Copy(SText, ((SPos * 2) - 1), 2)));
  // converte para texto
  Result := CriptoBinToText(Result);
end;

function CriptoBinToText(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  Result := '';
  // converte
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
  // inverte Result
  Result := Invert(Result);
end;

function Invert(SText: string): string;
var
  Position: Integer;
begin
  Result := '';
  for Position := Length(SText) downto 1 do
    Result := Result + SText[Position];
end;

function TextToCriptoBin(SText: string): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
begin
  // inverte texto
  SText := Invert(SText);
  // criptografa
  Result := '';
  for SPos := 1 to Length(SText) do
  begin
    S := Copy(FKey, (SPos mod Length(FKey)) + 1, 1);
    BKey := Ord(S[1]) + SPos;
    Result := Result + Chr(Ord(SText[SPos]) xor BKey);
  end;
end;

function TextToCriptoHex(SText: string): string;
var
  SPos: Integer;
begin
  SText := TextToCriptoBin(SText);
  // converte para hex
  Result := '';
  for SPos := 1 to Length(SText) do
    Result := Result + DecToHex(Ord(SText[SPos]));
end;

function DecToHex(Number: Byte): string;
begin
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1);
  Number := Number div 16;
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1) + Result
end;

procedure CriarLog(sucesso,httpcode,content:string);
var
  NomeDoLog, mDir: string;
  Arquivo: TextFile;
begin
  mDir  := ExtractFilePath(Application.ExeName);

  NomeDoLog := mDir+'\logTaaki.log';
  AssignFile(Arquivo, NomeDoLog);
  if not FileExists(mDir+'\logTaaki.log') then
    ReWrite(Arquivo)
  else
    Append(Arquivo);

  try
    WriteLn(Arquivo,'--------------------------------------------------');
    WriteLn(Arquivo,'data.......: '+DateTimeToStr(Now));
    WriteLn(Arquivo,'transmissão: '+sucesso);
    WriteLn(Arquivo,'httpCode...: '+httpcode );
    WriteLn(Arquivo,'Retorno....: '+content );
  finally
    CloseFile (Arquivo);
  end;
end;

//comentario feito no github
end.
