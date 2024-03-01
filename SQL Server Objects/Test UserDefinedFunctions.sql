-- Returns 1 since the pattern is matched.
SELECT dbo.RegexMatch(N'123-456-7890', N'^\d{3}-\d{3}-\d{4}') AS [true];

-- Returns 0 since the pattern is not matched.
SELECT dbo.RegexMatch(N'123-45-6789', N'^\d{3}-\d{3}-\d{4}') AS [false];

-- Returns N'137' since all alphabetic characters were replaced with an empty string.
SELECT dbo.RegExReplace(N'Remove1All3Letters7', N'[a-zA-Z]', N'') AS [137];

-- Returns N'123-456-7890' since first match was specified (matchIndex = 0).
SELECT dbo.RegexSelectOne(N'123-456-7890___222-333-4444', N'\d{3}-\d{3}-\d{4}', 0) AS [123-456-7890];

-- Returns N'222-333-4444' since second match was specified (matchIndex = 1).
SELECT dbo.RegexSelectOne(N'123-456-7890___222-333-4444', N'\d{3}-\d{3}-\d{4}', 1) AS [222-333-4444];

-- Returns N'123-456-7890|222-333-4444'.
SELECT dbo.RegexSelectAll(N'123-456-7890___222-333-4444', N'\d{3}-\d{3}-\d{4}', N'|') AS [123-456-7890|222-333-4444];

-- Returns N'7890...4444'.
SELECT dbo.RegexSelectAll(N'123-456-7890___222-333-4444', N'\d{4}', N'...') AS [7890...4444];
