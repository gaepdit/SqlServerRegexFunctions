# Includes code from
# https://benschwehn.wordpress.com/2007/10/07/generate-create-assembly-from-binary-bits-script/

param
(
    $out = 'CreateAssembly.sql',
    $assemblyFile = 'RegexFunctions.dll',
    $assemblyName = 'RegexFunctions'
)

$stringBuilder = New-Object -Type System.Text.StringBuilder

$stringBuilder.Append("-- Turn on advanced options.
exec sp_configure 'show advanced options', '1';
reconfigure;
go

-- Turn off CLR strict security.
exec sp_configure 'clr strict security', '0';
reconfigure;
go

-- Add the assembly.
") > $null

$stringBuilder.Append("CREATE ASSEMBLY [") > $null
$stringBuilder.Append($assemblyName) > $null
$stringBuilder.Append("] FROM 
") > $null

$stringBuilder.Append("0x") > $null

$assemblyFile = resolve-path $assemblyFile
$fileStream = [IO.File]::OpenRead($assemblyFile)

while (($byte = $fileStream.ReadByte()) -gt -1) {
    $stringBuilder.Append($byte.ToString("X2")) > $null
}

$stringBuilder.Append("
WITH PERMISSION_SET = SAFE;

-- Trust the assembly.
") > $null

$fileHash = Get-FileHash $assemblyFile SHA512

$stringBuilder.Append("exec sp_add_trusted_assembly
0x") > $null
$stringBuilder.Append($fileHash.Hash) > $null
$stringBuilder.Append("
, N'regexfunctions, version=0.0.0.0, culture=neutral, publickeytoken=null, processorarchitecture=msil';
") > $null

$stringBuilder.Append("
-- Enable executing CLR assembly.
exec sp_configure 'clr enabled', '1';
reconfigure;
go

-- Turn on CLR strict security.
exec sp_configure 'clr strict security', '1';
reconfigure;
go

-- Turn off advanced options.
exec sp_configure 'show advanced options', '0';
reconfigure;
go

-- Check for existence of assembly.
select * from sys.assemblies where name = '") > $null
$stringBuilder.Append($assemblyName) > $null
$stringBuilder.Append("';")

$stringBuilder.ToString() > $out;
$fileStream.Close()
$fileStream.Dispose()
