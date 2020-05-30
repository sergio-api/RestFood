unit UEstabelecimentoRet;

interface

uses
  Pkg.Json.DTO;

{$M+}

type
  TContentDTO = class
  private
    FTaakiToken: string;
    FTaakiToken_Type: string;
    FToken: string;
    FToken_Type: string;
  published
    property TaakiToken: string read FTaakiToken write FTaakiToken;
    property TaakiToken_Type: string read FTaakiToken_Type write FTaakiToken_Type;
    property Token: string read FToken write FToken;
    property Token_Type: string read FToken_Type write FToken_Type;
  end;
  
  TEstabelecimentoRetDTO = class(TJsonDTO)
  private
    FCode: Integer;
    FContent: TContentDTO;
    FHttpCode: string;
    FMsg: string;
    FNavigation: Boolean;
  published
    property Code: Integer read FCode write FCode;
    property Content: TContentDTO read FContent write FContent;
    property HttpCode: string read FHttpCode write FHttpCode;
    property Msg: string read FMsg write FMsg;
    property Navigation: Boolean read FNavigation write FNavigation;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;
  
implementation

{ TEstabelecimentoRetDTO }

constructor TEstabelecimentoRetDTO.Create;
begin
  inherited;
  FContent := TContentDTO.Create;
end;

destructor TEstabelecimentoRetDTO.Destroy;
begin
  FContent.Free;
  inherited;
end;

end.
