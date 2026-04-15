namespace OceanRange.Utils;

public static class HashCalculator
{
    private const uint Offset = 2166136261u;
    private const uint Prime = 16777619u;

    // public static ushort FoldHash(uint hash) => (ushort)(hash ^ (hash >> 16));

    public static uint ComputeHashOfString(this string @string)
    {
        unchecked
        {
            var hash = Offset;

            foreach (var ch in @string)
            {
                hash ^= ch;
                hash *= Prime;
            }

            return hash;
        }
    }
}