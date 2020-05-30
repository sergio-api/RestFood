unit UExportaProdutoCategorias;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TGruposDTO = class
  private
    FId: Integer;
    FDescricao: string;
    FIdcategoriapai: string;
  published
    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Idcategoriapai: string read FIdcategoriapai write FIdcategoriapai;
  end;

  TArrayGruposDTO = array of TGruposDTO;

  TGrupoCategoriaDTO = class
  private
    FCategorias: TArrayGruposDTO;
  published
    property aGrupos: TArrayGruposDTO read FCategorias write FCategorias;
  end;

  TRootDTO = class(TJsonDTO)
  private
    FCategoria: TArray<TGruposDTO>;
  published
    property Categoria: TArray<TGruposDTO> read FCategoria write FCategoria;
    destructor Destroy; override;
  end;

implementation

{ TRootDTO }

destructor TRootDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FCategoria do
    Element.Free;
  inherited;
end;

end.
