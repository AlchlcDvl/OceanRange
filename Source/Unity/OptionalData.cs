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

// [Serializable]
// public sealed class OptionalInt : OptionalData<int>
// {
//     public static implicit operator OptionalInt(int value) => new()
//     {
//         HasValue = true,
//         Value = value
//     };

//     public static implicit operator OptionalInt(int? value)
//     {
//         var result = new OptionalInt() { HasValue = value.HasValue };

//         if (value.HasValue)
//             result.Value = value.Value;

//         return result;
//     }
// }

// [Serializable]
// public sealed class OptionalColor : OptionalData<Color>
// {
//     public static implicit operator OptionalColor(Color value) => new()
//     {
//         HasValue = true,
//         Value = value
//     };

//     public static implicit operator OptionalColor(Color? value)
//     {
//         var result = new OptionalColor() { HasValue = value.HasValue };

//         if (value.HasValue)
//             result.Value = value.Value;

//         return result;
//     }
// }

// [Serializable]
// public sealed class OptionalFloat : OptionalData<float>
// {
//     public static implicit operator OptionalFloat(float value) => new()
//     {
//         HasValue = true,
//         Value = value
//     };

//     public static implicit operator OptionalFloat(float? value)
//     {
//         var result = new OptionalFloat() { HasValue = value.HasValue };

//         if (value.HasValue)
//             result.Value = value.Value;

//         return result;
//     }
// }

// [Serializable]
// public sealed class OptionalDouble : OptionalData<double>
// {
//     public static implicit operator OptionalDouble(double value) => new()
//     {
//         HasValue = true,
//         Value = value
//     };

//     public static implicit operator OptionalDouble(double? value)
//     {
//         var result = new OptionalDouble() { HasValue = value.HasValue };

//         if (value.HasValue)
//             result.Value = value.Value;

//         return result;
//     }
// }