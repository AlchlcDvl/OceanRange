using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Data/Zone Req")]
public sealed class ZoneRequirementData : JsonData
{
    public int CorporateLevelMin = 0;
    public int CorporateLevelMax = int.MaxValue;
    public int ExchangeProgress;
    public string PathToGameObject;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }

}

public enum RequirementType
{
    CorporateLevel,
    ExchangeProgress,
    DevCommand,
}

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

[CreateAssetMenu(menuName = "OceanRange/Data/Region")]
public sealed class RegionData : JsonData
{
    public float InitialWorldSize;
    public Vector3 InitialWorldPos;
    public float MinNodeSize;
    public float LoosenessVal;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Holder/World")]
public sealed class World : JsonData
{
    public ZoneData[] Zones;
    public RegionData[] Regions;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}