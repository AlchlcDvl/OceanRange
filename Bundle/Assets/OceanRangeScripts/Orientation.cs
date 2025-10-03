using UnityEngine;
using System.IO;
using System;

public struct Orientation : IEquatable<Orientation>
{
    public Vector3 Position;
    public Vector3 Rotation;
    public Vector3 Scale;

    public Orientation(Vector3 pos, Vector3 rot, Vector3 scale)
    {
        Position = pos;
        Rotation = rot;
        Scale = scale;
    }

    public Orientation(Vector3 pos, Vector3 rot) : this(pos, rot, Vector3.one) { }

    public Orientation(float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, float xScale, float yScale, float zScale)
        : this(new Vector3(xPos, yPos, zPos), new Vector3(ClampAngle(xRot), ClampAngle(yRot), ClampAngle(zRot)), new Vector3(xScale, yScale, zScale)) { }

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

    public override bool Equals(object obj) => obj is Orientation orientation && Equals(orientation);

    public bool Equals(Orientation other) => Position.Equals(other.Position) && Rotation.Equals(other.Rotation) && Scale.Equals(other.Scale);

    public override int GetHashCode() => Position.GetHashCode() ^ (Rotation.GetHashCode() << 2) ^ (Scale.GetHashCode() >> 2); // Mimics the Vector3 hash code calculation with x, y and z components

    public static bool operator ==(Orientation left, Orientation right) => left.Equals(right);

    public static bool operator !=(Orientation left, Orientation right) => !(left == right);

    // public void Deconstruct(out Vector3 position, out Vector3 rotation, out Vector3 scale)
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

    public void SerialiseTo(BinaryWriter writer)
    {

    }
}