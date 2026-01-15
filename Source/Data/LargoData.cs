// ReSharper disable UnassignedField.Global

using System.Reflection;

namespace OceanRange.Data;

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

    // TODO: Awaiting models for indices 1, 2 and 3 - Stick to index 0 for normal appearance for now
    [JsonRequired] public LargoAppearanceData[] Appearances;

    public DefinitionProps DefProps;

    public float? Jiggle;

    [JsonIgnore] public string Slime1;
    [JsonIgnore] public string Slime2;

    [JsonIgnore] public IdentifiableId Slime1Id;
    [JsonIgnore] public IdentifiableId Slime2Id;

    [JsonIgnore] public SlimeData Slime1Data;
    [JsonIgnore] public SlimeData Slime2Data;

    [JsonIgnore] public MethodInfo InitSlime1Details;
    [JsonIgnore] public MethodInfo InitSlime2Details;
    [JsonIgnore] public MethodInfo InitLargoDetails;

    [JsonIgnore] public MethodInfo InitSlime1AppearanceDetails;
    [JsonIgnore] public MethodInfo InitSlime2AppearanceDetails;
    [JsonIgnore] public MethodInfo InitLargoAppearanceDetails;

    protected override void OnDeserialise()
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

        Methods.TryGetValue("Init" + Slime1 + "AppearanceDetails", out InitSlime1AppearanceDetails);
        Methods.TryGetValue("Init" + Slime2 + "AppearanceDetails", out InitSlime2AppearanceDetails);
        Methods.TryGetValue("Init" + Slime1 + Slime2 + "AppearanceDetails", out InitLargoAppearanceDetails);

        Slimepedia.SlimeDataMap.TryGetValue(Slime1Id, out Slime1Data);
        Slimepedia.SlimeDataMap.TryGetValue(Slime2Id, out Slime2Data);

        Jiggle ??= ((Slime1Data?.Jiggle ?? 1f) + (Slime2Data?.Jiggle ?? 1f)) / 2f;

        foreach (var appearance in Appearances)
            appearance.SetJiggle(Jiggle);
    }
}

public sealed class LargoAppearanceData : JsonData
{
    [JsonRequired] public LargoProps LargoProps;

    public AppearanceProps AppProps;

    public ModelData BodyStruct;

    public ModelData[] Slime1Structs;
    public ModelData[] Slime2Structs;

    public float? Jiggle;

    protected override void OnDeserialise()
    {
        if (BodyStruct == null)
            return;

        BodyStruct.IsBody = true;
        // BodyStruct.Mesh ??= "slime_default";
    }

    public void SetJiggle(float? jiggle)
    {
        if (BodyStruct != null)
            BodyStruct.Jiggle ??= jiggle;

        if (!Slime1Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime1Structs)
                feature.Jiggle ??= jiggle;
        }

        if (!Slime2Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime2Structs)
                feature.Jiggle ??= jiggle;
        }
    }
}