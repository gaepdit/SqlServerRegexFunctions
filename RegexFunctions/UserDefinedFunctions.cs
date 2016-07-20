using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Text;

public partial class UserDefinedFunctions
{

    public static readonly RegexOptions Options = RegexOptions.IgnorePatternWhitespace | RegexOptions.Multiline;

    /// <summary>
    /// Indicates whether the regular expression finds a match in the input string.
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match. </param>
    /// <returns>true (1) if the regular expression finds a match; otherwise, false (0).</returns>
    [SqlFunction]
    public static SqlBoolean RegexMatch(SqlChars input, SqlString pattern)
    {
        Regex regex = new Regex(pattern.Value, Options);
        return regex.IsMatch(new string(input.Value));
    }

    /// <summary>
    /// In a specified input string, replaces strings that match a regular expression pattern with a specified replacement string.
    /// </summary>
    /// <param name="expression">The string to search for a match. </param>
    /// <param name="pattern">The regular expression pattern to match. </param>
    /// <param name="replace">The replacement string.</param>
    /// <returns>A new string that is identical to the input string, except that the replacement string takes the place of each matched string. If the regular expression pattern is not matched in the current instance, the method returns the current instance unchanged.</returns>
    [SqlFunction]
    public static SqlString RegexReplace(SqlString expression, SqlString pattern, SqlString replace)
    {
        if (expression.IsNull || pattern.IsNull || replace.IsNull)
            return SqlString.Null;

        Regex regex = new Regex(pattern.ToString());
        return new SqlString(regex.Replace(expression.ToString(), replace.ToString()));
    }
    
    /// <summary>
    /// Returns the matching string. Results are separated by the delimeter string
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match. </param>
    /// <param name="matchDelimiter">The delimeter string</param>
    /// <returns>The matching strings separated by the delimeter string.</returns>
    [SqlFunction]
    public static SqlString RegexSelectAll(SqlChars input, SqlString pattern, SqlString matchDelimiter)
    {
        Regex regex = new Regex(pattern.Value, Options);
        Match results = regex.Match(new string(input.Value));

        StringBuilder sb = new StringBuilder();
        while (results.Success)
        {
            sb.Append(results.Value);

            results = results.NextMatch();

            // separate the results with newline|newline
            if (results.Success)
            {
                sb.Append(matchDelimiter.Value);
            }
        }

        return new SqlString(sb.ToString());

    }

    /// <summary>
    /// Returns the matching string. Only the nth match is returned
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match. </param>
    /// <param name="matchIndex">The index of the result to return</param>
    /// <returns>The matching string (only the nth result)</returns>
    [SqlFunction]
    public static SqlString RegexSelectOne(SqlChars input, SqlString pattern, SqlInt32 matchIndex)
    {
        Regex regex = new Regex(pattern.Value, Options);
        Match results = regex.Match(new string(input.Value));

        string resultStr = "";
        int index = 0;

        while (results.Success)
        {
            if (index == matchIndex)
            {
                resultStr = results.Value.ToString();
            }

            results = results.NextMatch();
            index++;

        }

        return new SqlString(resultStr);

    }

};

