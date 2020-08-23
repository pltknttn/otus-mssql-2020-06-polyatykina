using Microsoft.SqlServer.Server;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Diagnostics.CodeAnalysis;

namespace StringExpressions
{
    public static class SqlStringEx
    {
        [SqlFunction(FillRowMethodName = "FillSplitRow", TableDefinition = "[Index] int,[Text] nvarchar(max)")]
        public static IEnumerable StringSplit(SqlString value, SqlChars delimeters)
        {
            return new SplitIterator(value.Value, delimeters.Value);
        }

        [SuppressMessage("Microsoft.Design", "CA1021:AvoidOutParameters")]
        public static void FillSplitRow(object data, out SqlInt32 index, out SqlString text)
        {
            var node = (SplitNode)data;
            index = new SqlInt32(node.Index);
            text = new SqlString(node.Value);
        }
    }
}