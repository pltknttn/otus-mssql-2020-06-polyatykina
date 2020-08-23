using System;
using System.Collections;
using System.Text;
using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using System.Diagnostics.CodeAnalysis;

namespace RegularExpressions
{
    public static class SqlRegex
    {
        public static readonly RegexOptions Options = RegexOptions.IgnorePatternWhitespace | RegexOptions.Singleline;

        [SqlFunction(Name = "ReplaceMatch", IsDeterministic = true)]
        public static SqlString ReplaceMatch(SqlString InputString, SqlString MatchPattern, SqlString ReplacementPattern)
        {
            try
            {
                if (!InputString.IsNull &&
                    !MatchPattern.IsNull &&
                    !ReplacementPattern.IsNull)
                { 
                    if (Regex.IsMatch(InputString.Value,  MatchPattern.Value)) 
                        return Regex.Replace(InputString.Value,
                                            MatchPattern.Value,
                                            ReplacementPattern.Value);
                    return SqlString.Null;
                }
                return SqlString.Null;
            }
            catch
            {
                return SqlString.Null;
            }
        }
                
        [SqlFunction(IsDeterministic = true)]
        public static SqlBoolean RegexMatch(SqlChars input, SqlString pattern)
        {
            try
            {
                Regex regex = new Regex(pattern.Value, Options);
                return regex.IsMatch(new string(input.Value));
            }
            catch
            {
                return SqlBoolean.Null;
            }
        }

        [SqlFunction(IsDeterministic = true)]
        public static SqlChars RegexGroup( SqlChars input, SqlString pattern, SqlString name)
        {
            try
            {
                Regex regex = new Regex(pattern.Value, Options);
                Match match = regex.Match(new string(input.Value));
                return match.Success ? new SqlChars(match.Groups[name.Value].Value) : SqlChars.Null;
            }
            catch
            {
                return SqlChars.Null;
            }
        }

        [SqlFunction(FillRowMethodName = "FillMatchRow", TableDefinition = "[Index] int,[Text] nvarchar(max)")]
        public static IEnumerable RegexMatches(SqlChars input, SqlString pattern)
        {
            return new MatchIterator(new string(input.Value), pattern.Value);
        }

        [SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters")]
        public static void FillMatchRow(object data, out SqlInt32 index, out SqlChars text)
        {
            MatchNode node = (MatchNode)data;
            index = new SqlInt32(node.Index);
            text = new SqlChars(node.Value.ToCharArray());
        }

        [SqlFunction(FillRowMethodName = "FillGroupRow", TableDefinition = "[Index] int,[Group] nvarchar(max),[Text] nvarchar(max)")]
        public static IEnumerable RegexGroups(SqlChars input, SqlString pattern)
        {
            return new GroupIterator(new string(input.Value), pattern.Value);
        }

        [SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters")]
        public static void FillGroupRow(object data,
            out SqlInt32 index, out SqlChars group, out SqlChars text)
        {
            GroupNode node = (GroupNode)data;
            index = new SqlInt32(node.Index);
            group = new SqlChars(node.Name.ToCharArray());
            text = new SqlChars(node.Value.ToCharArray());
        }
    }
}
