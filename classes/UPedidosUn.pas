unit UPedidosUn;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TNavigationDTO = class
  private
    FNext: Boolean;
    FPrev: Boolean;
    FTotal: Integer;
  published
    property Next: Boolean read FNext write FNext;
    property Prev: Boolean read FPrev write FPrev;
    property Total: Integer read FTotal write FTotal;
  end;

  TOpcionaisDTO = class
  private
    FIdpedido: Integer;
    FIdpedidoitem: Integer;
    FIdprodutoopcionais: Integer;
    FQuantidade: string;
    FValortotal: string;
  published
    property Idpedido: Integer read FIdpedido write FIdpedido;
    property Idpedidoitem: Integer read FIdpedidoitem write FIdpedidoitem;
    property Idprodutoopcionais: Integer read FIdprodutoopcionais write FIdprodutoopcionais;
    property Quantidade: string read FQuantidade write FQuantidade;
    property Valortotal: string read FValortotal write FValortotal;
  end;

  TSaboresDTO = class
  end;

  TItensDTO = class
  private
    FDescontomoeda: string;
    FId: Integer;
    FIdpedido: Integer;
    FIdproduto: Integer;
    FNome: string;
    FObservacao: string;
    FOpcionais: TArray<TOpcionaisDTO>;
    FQuantidade: string;
    FSabores: TArray<TSaboresDTO>;
    FValortotal: string;
    FValorunitario: string;
  published
    property Descontomoeda: string read FDescontomoeda write FDescontomoeda;
    property Id: Integer read FId write FId;
    property Idpedido: Integer read FIdpedido write FIdpedido;
    property Idproduto: Integer read FIdproduto write FIdproduto;
    property Nome: string read FNome write FNome;
    property Observacao: string read FObservacao write FObservacao;
    property Opcionais: TArray<TOpcionaisDTO> read FOpcionais write FOpcionais;
    property Quantidade: string read FQuantidade write FQuantidade;
    property Sabores: TArray<TSaboresDTO> read FSabores write FSabores;
    property Valortotal: string read FValortotal write FValortotal;
    property Valorunitario: string read FValorunitario write FValorunitario;
    destructor Destroy; override;
  end;

  TParcelasDTO = class
  private
    FDescricao: string;
    FId: Integer;
    FIdformapagamento: Integer;
    FIdpedido: Integer;
    FValortotal: string;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Id: Integer read FId write FId;
    property Idformapagamento: Integer read FIdformapagamento write FIdformapagamento;
    property Idpedido: Integer read FIdpedido write FIdpedido;
    property Valortotal: string read FValortotal write FValortotal;
  end;

  TClienteDTO = class
  private
    FCelular: string;
    FCpf: string;
    FEmail: string;
    FId: Integer;
    FName: string;
    FNome: string;
    FTelefone: string;
  published
    property Celular: string read FCelular write FCelular;
    property Cpf: string read FCpf write FCpf;
    property Email: string read FEmail write FEmail;
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property Nome: string read FNome write FNome;
    property Telefone: string read FTelefone write FTelefone;
  end;

  TContentDTO = class
  private
    FBairro: string;
    FCep: string;
    FCidade: string;
    FCliente: TClienteDTO;
    FComplemento: string;
    FCpf: string;
    FDescricaoendereco: string;
    FEndereco: string;
    FPontoreferencia: string;
    FIbge: Integer;
    FId: Integer;
    FIdcliente: Integer;
    FIdpedidoproducaostatus: Integer;
    FIdstatus: Integer;
    FItens: TArray<TItensDTO>;
    FNumero: string;
    FObservacao: string;
    FParcelas: TArray<TParcelasDTO>;
    FPontos: Integer;
    FUf: string;
    FValorfrete: string;
    FValortotal: string;
  published
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Cliente: TClienteDTO read FCliente write FCliente;
    property Complemento: string read FComplemento write FComplemento;
    property Cpf: string read FCpf write FCpf;
    property Descricaoendereco: string read FDescricaoendereco write FDescricaoendereco;
    property Endereco: string read FEndereco write FEndereco;
    property Pontoreferencia: string read FPontoreferencia write FPontoreferencia;
    property Ibge: Integer read FIbge write FIbge;
    property Id: Integer read FId write FId;
    property Idcliente: Integer read FIdcliente write FIdcliente;
    property Idpedidoproducaostatus: Integer read FIdpedidoproducaostatus write FIdpedidoproducaostatus;
    property Idstatus: Integer read FIdstatus write FIdstatus;
    property Itens: TArray<TItensDTO> read FItens write FItens;
    property Numero: string read FNumero write FNumero;
    property Observacao: string read FObservacao write FObservacao;
    property Parcelas: TArray<TParcelasDTO> read FParcelas write FParcelas;
    property Pontos: Integer read FPontos write FPontos;
    property Uf: string read FUf write FUf;
    property Valorfrete: string read FValorfrete write FValorfrete;
    property Valortotal: string read FValortotal write FValortotal;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TPedidosDTO = class(TJsonDTO)
  private
    FCode: Integer;
    FContent: TArray<TContentDTO>;
    FHttpCode: Integer;
    FMsg: string;
    FNavigation: TNavigationDTO;
  published
    property Code: Integer read FCode write FCode;
    property Content: TArray<TContentDTO> read FContent write FContent;
    property HttpCode: Integer read FHttpCode write FHttpCode;
    property Msg: string read FMsg write FMsg;
    property Navigation: TNavigationDTO read FNavigation write FNavigation;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TItensDTO }

destructor TItensDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FSabores do
    Element.Free;
  for Element in FOpcionais do
    Element.Free;
  inherited;
end;

{ TContentDTO }

constructor TContentDTO.Create;
begin
  inherited;
  FCliente := TClienteDTO.Create;
end;

destructor TContentDTO.Destroy;
var
  Element: TObject;
begin
  FCliente.Free;
  for Element in FParcelas do
    Element.Free;
  for Element in FItens do
    Element.Free;
  inherited;
end;

{ TPedidosDTO }

constructor TPedidosDTO.Create;
begin
  inherited;
  FNavigation := TNavigationDTO.Create;
end;

destructor TPedidosDTO.Destroy;
var
  Element: TObject;
begin
  FNavigation.Free;
  for Element in FContent do
    Element.Free;
  inherited;
end;

end.