#if UNITY
namespace OceanRange.Utils;

public static class UnityUtils
{
    public static bool IsNullOrEmpty<T>(this T[] array)
    {
        if (array == null)
            return true;

        return array.Length == 0;
    }

    public static bool IsNullOrEmpty<T>(this ICollection<T> collection)
    {
        if (collection == null)
            return true;

        return collection.Count == 0;
    }

    public static bool IsNullOrEmpty<T>(this IEnumerable<T> enumerable)
    {
        if (enumerable == null)
            return true;

        return enumerable.Count() == 0;
    }
}
#endif