using System.Collections;

namespace OceanRange.Modules;

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