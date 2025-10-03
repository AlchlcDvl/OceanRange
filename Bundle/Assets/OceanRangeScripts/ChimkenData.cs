using UnityEngine;
using System.IO;
using System.Collections.Generic;

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