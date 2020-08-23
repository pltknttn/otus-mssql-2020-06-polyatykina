using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.IO;
using System.Text;

namespace StringExpressions
{
    /// <summary>
    /// Конкатенация 
    /// </summary>
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined, MaxByteSize = 8000)]
    public class StringAgg : IBinarySerialize
    {
        private bool _unique;
        private string _delimeter;
        private List<string> _strings;

        public void Init()
        {
            _delimeter = ";";
            _unique = false;
            _strings = new List<string>(); 
        }

        public void Accumulate(SqlString value, SqlString delimeter, SqlBoolean unique)
        {
            if (!delimeter.IsNull) _delimeter = delimeter.Value;
            if (!unique.IsNull) _unique = unique.Value;
            if (value.IsNull) return;
            if (_unique && _strings.Exists(x => x == value.Value)) return;
            _strings.Add(value.Value);
        }

        public void Merge(StringAgg group)
        {
            if (group._strings?.Count > 0)
            {
                if (!string.IsNullOrWhiteSpace(group._delimeter)) _delimeter = group._delimeter;
                foreach (var str in group._strings)
                {
                    if (_unique && _strings.Exists(x => x == str)) continue;
                    _strings.Add(str);
                }
            }
        }

        public SqlString Terminate()
        {
            string output = string.Empty; 
            if (_strings != null && _strings.Count > 0)
            {
                output = string.Join(_delimeter, _strings); 
            }
            return new SqlString(output); 
        }

        public void Read(BinaryReader r)
        {
            _strings = new List<string>();
            if (r == null) return;
            var rows = r.ReadString()?.Split(new string[] { _delimeter }, StringSplitOptions.RemoveEmptyEntries);
            if (rows?.Length > 0) _strings.AddRange(rows);
        }

        public void Write(BinaryWriter w)
        {
            w.Write(string.Join(_delimeter, _strings));
        }
    }
}
