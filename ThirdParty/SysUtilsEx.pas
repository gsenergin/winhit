{******************************************************************************}
{                                                                              }
{                               UNIT SysUtilsEx                                }
{                                                                              }
{  В этом модуле содержатся различные полезные процедуры и функции.            }
{  This unit contains miscellaneous useful routines.                           }
{                                                                              }
{                       Copyright © 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ИСТОРИЯ ВЕРСИЙ / VERSION HISTORY:

  (1.17 | 27.09.2010)
    [+] GetByte function added.

  (1.16 | 13.09.2010)
    [!] Code review finished. Several methods were optimized.

  (1.15 | 07.09.2010)
    [*] GetWindowsVersion function has now out parameter instead of var.
    [*] DeleteToken function was refactored and optimized.
    [*] If..Then condition "(Length(String) = 0)" was replaced
        with "(String = '')" condition. I think it'll work a bit faster.
    [!] Code review started.

  (1.14 | 24.08.2010)
    [*] Source code fully re-formatted.
    [*] RemoveDir function updated.
        AbortOnSingleCopyFail parameter renamed to AbortOnSingleDelFail.
    [*] String typecast removed from DecEx function.
    [*] StripFileSystemProhibitedChars function updated.
        IgnoreDirsDelimiters parameter renamed to IgnorePathDelimiters.
    [*] Both overloaded FormatTime functions updated.
        Original FormatTime function now returns remaining milliseconds in
        Milliseconds : UInt64 parameter. Simplified FormatTime function
        was changed according to original function changes.

  (1.13 | 23.08.2010)
    [*] GetFileVersion function updated to use ExpandFileName function.

  (1.12 | 20.08.2010)
    [+] GetFileSize function added.

  (1.11 | 19.07.2010)
    [+] GetAppDir function added.

  (1.10 | 11.06.2010)
    [*] Updated CreateDirEx and StripFileSystemProhibitedChars functions
        to use PathDelim and DriveDelim constants from SysUtils.pas unit.

  (1.9 | 06.06.2010)
    [+] IsCurrentWinEditionSupported function added.
    [+] IsCurrentWinVersionSupported function added.
    [+] GetWindowsVersion function added.

  (1.8 | 09.04.2010)
    [+] RemoveDir function added.

  (1.7 | 08.04.2010)
    [!] CopyDir function fixed.

  (1.6 | 27.03.2010)
    [+] $WARN SYMBOL_PLATFORM OFF directive added.
    [+] CopyDir function added.
    [+] Some inlining added.
    [*] TStringTokens class methods are regular functions now.
    [-] TStringTokens class removed.
    [*] Code refactoring.

  (1.5 | 21.03.2010)
    [+] Added overloaded IsMostSignificantBitSet & IsMSBSet functions with
        Integer parameter.

  (1.4 | 20.03.2010)
    [*] GetToken & TokensNum methods optimized.
    [+] Some comments added.
    [*] Code reorganization.
    [+] Token as TStringTokens alias added.

  (1.3 | 14.03.2010)
    [*] WHILE cycle was replaced with FOR cycle in RepeatStr function.
    [!] Bug fix for GetToken method.
    [+] IsLowerCase & IsUpperCase functions added.

  (1.2 | 13.03.2010)
    [*] Updated RepeatStr function to use code from DupeString from StrUtils.pas.
    [+] CharInString function added.
    [+] CharInArray function added.
    [*] Updated FormatTime function to use some constants from SysUtils.pas.

  (1.1 | 12.03.2010)
    [!] Bug fix for GetToken & TokensNum methods.

  (1.0 | 10.03.2010)
    Первый релиз модуля.
    First unit release.

}

unit SysUtilsEx;

{$BOOLEVAL OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Classes, SysUtils, StrUtils, DateUtils, Graphics;

type

  ///  Верхняя граница при форматировании времени:
  ///  The top constraint for time formatting:
  TFormatTimeConstraint = (ftcWeeks, ftcDays, ftcHours, ftcMinutes, ftcSeconds);

{$REGION 'Detecting Windows version'}
  ///  Версии Windows:
  ///  Windows versions:
  TWinVersion = (wvUnknown, wv2000, wvXP, wvXPPro64, wvServer2003, wvServer2003R2,
                 wvStorageServer2003, wvHomeServer, wvVista, wvServer2008,
                 wvServer2008R2, wvSe7en);

  TWinVersions = set of TWinVersion;

  ///  Редакции Windows:
  ///  Windows editions:
  TWinEdition = (weBusiness, weClusterServer, weDatacenterServer, weEnterprise,
                 weEnterpriseServer, weHomeBasic, weHomePremium, weHyperVServer,
                 weMediumBusinessServer, weProfessional, weServerForSmallBusiness,
                 weServerFoundation, weSmallBusinessServer, weStandardServer,
                 weStarter, weStorageServer, weUnknown, weUltimate, weWebServer,
                 // Additional stuff for old versions of windows:
                 weXPHome, weDatacenterIA64, weEnterpriseIA64, weDatacenter64,
                 weEnterprise64, weStandard64, weComputeCluster, weDatacenter,
                 weWeb, weStandard, we2000AdvancedServer, we2000Server);

  TWinEditions = set of TWinEdition;

  ///  Структура для хранения версии сервис-пака:
  ///  Service pack version structure:
  TWinSPVersion = record
    Major, Minor : Cardinal;
  end;

  ///  Архитектура процессора, на котором выполняется Windows:
  ///  Architecture of the processor Windows are running on:
  TWinProcessorArchitecture = (pa32bit, pa64bit, paUnknown);

  ///  Структура для хранения версии Windows:
  ///  Windows version info structure:
  TWindowsVersion = record
    Version       : TWinVersion;
    Edition       : TWinEdition;
    ServicePack   : TWinSPVersion;
    ProcessorArch : TWinProcessorArchitecture;
    CSDVersion    : String;
    ToString      : String;
  end;
{$ENDREGION}

{$REGION 'Exported routines'}
  {$REGION 'Tokens'}
    function  AddToken(const Text, Token, Separator : String) : String;
    function  DeleteToken(const Text : String; const Index : Cardinal;
                          const Separator : String) : String; overload; inline;
    function  DeleteToken(const Text : String; const StartIndex, EndIndex : Cardinal;
                          const Separator : String) : String; overload;
    function  EndsWithSeparator(const Text, Separator : String) : Boolean;
    function  FindToken(const Text, Token : String; const Num : Cardinal;
                        const Separator : String) : Cardinal;
    function  GetToken(const Text : String; const Index : Cardinal;
                       const Separator : String) : String; overload;
    function  GetToken(const Text : String; const StartIndex, EndIndex : Cardinal;
                       const Separator : String) : String; overload;
    function  GetToken(const Text : String; const Index : Cardinal;
                       const Separator : String; out TokenPos,
                       TokenLength : Integer) : String; overload;
    function  InsertToken(const Text, Token : String; const Index : Cardinal;
                          const Separator : String) : String;
    function  MatchingToken(const Text, Substring : String; const Index : Cardinal;
                            const Separator : String) : Cardinal;
    function  PutToken(const Text, Token : String; const Index : Cardinal;
                       const Separator : String) : String;
    function  RemoveToken(const Text, Token : String; const Num : Cardinal;
                          const Separator : String) : String;
    function  ReplaceToken(const Text, OldToken, NewToken : String;
                           const Num : Cardinal; const Separator : String) : String;
    function  TokenExists(const Text, Token, Separator : String) : Boolean;
    function  TokensNum(const Text, Separator : String) : Cardinal;
    function  StartsWithSeparator(const Text, Separator : String) : Boolean;
  {$ENDREGION}
  function  AnsiPosEx(const SubStr, S : String; const Offset : Integer = 1;
                      const IgnoreCase : Boolean = True) : Integer;
  function  BinToHex(const BinValue : String; const Digits : Integer = 8;
                     const CPPStyle : Boolean = True) : String;
  function  BinToInt(const BinValue : String) : UInt64;
  function  CopyDir(const SourceDir, TargetDir : String; const CanCreateTargetDir,
                    AbortOnSingleCopyFail, OverwriteExistingFiles : Boolean) : Boolean;
  function  CreateDirEx(const Path : String) : Boolean;
  function  CharInArray(const C : Char; const CharArray : TCharArray;
                        const IgnoreCase : Boolean = True) : Boolean; inline;
  function  CharInString(const C : Char; const S : String;
                         const IgnoreCase : Boolean = True) : Boolean; inline;
  function  DeleteEx(const S : String; const StartIndex, EndIndex : Integer) : String;
  function  FileTimeToDateTime(const FileTime : TFileTime) : TDateTime;
  function  FormatSize(const Size : UInt64; const Precise : Byte = 2) : String;
  function  FormatTime(var Milliseconds : UInt64; out Weeks, Days, Hours,
                       Minutes, Seconds : Cardinal;
                       const Constraint : TFormatTimeConstraint = ftcHours;
                       const ShowMilliseconds : Boolean = False) : String; overload;
  function  FormatTime(const Milliseconds : UInt64;
                       const Constraint : TFormatTimeConstraint = ftcHours;
                       const ShowMilliseconds : Boolean = False) : String; overload;
  function  GetAppDir : String; inline;
  function  GetByte(const Value : LongInt; const BytePos : Byte) : Byte; inline;
  function  GetFileSize(const FileName : String) : Int64;
  function  GetFileVersion(const FileName : String; out Major, Minor, Release,
                           Build : Integer) : String; overload;
  function  GetFileVersion(const FileName : String) : String; overload;
  function  GetSelfVersion(out Major, Minor, Release,
                           Build : Integer) : String; overload; inline;
  function  GetSelfVersion : String; overload;
  function  GetWindowsVersion(out WindowsVersion : TWindowsVersion) : Boolean;
  function  HexToBin(const HexValue : String) : String;
  function  HexToInt(const HexValue : String) : Integer;
  function  HexToInt64(const HexValue : String) : Int64;
  function  HTMLToTColor(const HTMLColorValue : String) : TColor;
  function  IntToBin(const Value : UInt64) : String;
  function  IntToHexEx(const Value : Integer; const Digits : Integer = 8;
                       const CPPStyle : Boolean = True) : String; overload;
  function  IntToHexEx(const Value : Int64; const Digits : Integer = 8;
                       const CPPStyle : Boolean = True) : String; overload;
  function  IsBinary(const Value : String) : Boolean;
  function  IsFloat(const Value : String) : Boolean;
  function  IsHex(const Value : String) : Boolean;
  function  IsHexInCPPStyle(const HexValue : String) : Boolean;
  function  IsHTMLColor(const Value : String) : Boolean;
  function  IsInteger(const Value : String) : Boolean;
  function  IsLowerCase(const C : Char) : Boolean; overload; inline;
  function  IsLowerCase(const S : String) : Boolean; overload; inline;
  function  IsMostSignificantBitSet(const Value : Byte) : Boolean; overload; inline;
  function  IsMostSignificantBitSet(const Value : Integer) : Boolean; overload;
  function  IsMostSignificantBitSet(const Value : Int64) : Boolean; overload;
  function  IsMSBSet(const Value : Byte) : Boolean; overload; inline;
  function  IsMSBSet(const Value : Integer) : Boolean; overload; inline;
  function  IsMSBSet(const Value : Int64) : Boolean; overload; inline;
  function  IsUpperCase(const C : Char) : Boolean; overload; inline;
  function  IsUpperCase(const S : String) : Boolean; overload; inline;
  function  IsCurrentWinEditionSupported(const WinEditions : TWinEditions) : Boolean;
  function  IsCurrentWinVersionSupported(const WinVersions : TWinVersions) : Boolean;
  function  RemoveDir(const Dir : String;
                      const AbortOnSingleDelFail : Boolean = False) : Boolean;
  function  RepeatStr(const S : String; const RepeatTimes : Integer;
                      const Delimiter : String = '') : String;
  function  TColorToHTML(const ColorValue : TColor) : String; inline;
  function  ValidateFileName(const FileName : String;
                             const IgnorePathDelimiters : Boolean = False) : String;
  procedure WaitForThreadTermination(const Thread : TThread); inline;
{$ENDREGION}

implementation

{$REGION 'Tokens'}
//------------------------------------------------------------------------------

///  Добавляет токен в конец текста, но только если в тексте уже нет такого токена:
///  Adds a token to the end of text but only if it's not already in text.
function AddToken(const Text, Token, Separator : String) : String;
begin
  If TokenExists(Text, Token, Separator) Then Result := Text
  Else
  begin
    If EndsWithSeparator(Text, Separator)
    Then Result := Text + Token
    Else Result := Text + Separator + Token;
    // Удаляем лишний Separator:
    If (Text = '') Or
       (StartsWithSeparator(Text, Separator) And (Length(Text) = Length(Separator)))
    Then Delete(Result, 1, Length(Separator));
  end;
end;

///  Удаляет из текста одиночный токен с указанным индексом:
///  Removes from text the single token with specified index:
function DeleteToken(const Text : String; const Index : Cardinal;
                     const Separator : String) : String; overload; inline;
begin
  Result := DeleteToken(Text, Index, Index, Separator);
end;

///  Удаляет из текста токены с указанным диапазоном индексов:
///  Removes from text a range of tokens:
function DeleteToken(const Text : String; const StartIndex, EndIndex : Cardinal;
                     const Separator : String) : String; overload;
  var
    iStartTokPos, iStartTokLen, iEndTokPos, iEndTokLen : Integer;
begin
  Result := Text;
  If (StartIndex = 0) Or (StartIndex > TokensNum(Text, Separator)) Or
     (StartIndex > EndIndex) Then Exit;

  GetToken(Result, StartIndex, Separator, iStartTokPos, iStartTokLen);
  GetToken(Result, EndIndex, Separator, iEndTokPos, iEndTokLen);
  If (StartIndex = 1)
  Then Delete(Result, 1, iEndTokPos + iEndTokLen - 1)
  // Полный вариант выглядит так:
  // Else Delete(Result, iStartTokPos - Length(Separator),
  // (iEndTokPos + iEndTokLen - 1) - (iStartTokPos - Length(Separator)) + 1);
  // Но после сокращения остаётся:
  Else
    Delete(Result, iStartTokPos - Length(Separator), iEndTokPos + iEndTokLen -
                                            (iStartTokPos - Length(Separator)));
end;

///  Проверяет, не оканчивается ли текст разделителем:
///  Checks if text ends with separator:
function EndsWithSeparator(const Text, Separator : String) : Boolean;
begin
  Result := AnsiSameText(Separator, AnsiRightStr(Text, Length(Separator)));
end;

///  Возвращает для указанного токена индекс в тексте.
///  Если токен не найден, то возвращается 0.
///  Параметр Num - позиция какого по счёту найденного токена должна быть
///  возвращена, если равен 0, то возвращается общее кол-во найденных токенов.
///  Returns the position of the NUMth matching token in text but if
///  you specify zero for Num, it returns the total number of matching tokens.
///  Returns 0 if token not found.
function FindToken(const Text, Token : String; const Num : Cardinal;
                   const Separator : String) : Cardinal;
  var
    i, iTokNum, iCount : Cardinal;
begin
  Result := 0;
  iTokNum := TokensNum(Text, Separator);
  If (Num > iTokNum) Then Exit;

  iCount := 0;
  For i := 1 To iTokNum do
  begin
    If AnsiSameText(Token, GetToken(Text, i, Separator)) Then
    begin
      Inc(iCount);
      If (iCount = Num) And (Num <> 0) Then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;
  Result := iCount;
end;

///  Извлекает из текста токен с указанным индексом:
///  Returns the INDEXth token in text:
function GetToken(const Text : String; const Index : Cardinal;
                  const Separator : String) : String; overload;
  var
    iTokPos, iTokLen : Integer;
begin
  Result := GetToken(Text, Index, Separator, iTokPos, iTokLen);
end;

///  Извлекает из текста токены с разделителями между ними в указанном
///  диапазоне индексов:
///  Returns a range of tokens delimited with separator:
function GetToken(const Text : String; const StartIndex, EndIndex : Cardinal;
                  const Separator : String) : String; overload;
  var
    iStartTokPos, iStartTokLen, iEndTokPos, iEndTokLen : Integer;
begin
  GetToken(Text, StartIndex, Separator, iStartTokPos, iStartTokLen);
  GetToken(Text, EndIndex, Separator, iEndTokPos, iEndTokLen);
  // Полный вариант выглядит так:
  // Result := Copy(Text, iStartTokPos,
  // (iEndTokPos + iEndTokLen - 1) - (iStartTokPos + 1);
  // Но после сокращения остаётся:
  Result := Copy(Text, iStartTokPos, iEndTokPos + iEndTokLen - iStartTokPos);
end;

///  Извлекает из текста токен с указанным индексом, а в out параметрах
///  возвращает стартовую позицию и длину токена:
///  Returns the INDEXth token in text and also returns in out parameters
///  his start position and length :
function GetToken(const Text : String; const Index : Cardinal;
                  const Separator : String; out TokenPos,
                  TokenLength : Integer) : String; overload;
  const
    INT_INITIAL_TOKENPOS_VALUE = -1;
  var
    i, iLength, iSeparatorLen : Integer;                  // Для скорости работы
    iCount : Cardinal;
begin
  Result := '';
  TokenPos := INT_INITIAL_TOKENPOS_VALUE;
  TokenLength := 0;
  If (Index = 0) Or (Index > TokensNum(Text, Separator)) Then Exit;

  i := 1;
  iLength := Length(Text);
  iSeparatorLen := Length(Separator);
  If StartsWithSeparator(Text, Separator) Then iCount := 0 Else iCount := 1;
  While (i <= iLength) do
  begin
    If (iCount > Index) Then Break
    Else
    begin
      // Если наткнулись на Separator:
      If AnsiSameText(Copy(Text, i, iSeparatorLen), Separator) Then
      begin
        // Игнорируем множественные Separator:
        If Not AnsiSameText(Copy(Text, i + iSeparatorLen, iSeparatorLen), Separator)
        Then Inc(iCount);
        Inc(i, iSeparatorLen);
      end
      // Если обрабатываем не Separator:
      Else
      begin
        If (iCount = Index) Then
        begin
          If (TokenPos = INT_INITIAL_TOKENPOS_VALUE) Then TokenPos := i;
          Result := Result + Text[i];
          Inc(TokenLength);
        end;
        Inc(i);
      end;
    end;
  end;
end;

///  Вставляет токен в текст на позицию с указанным индексом, даже если такой
///  такой токен уже присутствует в тексте:
///  Inserts token into the INDEXth position in text,
///  even if it already exists in text:
function InsertToken(const Text, Token : String; const Index : Cardinal;
                     const Separator : String) : String;
  var
    iStartPos, iTokLen : Integer;
begin
  Result := Text;
  If (Index = 0) Or (Index > TokensNum(Text, Separator)) Then Exit;

  GetToken(Text, Index, Separator, iStartPos, iTokLen);
  Insert(Token + Separator, Result, iStartPos);
end;

///  Возвращает позицию токена, содержащего указанную подстроку.
///  Поиск ведётся, начиная с токена, имеющего указанный индекс.
///  Если параметр Index = 0, то возвращается общее кол-во совпадающих токенов.
///  Returns index of token that contains the specified substring.
///  Searching starts from INDEXth token.
///  If you specify zero for Index, it returns the total number of matching tokens.
function MatchingToken(const Text, Substring : String; const Index : Cardinal;
                       const Separator : String) : Cardinal;
  var
    i, iTokNum : Cardinal;
begin
  Result := 0;
  iTokNum := TokensNum(Text, Separator);
  If (Index > iTokNum) Then Exit;

{
  // Полный вариант выглядит так:
  If (Index = 0) Then
  begin
    iCount := 0;
    For i := 1 To iTokNum do
      If AnsiContainsText(GetToken(Text, i, Separator), Substring) Then Inc(iCount);
    Result := iCount;
  end
  Else
  begin
    For i := Index To iTokNum do
    begin
      If AnsiContainsText(GetToken(Text, i, Separator), Substring) Then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
}

  // Оптимизированный вариант:
  If (Index = 0) Then
  begin
    For i := 1 To iTokNum do
      If AnsiContainsText(GetToken(Text, i, Separator), Substring) Then Inc(Result);
  end
  Else
  begin
    For Result := Index To iTokNum do
      If AnsiContainsText(GetToken(Text, Result, Separator), Substring) Then Break;
  end;
end;

///  Заменяет токен с указанным индексом на новый:
///  Overwrites the INDEXth token in text with a new token.
function PutToken(const Text, Token : String; const Index : Cardinal;
                  const Separator : String) : String;
begin
  Result := DeleteToken(InsertToken(Text, Token, Index, Separator),
                        Index + 1, Separator);
end;

///  Удаляет Num-ый по счёту совпадающий токен из текста.
///  Если параметр Num = 0, то удаляет все совпадающие токены.
///  Removes the NUMth matching token from text.
///  If Num = 0, applies to all matching items.
function RemoveToken(const Text, Token : String; const Num : Cardinal;
                     const Separator : String) : String;
begin
  If (Num <> 0)
  Then Result := DeleteToken(Text, FindToken(Text, Token, Num, Separator), Separator)
  Else
  begin
    Result := Text;
    While TokenExists(Result, Token, Separator) do
      Result := DeleteToken(Result, FindToken(Result, Token, 1, Separator), Separator);
  end;
end;

///  Заменяет Num-ый по счёту совпадающий токен в тексте на новый токен.
///  Если параметр Num = 0, то заменяет все совпадающие токены.
///  Replaces the NUMth matching token in text with a new token.
///  If Num = 0, applies to all matching items.
function ReplaceToken(const Text, OldToken, NewToken : String; const Num : Cardinal;
                      const Separator : String) : String;
begin
  If (Num <> 0)
  Then Result := PutToken(Result, NewToken,
                          FindToken(Result, OldToken, Num, Separator), Separator)
  Else
  begin
    Result := Text;
    While TokenExists(Result, OldToken, Separator) do
      Result := PutToken(Result, NewToken,
                         FindToken(Result, OldToken, 1, Separator), Separator);
  end;
end;

///  Возвращает True, если указанный токен найден в тексте:
///  Returns True if token exists, otherwise returns False:
function TokenExists(const Text, Token, Separator : String) : Boolean;
begin
  If (Length(Text) = Length(Token))
  Then Result := AnsiSameText(Text, Token)
  Else Result := AnsiContainsText(Text, Separator + Token) Or
                 AnsiContainsText(Text, Token + Separator);
end;

///  Возвращает кол-во токенов в тексте:
///  Returns number of tokens in text:
function TokensNum(const Text, Separator : String) : Cardinal;
  var
    i, iTextLen, iSeparatorLen, iLength : Integer;        // Для скорости работы
    iCount : Cardinal;
begin
  Result := 0;
  iTextLen := Length(Text);
  iSeparatorLen := Length(Separator);
  If (iTextLen = 0) Or (iSeparatorLen = 0) Then Exit Else
  If StartsWithSeparator(Text, Separator) Then iCount := 0 Else iCount := 1;

  i := 1;
  iLength := iTextLen - iSeparatorLen;         // Чтобы избежать лишних итераций
  While (i <= iLength) do
  begin
    // Если наткнулись на Separator:
    If AnsiSameText(Copy(Text, i, iSeparatorLen), Separator) Then
    begin
      // Игнорируем множественные Separator:
      If Not AnsiSameText(Copy(Text, i + iSeparatorLen, iSeparatorLen), Separator)
      Then Inc(iCount);
      Inc(i, iSeparatorLen);
    end
    // Если обрабатываем не Separator:
    Else Inc(i);
  end;
  Result := iCount;
end;

///  Проверяет, не начинается ли текст с разделителя:
///  Checks if text starts with separator:
function StartsWithSeparator(const Text, Separator : String) : Boolean;
begin
  Result := AnsiSameText(Separator, AnsiLeftStr(Text, Length(Separator)));
end;

//------------------------------------------------------------------------------
{$ENDREGION}

///  Альтернатива PosEx из StrUtils.pas, которая позволяет игнорировать регистр букв:
function AnsiPosEx(const SubStr, S : String; const Offset : Integer = 1;
                   const IgnoreCase : Boolean = True) : Integer;
begin
  If IgnoreCase Then Result := PosEx(AnsiLowerCase(SubStr), AnsiLowerCase(S), Offset)
                Else Result := PosEx(SubStr, S, Offset);
end;

///  Конвертирование двоичного значения в HEX-значение:
function BinToHex(const BinValue : String; const Digits : Integer = 8;
                  const CPPStyle : Boolean = True) : String;
begin
  Result := IntToHexEx(BinToInt(BinValue), Digits, CPPStyle);
end;

///  Конвертирование двоичного значения в целое десятичное число:
function BinToInt(const BinValue : String) : UInt64;
  var
	  S : String;
    i : Integer;
begin
  Result := 0;
  If Not IsBinary(BinValue) Then
    raise EConvertError.Create('"' + BinValue + '" is not a valid binary value.');

  // Убираем начальные нули:
  S := BinValue;
  Delete(S, 1, Pos('1', S) - 1);

  // Конвертируем:
  For i := Length(S) DownTo 1 do
    If (S[i] = '1') Then Result := Result + (1 shl (Length(S) - i));
end;

///  Альтернатива CharInSet из SysUtils.pas, которая работает не только
///  для ASCII символов:
function CharInArray(const C : Char; const CharArray : TCharArray;
                     const IgnoreCase : Boolean = True) : Boolean; inline;
begin
  Result := CharInString(C, String(CharArray), IgnoreCase);
end;

///  Проверка вхождения символа в строку с возможностью игнорировать регистр:
function CharInString(const C : Char; const S : String;
                      const IgnoreCase : Boolean = True) : Boolean; inline;
begin
  Result := (AnsiPosEx(C, S, 1, IgnoreCase) > 0);
end;

///  Полное рекурсивное копирование каталога:
function CopyDir(const SourceDir, TargetDir : String; const CanCreateTargetDir,
                 AbortOnSingleCopyFail, OverwriteExistingFiles : Boolean) : Boolean;
  var
    sSourceDir, sTargetDir : String;
    SR : TSearchRec;
    bFileExists : Boolean;
begin
  Result := False;
  sSourceDir := IncludeTrailingPathDelimiter(SourceDir);
  sTargetDir := IncludeTrailingPathDelimiter(TargetDir);

  If Not DirectoryExists(sSourceDir) Then Exit;
  If Not DirectoryExists(sTargetDir) Then
    If (Not CanCreateTargetDir) Or (Not CreateDirEx(sTargetDir)) Then Exit;

  Try
    If (FindFirst(sSourceDir + '*', faAnyFile, SR) = 0) Then
      Repeat
        // Пропускаем текущий и верхний каталоги:
        If (SR.Name = '.') Or (SR.Name = '..') Then Continue;

        // Если найденный элемент - директория:
        If ((SR.Attr And faDirectory) <> 0) Then
          Result := CopyDir(sSourceDir + SR.Name, sTargetDir + SR.Name,
                            CanCreateTargetDir, AbortOnSingleCopyFail,
                            OverwriteExistingFiles)
        // Если найденный элемент - файл:
        Else
        begin
          bFileExists := FileExists(sTargetDir + SR.Name);

          // Если целевого файла не существует или
          // он существует и включена перезапись:
          If (Not bFileExists) Or (bFileExists And OverwriteExistingFiles)
          Then Result := CopyFile(PChar(sSourceDir + SR.Name),
                                  PChar(sTargetDir + SR.Name), False)
          Else
          // Если целевой файл существует и перезапись отключена:
          If bFileExists And (Not OverwriteExistingFiles) Then Result := True;
        end;
      Until (FindNext(SR) <> 0);
  Finally
    FindClose(SR);
  End;
end;

///  Создание нескольких вложенных папок.
///  Игнорирует символы, запрещённые в файловой системе.
///  Возвращает True в случае успешного создания директории.
function CreateDirEx(const Path : String) : Boolean;
  var
    sPath, sSysCurrDir, sCurrentDir : String;
    i : Integer;
begin
  Result := False;
  sSysCurrDir := GetCurrentDir;
  sPath := ValidateFileName(Path, True);

  // Создаём вложенные папки:
  SetCurrentDir(IncludeTrailingPathDelimiter(ExtractFileDrive(sPath)));
  For i := Pos(PathDelim, sPath) + 1 To Length(sPath) do
  begin
    If (sPath[i] <> PathDelim) Then sCurrentDir := sCurrentDir + sPath[i];
    If (sPath[i] = PathDelim) Or (i = Length(sPath)) Then
    begin
      If Not DirectoryExists(sCurrentDir) Then Result := CreateDir(sCurrentDir);
      SetCurrentDir(sCurrentDir);
      sCurrentDir := '';
     end;
  end;
  // Возвращаем текущую директорию в начальное значение:
  SetCurrentDir(sSysCurrDir);
end;

///  Возвращает строку S, из которой были удалены символы с номерами
///  от StartIndex до EndIndex включительно:
function DeleteEx(const S : String; const StartIndex,
                  EndIndex : Integer) : String;
begin
  Result := S;
  If (StartIndex < 0) Or (EndIndex < 0) Or (StartIndex > EndIndex) Then Exit;
  Delete(Result, StartIndex, EndIndex - StartIndex + 1);
end;

///  Преобразование файлового времени в тип TDateTime:
function FileTimeToDateTime(const FileTime : TFileTime) : TDateTime;
  var
    LocalFileTime : TFileTime;
    iTemp : Int64;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  With Int64Rec(iTemp), LocalFileTime do
  begin
    Hi := dwHighDateTime;
    Lo := dwLowDateTime;
  end;
  Result := (iTemp - 94353120000000000) / 8.64e11;
end;

///  Форматируем байты в строку:
function FormatSize(const Size : UInt64; const Precise : Byte = 2) : String;
  const
    strARR_MULTIPLIERS : array [0..6] of String = (' B', ' KB', ' MB', ' GB',
                                                   ' TB', ' PB', ' EB');
  var
    iarrMultipliers : array of UInt64;
    i, iLength : Byte;
begin
  // Если не определено ни одного множителя:
  If (Length(strARR_MULTIPLIERS) = 0) Then
  begin
    Result := IntToStr(Size);
    Exit;
  end;

  // Формируем целочисленный массив множителей:
  iLength := Length(strARR_MULTIPLIERS);
  SetLength(iarrMultipliers, iLength);
  iarrMultipliers[0] := 1;
  For i := 0 To iLength - 2 do iarrMultipliers[i+1] := iarrMultipliers[i] * 1024;

  // Форматируем строку:
  For i := 0 To iLength - 1 do
  begin
    If (i = iLength - 1) Or
       ((Size >= iarrMultipliers[i]) And (Size < iarrMultipliers[i+1]))
    Then Break;
  end;
  If (i = 0)
  Then Result := IntToStr(Size) + strARR_MULTIPLIERS[i]
  Else Result := FormatFloat('.' + StringOfChar('0', Precise) + strARR_MULTIPLIERS[i],
                             Size / iarrMultipliers[i]);
end;

///  Преобразование миллисекунд в строку вида ww:dd:hh:mm:ss:msec
function FormatTime(var Milliseconds : UInt64;
                    out Weeks, Days, Hours, Minutes, Seconds : Cardinal;
                    const Constraint : TFormatTimeConstraint = ftcHours;
                    const ShowMilliseconds : Boolean = False) : String; overload;
begin
  Weeks   := 0;
  Days    := 0;
  Hours   := 0;
  Minutes := 0;

  // Индусский код:
  Repeat

    // Считаем секунды:
    Seconds := Milliseconds div MSecsPerSec;
    If (Constraint = ftcSeconds) Then
    begin
      Result := Format('%u', [Seconds]); Break;
    end;

    // Считаем минуты:
    While (Seconds >= SecsPerMin) do
    begin
      Inc(Minutes); Dec(Seconds, SecsPerMin);
    end;
    If (Constraint = ftcMinutes) Then
    begin
      Result := Format('%u:%.2u', [Minutes, Seconds]); Break;
    end;

    // Считаем часы:
    While (Minutes >= MinsPerHour) do
    begin
      Inc(Hours); Dec(Minutes, MinsPerHour);
    end;
    If (Constraint = ftcHours) Then
    begin
      Result := Format('%u:%.2u:%.2u', [Hours, Minutes, Seconds]); Break;
    end;

    // Считаем дни:
    While (Hours >= HoursPerDay) do
    begin
      Inc(Days); Dec(Hours, HoursPerDay);
    end;
    If (Constraint = ftcDays) Then
    begin
      Result := Format('%u:%.2u:%.2u:%.2u', [Days, Hours, Minutes, Seconds]); Break;
    end;

    // Считаем недели:
    While (Days >= DaysPerWeek) do
    begin
      Inc(Weeks); Dec(Days, DaysPerWeek);
    end;
    Result := Format('%u:%u:%.2u:%.2u:%.2u', [Weeks, Days, Hours, Minutes, Seconds]);

  Until True;

  Milliseconds := Milliseconds mod MSecsPerSec;
  If ShowMilliseconds Then Result := Result + ':' + IntToStr(Milliseconds);
end;

///  Преобразование миллисекунд в строку вида ww:dd:hh:mm:ss:msec
///  Это упрощённый вариант для тех, кому нужна только строка:
function FormatTime(const Milliseconds : UInt64;
                    const Constraint : TFormatTimeConstraint = ftcHours;
                    const ShowMilliseconds : Boolean = False) : String; overload;
  var
    iMilliseconds : UInt64;
    iWeeks, iDays, iHours, iMinutes, iSeconds : Cardinal;
begin
  Result := FormatTime(iMilliseconds, iWeeks, iDays, iHours, iMinutes, iSeconds,
                       Constraint, ShowMilliseconds);
end;

///  Получение полного пути к директории текущего приложения:
function GetAppDir : String; inline;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

///  Получение байта под номером BytePos из 32-битного числа.
///  Внимание! Нумерация байтов ведётся от 1 справа налево!
function GetByte(const Value : LongInt; const BytePos : Byte) : Byte; inline;
begin
  Result := ( Value shl (8 * (SizeOf(LongInt) - BytePos)) ) shr
            ( 8 * (SizeOf(LongInt) - 1) );
end;

///  Получение размера файла в байтах:
function GetFileSize(const FileName : String) : Int64;
  var
    SR : TSearchRec;
begin
  Result := -1;
  Try
    If (FindFirst(ExpandFileName(FileName), faAnyFile, SR) = 0)
    Then Result := SR.Size;
  Finally
    FindClose(SR);
  End;
end;

///  Получение версии любого exe/dll файла:
function GetFileVersion(const FileName : String; out Major, Minor, Release,
                        Build : Integer) : String; overload;
  var
    pFileName : PChar;
    pInfo, pTemp : Pointer;
    iHandle, iSize, iVerInfoSize : DWORD;
    pVerInfo : PVSFixedFileInfo;
begin
  Result := '?.?.?.?';
  Major := -1; Minor := -1; Release := -1; Build := -1;

  pFileName := PChar(ExpandFileName(FileName));
  iSize := GetFileVersionInfoSize(pFileName, iHandle);
  If (iSize = 0) Then Exit;
  GetMem(pInfo, iSize);
  FillChar(pInfo^, iSize, 0);

  Try
    If (GetFileVersionInfo(pFileName, iHandle, iSize, pInfo)) Then
    begin
      iVerInfoSize := SizeOf(TVSFixedFileInfo);
      GetMem(pVerInfo, iVerInfoSize);
      FillChar(pVerInfo^, iVerInfoSize, 0);

      Try
        pTemp := Pointer(pVerInfo);
        VerQueryValue(pInfo, '\', pTemp, iVerInfoSize);
        Major   := PVSFixedFileInfo(pTemp)^.dwFileVersionMS shr $0016;
        Minor   := PVSFixedFileInfo(pTemp)^.dwFileVersionMS and $FFFF;
        Release := PVSFixedFileInfo(pTemp)^.dwFileVersionLS shr $0016;
        Build   := PVSFixedFileInfo(pTemp)^.dwFileVersionLS and $FFFF;

        Result := IntToStr(Major)   + '.' + IntToStr(Minor) + '.' +
                  IntToStr(Release) + '.' + IntToStr(Build);
      Finally
        FreeMem(pVerInfo, iVerInfoSize);
      end;
    end;
  Finally
    FreeMem(pInfo, iSize);
  end;
end;

///  Получение версии любого exe/dll файла - упрощённый вариант:
function GetFileVersion(const FileName : String) : String; overload;
  var
    iMajor, iMinor, iRelease, iBuild : Integer;
begin
  Result := GetFileVersion(FileName, iMajor, iMinor, iRelease, iBuild);
end;

///  Получение версии текущего exe/dll файла:
function GetSelfVersion(out Major, Minor, Release,
                        Build : Integer) : String; overload; inline;
begin
  Result := GetFileVersion(ParamStr(0), Major, Minor, Release, Build);
end;

///  Получение версии текущего exe/dll файла - упрощённый вариант:
function GetSelfVersion : String; overload;
  var
    iMajor, iMinor, iRelease, iBuild : Integer;
begin
  Result := GetSelfVersion(iMajor, iMinor, iRelease, iBuild);
end;

///  Получение версии Windows, в которой выполняется приложение:
function GetWindowsVersion(out WindowsVersion : TWindowsVersion) : Boolean;
  const
    {$REGION 'Processor Architecture'}
    PROCESSOR_ARCHITECTURE_INTEL = $00000000;
    PROCESSOR_ARCHITECTURE_IA64  = $00000006;
    PROCESSOR_ARCHITECTURE_AMD64 = $00000009;
    {$ENDREGION}
    {$REGION 'Platform ID'}
    VER_NT_WORKSTATION = $00000001;
    VER_SUITE_PERSONAL = $00000200;
    VER_SUITE_STORAGE_SERVER = $00002000;
    VER_SUITE_WH_SERVER = $00008000;
    VER_SUITE_DATACENTER = $00000080;
    VER_SUITE_ENTERPRISE = $00000002;
    VER_SUITE_COMPUTE_SERVER = $00004000;
    VER_SUITE_BLADE = $00000400;
    {$ENDREGION}
    {$REGION 'Product ID'}
    PRODUCT_BUSINESS = $00000006;
    PRODUCT_BUSINESS_N = $00000010;
    PRODUCT_CLUSTER_SERVER = $00000012;
    PRODUCT_DATACENTER_SERVER = $00000008;
    PRODUCT_DATACENTER_SERVER_CORE = $0000000C;
    PRODUCT_DATACENTER_SERVER_CORE_V = $00000027;
    PRODUCT_DATACENTER_SERVER_V = $00000025;
    PRODUCT_ENTERPRISE = $00000004;
    PRODUCT_ENTERPRISE_E = $00000046;
    PRODUCT_ENTERPRISE_N = $0000001B;
    PRODUCT_ENTERPRISE_SERVER = $0000000A;
    PRODUCT_ENTERPRISE_SERVER_CORE = $0000000E;
    PRODUCT_ENTERPRISE_SERVER_CORE_V = $00000029;
    PRODUCT_ENTERPRISE_SERVER_IA64 = $0000000F;
    PRODUCT_ENTERPRISE_SERVER_V = $00000026;
    PRODUCT_HOME_BASIC = $00000002;
    PRODUCT_HOME_BASIC_E = $00000043;
    PRODUCT_HOME_BASIC_N = $00000005;
    PRODUCT_HOME_PREMIUM = $00000003;
    PRODUCT_HOME_PREMIUM_E = $00000044;
    PRODUCT_HOME_PREMIUM_N = $0000001A;
    PRODUCT_HYPERV = $0000002A;
    PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT = $0000001E;
    PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING = $00000020;
    PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY = $0000001F;
    PRODUCT_PROFESSIONAL = $00000030;
    PRODUCT_PROFESSIONAL_E = $00000045;
    PRODUCT_PROFESSIONAL_N = $00000031;
    PRODUCT_SERVER_FOR_SMALLBUSINESS = $00000018;
    PRODUCT_SERVER_FOR_SMALLBUSINESS_V = $00000023;
    PRODUCT_SERVER_FOUNDATION = $00000021;
    PRODUCT_SMALLBUSINESS_SERVER = $00000009;
    PRODUCT_STANDARD_SERVER = $00000007;
    PRODUCT_STANDARD_SERVER_CORE = $0000000D;
    PRODUCT_STANDARD_SERVER_CORE_V = $00000028;
    PRODUCT_STANDARD_SERVER_V = $00000024;
    PRODUCT_STARTER = $0000000B;
    PRODUCT_STARTER_E = $00000042;
    PRODUCT_STARTER_N = $0000002F;
    PRODUCT_STORAGE_ENTERPRISE_SERVER = $00000017;
    PRODUCT_STORAGE_EXPRESS_SERVER = $00000014;
    PRODUCT_STORAGE_STANDARD_SERVER = $00000015;
    PRODUCT_STORAGE_WORKGROUP_SERVER = $00000016;
    PRODUCT_UNDEFINED = $00000000;
    PRODUCT_ULTIMATE = $00000001;
    PRODUCT_ULTIMATE_E = $00000047;
    PRODUCT_ULTIMATE_N = $0000001C;
    PRODUCT_WEB_SERVER = $00000011;
    PRODUCT_WEB_SERVER_CORE = $0000001D;
    {$ENDREGION}
  type
    TGetProductInfo = function (OSMajor, OSMinor, SPMajor, SPMinor : DWORD;
                                ProductType : PDWORD) : Boolean; stdcall;
  var
    OSVI : TOSVersionInfoEx;
    SI : TSystemInfo;
    dwType : DWORD;
    GetProductInfo : TGetProductInfo;
begin
  Result := False;
  ZeroMemory(@SI, SizeOf(TSystemInfo));
  ZeroMemory(@OSVI, SizeOf(TOSVersionInfoEx));
  ZeroMemory(@WindowsVersion, SizeOf(TWindowsVersion));
  With WindowsVersion do
  begin
    Version       := wvUnknown;
    Edition       := weUnknown;
    ProcessorArch := paUnknown;
  end;

  OSVI.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  If Not GetVersionEx(OSVI) Or
     Not ((OSVI.dwPlatformId = VER_PLATFORM_WIN32_NT) And (OSVI.dwMajorVersion > 4))
  Then Exit;
  If (GetProcAddress(GetModuleHandle(kernel32), 'GetNativeSystemInfo') <> nil)
  Then GetNativeSystemInfo(SI) Else GetSystemInfo(SI);

  // Определяем версию Windows:
  With OSVI, SI, WindowsVersion do
  begin
    ToString := 'Microsoft Windows ';
    Case dwMajorVersion of
      6:
        begin
          Case dwMinorVersion of
            0:
              begin
                If (wProductType = VER_NT_WORKSTATION) Then
                begin
                  Version := wvVista;
                  ToString := ToString + 'Vista ';
                end
                Else
                begin
                  Version := wvServer2008;
                  ToString := ToString + 'Server 2008 ';
                end;
              end;
            1:
              begin
                If (wProductType = VER_NT_WORKSTATION) Then
                begin
                  Version := wvSe7en;
                  ToString := ToString + '7 ';
                end
                Else
                begin
                  Version := wvServer2008R2;
                  ToString := ToString + 'Server 2008 R2 ';
                end;
              end;
          End;

          @GetProductInfo := GetProcAddress(GetModuleHandle(kernel32),
                                            'GetProductInfo');
          GetProductInfo(dwMajorVersion, dwMinorVersion, wServicePackMajor,
                         wServicePackMinor, @dwType);

          Case dwType of
            PRODUCT_BUSINESS, PRODUCT_BUSINESS_N:
              begin
                Edition := weBusiness;
                ToString := ToString + 'Business ';
              end;
            PRODUCT_CLUSTER_SERVER:
              begin
                Edition := weClusterServer;
                ToString := ToString + 'Cluster Server ';
              end;
            PRODUCT_DATACENTER_SERVER, PRODUCT_DATACENTER_SERVER_CORE,
            PRODUCT_DATACENTER_SERVER_CORE_V, PRODUCT_DATACENTER_SERVER_V:
              begin
                Edition := weDatacenterServer;
                ToString := ToString + 'Datacenter Server ';
              end;
            PRODUCT_ENTERPRISE, PRODUCT_ENTERPRISE_E, PRODUCT_ENTERPRISE_N:
              begin
                Edition := weEnterprise;
                ToString := ToString + 'Enterprise ';
              end;
            PRODUCT_ENTERPRISE_SERVER, PRODUCT_ENTERPRISE_SERVER_CORE,
            PRODUCT_ENTERPRISE_SERVER_CORE_V, PRODUCT_ENTERPRISE_SERVER_IA64,
            PRODUCT_ENTERPRISE_SERVER_V:
              begin
                Edition := weEnterpriseServer;
                ToString := ToString + 'Enterprise Server ';
              end;
            PRODUCT_HOME_BASIC, PRODUCT_HOME_BASIC_E, PRODUCT_HOME_BASIC_N:
              begin
                Edition := weHomeBasic;
                ToString := ToString + 'Home Basic ';
              end;
            PRODUCT_HOME_PREMIUM, PRODUCT_HOME_PREMIUM_E, PRODUCT_HOME_PREMIUM_N:
              begin
                Edition := weHomePremium;
                ToString := ToString + 'Home Premium ';
              end;
            PRODUCT_HYPERV:
              begin
                Edition := weHyperVServer;
                ToString := ToString + 'Hyper V Server ';
              end;
            PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT,
            PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING,
            PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY:
              begin
                Edition := weMediumBusinessServer;
                ToString := ToString + 'Medium Business Server ';
              end;
            PRODUCT_PROFESSIONAL, PRODUCT_PROFESSIONAL_E, PRODUCT_PROFESSIONAL_N:
              begin
                Edition := weProfessional;
                ToString := ToString + 'Professional ';
              end;
            PRODUCT_SERVER_FOR_SMALLBUSINESS, PRODUCT_SERVER_FOR_SMALLBUSINESS_V:
              begin
                Edition := weServerForSmallBusiness;
                ToString := ToString + 'Server For Small Business ';
              end;
            PRODUCT_SERVER_FOUNDATION:
              begin
                Edition := weServerFoundation;
                ToString := ToString + 'Server Foundation ';
              end;
            PRODUCT_SMALLBUSINESS_SERVER:
              begin
                Edition := weSmallBusinessServer;
                ToString := ToString + 'Small Business Server ';
              end;
            PRODUCT_STANDARD_SERVER, PRODUCT_STANDARD_SERVER_CORE,
            PRODUCT_STANDARD_SERVER_CORE_V, PRODUCT_STANDARD_SERVER_V:
              begin
                Edition := weStandardServer;
                ToString := ToString + 'Standard Server ';
              end;
            PRODUCT_STARTER, PRODUCT_STARTER_E, PRODUCT_STARTER_N:
              begin
                Edition := weStarter;
                ToString := ToString + 'Starter ';
              end;
            PRODUCT_STORAGE_ENTERPRISE_SERVER, PRODUCT_STORAGE_EXPRESS_SERVER,
            PRODUCT_STORAGE_STANDARD_SERVER, PRODUCT_STORAGE_WORKGROUP_SERVER:
              begin
                Edition := weStorageServer;
                ToString := ToString + 'Storage Server ';
              end;
            PRODUCT_UNDEFINED:
              begin
                Edition := weUnknown;
                ToString := ToString + 'Unknown ';
              end;
            PRODUCT_ULTIMATE, PRODUCT_ULTIMATE_E, PRODUCT_ULTIMATE_N:
              begin
                Edition := weUltimate;
                ToString := ToString + 'Ultimate ';
              end;
            PRODUCT_WEB_SERVER, PRODUCT_WEB_SERVER_CORE:
              begin
                Edition := weWebServer;
                ToString := ToString + 'Web Server ';
              end;
          End;
          ToString := ToString + 'Edition ';

          Case wProcessorArchitecture of
            PROCESSOR_ARCHITECTURE_AMD64: ProcessorArch := pa64bit;
            PROCESSOR_ARCHITECTURE_INTEL: ProcessorArch := pa32bit;
          End;
        end;
      5:
        Case dwMinorVersion of
          2:
            begin
              If (GetSystemMetrics(SM_SERVERR2) <> 0) Then
              begin
                Version := wvServer2003R2;
                ToString := ToString + 'Server 2003 R2 ';
              end
              Else
              If ((wSuiteMask And VER_SUITE_STORAGE_SERVER) <> 0) Then
              begin
                Version := wvStorageServer2003;
                ToString := ToString + 'Storage Server 2003 ';
              end
              Else
              If ((wSuiteMask And VER_SUITE_WH_SERVER) <> 0) Then
              begin
                Version := wvHomeServer;
                ToString := ToString + 'Home Server ';
              end
              Else
              If ((wProductType = VER_NT_WORKSTATION) And
                  (wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64)) Then
              begin
                Version := wvXPPro64;
                ToString := ToString + 'XP Professional x64 ';
              end
              Else
              begin
                Version := wvServer2003;
                ToString := ToString + 'Server 2003 ';
              end;

              If (wProductType <> VER_NT_WORKSTATION) Then
              begin
                Case wProcessorArchitecture of
                  PROCESSOR_ARCHITECTURE_IA64:
                    begin
                      ProcessorArch := pa64bit;
                      If ((wSuiteMask And VER_SUITE_DATACENTER) <> 0) Then
                      begin
                        Edition := weDatacenterIA64;
                        ToString := ToString + 'Datacenter ';
                      end
                      Else
                      If ((wSuiteMask And VER_SUITE_ENTERPRISE) <> 0) Then
                      begin
                        Edition := weEnterpriseIA64;
                        ToString := ToString + 'Enterprise ';
                      end;
                    end;
                  PROCESSOR_ARCHITECTURE_AMD64:
                    begin
                      ProcessorArch := pa64bit;
                      If ((wSuiteMask And VER_SUITE_DATACENTER) <> 0) Then
                      begin
                        Edition := weDatacenter64;
                        ToString := ToString + 'Datacenter ';
                      end
                      Else
                      If ((wSuiteMask And VER_SUITE_ENTERPRISE) <> 0) Then
                      begin
                        Edition := weEnterprise64;
                        ToString := ToString + 'Enterprise ';
                      end
                      Else
                      begin
                        Edition := weStandard64;
                        ToString := ToString + 'Standard ';
                      end;
                    end;
                  else
                    begin
                      ProcessorArch := pa32bit;
                      If ((wSuiteMask And VER_SUITE_COMPUTE_SERVER) <> 0) Then
                      begin
                        Edition := weComputeCluster;
                        ToString := ToString + 'Compute Cluster ';
                      end
                      Else
                      If ((wSuiteMask And VER_SUITE_DATACENTER) <> 0) Then
                      begin
                        Edition := weDatacenter;
                        ToString := ToString + 'Datacenter ';
                      end
                      Else
                      If ((wSuiteMask And VER_SUITE_ENTERPRISE) <> 0) Then
                      begin
                        Edition := weEnterprise;
                        ToString := ToString + 'Enterprise ';
                      end
                      Else
                      If ((wSuiteMask And VER_SUITE_BLADE) <> 0) Then
                      begin
                        Edition := weWeb;
                        ToString := ToString + 'Web ';
                      end
                      Else
                      begin
                        Edition := weStandard;
                        ToString := ToString + 'Standard ';
                      end;
                    end;
                End;
              end;
              ToString := ToString + 'Edition ';
            end;
          1:
            begin
              Version := wvXP;
              ToString := ToString + 'XP ';
              ProcessorArch := pa32bit;
              If ((OSVI.wSuiteMask And VER_SUITE_PERSONAL) <> 0) Then
              begin
                Edition := weXPHome;
                ToString := ToString + 'Home ';
              end
              Else
              begin
                Edition := weProfessional;
                ToString := ToString + 'Professional ';
              end;
              ToString := ToString + 'Edition ';
            end;
          0:
            begin
              Version := wv2000;
              ToString := ToString + '2000 ';
              ProcessorArch := pa32bit;
              If (wProductType = VER_NT_WORKSTATION) Then
              begin
                Edition := weProfessional;
                ToString := ToString + 'Professional ';
              end
              Else
              begin
                If ((wSuiteMask And VER_SUITE_DATACENTER) <> 0) Then
                begin
                  Edition := weDatacenterServer;
                  ToString := ToString + 'Datacenter Server ';
                end
                Else
                If ((wSuiteMask And VER_SUITE_ENTERPRISE) <> 0) Then
                begin
                  Edition := we2000AdvancedServer;
                  ToString := ToString + 'Advanced Server ';
                end
                Else
                begin
                  Edition := we2000Server;
                  ToString := ToString + 'Server ';
                end;
              end;
              ToString := ToString + 'Edition ';
            end;
        End;
    End;

    Case ProcessorArch of
      pa32bit: ToString := ToString + '(32-bit)';
      pa64bit: ToString := ToString + '(64-bit)';
      paUnknown: ToString := ToString + '(unknown processor architecture)';
    End;

    ServicePack.Major := wServicePackMajor;
    ServicePack.Minor := wServicePackMinor;
    CSDVersion := String(szCSDVersion);
  End;
  Result := True;
end;

///  Конвертирование HEX-значения в двоичную систему:
function HexToBin(const HexValue : String) : String;
begin
  Result := IntToBin(HexToInt64(HexValue));
end;

///  Конвертирование HEX-значения в Integer-число:
function HexToInt(const HexValue : String) : Integer;
begin
  If IsHexInCPPStyle(HexValue)
  Then Result := StrToInt('$' + Copy(HexValue, 3, Length(HexValue))) Else
  If IsHex(HexValue)
  Then Result := StrToInt('$' + HexValue)
  Else raise EConvertError.Create('"' + HexValue + '" is not a valid HEX value.');
end;

///  Конвертирование HEX-значения в Int64-число:
function HexToInt64(const HexValue : String) : Int64;
begin
  If IsHexInCPPStyle(HexValue)
  Then Result := StrToInt('$' + Copy(HexValue, 3, Length(HexValue))) Else
  If IsHex(HexValue)
  Then Result := StrToInt('$' + HexValue)
  Else raise EConvertError.Create('"' + HexValue + '" is not a valid HEX value.');
end;

///  Конвертирование #RRGGBB HTML значения цвета в TColor:
function HTMLToTColor(const HTMLColorValue : String) : TColor;
  var
    S : String;
begin
  S := HTMLColorValue;
  If (S[1] = '#') Then Delete(S, 1, 1);
  If IsHTMLColor(S) Then
    Result := TColor(HexToInt(S[5]+S[6] + S[3]+S[4] + S[1]+S[2]))
  Else raise EConvertError.Create('"' + HTMLColorValue +
                                  '" is not a valid HTML color value.');
end;

///  Конвертирование целого десятичного числа в двоичную систему:
function IntToBin(const Value : UInt64) : String;
  var
    i : Integer;
    iValue : UInt64;
begin
  // Конвертируем:
  iValue := Value;
  For i := 1 To 8 * SizeOf(Value) do
  begin
    If Odd(iValue) Then Result := '1' + Result
                   Else Result := '0' + Result;
    iValue := iValue shr 1;
  end;
  // Убираем начальные нули:
  Delete(Result, 1, Pos('1', Result) - 1);
end;

///  Конвертирование Integer-числа в HEX-значение:
function IntToHexEx(const Value : Integer; const Digits : Integer = 8;
                    const CPPStyle : Boolean = True) : String; overload;
begin
  Result := IntToHex(Value, Digits);
  If CPPStyle Then Result := '0x' + Result;
end;

///  Конвертирование Int64-числа в HEX-значение:
function IntToHexEx(const Value : Int64; const Digits : Integer = 8;
                    const CPPStyle : Boolean = True) : String; overload;
begin
  Result := IntToHex(Value, Digits);
  If CPPStyle Then Result := '0x' + Result;
end;

///  Является ли строка двоичным числом:
function IsBinary(const Value : String) : Boolean;
  var
    i : Integer;
begin
  Result := False;

  If (Value = '') Then Exit;
  For i := 1 To Length(Value) do
    If Not ((Value[i] = '0') Or (Value[i] = '1')) Then Exit;

  Result := True;
end;

///  Является ли строка числом с плавающей запятой:
function IsFloat(const Value : String) : Boolean;
  var
    f : Extended;
begin
  Result := TryStrToFloat(Value, f);
end;

///  Является ли строка HEX-значением:
function IsHex(const Value : String) : Boolean;
  var
    i : Int64;
begin
  If (Value[1] = '0') And SameText(Value[2], 'x')
  Then Result := TryStrToInt64('$' + Copy(Value, 3, Length(Value)), i)
  Else Result := TryStrToInt64('$' + Value, i);
end;

///  Проверяет записано ли HEX-значение в стиле C++:
function IsHexInCPPStyle(const HexValue : String) : Boolean;
begin
  Result := IsHex(HexValue) And (HexValue[1] = '0') And SameText(HexValue[2], 'x');
end;

///  Является ли строка #RRGGBB HTML значением цвета:
function IsHTMLColor(const Value : String) : Boolean;
  var
    S : String;
begin
  S := Value;
  If (S[1] = '#') Then Delete(S, 1, 1);
  Result := IsHex(S) And (Length(S) = 6);
end;

///  Является ли строка целым числом:
function IsInteger(const Value : String) : Boolean;
  var
    i : Int64;
begin
  Result := TryStrToInt64(Value, i);
end;

///  Проверка находится ли символ в нижнем регистре.
///  По идее всегда возвращает True для всех символов, не различающих регистр
///  (спец. символы, иероглифы и т.п.).
function IsLowerCase(const C : Char) : Boolean; overload; inline;
begin
  Result := (C = AnsiLowerCase(C));
end;

///  Проверка все ли символы в строке находятся в нижнем регистре:
function IsLowerCase(const S : String) : Boolean; overload; inline;
begin
  Result := (S = AnsiLowerCase(S));
end;

///  Проверка установки старшего бита:
function IsMostSignificantBitSet(const Value : Byte) : Boolean; overload; inline;
begin
  Result := ((Value And 128) = 128);
end;

///  Проверка установки старшего бита старшего байта:
function IsMostSignificantBitSet(const Value : Integer) : Boolean; overload;
  var
    i : Byte;
begin
  i := Hi(Value);
  Result := IsMostSignificantBitSet(i);
end;

///  Проверка установки старшего бита старшего байта:
function IsMostSignificantBitSet(const Value : Int64) : Boolean; overload;
  var
    i : Byte;
begin
  i := Hi(Value);
  Result := IsMostSignificantBitSet(i);
end;

///  Just alias for IsMostSignificantBitSet:
function IsMSBSet(const Value : Byte) : Boolean; overload; inline;
begin
  Result := IsMostSignificantBitSet(Value);
end;

///  Just alias for IsMostSignificantBitSet:
function IsMSBSet(const Value : Integer) : Boolean; overload; inline;
begin
  Result := IsMostSignificantBitSet(Value);
end;

///  Just alias for IsMostSignificantBitSet:
function IsMSBSet(const Value : Int64) : Boolean; overload; inline;
begin
  Result := IsMostSignificantBitSet(Value);
end;

///  Проверка находится ли символ в верхнем регистре,
///  по идее всегда возвращает True для всех символов, не различающих регистр
///  (спец. символы, иероглифы и т.п.).
function IsUpperCase(const C : Char) : Boolean; overload; inline;
begin
  Result := (C = AnsiUpperCase(C));
end;

///  Проверка все ли символы в строке находятся в верхнем регистре:
function IsUpperCase(const S : String) : Boolean; overload; inline;
begin
  Result := (S = AnsiUpperCase(S));
end;

///  Поддерживается ли редакция текущей версии Windows данным приложением:
function IsCurrentWinEditionSupported(const WinEditions : TWinEditions) : Boolean;
  var
    WindowsVersion : TWindowsVersion;
begin
  Result := GetWindowsVersion(WindowsVersion) And
            (WindowsVersion.Edition in WinEditions);
end;

///  Поддерживается ли текущая версия Windows данным приложением:
function IsCurrentWinVersionSupported(const WinVersions : TWinVersions) : Boolean;
  var
    WindowsVersion : TWindowsVersion;
begin
  Result := GetWindowsVersion(WindowsVersion) And
            (WindowsVersion.Version in WinVersions);
end;

///  Полное рекурсивное удаление каталога:
function RemoveDir(const Dir : String;
                   const AbortOnSingleDelFail : Boolean = False) : Boolean;
  var
    sDir : String;
    SR : TSearchRec;
begin
  Result := False;
  sDir := IncludeTrailingPathDelimiter(Dir);
  If Not DirectoryExists(sDir) Then Exit;

  Try
    If (FindFirst(sDir + '*', faAnyFile, SR) = 0) Then
      Repeat
        // Пропускаем текущий и верхний каталоги:
        If (SR.Name = '.') Or (SR.Name = '..') Then Continue;

        // Если найденный элемент - файл:
        If ((SR.Attr And faDirectory) = 0)
        Then Result := DeleteFile(sDir + SR.Name)
        // Если найденный элемент - директория:
        Else Result := RemoveDir(sDir + SR.Name, AbortOnSingleDelFail);

        // Если одно из удалений провалилось:
        If Not Result And AbortOnSingleDelFail Then Exit;
      Until (FindNext(SR) <> 0);
  Finally
    FindClose(SR);
  End;
  Result := RemoveDirectory(PChar(sDir));
end;

///  Повтор строки RepeatTimes раз:
function RepeatStr(const S : String; const RepeatTimes : Integer;
                   const Delimiter : String = '') : String;
  var
    pText, pDelimiter, pResult : PChar;
    i, iTextLen, iDelimiterLen : Integer;
begin
  If (Delimiter = '') Then
  begin
    Result := DupeString(S, RepeatTimes);
    Exit;
  end;

  iTextLen := Length(S);
  iDelimiterLen := Length(Delimiter);
  SetLength(Result, RepeatTimes * (iTextLen + iDelimiterLen));

  pText := Pointer(S);
  pDelimiter := Pointer(Delimiter);
  pResult := Pointer(Result);
  If (pText = nil) Or (pResult = nil) Then Exit;

  For i := 1 To RepeatTimes do
  begin
    Move(pText^, pResult^, iTextLen * SizeOf(Char));
    Inc(pResult, iTextLen);
    Move(pDelimiter^, pResult^, iDelimiterLen * SizeOf(Char));
    Inc(pResult, iDelimiterLen);
  end;
end;

///  Конвертирование TColor значения цвета в #RRGGBB значение для HTML:
function TColorToHTML(const ColorValue : TColor) : String; inline;
begin
  Result := IntToHex(ColorValue, 6);
  Result := '#' + Result[5]+Result[6] + Result[3]+Result[4] + Result[1]+Result[2];
end;

///  Удаление символов, запрещённых в файловой системе.
///  Параметр IgnoreDirsDelimiters позволяет пропускать символ '\' и символ ':',
///  но только если последний имеет вторую позицию, т.е. разделяет букву диска и путь.
function ValidateFileName(const FileName : String;
                          const IgnorePathDelimiters : Boolean = False) : String;
  const
    strARR_PROHIBITEDCHARS : array [0..8] of Char = (PathDelim, '/', DriveDelim,
                                                     '*', '?', '"', '<', '>', '|');
  var
    i : Integer;
begin
  Result := FileName;
  For i := 0 To Length(strARR_PROHIBITEDCHARS) - 1 do
  begin
    // Пропускаем разделитель папок:
    If IgnorePathDelimiters And (strARR_PROHIBITEDCHARS[i] = PathDelim) Then Continue;
    // Удаляем запрещённый символ:
    Result := StringReplace(Result, strARR_PROHIBITEDCHARS[i], '', [rfReplaceAll]);
  end;

  // Пропускаем разделитель диска и папок:
  If (FileName[2] = DriveDelim) And IgnorePathDelimiters
  Then Insert(DriveDelim, Result, 2);
end;

///  Ожидание завершения потока:
procedure WaitForThreadTermination(const Thread : TThread); inline;
begin
  If Assigned(Thread) Then
    While Not Thread.Finished do WaitForSingleObject(Thread.Handle, INFINITE);
end;

end.
