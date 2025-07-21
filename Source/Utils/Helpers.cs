// using SRML;
using AssetsLib;
using SRML.Utils;

namespace TheOceanRange.Utils;

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

    public static string[] TrueSplit(this string @string, params char[] separators) => [.. @string.Split(separators).Select(x => x.Trim()).Where(x => !string.IsNullOrEmpty(x))];

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
        gordo.transform.position = slimeData.GordoPos;
        gordo.transform.localEulerAngles  = slimeData.GordoRotation;
        gordo.name = gordo.name.Replace("(Clone)", "").Trim();
        gordo.GetComponent<GordoEat>().rewards.activeRewards = [.. gordo.GetComponent<GordoRewards>().rewardPrefabs];
    }

    public static T GetObjectFromName<T>(string name) where T : UObject
    {
        foreach (var t in Resources.FindObjectsOfTypeAll<T>())
        {
            if (t.name == name)
                return t;
        }

        return null;
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

            uv = originalMesh.uv,
            uv2 = originalMesh.uv2,
            uv3 = originalMesh.uv3,
            uv4 = originalMesh.uv4,
            uv5 = originalMesh.uv5,
            uv6 = originalMesh.uv6,
            uv7 = originalMesh.uv7,
            uv8 = originalMesh.uv8,

            subMeshCount = originalMesh.subMeshCount
        };

        for (var i = 0; i < originalMesh.subMeshCount; i++)
            mesh.SetTriangles(originalMesh.GetTriangles(i), i);

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();
        return mesh;
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

    public static string ToHexRGBA(this Color32 color) => $"{color.r:X2},{color.g:X2},{color.b:X2},{color.a:X2}";
}