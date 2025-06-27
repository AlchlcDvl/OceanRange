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

    public static bool TryFindingAll<T>(this IEnumerable<T> source, Func<T, bool> predicate, out IEnumerable<T> value)
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
        return obj.DontDestroyOnLoad();
    }

    public static T DontUnload<T>(this T obj) where T : UObject
    {
        obj.hideFlags |= HideFlags.DontUnloadUnusedAsset;
        return obj;
    }

    public static T DontDestroyOnLoad<T>(this T obj) where T : UObject
    {
        UObject.DontDestroyOnLoad(obj);
        return obj;
    }

    public static void Destroy(this UObject obj) => UObject.Destroy(obj);

    public static void DestroyImmediate(this UObject obj) => UObject.DestroyImmediate(obj);

    public static string ReplaceAll(this string @string, string newValue, params string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    public static string[] TrueSplit(this string @string, char separator) => [.. @string.Split(separator).Select(x => x.Trim()).Where(x => !string.IsNullOrEmpty(x))];

    public static IEnumerable<(int, T)> Indexed<T>(this IEnumerable<T> source)
    {
        var i = 0;

        foreach (var item in source)
            yield return (i++, item);
    }

    public static Color32 HexToColor(this string hex) => ColorUtility.TryParseHtmlString(hex, out var color) ? color : Color.white;
}