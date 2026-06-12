namespace OceanRange.Data;

// A lot of the code in this struct is to maintain parity with Unity's behaviour for structs like Vectors, Quaternions and Colors
public struct Orientation(Vector3 pos, Vector3 rot, Vector3 scale) : IEquatable<Orientation>
{
    public Vector3 Position = pos;
    public Vector3 Rotation = ClampAngles(rot);
    public Vector3 Scale = scale;

    // public static readonly Orientation Identity = new(Vector3.zero, Vector3.zero, Vector3.one);

    // public Orientation() : this(Vector3.zero, Vector3.zero, Vector3.one) { } // Avoids the scales making things disappear

    // public Orientation(Transform t) : this(t.position, t.eulerAngles, t.localScale) { }

    // public Orientation(Vector3 pos) : this(pos, Vector3.zero, Vector3.one) { }

    // public Orientation(Vector3 pos, Quaternion rot) : this(pos, rot.eulerAngles, Vector3.one) { }

    // public Orientation(Vector3 pos, Quaternion rot, Vector3 scale) : this(pos, rot.eulerAngles, scale) { }

#if DEBUG
    public Orientation(Vector3 pos, Vector3 rot) : this(pos, rot, Vector3.one) { }
#endif

    public Orientation(float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, float xScale, float yScale, float zScale)
        : this(new(xPos, yPos, zPos), new(xRot, yRot, zRot), new(xScale, yScale, zScale)) { }

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

    // public static implicit operator Orientation(Transform t) => new(t);

    public static bool operator ==(Orientation left, Orientation right) => left.Equals(right);

    public static bool operator !=(Orientation left, Orientation right) => !(left == right);

    public readonly override bool Equals(object? obj) => obj is Orientation orientation && Equals(orientation);

    public readonly bool Equals(Orientation other) => Position.Equals(other.Position) && Rotation.Equals(other.Rotation) && Scale.Equals(other.Scale);

    public readonly override string ToString() => $"Position: {Position}, Rotation: {Rotation}, Scale: {Scale}";

    public readonly override int GetHashCode() => Position.GetHashCode() ^ (Rotation.GetHashCode() << 5) ^ (Scale.GetHashCode() >> 2); // Mimics the Vector3 hash code calculation with x, y and z components

    // public readonly Orientation WithPosition(Vector3 newPosition) => new(newPosition, Rotation, Scale);

    // public readonly Orientation WithRotation(Vector3 newRotation) => new(Position, newRotation, Scale);

    // public readonly Orientation WithQuaternion(Quaternion newRotation) => new(Position, newRotation.eulerAngles, Scale);

    // public readonly Orientation WithScale(Vector3 newScale) => new(Position, Rotation, newScale);

    // public readonly Quaternion ToQuaternion() => Quaternion.Euler(Rotation);

    // public readonly void SetTransform(Transform t, bool worldSpace = true)
    // {
    //     if (worldSpace)
    //     {
    //         t.position = Position;
    //         t.eulerAngles = Rotation;
    //     }
    //     else
    //     {
    //         t.localPosition = Position;
    //         t.localEulerAngles = Rotation;
    //     }

    //     t.localScale = Scale; // Can't really do world scale easily, but the general use case is local scale anyway
    // }

    // public static Orientation Lerp(Orientation a, Orientation b, float t) => new(Vector3.Lerp(a.Position, b.Position, t), ClampAngles(LerpAngle(a.Rotation, b.Rotation, t)), Vector3.Lerp(a.Scale, b.Scale, t));

    // public readonly void Deconstruct(out Vector3 position, out Vector3 rotation, out Vector3 scale)
    // {
    //     position = Position;
    //     rotation = Rotation;
    //     scale = Scale;
    // }

    private static Vector3 ClampAngles(Vector3 angles) => new(ClampAngle(angles.x), ClampAngle(angles.y), ClampAngle(angles.z));

    private static float ClampAngle(float angle)
    {
        var clampedAngle = angle % 360f;
        return clampedAngle < 0 ? clampedAngle + 360f : clampedAngle;
    }

    // private static Vector3 LerpAngle(Vector3 a, Vector3 b, float t) => new(Mathf.LerpAngle(a.x, b.x, t), Mathf.LerpAngle(a.y, b.y, t), Mathf.LerpAngle(a.z, b.z, t));
}