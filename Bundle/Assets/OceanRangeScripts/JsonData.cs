using UnityEngine;
using System.IO;

public abstract class JsonData : ScriptableObject
{
    public string Name;

    public abstract void SerialiseTo(BinaryWriter writer);
}