using System.Globalization;

namespace OceanRange.Utils;

public static partial class Helpers
{
    // private static readonly Dictionary<string, Color32> HexToColor32s = [];
    private static readonly Dictionary<string, Color> HexToColors = [];

    // public static bool TryHexToColor32(string hex, out Color32 color)
    // {
    //     if (HexToColor32s.TryGetValue(hex, out color))
    //         return true;

    //     if (ColorUtility.DoTryParseHtmlColor(hex, out color))
    //     {
    //         HexToColor32s[hex] = color;
    //         return true;
    //     }

    //     color = default;
    //     return false;
    // }

    public static bool TryHexToColor(string hex, out Color color)
    {
        if (HexToColors.TryGetValue(hex, out color))
            return true;

        if (ColorUtility.TryParseHtmlString(hex, out color))
        {
            HexToColors[hex] = color;
            return true;
        }

        color = default;
        return false;
    }

#if UNITY
    public static Vector3 ParseVector(string value) => Vector3Converter.Instance.Parse(value);
#endif

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

    public static string ToColorString(this Color value) => $"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}";

    // public static string ToHexRGBA(this Color32 color) => $"#{color.r.ToString(InvariantCulture):X2}{color.g.ToString(InvariantCulture):X2}{color.b.ToString(InvariantCulture):X2}{color.a.ToString(InvariantCulture):X2}";

    public static bool IsNullableOf<T>(this Type type)
    {
        var tType = typeof(T);
        return tType.IsValueType && tType.IsAssignableFrom(Nullable.GetUnderlyingType(type));
    }

    public static bool IsNullableEnum(this Type type) => Nullable.GetUnderlyingType(type) is { IsEnum: true };

    // public static void Deconstruct<TKey, TValue>(this KeyValuePair<TKey, TValue> pair, out TKey key, out TValue value)
    // {
    //     key = pair.Key;
    //     value = pair.Value;
    // }

    public static bool IsDefined<T>(this MemberInfo member) where T : Attribute => member.IsDefined(typeof(T), false);

    public static IEnumerable<(T1, T2)> Zip<T1, T2>(this IEnumerable<T1> source1, IEnumerable<T2> source2)
    {
        using var e1 = source1.GetEnumerator();
        using var e2 = source2.GetEnumerator();

        while (true)
        {
            var has1 = e1.MoveNext();
            var has2 = e2.MoveNext();

            if (!has1 || !has2)
            {
                if (has1 != has2)
                    throw new ArgumentException("Sequences have different lengths.");

                yield break;
            }

            yield return (e1.Current, e2.Current);
        }
    }

    public static void WriteArray<T>(this BinaryWriter writer, T[] array, Action<BinaryWriter, T> write)
    {
        if (array == null)
        {
            writer.Write(0);
            return;
        }

        writer.Write(array.Length);

        foreach (var item in array)
            write(writer, item);
    }

    public static void WriteModData(this BinaryWriter writer, Data.ModData value) => value.SerialiseTo(writer);

    public static void WriteString(this BinaryWriter writer, string value)
    {
        value = (value ?? "").Trim();
        var noValue = string.IsNullOrWhiteSpace(value);
        writer.Write(noValue);

        if (!noValue)
            writer.Write(value);
    }

    public static void WriteFloat(this BinaryWriter writer, float value) => writer.Write(value);

    public static void WriteDouble(this BinaryWriter writer, double value) => writer.Write(value);

    public static void WriteInt(this BinaryWriter writer, int value) => writer.Write(value);

    public static void WriteVector3(this BinaryWriter writer, Vector3 value)
    {
        writer.Write(value.x);
        writer.Write(value.y);
        writer.Write(value.z);
    }

    public static void WriteColor(this BinaryWriter writer, Color value)
    {
        writer.Write(value.r);
        writer.Write(value.g);
        writer.Write(value.b);
        writer.Write(value.a);
    }

    public static void WriteOrientation(this BinaryWriter writer, Orientation value)
    {
        writer.WriteVector3(value.Position);
        writer.WriteVector3(value.Rotation);
        writer.WriteVector3(value.Scale);
    }

    public static void WriteNullable<T>(this BinaryWriter writer, T? value, Action<BinaryWriter, T> write) where T : struct
    {
        writer.Write(value.HasValue);

        if (value.HasValue)
            write(writer, value.Value);
    }

    public static void WriteDictionary<TValue>(this BinaryWriter writer, IEnumerable<StringDictEntry<TValue>> dict, Action<BinaryWriter, TValue> valueWrite)
    {
        if (dict == null)
        {
            writer.Write(0);
            return;
        }

        var count = dict is ICollection<StringDictEntry<TValue>> collection ? collection.Count : dict.Count();
        writer.Write(count);

        foreach (var (key, value) in dict)
        {
            writer.Write(key);
            valueWrite(writer, value);
        }
    }
}