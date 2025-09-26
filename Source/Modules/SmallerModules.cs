namespace OceanRange.Modules;

public sealed class PersistentId : MonoBehaviour
{
    public string ID;
}

public struct Orientation(Vector3 pos, Vector3 rot, Vector3 scale) : IEquatable<Orientation>
{
    public Vector3 Position = pos;
    public Vector3 Rotation = rot;
    public Vector3 Scale = scale;

    public Orientation(Vector3 pos, Vector3 rot) : this(pos, rot, Vector3.one) { }

    public Orientation(float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, float xScale, float yScale, float zScale)
        : this(new(xPos, yPos, zPos), new(ClampAngle(xRot), ClampAngle(yRot), ClampAngle(zRot)), new(xScale, yScale, zScale)) { }

    // To maintain parity with Unity's indexers for structs like Vectors, Quaternions and Colors
    // public Vector3 this[int index]
    // {
    //     readonly get => index switch
    //     {
    //         0 => Position,
    //         1 => Rotation,
    //         2 => Scale,
    //         _ => throw new ArgumentOutOfRangeException(nameof(index))
    //     };
    //     set
    //     {
    //         switch (index)
    //         {
    //             case 0:
    //             {
    //                 Position = value;
    //                 break;
    //             }
    //             case 1:
    //             {
    //                 Rotation = value;
    //                 break;
    //             }
    //             case 2:
    //             {
    //                 Scale = value;
    //                 break;
    //             }
    //             default:
    //                 throw new ArgumentOutOfRangeException(nameof(index));
    //         }
    //     }
    // }

    public override readonly bool Equals(object obj) => obj is Orientation orientation && Equals(orientation);

    public readonly bool Equals(Orientation other) => Position.Equals(other.Position) && Rotation.Equals(other.Rotation) && Scale.Equals(other.Scale);

    public override readonly int GetHashCode() => Position.GetHashCode() ^ (Rotation.GetHashCode() << 2) ^ (Scale.GetHashCode() >> 2); // Mimics the Vector3 hash code calculation with x, y and z components

    public static bool operator ==(Orientation left, Orientation right) => left.Equals(right);

    public static bool operator !=(Orientation left, Orientation right) => !(left == right);

    // public readonly void Deconstruct(out Vector3 position, out Vector3 rotation, out Vector3 scale)
    // {
    //     position = Position;
    //     rotation = Rotation;
    //     scale = Scale;
    // }

    private static float ClampAngle(float angle)
    {
        var clampedAngle = angle % 360f;
        return clampedAngle < 0 ? clampedAngle + 360f : clampedAngle;
    }
}

// public sealed class ValueMismatchException(string mainValue, object value1, object value2) : Exception($"{mainValue} contained {value1} but not {value2} or vice versa!");

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class

// public sealed record class Out<T>(T Value); // To be used as an out param for coroutines

public sealed class SoftTypeDictionary<T> : Dictionary<Type, T>
{
    public bool TryGetEquivalentKey(Type type, out T result)
    {
        using var enumerator = GetEnumerator();

        while (enumerator.MoveNext())
        {
            var (key, value) = enumerator.Current;

            if (!key.IsAssignableFrom(type))
                continue;

            result = value;
            return true;
        }

        result = default;
        return false;
    }
}

public sealed class PlatformComparer : IEqualityComparer<RuntimePlatform>
{
    public static readonly PlatformComparer Instance = new();

    public bool Equals(RuntimePlatform id1, RuntimePlatform id2) => id1 == id2;

    public int GetHashCode(RuntimePlatform id) => (int)id;
}