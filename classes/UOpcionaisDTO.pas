unit UOpcionaisDTO;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TItensDTO = class
  private
    FId: Integer;
    FIdproduto: Integer;
    FIdprodutoopcionais: Integer;
  published
    property Id: Integer read FId write FId;
    property Idproduto: Integer read FIdproduto write FIdproduto;
    property Idprodutoopcionais: Integer read FIdprodutoopcionais write FIdprodutoopcionais;
  end;
  
  TItemDTO = class
  private
    FAtivo: Integer;
    FDescricao: string;
    FId: Integer;
    FIdtipo: Integer;
    FItens: TArray<TItensDTO>;
    FValortotal: string;
  published
    property Ativo: Integer read FAtivo write FAtivo;
    property Descricao: string read FDescricao write FDescricao;
    property Id: Integer read FId write FId;
    property Idtipo: Integer read FIdtipo write FIdtipo;
    property Itens: TArray<TItensDTO> read FItens write FItens;
    property Valortotal: string read FValortotal write FValortotal;
    destructor Destroy; override;
  end;
  
  TOpcionaisDTO = class(TJsonDTO)
  private
    FItems: TArray<TItemDTO>;
  published
    property Items: TArray<TItemDTO> read FItems write FItems;
    destructor Destroy; override;
  end;
  
implementation

{ TItemDTO }

destructor TItemDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FItens do
    Element.Free;
  inherited;
end;

{ TOpcionaisDTO }

destructor TOpcionaisDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FItems do
    Element.Free;
  inherited;
end;

end.
