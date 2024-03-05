SET ANSI_NULLS OFF;
GO
SET QUOTED_IDENTIFIER OFF;
GO

IF OBJECT_ID('dbo.RegexMatch') IS NOT NULL
    DROP FUNCTION dbo.RegexMatch;
GO

CREATE FUNCTION dbo.RegexMatch(@input nvarchar(max), @pattern nvarchar(max))
    RETURNS bit
    WITH EXECUTE AS CALLER ,
        RETURNS NULL ON NULL INPUT
AS EXTERNAL NAME
    RegexFunctions.UserDefinedFunctions.RegexMatch;
GO

IF OBJECT_ID('dbo.RegexReplace') IS NOT NULL
    DROP FUNCTION dbo.RegexReplace;
GO

CREATE FUNCTION dbo.RegexReplace(@expression nvarchar(max), @pattern nvarchar(max), @replace nvarchar(max))
    RETURNS nvarchar(max)
    WITH EXECUTE AS CALLER ,
        RETURNS NULL ON NULL INPUT
AS EXTERNAL NAME
    RegexFunctions.UserDefinedFunctions.RegexReplace;
GO

IF OBJECT_ID('dbo.RegexSelectAll') IS NOT NULL
    DROP FUNCTION dbo.RegexSelectAll;
GO

CREATE FUNCTION dbo.RegexSelectAll(@input nvarchar(max), @pattern nvarchar(max), @matchDelimiter nvarchar(max))
    RETURNS nvarchar(max)
    WITH EXECUTE AS CALLER ,
        RETURNS NULL ON NULL INPUT
AS EXTERNAL NAME
    RegexFunctions.UserDefinedFunctions.RegexSelectAll;
GO

IF OBJECT_ID('dbo.RegexSelectOne') IS NOT NULL
    DROP FUNCTION dbo.RegexSelectOne;
GO

CREATE FUNCTION dbo.RegexSelectOne(@input nvarchar(max), @pattern nvarchar(max), @matchIndex int)
    RETURNS nvarchar(max)
    WITH EXECUTE AS CALLER ,
        RETURNS NULL ON NULL INPUT
AS EXTERNAL NAME
    RegexFunctions.UserDefinedFunctions.RegexSelectOne;
GO
