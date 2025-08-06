// using SRML;
using System.Collections;
using System.Globalization;
using SRML.Utils;

namespace OceanRange.Utils;

public static class Helpers
{
    private static readonly Dictionary<string, Color32> HexToColor32s = [];
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

    public static bool TryFinding(this IEnumerable source, Func<object, bool> predicate, out object value)
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
        return obj;
    }

    public static string ReplaceAll(this string @string, string newValue, params string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    private static readonly Func<string, bool> IsNotNullEmptyOrWhiteSpaceDel = IsNotNullEmptyOrWhiteSpace;
    private static readonly Func<string, string> TrimDel = Trim;

    public static string[] TrueSplit(this string @string, params char[] separators) => [.. @string.Split(separators, StringSplitOptions.RemoveEmptyEntries).Select(TrimDel).Where(IsNotNullEmptyOrWhiteSpaceDel)];

    private static bool IsNotNullEmptyOrWhiteSpace(string @string) => !string.IsNullOrWhiteSpace(@string);

    private static string Trim(string @string) => @string.Trim();

    public static Color32 HexToColor32(this string hex)
    {
        if (HexToColor32s.TryGetValue(hex, out var color))
            return color;

        if (ColorUtility.DoTryParseHtmlColor(hex, out color))
            return HexToColor32s[hex] = color;

        throw new InvalidDataException($"Invalid color hex {hex}!");
    }

    public static Color HexToColor(this string hex)
    {
        if (HexToColors.TryGetValue(hex, out var color))
            return color;

        if (ColorUtility.TryParseHtmlString(hex, out color))
            return HexToColors[hex] = color;

        throw new InvalidDataException($"Invalid color hex {hex}!");
    }

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value);

    public static T ToEnum<T>(object value) where T : struct, Enum => (T)Enum.ToObject(typeof(T), value);

    public static T DeepCopy<T>(this T obj) where T : UObject => (T)PrefabUtils.DeepCopyObject(obj).DontDestroy();

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

    public static bool IsAny<T>(this T item, params T[] items) where T : struct => items.Contains(item); // Reference types are never gonna be used but it's better to be safe than sorry

    private static readonly Dictionary<Type, Array> EnumMaps = [];

    public static bool TryParse(Type enumType, string name, bool ignoreCase, out object result)
    {
        if (!EnumMaps.TryGetValue(enumType, out var enums))
            enums = EnumMaps[enumType] = Enum.GetValues(enumType);

        var caseCheck = ignoreCase ? StringComparison.InvariantCultureIgnoreCase : StringComparison.InvariantCulture;

        if (enums.TryFinding(value => string.Equals(value.ToString(), name, caseCheck), out var value))
        {
            result = value;
            return true;
        }

        result = null;
        return false;
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

    public static string ToVectorString(Vector3 value) => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";

    public static string ToColorString(Color value) => $"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}";

#if DEBUG
    private static bool IsZoneObj(GameObject gameObject) => gameObject.name.StartsWith("zone");

    private static GameObject[] GetCellObjects(GameObject zone) => zone.FindChildrenWithPartialName("cell", true);

    private static readonly Func<GameObject, bool> IsZone = IsZoneObj;
    private static readonly Func<GameObject, GameObject[]> GetCells = GetCellObjects;

    public static GameObject GetClosestCell(Vector3 pos)
    {
        GameObject closest = null;
        var distance = float.MaxValue;

        foreach (var cell in UnityEngine.SceneManagement.SceneManager.GetActiveScene().GetRootGameObjects().Where(IsZone).SelectMany(GetCells))
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