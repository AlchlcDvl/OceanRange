using Newtonsoft.Json.Converters;

namespace OceanRange.Modules;

public sealed class ZoneRequirementData : JsonData
{
    [JsonProperty("minLevel")]
    public int CorporateLevelMin = 0;
    
    [JsonProperty("maxLevel")]
    public int CorporateLevelMax = int.MaxValue;
    
    [JsonProperty("rancherProgress")]
    public int ExchangeProgress;
    
    [JsonProperty("modifyPath"), JsonRequired]
    public string PathToGameObject;
    
    public enum RequirementType
    {
        CorporateLevel,
        ExchangeProgress,
        DevCommand,
        
        // add more?
    }
}

public sealed class ZoneData : JsonData
{
    [JsonProperty("region"), JsonRequired]
    public RegionId Region;

    [JsonProperty("teleporterOri"), JsonRequired]
    public Orientation TeleporterOrientation;

    [JsonProperty("teleporterLoc"), JsonRequired]
    public string TeleporterLocation;

    
    [JsonProperty("requirements")] 
    // The key for the dictionary is the public ZoneRequirementData.RequirementType enum.
    public Dictionary<string, ZoneRequirementData> Requirements = new();
    
    [JsonProperty("prefab"), JsonRequired]
    public string AssetName;

    [JsonIgnore]
    public Zone Zone;

    [JsonIgnore]
    public PediaId PediaId;

    [JsonIgnore]
    public Ambiance Ambiance;

    [JsonIgnore]
    public bool PrefabsPrepped;

    [JsonIgnore]
    public GameObject Prefab;

    [JsonIgnore]
    public AmbianceDirectorZoneSetting AmbianceSetting;

    [OnDeserialized]
    public void PopulateValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        Zone = Helpers.AddEnumValue<Zone>(upper);
        PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
        Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
    }
}

public sealed class RegionData : JsonData
{
    [JsonProperty("initialWorldSize"), JsonRequired]
    public float InitialWorldSize;

    [JsonProperty("initialWorldPos"), JsonRequired]
    public Vector3 InitialWorldPos;

    [JsonProperty("minNodeSize"), JsonRequired]
    public float MinNodeSize;

    [JsonProperty("loosenessVal"), JsonRequired]
    public float LoosenessVal;

    [JsonIgnore]
    public RegionId Region;

    [OnDeserialized]
    public void PopulateValues(StreamingContext _) => Region = Helpers.AddEnumValue<RegionId>(Name.ToUpperInvariant());
}

public sealed class World
{
    [JsonProperty("zones")]
    public ZoneData[] Zones;

    [JsonProperty("regions")]
    public RegionData[] Regions;
}