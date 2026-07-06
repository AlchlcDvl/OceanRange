#if UNITY
using System.Globalization;
using OceanRange.Unity;

namespace OceanRange.Utils;

public static class UnityUtils
{
    private static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    public static bool IsNullOrEmpty<T>(this T[]? array)
    {
        if (array == null)
            return true;

        return array.Length == 0;
    }

    public static bool IsNullOrEmpty<T>(this ICollection<T>? collection)
    {
        if (collection == null)
            return true;

        return collection.Count == 0;
    }

    public static bool IsNullOrEmpty<T>(this IEnumerable<T>? enumerable)
    {
        if (enumerable == null)
            return true;

        return enumerable.Count() == 0;
    }

    public static void Deconstruct<TKey, TValue>(this KeyValuePair<TKey, TValue> pair, out TKey key, out TValue value)
    {
        key = pair.Key;
        value = pair.Value;
    }

    extension(Type type)
    {
        public bool IsNullableOf<T>()
        {
            var tType = typeof(T);
            return tType.IsValueType && tType.IsAssignableFrom(Nullable.GetUnderlyingType(type));
        }

        public bool IsNullableEnum() => Nullable.GetUnderlyingType(type) is { IsEnum: true };
    }

    public static string ToVectorString(this Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";

    public static Vector3 ParseVector(string value) => Vector3Converter.Instance.Parse(value);

    public static bool TryParseVector(string value, NumberStyles _1, CultureInfo _2, out Vector3 result)
    {
        try
        {
            result = ParseVector(value);
            return true;
        }
        catch
        {
            result = default;
            return false;
        }
    }

    extension(string @string)
    {
        public List<string> TrueSplit(params char[] separators)
        {
            var list = new List<string>(@string.Count(separators.Contains) + 1);
            var start = 0;

            for (var i = 0; i < @string.Length; i++)
            {
                if (!separators.Contains(@string[i]))
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

        public bool StartsWith(char character) => @string is { Length: > 0 } && @string[0] == character;
    }

    public static string ToHex(this Color32 color) => $"{color.r:X2}{color.g:X2}{color.b:X2}";

    public static string? ToHex(this Optional<Color32> color) => color.HasValue ? color.Value.ToHex() : null;

    public static bool TryParseColor32(string value, out Color32 result)
    {
        if (value.StartsWith('#'))
            value = value.Substring(1);

        switch (value.Length)
        {
            case 3:
            {
                var r = byte.Parse(value[0].ToString(), NumberStyles.AllowHexSpecifier);
                var g = byte.Parse(value[1].ToString(), NumberStyles.AllowHexSpecifier);
                var b = byte.Parse(value[2].ToString(), NumberStyles.AllowHexSpecifier);
                result = new((byte)((r << 4) | r), (byte)((g << 4) | g), (byte)((b << 4) | b), 255);
                return true;
            }
            case 4:
            {
                var r = byte.Parse(value[0].ToString(), NumberStyles.AllowHexSpecifier);
                var g = byte.Parse(value[1].ToString(), NumberStyles.AllowHexSpecifier);
                var b = byte.Parse(value[2].ToString(), NumberStyles.AllowHexSpecifier);
                var a = byte.Parse(value[3].ToString(), NumberStyles.AllowHexSpecifier);
                result = new((byte)((r << 4) | r), (byte)((g << 4) | g), (byte)((b << 4) | b), (byte)((a << 4) | a));
                return true;
            }
            case 6:
            {
                var r = byte.Parse(value.Substring(0, 2), NumberStyles.AllowHexSpecifier);
                var g = byte.Parse(value.Substring(2, 2), NumberStyles.AllowHexSpecifier);
                var b = byte.Parse(value.Substring(4, 2), NumberStyles.AllowHexSpecifier);
                result = new(r, g, b, 255);
                return true;
            }
            case 8:
            {
                var r = byte.Parse(value.Substring(0, 2), NumberStyles.AllowHexSpecifier);
                var g = byte.Parse(value.Substring(2, 2), NumberStyles.AllowHexSpecifier);
                var b = byte.Parse(value.Substring(4, 2), NumberStyles.AllowHexSpecifier);
                var a = byte.Parse(value.Substring(6, 2), NumberStyles.AllowHexSpecifier);
                result = new(r, g, b, a);
                return true;
            }
            default:
            {
                result = default;
                return false;
            }
        }
    }

    public static unsafe uint ToUIntBits(this float value) => *(uint*)&value;

    public static unsafe ulong ToULongBits(this double value) => *(ulong*)&value;
}
#endif