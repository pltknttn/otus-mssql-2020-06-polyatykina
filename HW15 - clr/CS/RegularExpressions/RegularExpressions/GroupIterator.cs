using System.Collections;
using System.Text.RegularExpressions;

namespace RegularExpressions
{
    internal class GroupIterator : IEnumerable
    {
        private Regex _regex;
        private string _input;

        public GroupIterator(string input, string pattern)
        {
            _regex = new Regex(pattern, SqlRegex.Options);
            _input = input;
        }

        public IEnumerator GetEnumerator()
        {
            int index = 0;
            Match current = null;
            string[] names = _regex.GetGroupNames();
            do
            {
                index++;
                current = (current == null) ?
                    _regex.Match(_input) : current.NextMatch();
                if (current.Success)
                {
                    foreach (string name in names)
                    {
                        Group group = current.Groups[name];
                        if (group.Success)
                        {
                            yield return new GroupNode(
                                index, name, group.Value);
                        }
                    }
                }
            }
            while (current.Success);
        }
    }
}
