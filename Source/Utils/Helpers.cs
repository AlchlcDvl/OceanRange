using SRML;
using SRML.Utils;
using System.Collections;
using System.Reflection;

namespace OceanRange.Common;

public static partial class Helpers
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

    public static string ReplaceAll(this string @string, string newValue, string[] valuesToReplace)
    {
        valuesToReplace.Do(x => @string = @string.Replace(x, newValue));
        return @string;
    }

    // private static IEnumerable<T> ExceptBy<T>(this IEnumerable<T> source, Func<T, bool> predicate) => source.Where(x => !predicate(x));

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

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value, true);

    public static T ToEnum<T>(object value) where T : struct, Enum => (T)Enum.ToObject(typeof(T), value);

    public static T DeepCopy<T>(this T obj) where T : UObject => (T)PrefabUtils.DeepCopyObject(obj).DontDestroy();

    // public static T DeepCopyNonUnityObject<T>(this T obj)
    // {
    //     var instance = Activator.CreateInstance<T>();
    //     instance.CopyValues(obj);
    //     return instance;
    // }

    private const BindingFlags CopyFlags = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy;

    public static void CopyValuesFrom(this object dest, object source)
    {
        var type1 = dest.GetType();
        var type2 = source.GetType();

        if (type1 != type2)
            throw new InvalidOperationException($"Cannot copy over values between two different types! {type1.Name} & {type2.Name}");

        foreach (var field in type1.GetFields(CopyFlags))
            field.SetValue(dest, field.GetValue(source));

        foreach (var property in type1.GetProperties(CopyFlags))
        {
            if (property.CanWrite)
                property.SetValue(dest, property.GetValue(source));
        }
    }

    public static bool IsInLoopedRange(this float num, float min, float max, float rangeMin, float rangeMax, bool inner)
    {
        var result = num >= rangeMin && num <= rangeMax;
        var part = num >= min && num <= max;
        return (inner ? result : !result) && part;
    }

    public static void BuildGordo(SlimeData slimeData, GameObject sectorCategory)
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

    public static readonly List<Mesh> ClonedMeshes = [];

    public static Mesh Clone(this Mesh originalMesh)
    {
        if (!originalMesh.isReadable)
            return originalMesh;

        var mesh = new Mesh
        {
            vertices = originalMesh.vertices,
            triangles = originalMesh.triangles,

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

        ClonedMeshes.Add(mesh);
        return mesh;
    }

    private static readonly HashSet<IdentifiableId> IdentifiableIds = new(Identifiable.idComparer);
    // private static readonly HashSet<GadgetId> GadgetIds = new(Gadget.idComparer);

    public static T AddEnumValue<T>(string name) where T : struct, Enum => (T)AddEnumValue(name, typeof(T));

    public static object AddEnumValue(string name, Type enumType)
    {
        if (TryParseEnum(enumType, name, true, out var result))
            return result;

        if (SRModLoader.CurrentLoadingStep > SRModLoader.LoadingStep.PRELOAD)
            throw new InvalidOperationException("Can't add enums outside of the Preload step");

        var value = EnumPatcher.GetFirstFreeValue(enumType);
        EnumPatcher.AddEnumValueWithAlternatives(enumType, value, name);

        switch (value)
        {
            case IdentifiableId identifiableId:
            {
                IdentifiableIds.Add(identifiableId);
                break;
            }
            // case GadgetId gadgetId: // Uncomment once we add gadgets
            // {
            //     GadgetIds.Add(gadgetId);
            //     break;
            // }
        }

        return value;
    }

#if DEBUG
    [TimeDiagnostic("Ids Categoriz")]
#endif
    public static void CategoriseIds()
    {
        IdentifiableIds.Do(IdentifiableRegistry.CategorizeId);
        // GadgetIds.Do(GadgetRegistry.CategorizeId);
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

    public static bool IsValidZone(DirectedActorSpawner spawner, Zone[] zones, string[] excluded = null)
    {
        if (excluded?.Length is > 0)
        {
            var cell = spawner.GetComponentInParent<CellDirector>(true);

            if (excluded.Contains(cell.name.Replace("cell", "")))
                return false;
        }

        var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();

        if (Atlas.ZoneToDataMap.ContainsKey(zoneId)) // The prefabs are already set for these
            return false;

        return zoneId == Zone.NONE || zones.Contains(zoneId);
    }

    public static void CreateRanchExchangeOffer(IdentifiableId id, int weight, ProgressType[] progress)
    {
        if (progress.Length == 0)
            ExchangeOfferRegistry.RegisterInitialItem(id, weight);
        else
            ExchangeOfferRegistry.RegisterUnlockableItem(id, progress[0], weight);
    }

    // public static bool IsAny<T>(this T item, params T[] items) where T : struct => items.Contains(item); // Reference types are never gonna be used, but it's better to be safe than sorry

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

    // public static bool ContainsKeys<TKey, TValue>(this IDictionary<TKey, TValue> dict, params TKey[] keys)
    // {
    //     foreach (var key in keys)
    //     {
    //         if (dict.ContainsKey(key))
    //             return true;
    //     }

    //     return false;
    // }

    public static bool IsNullableOf<T>(this Type type)
    {
        var tType = typeof(T);
        return tType.IsValueType && tType.IsAssignableFrom(Nullable.GetUnderlyingType(type));
    }

    public static bool IsNullableEnum(this Type type) => Nullable.GetUnderlyingType(type) is { IsEnum: true };

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

    public static IEnumerator PerformTimedAction(float duration, Action<float> action)
    {
        var startTime = Time.time;
        var endTime = startTime + duration;

        while (Time.time < endTime)
        {
            action((Time.time - startTime) / duration);
            yield return null;
        }

        action(1f);
    }

    public static IEnumerator WaitWhile(Func<bool> predicate)
    {
        while (predicate())
            yield return null;
    }

    // public static IEnumerator WaitUntil(Func<bool> predicate)
    // {
    //     while (!predicate())
    //         yield return null;
    // }

    // public static IEnumerator Wait(float duration)
    // {
    //     var endTime = Time.time + duration;

    //     while (Time.time < endTime)
    //         yield return null;
    // }

    // public static bool TryGetInterfaceComponent<T>(this Component obj, out T component) where T : class
    // {
    //     if (obj.TryGetComponent(typeof(T), out var result))
    //     {
    //         component = result as T;
    //         return true;
    //     }

    //     component = default;
    //     return false;
    // }

    private static T EnsureComponent<T>(this GameObject go) where T : Component => go.GetComponent<T>() ?? go.AddComponent<T>();

    public static T EnsureComponent<T>(this Component component) where T : Component => component.gameObject.EnsureComponent<T>();

    // public static TValue GetOrAdd<TKey, TValue>(this IDictionary<TKey, TValue> dict, TKey key, Func<TKey, TValue> func)
    // {
    //     if (!dict.TryGetValue(key, out var value))
    //         dict[key] = value = func(key);

    //     return value;
    // }

    public static T[] GetEnumValues<T>() where T : struct, Enum => Enum.GetValues(typeof(T)) as T[];

    public static string[] GetEnumNames<T>() where T : struct, Enum => Enum.GetNames(typeof(T));

    public static Material Clone(this Material material) => new(material);

    public static T CreatePrefab<T>(this T obj) where T : UObject => UObject.Instantiate(obj, Main.PrefabParent, false);

    public static Vector3 Multiply(this Vector3 value, Vector3 scale) => new(value.x * scale.x, value.y * scale.y, value.z * scale.z);

    public static Vector3 Abs(this Vector3 value) => new(Mathf.Abs(value.x), Mathf.Abs(value.y), Mathf.Abs(value.z));

    public static bool TryGetItem<T>(this T[] array, int index, out T value)
    {
        if (array == null)
        {
            value = default;
            return false;
        }

        var result = index < array.Length && index >= 0;
        value = result ? array[index] : default;
        return result;
    }

    public static string ReadNullableString(this BinaryReader reader) => reader.ReadBoolean() ? reader.ReadString() : null;

    public static T? ReadNullable<T>(this BinaryReader reader, Func<BinaryReader, T> read) where T : struct => reader.ReadBoolean() ? read(reader) : null;

    public static Dictionary<TKey, TValue> ReadDictionary<TKey, TValue>(this BinaryReader reader, Func<BinaryReader, TKey> keyRead, Func<BinaryReader, TValue> valueRead)
    {
        var count = reader.ReadInt32();
        var dict = new Dictionary<TKey, TValue>(count);

        while (count-- > 0)
            dict[keyRead(reader)] = valueRead(reader);

        return dict;
    }

    public static T ReadEnum<T>(this BinaryReader reader) where T : struct, Enum => ParseEnum<T>(reader.ReadString());

    // public static object ReadEnum(this BinaryReader reader) => Enum.Parse(reader.ReadType(), reader.ReadString());

    public static T ReadModData<T>(this BinaryReader reader) where T : ModData, new()
    {
        if (reader.ReadBoolean())
            return null;

        var result = new T();
        result.DeserialiseFrom(reader);
        result.OnDeserialise();
        return result;
    }

    public static string ReadString2(this BinaryReader reader) => reader.ReadString();

    public static int ReadInt(this BinaryReader reader) => reader.ReadInt32();

    public static float ReadFloat(this BinaryReader reader) => reader.ReadSingle();

    public static double ReadDouble2(this BinaryReader reader) => reader.ReadDouble();

    public static Orientation ReadOrientation(this BinaryReader reader) => new(reader.ReadVector3(), reader.ReadVector3(), reader.ReadVector3());

    public static Vector3 ReadVector3(this BinaryReader reader) => BinaryUtils.ReadVector3(reader);

    public static Color ReadColor(this BinaryReader reader) => new(reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle(), reader.ReadSingle());

    public static T[] ReadArray<T>(this BinaryReader reader, Func<BinaryReader, T> read) => BinaryUtils.ReadArray(reader, read);

    public static T Combine<T>(this T[] array) where T : struct, Enum
    {
        var result = 0UL;

        foreach (var value in array)
            result |= Convert.ToUInt64(value);

        return ToEnum<T>(result);
    }

    private static readonly Dictionary<string, Type> CachedTypes = [];

    public static Type ReadType(this BinaryReader reader)
    {
        var name = reader.ReadString();

        if (!CachedTypes.TryGetValue(name!, out var type)) // Try to find if a type was already deserialised
            CachedTypes[name] = type = Type.GetType(name!) ?? throw new ArgumentException($"Cannot find type {name}!"); // Find type or throw if not found

        return type;
    }
}