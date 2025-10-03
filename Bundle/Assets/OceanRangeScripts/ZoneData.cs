using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Data/Zone")]
public sealed class ZoneData : JsonData
{
    public string Region;
    public Orientation TeleporterOrientation;
    public string TeleporterLocation;
    public Dictionary<RequirementType, ZoneRequirementData> Requirements;
    public string AssetName;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}