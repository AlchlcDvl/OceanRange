namespace OceanRange.Common;

public static partial class Helpers
{
    public static bool StartsWith(this string @string, char character) => @string[0] == character;

    public static List<string> TrueSplit(this string @string, params char[] separators)
    {
        var separatorSet = separators.ToHashSet();
        var separatorCount = @string.Count(separatorSet.Contains);

        var list = new List<string>(separatorCount + 1);
        var start = 0;

        for (var i = 0; i < @string.Length; i++)
        {
            if (!separatorSet.Contains(@string[i]))
                continue;

            if (i > start)
            {
                var part = @string.Substring(start, i - start).Trim();

                if (!string.IsNullOrWhiteSpace(part))
                    list.Add(part);
            }

            start = i + 1;
        }

        if (start < @string.Length)
        {
            var lastPart = @string.Substring(start).Trim();

            if (!string.IsNullOrWhiteSpace(lastPart))
                list.Add(lastPart);
        }

        return list;
    }

    public static bool TryParseEnum(Type enumType, string name, bool ignoreCase, out object result)
    {
        try
        {
            result = Enum.Parse(enumType, name, ignoreCase);
            return true;
        }
        catch
        {
            result = null;
            return false;
        }
    }
}