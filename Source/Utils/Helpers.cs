// using SRML;
using System.Globalization;
using AssetsLib;
using SRML.Utils;

namespace OceanRange.Utils;

public static class Helpers
{
    // private static readonly Dictionary<string, Color32> HexToColor32s = [];
    private static readonly Dictionary<string, Color> HexToColors = [];

    public static bool TryFinding<T>(this IEnumerable<T> source, Func<T, bool> predicate, out T value)
    {
        foreach (var item in source)
        {
            if (!predicate(item))
                continue;

            value = item;
            return true;
        }

        value = default;
        return false;
    }

    public static T DontDestroy<T>(this T obj) where T : UObject
    {
        obj.DontDestroyOnLoad();
        obj.hideFlags |= HideFlags.HideAndDontSave;
        return obj;
    }

    public static string ReplaceAll(this string @string, string newValue, params string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    public static List<string> TrueSplit(this string @string, params char[] separators)
    {
        var separatorSet = separators.ToHashSet();
        var separatorCount = 0;

        for (var i = 0; i < @string.Length; i++)
        {
            if (separatorSet.Contains(@string[i]))
                separatorCount++;
        }

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

    // private static IEnumerable<T> ExceptBy<T>(this IEnumerable<T> source, Func<T, bool> predicate) => source.Where(x => !predicate(x));

    // public static Color32 HexToColor32(this string hex)
    // {
    //     if (HexToColor32s.TryGetValue(hex, out var color))
    //         return color;

    //     if (ColorUtility.DoTryParseHtmlColor(hex, out color))
    //         return HexToColor32s[hex] = color;

    //     throw new InvalidDataException($"Invalid color hex {hex}!");
    // }

    public static Color HexToColor(this string hex)
    {
        if (HexToColors.TryGetValue(hex, out var color))
            return color;

        if (ColorUtility.TryParseHtmlString(hex, out color))
            return HexToColors[hex] = color;

        throw new InvalidDataException($"Invalid color hex {hex}!");
    }

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value, true);

    // public static T ToEnum<T>(object value) where T : struct, Enum => (T)Enum.ToObject(typeof(T), value);

    public static T DeepCopy<T>(this T obj) where T : UObject => (T)PrefabUtils.DeepCopyObject(obj).DontDestroy();

    // public static T DeepCopyNonUnityObject<T>(this T obj)
    // {
    //     var instance = Activator.CreateInstance<T>();
    //     var tType = typeof(T);

    //     foreach (var field in tType.GetFields(AccessTools.all))
    //         field.SetValue(instance, field.GetValue(obj));

    //     foreach (var property in tType.GetProperties(AccessTools.all))
    //     {
    //         if (property.CanWrite)
    //             property.SetValue(instance, property.GetValue(obj));
    //     }

    //     return instance;
    // }

    public static bool IsInLoopedRange(this float num, float min, float max, float rangeMin, float rangeMax, bool inner)
    {
        var result = num >= rangeMin && num <= rangeMax;
        var part = num >= min && num <= max;
        return (inner ? result : !result) && part;
    }

    public static void BuildGordo(CustomSlimeData slimeData, GameObject sectorCategory)
    {
        var gordo = slimeData.GordoId.GetPrefab().Instantiate(sectorCategory.transform);
        gordo.transform.position = slimeData.GordoOrientation.Position;
        gordo.transform.localEulerAngles = slimeData.GordoOrientation.Rotation;
        gordo.name = gordo.name.Replace("(Clone)", "").Trim();
        gordo.GetComponent<GordoEat>().rewards.activeRewards = [.. gordo.GetComponent<GordoRewards>().rewardPrefabs];
        gordo.AddComponent<GordoPop>().Data = slimeData;

        if (slimeData.IsPopped)
            gordo.SetActive(false);
    }

    public static Mesh Clone(this Mesh originalMesh)
    {
        var mesh = new Mesh
        {
            vertices = originalMesh.vertices,
            triangles = originalMesh.triangles,
            normals = originalMesh.normals,
            tangents = originalMesh.tangents,

            colors = originalMesh.colors,
            colors32 = originalMesh.colors32,

            name = originalMesh.name + "_Clone",

            subMeshCount = originalMesh.subMeshCount
        };

        var uvs = new List<Vector2>();

        for (var i = 0; i < 8; i++)
        {
            originalMesh.GetUVs(i, uvs);
            mesh.SetUVs(i, uvs);
            uvs.Clear();
        }

        for (var i = 0; i < originalMesh.subMeshCount; i++)
            mesh.SetTriangles(originalMesh.GetTriangles(i), i);

        return mesh;
    }

    // private static T AddEnumValue<T>(string name) where T : struct, Enum
    // {
    //     var value = EnumPatcher.GetFirstFreeValue<T>();
    //     EnumPatcher.AddEnumValueWithAlternatives<T>(value, name);
    //     return value;
    // }

    // public static IdentifiableId CreateIdentifiableId(string name)
    // {
    //     var value = AddEnumValue<IdentifiableId>(name);
    //     IdentifiableRegistry.CategorizeId(value);
    //     return value;
    // }

    // public static string ToHexRGBA(this Color32 color) => $"#{color.r:X2}{color.g:X2}{color.b:X2}{color.a:X2}";

    public static Vector3 ToPower(this Vector3 vector, int power)
    {
        if (power == 0)
            return Vector3.one;

        var result = Vector3.one;
        var abs = Mathf.Abs(power);

        for (var i = 0; i < abs; i++)
        {
            result.x *= vector.x;
            result.y *= vector.y;
            result.z *= vector.z;
        }

        if (power < 0)
        {
            result.x = 1f / result.x;
            result.y = 1f / result.y;
            result.z = 1f / result.z;
        }

        return result;
    }

    public static float Sum(this Vector3 vector) => vector.x + vector.y + vector.z;

    public static bool IsValidZone(DirectedActorSpawner spawner, Zone[] zones)
    {
        var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
        return zoneId == Zone.NONE || zones.Contains(zoneId);
    }

    private static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

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

    public static void CreateRanchExchangeOffer(IdentifiableId id, int weight, ProgressType[] progress)
    {
        if (progress.Length == 0)
            ExchangeOfferRegistry.RegisterInitialItem(id, weight);
        else
            ExchangeOfferRegistry.RegisterUnlockableItem(id, progress[0], weight);
    }

    public static bool IsAny<T>(this T item, params T[] items) where T : struct => items.Contains(item); // Reference types are never gonna be used, but it's better to be safe than sorry

    public static bool TryParse(Type enumType, string name, bool ignoreCase, out object result)
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

    public static bool TryGetValue<TKey, TValue>(this IDictionary<TKey, TValue> dict, TKey[] keys, out TValue result)
    {
        foreach (var key in keys)
        {
            if (dict.TryGetValue(key, out result))
                return true;
        }

        result = default;
        return false;
    }

    // public static bool ContainsKey<TKey, TValue>(this IDictionary<TKey, TValue> dict, TKey[] keys)
    // {
    //     foreach (var key in keys)
    //     {
    //         if (dict.ContainsKey(key))
    //             return true;
    //     }

    //     return false;
    // }

    public static string ToVectorString(this Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";

    public static string ToColorString(this Color value) => $"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}";

    public static bool IsNullableOf<T>(this Type type) => typeof(T).IsAssignableFrom(Nullable.GetUnderlyingType(type));

    public static bool IsNullableEnum(this Type type) => Nullable.GetUnderlyingType(type)?.IsEnum == true;

    public static bool TryAdd<TKey, TValue>(this IDictionary<TKey, TValue> dict, TKey key, TValue value)
    {
        try
        {
            dict.Add(key, value);
            return true;
        }
        catch
        {
            return false;
        }
    }

    public static void Deconstruct<TKey, TValue>(this KeyValuePair<TKey, TValue> pair, out TKey key, out TValue value)
    {
        key = pair.Key;
        value = pair.Value;
    }

    public static bool TryRemove<TKey, TValue>(this IDictionary<TKey, TValue> dict, TKey key, out TValue value)
    {
        try
        {
            return dict.TryGetValue(key, out value) && dict.Remove(key);
        }
        catch
        {
            value = default;
            return false;
        }
    }

    public static SlimeExpressionFace Clone(this SlimeExpressionFace face) => new()
    {
        SlimeExpression = face.SlimeExpression,
        Eyes = face.Eyes?.Clone(),
        Mouth = face.Mouth?.Clone(),
    };

#if DEBUG
    // public static void DoLog(this object message) => Main.Console.Log(message ?? "message was null");

    // public static void LogIf(this object message, bool condition)
    // {
    //     if (condition)
    //         message.DoLog();
    // }

    public static GameObject GetClosestCell(Vector3 pos)
    {
        GameObject closest = null;
        var distance = float.MaxValue;

        foreach (var cell in UnityEngine.SceneManagement
            .SceneManager.GetActiveScene()
            .GetRootGameObjects()
            .Where(x => x.name.StartsWith("zone"))
            .SelectMany(x => x.FindChildrenWithPartialName("cell", true)))
        {
            var diff = (cell.transform.position - pos).sqrMagnitude;

            if (diff >= distance)
                continue;

            closest = cell;
            distance = diff;
        }

        return closest;
    }
#endif
}