// ReSharper disable UnassignedField.Global
// ReSharper disable UnusedMember.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class ZoneRequirementData : JsonData
{
    [JsonProperty("minLevel")] public int CorporateLevelMin;
    [JsonProperty("maxLevel")] public int CorporateLevelMax = int.MaxValue;

    [JsonProperty("rancherProgress")] public int ExchangeProgress;

    [JsonRequired] public string PathToGameObject;
}

[Serializable]
public sealed partial class ZoneData : JsonData
{
    protected override bool SerialiseName => true;

    [JsonProperty("teleporterOri"), JsonRequired] public Orientation TeleporterOrientation;
    [JsonProperty("teleporterLoc"), JsonRequired] public string TeleporterLocation;
    [JsonProperty("prefab"), JsonRequired] public string AssetName;
}

[Serializable]
public sealed partial class RegionData : JsonData
{
    protected override bool SerialiseName => true;

    [JsonRequired] public float MinNodeSize;
    [JsonRequired] public float LoosenessVal;
    [JsonRequired] public float InitialWorldSize;

    [JsonRequired] public Vector3 InitialWorldPos;
}

[Serializable]
public sealed partial class World : JsonData
{
    [JsonRequired] public RegionData[] Regions;
    [JsonRequired] public ZoneData[] Zones;
}
