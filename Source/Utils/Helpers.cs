// using SRML;
using System.Globalization;
using AssetsLib;
using SRML.Utils;

#if DEBUG
using UnityEngine.SceneManagement;
#endif

namespace OceanRange.Utils;

public static class Helpers
{
    // private static readonly Dictionary<string, Color32> HexToColor32s = [];
    private static readonly Dictionary<string, Color> HexToColors = [];

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

    public static string ReplaceAll(this string @string, string newValue, params string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    private static readonly Func<string, bool> IsNotNullEmptyOrWhiteSpaceDel = IsNotNullEmptyOrWhiteSpace;
    private static readonly Func<string, string> TrimDel = Trim;

    public static string[] TrueSplit(this string @string, params char[] separators) => [.. @string.Split(separators).Select(TrimDel).Where(IsNotNullEmptyOrWhiteSpaceDel)];

    private static bool IsNotNullEmptyOrWhiteSpace(string @string) => !string.IsNullOrWhiteSpace(@string) && @string.Length != 0;

    private static string Trim(string @string) => @string.Trim();

    // public static IEnumerable<(int, T)> Indexed<T>(this IEnumerable<T> source)
    // {
    //     var i = 0;

    //     foreach (var item in source)
    //         yield return (i++, item);
    // }

    // public static Color32 HexToColor32(this string hex)
    // {
    //     if (HexToColor32s.TryGetValue(hex, out var color))
    //         return color;

    //     return HexToColor32s[hex] = ColorUtility.DoTryParseHtmlColor(hex, out color) ? color : Color.white;
    // }

    public static Color HexToColor(this string hex)
    {
        if (HexToColors.TryGetValue(hex, out var color))
            return color;

        return HexToColors[hex] = ColorUtility.TryParseHtmlString(hex, out color) ? color : Color.white;
    }

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value);

    public static T ToEnum<T>(object value) where T : struct, Enum => (T)Enum.ToObject(typeof(T), value);

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

    public static void BuildGordo(CustomSlimeData slimeData, GameObject sectorCategory)
    {
        var gordo = slimeData.GordoId.GetPrefab().Instantiate(sectorCategory.transform);
        gordo.transform.position = slimeData.GordoOrientation.Position;
        gordo.transform.localEulerAngles  = slimeData.GordoOrientation.Rotation;
        gordo.name = gordo.name.Replace("(Clone)", "").Trim();
        gordo.GetComponent<GordoEat>().rewards.activeRewards = [.. gordo.GetComponent<GordoRewards>().rewardPrefabs];
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
        var result = vector;

        for (var i = 1; i < power; i++)
            result = result.Multiply(vector);

        return result;
    }

    // public static Texture2D CreateRamp(string name, Color a, Color b)
    // {
    //     var texture2D = new Texture2D(128, 32);

    //     for (var i = 0; i < 128; i++)
    //     {
    //         var color = Color.Lerp(a, b, i / 127f);

    //         for (var j = 0; j < 32; j++)
    //             texture2D.SetPixel(i, j, color);
    //     }

    //     texture2D.name = name;
    //     texture2D.Apply();
    //     return texture2D;
    // }

    // public static Texture2D CreateRamp(string name, string hexA, string hexB) => CreateRamp(name, hexA.HexToColor(), hexB.HexToColor());

    // public static string ToHexRGBA(this Color32 color) => $"#{color.r:X2}{color.g:X2}{color.b:X2}{color.a:X2}";

    public static float Sum(this Vector3 vector) => vector.x + vector.y + vector.z;

    public static bool IsValidZone(DirectedActorSpawner spawner, Zone[] zones)
    {
        var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
        return zoneId == Zone.NONE || zones.Contains(zoneId);
    }

    public static Vector3 ParseVector(string value) => ParseVector(value, NumberStyles.Float | NumberStyles.AllowThousands, CultureInfo.InvariantCulture);

    public static Vector3 ParseVector(string value, NumberStyles style, CultureInfo culture)
    {
        var components = value.TrueSplit(',', ' ');

        switch (components.Length)
        {
            case < 2:
                throw new InvalidDataException($"'{value}' has too less values!");
            case > 3:
                throw new InvalidDataException($"'{value}' has too many values!");
        }

        if (!float.TryParse(components[0], style, culture, out var x))
            throw new InvalidDataException($"Invalid float string '{components[0]}'!");

        if (!float.TryParse(components[1], style, culture, out var y))
            throw new InvalidDataException($"Invalid float string '{components[1]}'!");

        float z;

        if (components.Length == 2)
            z = 0f;
        else if (!float.TryParse(components[2], style, culture, out z))
            throw new InvalidDataException($"Invalid float string '{components[2]}'!");

        return new(x, y, z);
    }

    public static bool TryParseVector(string value, NumberStyles styles, CultureInfo culture, out Vector3 result)
    {
        try
        {
            result = ParseVector(value, styles, culture);
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

    public static bool IsAny<T>(this T item, params T[] items) => items.Any(x => item.Equals(x));

    public static bool TryParse(Type enumType, string value, bool ignoreCase, out object result)
    {
        try
        {
            result = Enum.Parse(enumType, value, ignoreCase);
            return true;
        }
        catch
        {
            result = null;
            return false;
        }
    }

#if DEBUG
    private static bool IsZoneObj(GameObject gameObject) => gameObject.name.StartsWith("zone");

    private static GameObject[] GetCellObjects(GameObject zone) => zone.FindChildrenWithPartialName("cell", true);

    private static readonly Func<GameObject, bool> IsZone = IsZoneObj;
    private static readonly Func<GameObject, GameObject[]> GetCells = GetCellObjects;

    public static GameObject GetClosestCell(Vector3 pos)
    {
        GameObject closest = null;
        var distance = float.MaxValue;

        foreach (var cell in SceneManager.GetActiveScene().GetRootGameObjects().Where(IsZone).SelectMany(GetCells))
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