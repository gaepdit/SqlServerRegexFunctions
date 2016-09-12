# Regular Expressions (Regex) Functions for SQL Server

An implementation of .NET Regular Expressions for use in SQL Server. All C# code is from the [Just geeks blog](http://justgeeks.blogspot.com/2008/08/adding-regular-expressions-regex-to-sql.html). 

The SQL script creates T-SQL wrapper functions that call the functions in the CLR assembly.

## Available functions

* **RegexMatch** - returns 1 if pattern can be found in input, else 0
* **RegexReplace** - replaces all matches in input with a specified string
* **RegexSelectOne** - returns the first, second, third, etc match that can be found in the input
* **RegexSelectAll** - returns all matches delimited by separator that can be found in the input

## Usage examples

``` sql
-- Returns 1 in this case since the phone number pattern is matched
select dbo.RegexMatch( N'123-45-6749', N'^\d{3}-\d{2}-\d{4}') 

-- Returns 137 since all alpha characters where replaced with no characters
select dbo.RegExReplace('Remove1All3Letters7','[a-zA-Z]','') 

-- Returns 123-45-6789 since first match was specifed. If last parameter was 1 then the second match (222-33-4444) would be returned.
select dbo.RegexSelectOne('123-45-6749xxx222-33-4444', '\d{3}-\d{2}-\d{4}', 0) 

-- Returns 123-45-6749|222-33-4444 
select dbo.RegexSelectAll('123-45-6749xxx222-33-4444', '\d{3}-\d{2}-\d{4}', '|') 
```

## Installation

1. Build the `RegexFunctions` project in Visual Studio
2. In SQL Server, add the `"RegexFunctions\bin\Release\RegexFunctions.dll"` file as a new assembly
3. Run the `"SQL Server Objects\UserDefinedFunctions.sql"` script to add the SQL Server wrapper functions