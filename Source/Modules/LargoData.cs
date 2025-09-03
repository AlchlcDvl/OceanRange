namespace OceanRange.Modules;

public sealed class LargoData : ActorData
{
    [JsonProperty("props"), JsonRequired]
    public LargoProps Props;

    [JsonProperty("slime1"), JsonRequired]
    public string Slime1;

    [JsonProperty("slime2"), JsonRequired]
    public string Slime2;

    [JsonProperty("bodyMatData")]
    public MaterialData BodyMatData;

    [JsonProperty("slime1StructureMatData")]
    public MaterialData[] Slime1StructMatData;

    [JsonProperty("slime2StructureMatData")]
    public MaterialData[] Slime2StructMatData;

    [JsonProperty("customMatData")]
    public MaterialData[] MatData;

    [JsonProperty("meshes")]
    public string[] Meshes;

    [JsonProperty("skipNull")]
    public bool SkipNull;

    [JsonProperty("jiggle")]
    public float? Jiggle;

    [JsonIgnore]
    public IdentifiableId Slime1Id;

    [JsonIgnore]
    public IdentifiableId Slime2Id;

    [JsonIgnore]
    public SlimeData Slime1Data;

    [JsonIgnore]
    public SlimeData Slime2Data;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(slime1Upper + "_" + slime2Upper + "_LARGO");
        Slime1Id = Helpers.ParseEnum<IdentifiableId>(slime1Upper + "_SLIME");
        Slime2Id = Helpers.ParseEnum<IdentifiableId>(slime2Upper + "_SLIME");

        if (slime1Upper == "MESMER" || slime2Upper == "MESMER")
            LargoManager.Mesmers.Add(MainId);

        if (SlimeManager.SlimeDataMap.TryGetValue(Slime1Id, out var data1))
            Slime1Data = data1;

        if (SlimeManager.SlimeDataMap.TryGetValue(Slime2Id, out var data2))
            Slime2Data = data2;

        Jiggle ??= ((Slime1Data?.JiggleAmount ?? 1f) + (Slime2Data?.JiggleAmount ?? 1f)) / 2f;
    }
}