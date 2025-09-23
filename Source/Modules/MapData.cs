namespace OceanRange.Modules;

public sealed class ZoneData : JsonData
{
    [JsonProperty("intro"), JsonRequired]
    public string Intro;

    [JsonProperty("description"), JsonRequired]
    public string Description;

    [JsonProperty("presence"), JsonRequired]
    public string Presence;

    [JsonProperty("pediaName"), JsonRequired]
    public string PediaName;

    [JsonIgnore]
    public Zone Zone;

    [JsonIgnore]
    public PediaId PediaId;

    [JsonIgnore]
    public Ambiance Ambiance;

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

    public void PopulateValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        Region = Helpers.AddEnumValue<RegionId>(upper);
    }
}

public sealed class World
{
    [JsonProperty("zones")]
    public ZoneData[] Zones;

    [JsonProperty("regions")]
    public RegionData[] Regions;
}