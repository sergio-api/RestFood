unit uGrupos;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TGrupos = class
  private
    FDescricao: string;
    FId: Integer;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Id: Integer read FId write FId;
  end;
  
  TRootDTO = class(TJsonDTO)
  private
    FCategorias: TArray<TGrupos>;
  published
    property Categorias: TArray<TGrupos> read FCategorias write FCategorias;
    destructor Destroy; override;
  end;
  
implementation

{ TRootDTO }

destructor TRootDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FCategorias do
    Element.Free;
  inherited;
end;

end.
