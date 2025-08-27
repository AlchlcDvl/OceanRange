namespace OceanRange.Modules;

public sealed class LargoData : ActorData
{
    [JsonProperty("props"), JsonRequired]
    public LargoProps[] PropValues;

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

    [JsonProperty("meshes")]
    public string[] Meshes;

    [JsonIgnore]
    public LargoProps Props;

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
        foreach (var prop in PropValues)
            Props |= prop;

        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.CreateIdentifiableId((Props.HasFlag(LargoProps.UseSlime2NameFirst) ? (slime2Upper + "_" + slime1Upper) : (slime1Upper + "_" + slime2Upper)) + "_LARGO");
        Slime1Id = Helpers.ParseEnum<IdentifiableId>(slime1Upper + "_SLIME");
        Slime2Id = Helpers.ParseEnum<IdentifiableId>(slime2Upper + "_SLIME");

        if (slime1Upper == "MESMER")
            LargoManager.MesmerLargos.Add(MainId);

        Slime1Data = SlimeManager.SlimeDataMap[Slime1Id];
        Slime2Data = SlimeManager.SlimeDataMap[Slime2Id];
    }
}