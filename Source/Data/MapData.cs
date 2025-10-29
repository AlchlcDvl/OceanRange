// ReSharper disable UnassignedField.Global
// ReSharper disable UnusedMember.Global

namespace OceanRange.Data;

public sealed class ZoneRequirementData : JsonData
{
    [JsonProperty("minLevel")] public int CorporateLevelMin;
    [JsonProperty("maxLevel")] public int CorporateLevelMax = int.MaxValue;

    [JsonProperty("rancherProgress")] public int ExchangeProgress;

    [JsonRequired] public string PathToGameObject;
}

public enum RequirementType : byte
{
    CorporateLevel,
    ExchangeProgress,
    DevCommand,

    // add more?
}

public sealed class ZoneData : JsonData
{
    [JsonRequired] public RegionId Region;

    [JsonProperty("teleporterOri"), JsonRequired] public Orientation TeleporterOrientation;
    [JsonProperty("teleporterLoc"), JsonRequired] public string TeleporterLocation;
    [JsonProperty("prefab"), JsonRequired] public string AssetName;

    public Dictionary<RequirementType, ZoneRequirementData> Requirements;

    [JsonIgnore] public Zone Zone;
    [JsonIgnore] public PediaId PediaId;
    [JsonIgnore] public Ambiance Ambiance;
    [JsonIgnore] public bool PrefabsPrepped;
    [JsonIgnore] public GameObject Prefab;
    [JsonIgnore] public AmbianceDirectorZoneSetting AmbianceSetting;

    protected override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        Zone = Helpers.AddEnumValue<Zone>(upper);
        PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
        Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
    }
}

public sealed class RegionData : JsonData
{
    [JsonRequired] public float MinNodeSize;
    [JsonRequired] public float LoosenessVal;
    [JsonRequired] public float InitialWorldSize;

    [JsonRequired] public Vector3 InitialWorldPos;

    [JsonIgnore] public RegionId Region;

    protected override void OnDeserialise() => Region = Helpers.AddEnumValue<RegionId>(Name.ToUpperInvariant());
}

public sealed class World : JsonData
{
    [JsonRequired] public RegionData[] Regions;
    [JsonRequired] public ZoneData[] Zones;
}