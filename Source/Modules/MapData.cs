namespace OceanRange.Modules;

public sealed class ZoneData : JsonData
{
    [JsonProperty("region"), JsonRequired]
    public RegionId Region;

    [JsonIgnore]
    public Zone Zone;

    [JsonIgnore]
    public PediaId PediaId;

    [JsonIgnore]
    public Ambiance Ambiance;

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