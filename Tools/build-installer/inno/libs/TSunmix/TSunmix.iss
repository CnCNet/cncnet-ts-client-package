[Files]
Source: libs\TSunmix\tsunmix.exe; Flags: dontcopy
Source: libs\TSunmix\global mix database.dat; Flags: dontcopy

[Code]
function TSunMixCMD(workingDir: String; params: String): Integer;
var
  ErrorCode: integer;
begin
  if not FileExists(ExpandConstant('{tmp}\tsunmix.exe')) then ExtractTemporaryFile('tsunmix.exe');
  if not FileExists(ExpandConstant('{tmp}\global mix database.dat')) then ExtractTemporaryFile('global mix database.dat');
  ErrorCode := 1;
  Exec(ExpandConstant('{tmp}\tsunmix.exe'), params, workingDir, SW_HIDE, ewWaitUntilTerminated, ErrorCode);
  Result := ErrorCode;
end;
