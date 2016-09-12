-- Returns 1 in this case since the phone number pattern is matched
SELECT dbo.RegexMatch( N'123-45-6749', N'^\d{3}-\d{2}-\d{4}' ) AS [1];

-- Returns 137 since all alpha characters where replaced with no characters
SELECT dbo.RegExReplace( 'Remove1All3Letters7', '[a-zA-Z]', '' ) AS [137];

-- Returns 123-45-6789 since first match was specifed. If last parameter was 1 then the second match (222-33-4444) would be returned.
SELECT dbo.RegexSelectOne( '123-45-6749xxx222-33-4444', '\d{3}-\d{2}-\d{4}', 0 ) AS [123-45-6789];

-- Returns 123-45-6749|222-33-4444 
SELECT dbo.RegexSelectAll( '123-45-6749xxx222-33-4444', '\d{3}-\d{2}-\d{4}', '|' ) AS [123-45-6749|222-33-4444];