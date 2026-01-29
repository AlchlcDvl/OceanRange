using SRML;
using System.Globalization;
using SRML.Utils;
using System.Collections;
using System.Reflection;
using OceanRange.Saves;
using System.Linq.Expressions;
using System.Runtime.CompilerServices;
using System.Text;

namespace OceanRange.Utils;

public static class Helpers
{
    // private static readonly Dictionary<string, Color32> HexToColor32s = [];
    private static readonly Dictionary<string, Color> HexToColors = [];

    extension<T1>(IEnumerable<T1> source1)
    {
        public bool TryFinding(Func<T1, bool> predicate, out T1 value)
        {
            foreach (var item in source1)
            {
                if (!predicate(item))
                    continue;

                value = item;
                return true;
            }

            value = default;
            return false;
        }

        public IEnumerable<T1> Except(Func<T1, bool> predicate) => source1.Where(x => !predicate(x));

        public IEnumerable<(T1, T2)> Zip<T2>(IEnumerable<T2> source2)
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
    }

    extension(string @string)
    {
        public string ReplaceAll(string newValue, string[] valuesToReplace)
        {
            var sb = new StringBuilder(@string);

            foreach (var val in valuesToReplace)
                sb.Replace(val, newValue);

            return sb.ToString();
        }

        public List<string> TrueSplit(params char[] separators)
        {
            var separatorSet = separators.ToHashSet();
            var separatorCount = @string.Count(separatorSet.Contains);

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

        // public bool TryHexToColor32(out Color32 color)
        // {
        //     if (HexToColor32s.TryGetValue(@string, out color))
        //         return true;

        //     if (ColorUtility.DoTryParseHtmlColor(@string, out color))
        //     {
        //         HexToColor32s[@string] = color;
        //         return true;
        //     }

        //     color = default;
        //     return false;
        // }

        public bool TryHexToColor(out Color color)
        {
            if (HexToColors.TryGetValue(@string, out color))
                return true;

            if (ColorUtility.TryParseHtmlString(@string, out color))
            {
                HexToColors[@string] = color;
                return true;
            }

            color = default;
            return false;
        }

        public Color HexToColor() => @string.TryHexToColor(out var color) ? color : default;

        public bool StartsWith(char character) => @string.Length > 0 && @string[0] == character;
    }

    public static T ParseEnum<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value, true);

    // public static T ToEnum<T>(object value) where T : struct, Enum => (T)Enum.ToObject(typeof(T), value);

    extension<T>(T obj) where T : UObject
    {
        public T DontDestroy()
        {
            obj.DontDestroyOnLoad();
            obj.hideFlags |= HideFlags.HideAndDontSave;
            return obj;
        }

        // public T DeepCopy() => (T)PrefabUtils.DeepCopyObject(obj).DontDestroy();

        public T CreatePrefab() => UObject.Instantiate(obj, Main.PrefabParent, false);
    }

    // public static T DeepCopyNonUnityObject<T>(this T obj)
    // {
    //     var instance = Activator.CreateInstance<T>();
    //     instance.CopyValuesFrom(obj);
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
        gordo.name = gordo.name.Replace("(Clone)", string.Empty).Trim();
        gordo.GetComponent<GordoEat>().rewards.activeRewards = [.. gordo.GetComponent<GordoRewards>().rewardPrefabs, IdentifiableId.KEY.GetPrefab()];

        if (GordoSaveDataV02.Lookup.TryGetValue(slimeData.GordoId, out var popped) && popped.IsPopped)
            gordo.SetActive(false);
    }

    public static readonly List<Mesh> ClonedMeshes = [];

    public static Mesh Clone(this Mesh originalMesh)
    {
        var mesh = new Mesh
        {
            indexFormat = originalMesh.indexFormat,
            vertices = originalMesh.vertices,
            normals = originalMesh.normals,
            tangents = originalMesh.tangents,
            bounds = originalMesh.bounds,
            colors32 = originalMesh.colors32,
            name = originalMesh.name + "_Clone",
            subMeshCount = originalMesh.subMeshCount
        };

        var uvs = new List<Vector2>();

        for (var i = 0; i < 8; i++)
        {
            originalMesh.GetUVs(i, uvs);

            if (uvs.Count > 0)
                mesh.SetUVs(i, uvs);

            uvs.Clear();
        }

        for (var i = 0; i < originalMesh.subMeshCount; i++)
            mesh.SetTriangles(originalMesh.GetTriangles(i), i);

        ClonedMeshes.Add(mesh);
        return mesh.DontDestroy();
    }

    private static readonly HashSet<IdentifiableId> IdentifiableIds = new(Identifiable.idComparer);
    // private static readonly HashSet<GadgetId> GadgetIds = new(Gadget.idComparer);

    public static T ParseOrAddEnumValue<T>(string name) where T : struct, Enum => Enum.TryParse<T>(name, out var result) ? result : AddEnumValue<T>(name);

    public static T AddEnumValue<T>(string name) where T : struct, Enum => (T)AddEnumValue(name, typeof(T));

    public static object ParseOrAddEnumValue(string name, Type enumType) => TryParseEnum(enumType, name, true, out var result) ? result : AddEnumValue(name, enumType);

    public static object AddEnumValue(string name, Type enumType) => AddEnumValue(name, enumType, EnumPatcher.GetFirstFreeValue(enumType));

    public static T AddEnumValue<T>(string name, T value) where T : struct, Enum => (T)AddEnumValue(name, typeof(T), value);

    public static object AddEnumValue(string name, Type enumType, object value)
    {
        if (SRModLoader.CurrentLoadingStep > SRModLoader.LoadingStep.PRELOAD)
            throw new InvalidOperationException("Can't add enums outside of the Preload step");

        EnumPatcher.AddEnumValueWithAlternatives(enumType, value, name);

        switch (value)
        {
            case IdentifiableId identifiableId:
            {
                IdentifiableIds.Add(identifiableId);
                break;
            }
            // case GadgetId gadgetId: // TODO: Uncomment once we add gadgets
            // {
            //     GadgetIds.Add(gadgetId);
            //     break;
            // }
        }

        if (EnumMetadata.TryGet(enumType, out var metadata))
            metadata.AddEnumValue(value, name);

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

    // public static string ToHexRGBA(this Color32 color) => $"#{color.r.ToString(InvariantCulture):X2}{color.g.ToString(InvariantCulture):X2}{color.b.ToString(InvariantCulture):X2}{color.a.ToString(InvariantCulture):X2}";

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
        if (progress.IsNullOrEmpty())
            ExchangeOfferRegistry.RegisterInitialItem(id, weight);
        else
            ExchangeOfferRegistry.RegisterUnlockableItem(id, progress[0], weight);
    }

    // public static bool IsAny<T>(this T item, params T[] items) where T : struct => items.Contains(item); // Reference types are never gonna be used, but it's better to be safe than sorry

    public static bool TryParseEnum(Type enumType, string name, bool ignoreCase, out object result)
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

    extension(Vector3 value)
    {
        // public Vector3 ToPower(int power)
        // {
        //     if (power == 0)
        //         return Vector3.one;

        //     var result = Vector3.one;
        //     var abs = Mathf.Abs(power);

        //     for (var i = 0; i < abs; i++)
        //     {
        //         result.x *= value.x;
        //         result.y *= value.y;
        //         result.z *= value.z;
        //     }

        //     if (power < 0)
        //     {
        //         result.x = 1f / result.x;
        //         result.y = 1f / result.y;
        //         result.z = 1f / result.z;
        //     }

        //     return result;
        // }

        public float Sum() => value.x + value.y + value.z;

        public string ToVectorString() => $"{value.x.ToString(InvariantCulture)},{value.y.ToString(InvariantCulture)},{value.z.ToString(InvariantCulture)}";

        public Vector3 Multiply(Vector3 scale) => new(value.x * scale.x, value.y * scale.y, value.z * scale.z);

        // public Vector3 Abs() => new(Mathf.Abs(value.x), Mathf.Abs(value.y), Mathf.Abs(value.z));
    }

    public static string ToColorString(this Color value) => $"{value.r.ToString(InvariantCulture)},{value.g.ToString(InvariantCulture)},{value.b.ToString(InvariantCulture)},{value.a.ToString(InvariantCulture)}";

    extension(Type type)
    {
        public bool IsNullableOf<T>()
        {
            var tType = typeof(T);
            return tType.IsValueType && tType.IsAssignableFrom(Nullable.GetUnderlyingType(type));
        }

        public bool IsNullableEnum() => Nullable.GetUnderlyingType(type) is { IsEnum: true };
    }

    public static void Deconstruct<TKey, TValue>(this KeyValuePair<TKey, TValue> pair, out TKey key, out TValue value)
    {
        key = pair.Key;
        value = pair.Value;
    }

    extension<TKey, TValue>(IDictionary<TKey, TValue> dict)
    {
        public bool TryGetValue(TKey[] keys, out TValue result)
        {
            foreach (var key in keys)
            {
                if (dict.TryGetValue(key, out result))
                    return true;
            }

            result = default;
            return false;
        }

        // public bool ContainsKeys(params TKey[] keys)
        // {
        //     foreach (var key in keys)
        //     {
        //         if (dict.ContainsKey(key))
        //             return true;
        //     }

        //     return false;
        // }

        public bool TryAdd(TKey key, TValue value)
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

        public bool TryRemove(TKey key, out TValue value)
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

        public TValue GetOrAdd(TKey key, Func<TKey, TValue> func)
        {
            if (!dict.TryGetValue(key, out var value))
                dict[key] = value = func(key);

            return value;
        }

        public TValue GetOrAdd(TKey key, Func<TValue> func)
        {
            if (!dict.TryGetValue(key, out var value))
                dict[key] = value = func();

            return value;
        }

        public TValue GetOrAdd(TKey key, TValue defaultValue)
        {
            if (!dict.TryGetValue(key, out var value))
                dict[key] = value = defaultValue;

            return value;
        }
    }

    // public static IEnumerator PerformTimedAction(float duration, Action<float> action)
    // {
    //     var startTime = Time.time;
    //     var endTime = startTime + duration;
    //
    //     while (Time.time < endTime)
    //     {
    //         action((Time.time - startTime) / duration);
    //         yield return null;
    //     }
    //
    //     action(1f);
    // }

    // public static IEnumerator WaitWhile(Func<bool> predicate)
    // {
    //     while (predicate())
    //         yield return null;
    // }

    // public static IEnumerator WaitUntil(Func<bool> predicate)
    // {
    //     while (!predicate())
    //         yield return null;
    // }

    public static IEnumerator Wait(float duration)
    {
        var endTime = Time.time + duration;

        while (Time.time < endTime)
            yield return null;
    }

    extension(Component component)
    {
        // public bool TryGetInterfaceComponent<T>(out T result) where T : class
        // {
        //     if (component.TryGetComponent(typeof(T), out var value))
        //     {
        //         result = value as T;
        //         return true;
        //     }

        //     result = default;
        //     return false;
        // }

        public T EnsureComponent<T>() where T : Component => component.gameObject.EnsureComponent<T>();

        public bool HasComponent<T>() where T : Component => component.gameObject.HasComponent<T>();
    }

    extension(GameObject obj)
    {
        public GameObject[] FindAllChildren(string name)
        {
            var list = new List<GameObject>();

            foreach (Transform item in obj.transform)
            {
                if (item.name.Equals(name))
                    list.Add(item.gameObject);

                if (item.childCount > 0)
                    list.AddRange(item.gameObject.FindAllChildren(name));
            }

            return [.. list];
        }

        public T EnsureComponent<T>() where T : Component => obj.GetComponent<T>() ?? obj.AddComponent<T>();
    }

    extension<T>(MemberInfo info) where T : Attribute
    {
        public bool IsDefined() => info.IsDefined(typeof(T), false);

        public bool TryGetAttribute(out T attribute, bool inherit = true)
        {
            attribute = info.GetCustomAttribute<T>(inherit);
            return attribute != null;
        }
    }

    public static T[] GetEnumValues<T>() where T : struct, Enum => Enum.GetValues(typeof(T)) as T[];

    // public static string[] GetEnumNames<T>() where T : struct, Enum => Enum.GetNames(typeof(T));

    public static bool TryGetItem<T>(this T[] array, int index, out T value)
    {
        if (array.IsNullOrEmpty())
        {
            value = default;
            return false;
        }

        if (index < 0)
            index = array.Length + index;

        if (index >= 0 && index < array.Length)
        {
            value = array[index];
            return true;
        }

        value = default;
        return false;
    }

    // private static readonly List<Texture2D> CreatedRamps = [];

    // public static Texture2D CreateRamp(string name, Color a, Color b)
    // {
    //     var texture2D = new Texture2D(128, 32) { name = name };

    //     for (var i = 0; i < 128; i++)
    //     {
    //         var color = Color.Lerp(a, b, i / 127f);

    //         for (var j = 0; j < 32; j++)
    //             texture2D.SetPixel(i, j, color);
    //     }

    //     texture2D.Apply();
    //     CreatedRamps.Add(texture2D);
    //     return texture2D.DontDestroy();
    // }

    // public static Texture2D CreateRamp(string name, Color a, Texture2D b)
    // {
    //     var texture2D = new Texture2D(128, 32) { name = name };

    //     for (var i = 0; i < 128; i++)
    //     {
    //         for (var j = 0; j < 32; j++)
    //             texture2D.SetPixel(i, j, Color.Lerp(a, b.GetPixel(i, j), i / 127f));
    //     }

    //     texture2D.Apply();
    //     CreatedRamps.Add(texture2D);
    //     return texture2D.DontDestroy();
    // }

    // public static T AddComponent<T>(this Component component) where T : Component => component.gameObject.AddComponent<T>();

    public static List<Material> ClonedMats = [];

    extension(Material material)
    {
        public Material Clone()
        {
            var mat = new Material(material);
            ClonedMats.Add(mat);
            return mat;
        }

        // public void SetColors(params (int, Color)[] values)
        // {
        //     foreach (var (prop, color) in values)
        //         material.SetColor(prop, color);
        // }

        // public void SetColors(Color color, params int[] props)
        // {
        //     foreach (var prop in props)
        //         material.SetColor(prop, color);
        // }

        public void SetColor(int nameId, Color? color)
        {
            if (color.HasValue)
                material.SetColor(nameId, color.Value);
        }
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static bool HasFlagFast<T>(this T value, T flag) where T : struct, Enum => EnumFlagCache<T>.HasFlagDelegate(value, flag);

    private static class EnumFlagCache<T> where T : struct, Enum
    {
        public static readonly Func<T, T, bool> HasFlagDelegate = CreateDelegate();

        private static Func<T, T, bool> CreateDelegate()
        {
            var valueParam = Expression.Parameter(typeof(T), "value");
            var flagParam = Expression.Parameter(typeof(T), "flag");

            var underlyingType = Enum.GetUnderlyingType(typeof(T));

            var valueCast = Expression.Convert(valueParam, underlyingType); // (number)value
            var flagCast = Expression.Convert(flagParam, underlyingType); // (number)flag

            var andOp = Expression.And(valueCast, flagCast); // and = value & flag
            var bitCheck = Expression.Equal(andOp, flagCast); // bit = and == flag

            return Expression.Lambda<Func<T, T, bool>>(bitCheck, valueParam, flagParam).Compile();
        }
    }

    public static Action<T> CompileAction<T>(MethodInfo method)
    {
        var arg = Expression.Parameter(typeof(T), "arg");
        var callExpr = Expression.Call(method, arg);
        return Expression.Lambda<Action<T>>(callExpr, arg).Compile();
    }

    public static Action<T1, T2> CompileAction<T1, T2>(MethodInfo method)
    {
        var arg1 = Expression.Parameter(typeof(T1), "arg1");
        var arg2 = Expression.Parameter(typeof(T2), "arg2");

        var callExpr = Expression.Call(method, arg1, arg2);
        return Expression.Lambda<Action<T1, T2>>(callExpr, arg1, arg2).Compile();
    }
}