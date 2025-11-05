namespace OceanRange.Modules;

// A lot of the code in this struct is to maintain parity with Unity's behaviour for structs like Vectors, Quaternions and Colors
public struct Orientation(Vector3 pos, Vector3 rot, Vector3 scale) : IEquatable<Orientation>
{
    public Vector3 Position = pos;
    public Vector3 Rotation = ClampAngles(rot);
    public Vector3 Scale = scale;

    // public static readonly Orientation Identity = new(Vector3.zero, Vector3.zero, Vector3.one);

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

    public override readonly bool Equals(object obj) => obj is Orientation orientation && Equals(orientation);

    public readonly bool Equals(Orientation other) => Position.Equals(other.Position) && Rotation.Equals(other.Rotation) && Scale.Equals(other.Scale);

    public override readonly int GetHashCode() => Position.GetHashCode() ^ (Rotation.GetHashCode() << 2) ^ (Scale.GetHashCode() >> 2); // Mimics the Vector3 hash code calculation with x, y and z components

    public readonly override string ToString() => $"Position: {Position}, Rotation: {Rotation}, Scale: {Scale}";

    public static bool operator ==(Orientation left, Orientation right) => left.Equals(right);

    public static bool operator !=(Orientation left, Orientation right) => !(left == right);

    // public readonly Orientation WithPosition(Vector3 newPosition) => new(newPosition, Rotation, Scale);

    // public readonly Orientation WithRotation(Vector3 newRotation) => new(Position, newRotation, Scale);

    // public readonly Orientation WithQuaternion(Quaternion newRotation) => new(Position, newRotation.eulerAngles, Scale);

    // public readonly Orientation WithScale(Vector3 newScale) => new(Position, Rotation, newScale);

    // public readonly Quaternion ToQuaternion() => Quaternion.Euler(Rotation);

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
}