# Includes code from
# https://benschwehn.wordpress.com/2007/10/07/generate-create-assembly-from-binary-bits-script/

param
(
    $out = 'CreateAssembly.sql',
    $assemblyFile = 'RegexFunctions.dll',
    $assemblyName = 'RegexFunctions'
)

$stringBuilder = New-Object -Type System.Text.StringBuilder

$stringBuilder.Append("IF EXISTS (SELECT name FROM sys.assemblies WHERE name = '") > $null
$stringBuilder.Append($assemblyName) > $null
$stringBuilder.Append("')") > $null

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("    DROP ASSEMBLY [") > $null
$stringBuilder.Append($assemblyName) > $null
$stringBuilder.Append("]") > $null

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("go") > $null

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("`n") > $null
$stringBuilder.Append("CREATE ASSEMBLY [") > $null
$stringBuilder.Append($assemblyName) > $null
$stringBuilder.Append("] FROM ") > $null

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("0x") > $null

$assemblyFile = resolve-path $assemblyFile
$fileStream = [IO.File]::OpenRead($assemblyFile)

while (($byte = $fileStream.ReadByte()) -gt -1) {
    $stringBuilder.Append($byte.ToString("X2")) > $null
}

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("WITH PERMISSION_SET = SAFE;") > $null
$stringBuilder.Append("`n") > $null

$fileHash = Get-FileHash $assemblyFile SHA512

$stringBuilder.Append("`n") > $null
$stringBuilder.Append("exec sp_add_trusted_assembly") > $null
$stringBuilder.Append("`n") > $null
$stringBuilder.Append("0x") > $null
$stringBuilder.Append($fileHash.Hash) > $null
$stringBuilder.Append("`n") > $null
$stringBuilder.Append(", N'regexfunctions, version=0.0.0.0, culture=neutral, publickeytoken=null, processorarchitecture=msil';")

$stringBuilder.ToString() > $out;
$fileStream.Close()
$fileStream.Dispose()


