unit firebird.client;

interface

uses Windows, IB_Header, Classes;

type
  {$region 'Firebird Client: Debugger'}
  IFirebirdClientDebuggerListener = interface(IInterface)
  ['{5E724646-C4F6-499E-9C04-38AA81425B47}']
    procedure Update(const aDebugStr: string);
  end;

  IFirebirdClientDebugger = interface(IInterface)
  ['{F9E55F0A-3843-44B3-AA64-5D2EC8211B94}']
    procedure Add(const aListener: IFirebirdClientDebuggerListener);
    procedure Notify(const aDebugStr: string);
  end;

  IFirebirdClientDebugFactory = interface(IInterface)
  ['{2FDB8E26-BA3D-4091-A1B1-176DBA686A7B}']
    function Get(const aProcName: string; const aProc: pointer; const aParams:
        array of const; const aResult: longInt): string;
  end;

  TFirebirdClientDebugger = class(TInterfacedObject, IFirebirdClientDebugger)
  private
    FDebuggerListener: IInterfaceList;
    function GetDebuggerListener: IInterfaceList;
  protected
    procedure Add(const aListener: IFirebirdClientDebuggerListener);
    procedure Notify(const aDebugStr: string);
  end;
  {$endregion}

  IFirebirdClient = interface(IInterface)
  ['{90A53F8C-2F1A-437C-A3CF-97D15D35E1C5}']
    function isc_attach_database(status: pstatus_vector; db_name_len: short;
        db_name: pchar; db_handle: pisc_db_handle; parm_buffer_len: short;
        parm_buffer: pchar): ISC_STATUS; stdcall;
    function isc_commit_transaction(status: pstatus_vector; tr_handle:
        pisc_tr_handle): ISC_STATUS; stdcall;
    procedure isc_decode_sql_date(a: PISC_DATE; b: PISC_LONG);
    procedure isc_decode_sql_time(a: PISC_TIME; b: PISC_LONG);
    procedure isc_decode_timestamp(a: PISC_TIMESTAMP; b: PISC_LONG);
    function isc_detach_database(status: pstatus_vector; db_handle:
        pisc_db_handle): ISC_STATUS; stdcall;
    function isc_dsql_allocate_statement(status: pstatus_vector; db_handle:
        pisc_db_handle; st_handle: pisc_stmt_handle): ISC_STATUS;
    function isc_dsql_alloc_statement2(status: pstatus_vector; a:	pisc_db_handle;
        b:	pisc_stmt_handle): ISC_STATUS; stdcall;
    function isc_dsql_describe(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_describe_bind(status: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_execute(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS;
        stdcall;
    function isc_dsql_execute2(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; a: word; d: PXSQLDA; e: PXSQLDA): ISC_STATUS;
        stdcall;
    function isc_dsql_execute_immediate(status: pstatus_vector; db_handle:
        pisc_db_handle; tr_handle: pisc_tr_handle; length: word; statement: PChar;
        dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_fetch(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; fields: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_free_statement(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; option: word): ISC_STATUS; stdcall;
    function isc_dsql_prepare(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; len: word; statement: pchar; dialect: word;
        params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_sql_info(status: pstatus_vector; st_handle: pisc_stmt_handle;
        item_length: short; items: pchar; buffer_length: short; result_buffer:
        pchar): ISC_STATUS; stdcall;
    procedure isc_encode_sql_date(a: pointer; b: PISC_DATE);
    procedure isc_encode_sql_time(a: pointer; b: PISC_TIME);
    procedure isc_encode_timestamp(a: pointer; b: PISC_TIMESTAMP);
    function isc_interprete(buffer: PChar; status: ppstatus_vector): ISC_STATUS;
        stdcall;
    function isc_rollback_transaction(status: pstatus_vector; tr_handle:
        pisc_tr_handle): ISC_STATUS; stdcall;
    function isc_sqlcode(status: PISC_STATUS): ISC_LONG; stdcall;
    function isc_start_multiple(status: pstatus_vector; tr_handle: pisc_tr_handle;
        db_handle_count: short; teb_vector_address: pointer): ISC_STATUS; stdcall;
    function isc_vax_integer(a: pchar; b: short): ISC_LONG; stdcall;
    procedure Setup(const aHandle: THandle);
  end;

  TFirebirdClient = class(TInterfacedObject, IFirebirdClient)
  strict private
    FDebugFactory: IFirebirdClientDebugFactory;
    FDebugger: IFirebirdClientDebugger;
    FProcs: TStringList;
    function Call(const aProc: pointer; const aParams: array of const): ISC_STATUS;
    function GetProc(const aHandle: THandle; const aProcName: PAnsiChar): pointer;
  private
    Fisc_attach_database: Tisc_attach_database;
    Fisc_commit_transaction: Tisc_commit_transaction;
    Fisc_decode_sql_date: Tisc_decode_sql_date;
    Fisc_decode_sql_time: Tisc_decode_sql_time;
    Fisc_decode_timestamp: Tisc_decode_timestamp;
    Fisc_detach_database: Tisc_detach_database;
    Fisc_dsql_allocate_statement: Tisc_dsql_allocate_statement;
    Fisc_dsql_alloc_statement2: Tisc_dsql_alloc_statement2;
    Fisc_dsql_describe: Tisc_dsql_describe;
    Fisc_dsql_describe_bind: Tisc_dsql_describe_bind;
    Fisc_dsql_execute: Tisc_dsql_execute;
    Fisc_dsql_execute2: Tisc_dsql_execute2;
    Fisc_dsql_execute_immediate: Tisc_dsql_execute_immediate;
    Fisc_dsql_fetch: Tisc_dsql_fetch;
    Fisc_dsql_free_statement: Tisc_dsql_free_statement;
    Fisc_dsql_prepare: Tisc_dsql_prepare;
    Fisc_dsql_sql_info: Tisc_dsql_sql_info;
    Fisc_encode_sql_date: Tisc_encode_sql_date;
    Fisc_encode_sql_time: Tisc_encode_sql_time;
    Fisc_encode_timestamp: Tisc_encode_timestamp;
    Fisc_interprete: Tisc_interprete;
    Fisc_rollback_transaction: Tisc_rollback_transaction;
    Fisc_sqlcode: Tisc_sqlcode;
    Fisc_start_multiple: Tisc_start_multiple;
    Fisc_vax_integer: Tisc_vax_integer;
  protected
    function isc_attach_database(status: pstatus_vector; db_name_len: short;
        db_name: pchar; db_handle: pisc_db_handle; parm_buffer_len: short;
        parm_buffer: pchar): ISC_STATUS; stdcall;
    function isc_commit_transaction(status: pstatus_vector; tr_handle:
        pisc_tr_handle): ISC_STATUS; stdcall;
    procedure isc_decode_sql_date(a: PISC_DATE; b: PISC_LONG);
    procedure isc_decode_sql_time(a: PISC_TIME; b: PISC_LONG);
    procedure isc_decode_timestamp(a: PISC_TIMESTAMP; b: PISC_LONG);
    function isc_detach_database(status: pstatus_vector; db_handle:
        pisc_db_handle): ISC_STATUS; stdcall;
    function isc_dsql_allocate_statement(status: pstatus_vector; db_handle:
        pisc_db_handle; st_handle: pisc_stmt_handle): ISC_STATUS;
    function isc_dsql_alloc_statement2(status: pstatus_vector; a:	pisc_db_handle;
        b:	pisc_stmt_handle): ISC_STATUS; stdcall;
    function isc_dsql_describe(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_describe_bind(status: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_execute(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS;
        stdcall;
    function isc_dsql_execute2(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; a: word; d: PXSQLDA; e: PXSQLDA): ISC_STATUS;
        stdcall;
    function isc_dsql_execute_immediate(status: pstatus_vector; db_handle:
        pisc_db_handle; tr_handle: pisc_tr_handle; length: word; statement: PChar;
        dialect: word; params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_fetch(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; dialect: word; fields: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_free_statement(status_vector: pstatus_vector; st_handle:
        pisc_stmt_handle; option: word): ISC_STATUS; stdcall;
    function isc_dsql_prepare(status: pstatus_vector; tr_handle: pisc_tr_handle;
        st_handle: pisc_stmt_handle; len: word; statement: pchar; dialect: word;
        params: PXSQLDA): ISC_STATUS; stdcall;
    function isc_dsql_sql_info(status: pstatus_vector; st_handle: pisc_stmt_handle;
        item_length: short; items: pchar; buffer_length: short; result_buffer:
        pchar): ISC_STATUS; stdcall;
    procedure isc_encode_sql_date(a: pointer; b: PISC_DATE);
    procedure isc_encode_sql_time(a: pointer; b: PISC_TIME);
    procedure isc_encode_timestamp(a: pointer; b: PISC_TIMESTAMP);
    function isc_interprete(buffer: PChar; status: ppstatus_vector): ISC_STATUS;
        stdcall;
    function isc_rollback_transaction(status: pstatus_vector; tr_handle:
        pisc_tr_handle): ISC_STATUS; stdcall;
    function isc_sqlcode(status: PISC_STATUS): ISC_LONG; stdcall;
    function isc_start_multiple(status: pstatus_vector; tr_handle: pisc_tr_handle;
        db_handle_count: short; teb_vector_address: pointer): ISC_STATUS; stdcall;
    function isc_vax_integer(a: pchar; b: short): ISC_LONG; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    procedure Setup(const aHandle: THandle);
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  IFirebirdError = interface(IInterface)
  ['{5D89C7AC-544B-4170-AF0F-79AD05265BC5}']
    procedure GetMessage(const aMsg: PWideChar); overload;
    function GetMessage: string; overload;
    function GetLength: Smallint;
  end;

  TFirebirdError = class(TInterfacedObject, IFirebirdError)
  private
    FMessage: string;
  protected
    procedure GetMessage(const aMsg: PWideChar); overload;
    function GetMessage: string; overload;
    function GetLength: Smallint;
  public
    constructor Create(const aErrorMessage: string);
  end;

  IStatusVector = interface(IInterface)
  ['{A51BBF0A-0565-4397-AFBE-ED0DD7BAF3BC}']
    function CheckError(const aFirebirdClient: IFirebirdClient; out aErrorCode:
        longint): boolean;
    function CheckResult(out aResult: word; const aFailed_Result: word): Boolean;
    function GetError(const aFirebirdClient: IFirebirdClient): IFirebirdError;
    function GetLastError: IFirebirdError;
    function GetpValue: pstatus_vector;
    property pValue: pstatus_vector read GetpValue;
  end;

  TStatusVector = class(TInterfacedObject, IStatusVector)
  private
    FError: IFirebirdError;
    FStatusVector: status_vector;
  protected
    function CheckError(const aFirebirdClient: IFirebirdClient; out aErrorCode:
        longint): boolean;
    function CheckResult(out aResult: word; const aFailed_Result: word): Boolean;
    function GetError(const aFirebirdClient: IFirebirdClient): IFirebirdError;
    function GetLastError: IFirebirdError;
    function GetpValue: pstatus_vector;
  public
  end;

  TFirebirdClientFactory = class abstract
  public
    class function New(const aHandle: THandle): IFirebirdClient;
  end;

implementation

uses SysUtils, firebird.client.debug;

procedure TFirebirdClient.AfterConstruction;
begin
  inherited;
  FProcs := TStringList.Create;
  FDebugger := TFirebirdClientDebugger.Create;
  FDebugFactory := TFirebirdClientDebugFactory.Create;
end;

procedure TFirebirdClient.BeforeDestruction;
begin
  inherited;
  FProcs.Free;
end;

function TFirebirdClient.Call(const aProc: pointer; const aParams: array of
    const): ISC_STATUS;
var i: integer;
    aInteger: integer;
    aPointer: pointer;
    aPChar: PChar;
    sDebug: PAnsiChar;
begin
  for i := High(aParams) downto Low(aParams) do begin
    case aParams[i].VType of
      vtInteger: begin
        aInteger := aParams[i].VInteger;
        asm
          push dword [aInteger];
        end;
      end;
      vtPointer: begin
        aPointer := aParams[i].VPointer;
        asm
          push dword [aPointer];
        end;
      end;
      vtPChar: begin
        aPChar := aParams[i].VPChar;
        asm
          push dword [aPChar];
        end;
      end
      else
        raise Exception.CreateFmt('Unsupported data type: %d', [aParams[i].VType]);
    end;
  end;

  asm
    call aProc;
    mov  [Result],eax;
  end;

  if True then begin
    i := FProcs.IndexOfObject(aProc);
    Assert(i <> -1);
    sDebug := PAnsiChar(FDebugFactory.Get(FProcs[i], aProc, aParams, Result));
    FDebugger.Notify(sDebug);
  end;
end;

function TFirebirdClient.GetProc(const aHandle: THandle; const aProcName:
    PAnsiChar): pointer;
begin
  Result := GetProcAddress(aHandle, aProcName);
  FProcs.AddObject(aProcName, Result);
  if Result = nil then
    RaiseLastOSError;
end;

function TFirebirdClient.isc_attach_database(status: pstatus_vector;
  db_name_len: short; db_name: pchar; db_handle: pisc_db_handle;
  parm_buffer_len: short; parm_buffer: pchar): ISC_STATUS;
begin
  Result := Call(@Fisc_attach_database, [status, db_name_len, db_name, db_handle, parm_buffer_len, parm_buffer]);
end;

function TFirebirdClient.isc_commit_transaction(status: pstatus_vector;
  tr_handle: pisc_tr_handle): ISC_STATUS;
begin
  Result := Call(@Fisc_commit_transaction, [status, tr_handle]);
end;

procedure TFirebirdClient.isc_decode_sql_date(a: PISC_DATE; b: PISC_LONG);
begin
  Call(@Fisc_decode_sql_date, [a, b]);
end;

procedure TFirebirdClient.isc_decode_sql_time(a: PISC_TIME; b: PISC_LONG);
begin
  Call(@Fisc_decode_sql_time, [a, b]);
end;

procedure TFirebirdClient.isc_decode_timestamp(a: PISC_TIMESTAMP;
  b: PISC_LONG);
begin
  Call(@Fisc_decode_timestamp, [a, b]);
end;

function TFirebirdClient.isc_detach_database(status: pstatus_vector;
  db_handle: pisc_db_handle): ISC_STATUS;
begin
  Result := Call(@Fisc_detach_database, [status, db_handle]);
end;

function TFirebirdClient.isc_dsql_allocate_statement(
  status: pstatus_vector; db_handle: pisc_db_handle;
  st_handle: pisc_stmt_handle): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_allocate_statement, [status, db_handle, st_handle]);
end;

function TFirebirdClient.isc_dsql_alloc_statement2(status: pstatus_vector;
  a: pisc_db_handle; b: pisc_stmt_handle): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_alloc_statement2, [status, a, b]);
end;

function TFirebirdClient.isc_dsql_describe(status_vector: pstatus_vector;
  st_handle: pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_describe, [status_vector, st_handle, dialect, params]);
end;

function TFirebirdClient.isc_dsql_describe_bind(status: pstatus_vector;
  st_handle: pisc_stmt_handle; dialect: word; params: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_describe_bind, [status, st_handle, dialect, params]);
end;

function TFirebirdClient.isc_dsql_execute(status: pstatus_vector;
  tr_handle: pisc_tr_handle; st_handle: pisc_stmt_handle; dialect: word;
  params: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_execute, [status, tr_handle, st_handle, dialect, params]);
end;

function TFirebirdClient.isc_dsql_execute2(status: pstatus_vector;
  tr_handle: pisc_tr_handle; st_handle: pisc_stmt_handle; a: word; d,
  e: PXSQLDA): ISC_STATUS;
begin
  Result := call(@Fisc_dsql_execute2, [status, tr_handle, st_handle, a, d, e]);
end;

function TFirebirdClient.isc_dsql_execute_immediate(status: pstatus_vector;
  db_handle: pisc_db_handle; tr_handle: pisc_tr_handle; length: word;
  statement: PChar; dialect: word; params: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_execute_immediate, [status, db_handle, tr_handle, length, statement, dialect, params]);
end;

function TFirebirdClient.isc_dsql_fetch(status_vector: pstatus_vector;
  st_handle: pisc_stmt_handle; dialect: word; fields: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_fetch, [status_vector, st_handle, dialect, fields]);
end;

function TFirebirdClient.isc_dsql_free_statement(
  status_vector: pstatus_vector; st_handle: pisc_stmt_handle;
  option: word): ISC_STATUS;
begin
  Result := call(@Fisc_dsql_free_statement, [status_vector, st_handle, option]);
end;

function TFirebirdClient.isc_dsql_prepare(status: pstatus_vector;
  tr_handle: pisc_tr_handle; st_handle: pisc_stmt_handle; len: word;
  statement: pchar; dialect: word; params: PXSQLDA): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_prepare, [status, tr_handle, st_handle, len, statement, dialect, params]);
end;

function TFirebirdClient.isc_dsql_sql_info(status: pstatus_vector;
  st_handle: pisc_stmt_handle; item_length: short; items: pchar;
  buffer_length: short; result_buffer: pchar): ISC_STATUS;
begin
  Result := Call(@Fisc_dsql_sql_info, [status, st_handle, item_length, items, buffer_length, result_buffer]);
end;

procedure TFirebirdClient.isc_encode_sql_date(a: pointer; b: PISC_DATE);
begin
  Call(@Fisc_encode_sql_date, [a, b]);
end;

procedure TFirebirdClient.isc_encode_sql_time(a: pointer; b: PISC_TIME);
begin
  Call(@Fisc_encode_sql_time, [a, b]);
end;

procedure TFirebirdClient.isc_encode_timestamp(a: pointer;
  b: PISC_TIMESTAMP);
begin
  Call(@Fisc_encode_timestamp, [a, b]);
end;

function TFirebirdClient.isc_interprete(buffer: PChar;
  status: ppstatus_vector): ISC_STATUS;
begin
  Result := Call(@Fisc_interprete, [buffer, status]);
end;

function TFirebirdClient.isc_rollback_transaction(status: pstatus_vector;
  tr_handle: pisc_tr_handle): ISC_STATUS;
begin
  Result := Call(@Fisc_rollback_transaction, [status, tr_handle]);
end;

function TFirebirdClient.isc_sqlcode(status: PISC_STATUS): ISC_LONG;
begin
  Result := Call(@Fisc_sqlcode, [status]);
end;

function TFirebirdClient.isc_start_multiple(status: pstatus_vector;
  tr_handle: pisc_tr_handle; db_handle_count: short;
  teb_vector_address: pointer): ISC_STATUS;
begin
  Result := Call(@Fisc_start_multiple, [status, tr_handle, db_handle_count, teb_vector_address]);
end;

function TFirebirdClient.isc_vax_integer(a: pchar; b: short): ISC_LONG;
begin
  Result := Call(@Fisc_vax_integer, [a, b]);
end;

function TFirebirdClient.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(IID, IFirebirdClientDebugger) then begin
    IFirebirdClientDebugger(Obj) := FDebugger;
    Result := S_OK;
  end else
    Result := inherited QueryInterface(IID, Obj);
end;

procedure TFirebirdClient.Setup(const aHandle: THandle);
begin
  Fisc_attach_database         := GetProc(aHandle, 'isc_attach_database');
  Fisc_commit_transaction      := GetProc(aHandle, 'isc_commit_transaction');
  Fisc_decode_sql_date         := GetProc(aHandle, 'isc_decode_sql_date');
  Fisc_decode_sql_time         := GetProc(aHandle, 'isc_decode_sql_time');
  Fisc_decode_timestamp        := GetProc(aHandle, 'isc_decode_timestamp');
  Fisc_detach_database         := GetProc(aHandle, 'isc_detach_database');
  Fisc_dsql_allocate_statement := GetProc(aHandle, 'isc_dsql_allocate_statement');
  Fisc_dsql_alloc_statement2   := GetProc(aHandle, 'isc_dsql_alloc_statement2');
  Fisc_dsql_describe           := GetProc(aHandle, 'isc_dsql_describe');
  Fisc_dsql_describe_bind      := GetProc(aHandle, 'isc_dsql_describe_bind');
  Fisc_dsql_execute            := GetProc(aHandle, 'isc_dsql_execute');
  Fisc_dsql_execute2           := GetProc(aHandle, 'isc_dsql_execute2');
  Fisc_dsql_execute_immediate  := GetProc(aHandle, 'isc_dsql_execute_immediate');
  Fisc_dsql_fetch              := GetProc(aHandle, 'isc_dsql_fetch');
  Fisc_dsql_free_statement     := GetProc(aHandle, 'isc_dsql_free_statement');
  Fisc_dsql_prepare            := GetProc(aHandle, 'isc_dsql_prepare');
  Fisc_dsql_sql_info           := GetProc(aHandle, 'isc_dsql_sql_info');
  Fisc_encode_sql_date         := GetProc(aHandle, 'isc_encode_sql_date');
  Fisc_encode_sql_time         := GetProc(aHandle, 'isc_encode_sql_time');
  Fisc_encode_timestamp        := GetProc(aHandle, 'isc_encode_timestamp');
  Fisc_interprete              := GetProc(aHandle, 'isc_interprete');
  Fisc_rollback_transaction    := GetProc(aHandle, 'isc_rollback_transaction');
  Fisc_sqlcode                 := GetProc(aHandle, 'isc_sqlcode');
  Fisc_start_multiple          := GetProc(aHandle, 'isc_start_multiple');
  Fisc_vax_integer             := GetProc(aHandle, 'isc_vax_integer');
end;

class function TFirebirdClientFactory.New(
  const aHandle: THandle): IFirebirdClient;
var L: IFirebirdClient;
begin
  L := TFirebirdClient.Create;
  try
    L.Setup(aHandle);
  except
    L := nil;
  end;
  Result := L;
end;

function TStatusVector.CheckError(const aFirebirdClient: IFirebirdClient; out
    aErrorCode: longint): boolean;
begin
  aErrorCode := 0;
  if (FStatusVector[0] = 1) and (FStatusVector[1] > 0) then
    aErrorCode := aFirebirdClient.isc_sqlcode(PISC_STATUS(GetpValue));
  Result := aErrorCode <> 0;
end;

function TStatusVector.CheckResult(out aResult: word; const aFailed_Result:
    word): Boolean;
begin
  aResult := 0;
  if (FStatusVector[0] = 1) and (FStatusVector[1] > 0) then
    aResult := aFailed_Result;
  Result := aResult = 0;
end;

function TStatusVector.GetError(const aFirebirdClient: IFirebirdClient):
    IFirebirdError;
var P: array [0..511] of char;
    ptr: pstatus_vector;
    sError: string;
begin
  sError := '';
  ptr := GetpValue;
  while aFirebirdClient.isc_interprete(P, @ptr) > 0 do
    sError := sError + P;

  FError := nil;
  FError := TFirebirdError.Create(sError);
  Result := FError;
end;

function TStatusVector.GetpValue: pstatus_vector;
begin
  Result := @FStatusVector;
end;

function TStatusVector.GetLastError: IFirebirdError;
begin
  Result := FError;
end;

{ TFirebirdClientDebugger }

procedure TFirebirdClientDebugger.Add(
  const aListener: IFirebirdClientDebuggerListener);
begin
  GetDebuggerListener.Add(aListener);
end;

function TFirebirdClientDebugger.GetDebuggerListener: IInterfaceList;
begin
  if FDebuggerListener = nil then
    FDebuggerListener := TInterfaceList.Create;
  Result := FDebuggerListener;
end;

procedure TFirebirdClientDebugger.Notify(const aDebugStr: string);
var i: integer;
begin
  for i := 0 to GetDebuggerListener.Count - 1 do
    (GetDebuggerListener[i] as IFirebirdClientDebuggerListener).Update(aDebugStr);
end;

{ TFirebirdError }

constructor TFirebirdError.Create(const aErrorMessage: string);
begin
  inherited Create;
  FMessage := aErrorMessage;
end;

function TFirebirdError.GetLength: Smallint;
begin
  Result := Length(FMessage);
end;

function TFirebirdError.GetMessage: string;
begin
  Result := FMessage;
end;

procedure TFirebirdError.GetMessage(const aMsg: PWideChar);
var W: WideString;
begin
  W := FMessage;
  lstrcpyW(aMsg, PWideChar(W));
end;

end.