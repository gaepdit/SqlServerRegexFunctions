using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Text;
using System.Text.RegularExpressions;

// ReSharper disable UnusedMember.Global
// ReSharper disable once UnusedType.Global
public static class UserDefinedFunctions
{
    private const RegexOptions Options = RegexOptions.IgnorePatternWhitespace | RegexOptions.Multiline;

    /// <summary>
    /// Indicates whether the regular expression finds a match in the input string.
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match.</param>
    /// <returns>true (1) if the regular expression finds a match; otherwise, false (0).</returns>
    [SqlFunction(IsDeterministic = true)]
    public static SqlBoolean RegexMatch(SqlChars input, SqlString pattern) =>
        new Regex(pattern.Value, Options).IsMatch(new string(input.Value));

    /// <summary>
    /// In a specified input string, replaces strings that match a regular expression pattern with a specified
    /// replacement string.
    /// </summary>
    /// <param name="expression">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match.</param>
    /// <param name="replace">The replacement string.</param>
    /// <returns>A new string that is identical to the input string, except that the replacement string takes
    /// the place of each matched string. If the regular expression pattern is not matched in the current instance,
    /// the method returns the current instance unchanged.</returns>
    [SqlFunction(IsDeterministic = true)]
    public static SqlString RegexReplace(SqlString expression, SqlString pattern, SqlString replace) =>
        expression.IsNull || pattern.IsNull || replace.IsNull
            ? SqlString.Null
            : new SqlString(new Regex(pattern.ToString()).Replace(expression.ToString(), replace.ToString()));

    /// <summary>
    /// Returns the matching string. Results are separated by the delimiter string.
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match.</param>
    /// <param name="matchDelimiter">The delimiter string.</param>
    /// <returns>The matching strings separated by the delimiter string.</returns>
    [SqlFunction(IsDeterministic = true)]
    public static SqlString RegexSelectAll(SqlChars input, SqlString pattern, SqlString matchDelimiter)
    {
        var results = new Regex(pattern.Value, Options).Match(new string(input.Value));
        var sb = new StringBuilder();

        while (results.Success)
        {
            sb.Append(results.Value);
            results = results.NextMatch();

            // separate the results with matchDelimiter
            if (results.Success) sb.Append(matchDelimiter.Value);
        }

        return new SqlString(sb.ToString());
    }

    /// <summary>
    /// Returns the matching string. Only the nth match is returned. If there are no matches (or fewer than
    /// the requested index), an empty string is returned.
    /// </summary>
    /// <param name="input">The string to search for a match.</param>
    /// <param name="pattern">The regular expression pattern to match.</param>
    /// <param name="matchIndex">The zero-based index of the result to return.</param>
    /// <returns>The nth matching string.</returns>
    [SqlFunction(IsDeterministic = true)]
    public static SqlString RegexSelectOne(SqlChars input, SqlString pattern, SqlInt32 matchIndex)
    {
        var results = new Regex(pattern.Value, Options).Match(new string(input.Value));
        var resultStr = "";
        var index = 0;

        while (results.Success)
        {
            if (index == matchIndex)
            {
                resultStr = results.Value;
                break;
            }

            results = results.NextMatch();
            index++;
        }

        return new SqlString(resultStr);
    }
}
