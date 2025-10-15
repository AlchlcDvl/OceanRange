using System;
using System.IO;
using UnityEngine;

public abstract class Holder : ScriptableObject
{
    public abstract Type DataType { get; }
    public abstract string Name { get; }
    public abstract object BoxedValue { get; }

    public virtual string GetFileName() => Name.Replace(' ', '_').ToLowerInvariant();

    public abstract void SerialiseTo(BinaryWriter writer);

    public abstract void ReadJson(object values);
}