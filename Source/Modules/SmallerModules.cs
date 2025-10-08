using System.Collections;

namespace OceanRange.Modules;

public sealed class PersistentId : MonoBehaviour
{
    public string ID;
}

// public sealed class ValueMismatchException(string mainValue, object value1, object value2) : Exception($"{mainValue} contained {value1} but not {value2} or vice versa!");

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class

// public sealed record class Out<T>(T Value); // To be used as an out param for coroutines

public sealed class SoftTypeDictionary<T> : IDictionary<Type, T>
{
    private readonly Dictionary<Type, T> AllPairs = [];

    public ICollection<Type> Keys => AllPairs.Keys;
    public ICollection<T> Values => AllPairs.Values;
    public int Count => AllPairs.Count;
    public bool IsReadOnly => false;

    public T this[Type key]
    {
        get => AllPairs[key];
        set
        {
            ClearKeys(key);
            AllPairs[key] = value;
        }
    }

    public void Add(Type key, T value)
    {
        ClearKeys(key);
        AllPairs.Add(key, value);
    }

    public bool Remove(Type key) => ClearKeys(key);

    public void Clear() => AllPairs.Clear();

    private bool ClearKeys(Type key)
    {
        var result = true;

        foreach (var innerKey in AllPairs.Keys.ToArray())
        {
            if (key.IsAssignableFrom(innerKey))
                result &= AllPairs.Remove(innerKey);
        }

        return result;
    }

    public bool ContainsKey(Type key) => AllPairs.ContainsKey(key);

    public bool TryGetValue(Type key, out T value)
    {
        if (AllPairs.TryGetValue(key, out value))
            return true;

        if (!TryGetEquivalentValue(key, out value))
            return false;

        return AllPairs.TryAdd(key, value);
    }

    public bool TryGetEquivalentValue(Type type, out T result)
    {
        foreach (var (key, value) in AllPairs)
        {
            if (!key.IsAssignableFrom(type))
                continue;

            result = value;
            return true;
        }

        result = default;
        return false;
    }

    public void Add(KeyValuePair<Type, T> item)
    {
        ClearKeys(item.Key);
        AllPairs.Add(item.Key, item.Value);
    }

    public bool Contains(KeyValuePair<Type, T> item) => TryGetValue(item.Key, out var value) && value.Equals(item.Value);

    public void CopyTo(KeyValuePair<Type, T>[] array, int arrayIndex) => ((IDictionary<Type, T>)AllPairs).CopyTo(array, arrayIndex);

    public bool Remove(KeyValuePair<Type, T> item) => Remove(item.Key);

    public IEnumerator<KeyValuePair<Type, T>> GetEnumerator() => AllPairs.GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

public sealed class PlatformComparer : IEqualityComparer<RuntimePlatform>
{
    public static readonly PlatformComparer Instance = new();

    public bool Equals(RuntimePlatform id1, RuntimePlatform id2) => id1 == id2;

    public int GetHashCode(RuntimePlatform id) => (int)id;
}

public sealed class RancherNameComparer : IEqualityComparer<RancherName>
{
    public static readonly RancherNameComparer Instance = new();

    public bool Equals(RancherName id1, RancherName id2) => id1 == id2;

    public int GetHashCode(RancherName id) => (int)id;
}

public sealed class LanguageComparer : IEqualityComparer<Language>
{
    public static readonly LanguageComparer Instance = new();

    public bool Equals(Language id1, Language id2) => id1 == id2;

    public int GetHashCode(Language id) => (int)id;
}

public sealed class PediaOnomicsHandler : MonoBehaviour
{
    public XlateText Text;

    public void Awake() => Text = gameObject.FindChild("PlortLabel", true).GetComponent<XlateText>();
}