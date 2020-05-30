program RESTFood;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {FPrincipal},
  Funcoes in 'Funcoes.pas',
  udmAcesso in 'udmAcesso.pas' {dmAcesso: TDataModule},
  UEstabelecimentoRet in 'classes\UEstabelecimentoRet.pas',
  Pkg.Json.DTO in 'classes\Pkg.Json.DTO.pas',
  UPedidosUn in 'classes\UPedidosUn.pas',
  uPedidosNovos in 'classes\uPedidosNovos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Monitor de Integrações';
  Application.CreateForm(TdmAcesso, dmAcesso);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
