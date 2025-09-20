using System.Reflection;

namespace OceanRange.Modules;

public sealed class LargoData : ActorData
{
    private static readonly Dictionary<string, MethodInfo> Methods = [];

    static LargoData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Largopedia)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

    [JsonProperty("props"), JsonRequired]
    public LargoProps Props;

    [JsonIgnore]
    public string Slime1;

    [JsonIgnore]
    public string Slime2;

    [JsonProperty("bodyMesh")]
    public ModelData BodyStructData;

    [JsonProperty("slime1Meshes")]
    public ModelData[] Slime1StructData;

    [JsonProperty("slime2Meshes")]
    public ModelData[] Slime2StructData;

    [JsonProperty("meshes")]
    public ModelData[] LargoStructData;

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

    [JsonIgnore]
    public MethodInfo InitSlime1Details;

    [JsonIgnore]
    public MethodInfo InitSlime2Details;

    [JsonIgnore]
    public MethodInfo InitLargoDetails;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var parts = Name.TrueSplit(' ');

        Slime1 = parts[0];
        Slime2 = parts[1];

        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(slime1Upper + "_" + slime2Upper + "_LARGO");
        Slime1Id = Helpers.ParseEnum<IdentifiableId>(slime1Upper + "_SLIME");
        Slime2Id = Helpers.ParseEnum<IdentifiableId>(slime2Upper + "_SLIME");

        Methods.TryGetValue("Init" + Slime1 + "Details", out InitSlime1Details);
        Methods.TryGetValue("Init" + Slime2 + "Details", out InitSlime2Details);
        Methods.TryGetValue("Init" + Slime1 + Slime2 + "Details", out InitLargoDetails);

        Slimepedia.SlimeDataMap.TryGetValue(Slime1Id, out Slime1Data);
        Slimepedia.SlimeDataMap.TryGetValue(Slime2Id, out Slime2Data);

        Jiggle ??= ((Slime1Data?.JiggleAmount ?? 1f) + (Slime2Data?.JiggleAmount ?? 1f)) / 2f;

        BodyStructData?.IsBody = true;
    }
}