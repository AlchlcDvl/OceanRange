#if UNITY
using System.Collections.Generic;
using OceanRange.Unity;

namespace OceanRange.Data;

public sealed class StringPooler(HashSet<string> pool)
{
    private readonly HashSet<string> Pool = pool;

    public void PoolSubstring(string? value, int startIndex) => PoolString(value?.Substring(startIndex));

    public void PoolString(string? value)
    {
        if (!string.IsNullOrEmpty(value))
            Pool.Add(value!);
    }

    public void PoolSubstrings(string[] values, int startIndex)
    {
        if (values.IsNullOrEmpty())
            return;

        for (var i = 0; i < values.Length; i++)
            PoolString(values[i]?.Substring(startIndex));
    }

    public void PoolSubstrings(ICollection<string> values, int startIndex)
    {
        if (values.IsNullOrEmpty())
            return;

        foreach (var value in values)
            PoolString(value?.Substring(startIndex));
    }

    public void PoolStrings(string[] values)
    {
        if (values.IsNullOrEmpty())
            return;

        for (var i = 0; i < values.Length; i++)
            PoolString(values[i]);
    }

    public void PoolStrings(ICollection<string> values)
    {
        if (values.IsNullOrEmpty())
            return;

        foreach (var value in values)
            PoolString(value);
    }

    public void PoolStrings(IEnumerable<string> values)
    {
        if (values.IsNullOrEmpty())
            return;

        foreach (var value in values)
            PoolString(value);
    }
}
#endif