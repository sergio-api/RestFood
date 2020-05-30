unit uHorarioFuncionamento;

interface

uses
  Pkg.Json.DTO;

{$M+}
type

  THorarioDiaDTO = class
  private
    FDia: Integer;
    FPrimeiroturnoinicio: string;
    FPrimeiroturnofim: string;
    FSegundoturnoinicio: string;
    FSegundoturnofim: string;
    FTerceiroturnoinicio: string;
    Fterceiroturnofim: string;
    FQuartoturnoinicio: string;
    FQuartoturnofim: string;
  published
    property Dia: Integer read FDia write FDia;
    property Primeiroturnoinicio: string read FPrimeiroturnoinicio write FPrimeiroturnoinicio;
    property Primeiroturnofim: string read FPrimeiroturnofim write FPrimeiroturnofim;
    property Segundoturnoinicio: string read FSegundoturnoinicio write FSegundoturnoinicio;
    property Segundoturnofim: string read FSegundoturnofim write FSegundoturnofim;
    property Terceiroturnoinicio: string read FTerceiroturnoinicio write FTerceiroturnoinicio;
    property Terceiroturnofim: string read FTerceiroturnofim write Fterceiroturnofim;
    property Quartoturnoinicio: string read FQuartoturnoinicio write FQuartoturnoinicio;
    property Quartoturnofim: string read FQuartoturnofim write FQuartoturnofim;
  end;

  TArrayHorariosDTO = array of THorarioDiaDTO;

  TCategoriaDTO = class
  private
    Fidcategoria: Integer;
    FHorarios: TArrayHorariosDTO;
  published
    property idcategoria : Integer read Fidcategoria write Fidcategoria;
    property Horarios: TArrayHorariosDTO read FHorarios write FHorarios;
  end;


  TRootDTO = class(TJsonDTO)
  private
    FHorarioDia: TArray<THorarioDiaDTO>;
    FIdcategoria: Integer;
  published
    property Horarios: TArray<THorarioDiaDTO> read FHorarioDia write FHorarioDia;
    property Idcategoria: Integer read FIdcategoria write FIdcategoria;
    destructor Destroy; override;
  end;

implementation

{ TRootDTO }

destructor TRootDTO.Destroy;
var
  Element: TObject;
begin
  for Element in FHorarioDia do
    Element.Free;
  inherited;
end;

end.
