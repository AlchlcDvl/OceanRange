using UnityEngine;
using System.IO;
using System.Collections.Generic;

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