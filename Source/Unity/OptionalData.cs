namespace OceanRange.Unity;

[Serializable]
public class OptionalData<T>(T? value = null) where T : struct
{
    [Tooltip("Indicates whether or not the field has a value")]
    public bool HasValue = value.HasValue;

    [Tooltip("The value")]
    public T Value = value.GetValueOrDefault();

    public T? AsNullable() => HasValue ? Value : null;

    public T AsValue() => HasValue ? Value : throw new NullReferenceException();

    public void FromNullable(T? newValue)
    {
        HasValue = newValue.HasValue;
        Value = newValue.GetValueOrDefault();
    }

    public static implicit operator OptionalData<T>(T value) => new(value);

    public static implicit operator OptionalData<T>(T? value) => new(value);

    public static implicit operator T(OptionalData<T> optionalData) => optionalData.AsValue();

    public static implicit operator T?(OptionalData<T> optionalData) => optionalData?.AsNullable();

    public static implicit operator bool(OptionalData<T> optionalData) => optionalData?.HasValue ?? false;
}