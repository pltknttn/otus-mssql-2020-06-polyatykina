using System.Collections; 
using System.Text.RegularExpressions;
 
namespace RegularExpressions
{
    internal class MatchIterator : IEnumerable
    {
        private Regex _regex;
        private string _input;

        public MatchIterator(string input, string pattern)
        {
            _regex = new Regex(pattern, SqlRegex.Options);
            _input = input;
        }

        public IEnumerator GetEnumerator()
        {
            int index = 0;
            Match current = null;
            do
            {
                current = (current == null) ?
                    _regex.Match(_input) : current.NextMatch();
                if (current.Success)
                {
                    yield return new MatchNode(++index, current.Value);
                }
            }
            while (current.Success);
        }
    }
}
