using System;
using System.Collections; 
using System.Text;

namespace StringExpressions
{
    internal class SplitNode
    {
        private int _index;
        public int Index { get { return _index; } }

        private string _value;
        public string Value { get { return _value; } }

        public SplitNode(int index, string value)
        {
            _index = index;
            _value = value;
        }
    }
    internal class SplitIterator : IEnumerable
    {
        private char[] _delimeters;
        private string _input;

        public SplitIterator(string input, char[] delimeters)
        {
            _delimeters = delimeters;
            _input = input;
        }

        public IEnumerator GetEnumerator()
        {
            int index = 0;
            var results = _input.Split(_delimeters, StringSplitOptions.RemoveEmptyEntries);
            foreach(var str in results)
            {
                yield return new SplitNode(++index, str);
            } 
        }
    }
}
