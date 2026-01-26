// namespace OceanRange.Modules;

// public sealed class Box<T>(T value = default) : IEquatable<Box<T>>, IComparable<Box<T>>, IEquatable<T>, IComparable<T> // To be used as an out/ref param for coroutines
// {
//     private static readonly bool IsUnityObject = typeof(UObject).IsAssignableFrom(typeof(T));

//     public T Value = value;

//     public static implicit operator T(Box<T> outObj) => outObj == null ? default : outObj.Value;

//     public static implicit operator Box<T>(T value) => new(value);

//     public bool Equals(Box<T> other) => other != null && Equals(other.Value);

//     public bool Equals(T other) => IsUnityObject ? (UObject)(object)Value == (UObject)(object)other : EqualityComparer<T>.Default.Equals(Value, other);

//     public int CompareTo(T other) => Comparer<T>.Default.Compare(Value, other);

//     public int CompareTo(Box<T> other) => other != null ? Comparer<T>.Default.Compare(Value, other.Value) : 1;

//     public override string ToString() => Value?.ToString() ?? "null";

//     public override int GetHashCode() => Value?.GetHashCode() ?? 0;

//     public override bool Equals(object obj) => obj switch
//     {
//         Box<T> other => Equals(other),
//         T otherValue => Equals(otherValue),
//         _ => false
//     };

//     public bool IsNull()
//     {
//         if (Value == null)
//             return true;

//         if (Value is UObject uObj)
//             return !uObj;

//         return false;
//     }
// }