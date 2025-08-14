namespace OceanRange.Modules;

public sealed class PersistentId : MonoBehaviour
{
    public string ID;
}

public struct Orientation(Vector3 pos, Vector3 rot) : IEquatable<Orientation>
{
    public Vector3 Position = pos;
    public Vector3 Rotation = rot;

    // public Orientation(float xPos, float yPos, float zPos, float xRot, float yRot, float zRot)
    //    : this(new(xPos, yPos, zPos), new(ClampAngle(xRot), ClampAngle(yRot), ClampAngle(zRot))) { }

    // public Vector3 this[int index]
    // {
    //     readonly get => index switch
    //     {
    //         0 => Position,
    //         1 => Rotation,
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
    //             default:
    //                 throw new ArgumentOutOfRangeException(nameof(index));
    //         }
    //     }
    // }

    public override readonly bool Equals(object obj) => obj is Orientation orientation && Equals(orientation);

    public readonly bool Equals(Orientation other) => Position.Equals(other.Position) && Rotation.Equals(other.Rotation);

    public override readonly int GetHashCode() => (Position.GetHashCode() * -1521134295) + Rotation.GetHashCode();

    public static bool operator ==(Orientation left, Orientation right) => left.Equals(right);

    public static bool operator !=(Orientation left, Orientation right) => !(left == right);

    // public readonly void Deconstruct(out Vector3 position, out Vector3 rotation)
    // {
    //     position = Position;
    //     rotation = Rotation;
    // }

    // private static float ClampAngle(float angle)
    // {
    //     var clampedAngle = angle % 360f;
    //     return clampedAngle < 0 ? clampedAngle + 360f : clampedAngle;
    // }
}

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class

// public sealed record class Out<T>(T Value); // To be used as an out param for coroutines