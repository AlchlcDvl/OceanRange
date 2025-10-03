using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Holder/Ingredients")]
public sealed class Ingredients : JsonData
{
    public PlantData[] Plants;
    public ChimkenData[] Chimkens;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Chicken")]
public sealed class ChimkenData : SpawnedActorData
{
    public string[] Zones;
    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Plant")]
public sealed class PlantData : SpawnedActorData
{
    public string Type;
    public bool IsVeggie;
    public string ResourceIdSuffix;
    public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}