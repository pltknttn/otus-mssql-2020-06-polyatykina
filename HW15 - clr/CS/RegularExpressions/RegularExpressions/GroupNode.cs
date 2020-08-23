using System;
using System.Collections.Generic;
using System.Text;

namespace RegularExpressions
{
    internal class GroupNode
    {
        private int _index;
        public int Index { get { return _index; } }

        private string _name;
        public string Name { get { return _name; } }

        private string _value;
        public string Value { get { return _value; } }

        public GroupNode(int index, string group, string value)
        {
            _index = index;
            _name = group;
            _value = value;
        }
    }
}
