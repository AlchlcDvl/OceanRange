using SRML;
using SRML.Utils;

namespace TheOceanRange.Utils;

public static class Helpers
{
    public static bool TryFinding<T>(this IEnumerable<T> source, Func<T, bool> predicate, out T value)
    {
        var result = source.TryFindingAll(predicate, out var values);
        value = values.FirstOrDefault();
        return result;
    }

    public static bool TryFinding<T1, T2>(this IEnumerable<T1> source, out T2 value, Func<T2, bool> predicate1 = null, Func<T1, bool> predicate2 = null)
    {
        var result = source.TryFindingAll(out var values, predicate1, predicate2);
        value = values.FirstOrDefault();
        return result;
    }

    private static bool TryFindingAll<T>(this IEnumerable<T> source, Func<T, bool> predicate, out IEnumerable<T> value)
    {
        value = source.Where(predicate);
        return value.Any();
    }

    private static bool TryFindingAll<T1, T2>(this IEnumerable<T1> source, out IEnumerable<T2> value, Func<T2, bool> predicate1 = null, Func<T1, bool> predicate2 = null)
    {
        if (predicate2 is not null)
            source = source.Where(predicate2);

        value = source.OfType<T2>();

        if (predicate1 is not null)
            value = value.Where(predicate1);

        return value.Any();
    }

    public static T DontDestroy<T>(this T obj) where T : UObject
    {
        obj.hideFlags |= HideFlags.HideAndDontSave;
        obj.DontDestroyOnLoad();
        return obj;
    }

    // public static T DontUnload<T>(this T obj) where T : UObject
    // {
    //     obj.hideFlags |= HideFlags.DontUnloadUnusedAsset;
    //     return obj;
    // }

    public static string ReplaceAll(this string @string, string newValue, params string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    public static string[] TrueSplit(this string @string, char separator) => [.. @string.Split(separator).Select(x => x.Trim()).Where(x => !string.IsNullOrEmpty(x))];

    // public static IEnumerable<(int, T)> Indexed<T>(this IEnumerable<T> source)
    // {
    //     var i = 0;

    //     foreach (var item in source)
    //         yield return (i++, item);
    // }

    // public static Color32 HexToColor32(this string hex) => ColorUtility.TryParseHtmlString(hex, out var color) ? color : Color.white;

    public static Color HexToColor(this string hex) => ColorUtility.TryParseHtmlString(hex, out var color) ? color : Color.white;

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value);

    public static T DeepCopy<T>(this T obj) where T : UObject => (T)PrefabUtils.DeepCopyObject(obj).DontDestroy();

    // public static string GetPath(this Transform transform)
    // {
    //     var result = "";

    //     while (transform)
    //     {
    //         result = transform.name + "/" + result;
    //         transform = transform.parent;
    //     }

    //     return result;
    // }

    public static bool IsInLoopedRange(this float num, float min, float max, float rangeMin, float rangeMax, bool inner)
    {
        var result = num >= rangeMin && num <= rangeMax;
        var part = num >= min && num <= max;
        return (inner ? result : !result) && part;
    }

    public static T AddEnumValue<T>(string name) where T : struct, Enum
    {
        var value = EnumPatcher.GetFirstFreeValue<T>();
        EnumPatcher.AddEnumValueWithAlternatives<T>(value, name);
        return value;
    }

    public static IdentifiableId CreateIdentifiableId(string name)
    {
        var value = AddEnumValue<IdentifiableId>(name);
        IdentifiableRegistry.CategorizeId(value);
        return value;
    }
}