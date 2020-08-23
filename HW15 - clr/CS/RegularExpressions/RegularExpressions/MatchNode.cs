using System;
using System.Collections.Generic;
using System.Text;

namespace RegularExpressions
{
    internal class MatchNode
    {
        private int _index;
        public int Index { get { return _index; } }

        private string _value;
        public string Value { get { return _value; } }

        public MatchNode(int index, string value)
        {
            _index = index;
            _value = value;
        }
    }
}
