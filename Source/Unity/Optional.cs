#if UNITY
namespace OceanRange.Unity;

[Serializable]
public struct Optional<T> : IOptional
{
    public bool HasValue;
    public T Value;

    bool IOptional.HasValue => HasValue;
    object? IOptional.Value => Value;

    public Optional(T initialValue)
    {
        HasValue = true;
        Value = initialValue;
    }

    public static implicit operator T?(Optional<T> value) => value.HasValue ? value.Value! : default;
}

public interface IOptional
{
    bool HasValue { get; }
    object? Value { get; }
}
#endif