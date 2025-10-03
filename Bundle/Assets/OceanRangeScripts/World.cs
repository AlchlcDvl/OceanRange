using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Holder/World")]
public sealed class World : JsonData
{
    public ZoneData[] Zones;
    public RegionData[] Regions;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}