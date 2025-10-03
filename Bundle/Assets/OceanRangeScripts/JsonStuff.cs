using UnityEngine;
using System.IO;

public abstract class JsonData : ScriptableObject
{
    public string Name;

    public abstract void SerialiseTo(BinaryWriter writer);
}

public abstract class SpawnedActorData : JsonData
{
    public string[] Progress;
    public float BasePrice;
    public float Saturation;
    public int ExchangeWeight = 20;
    public Color MainAmmoColor;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}