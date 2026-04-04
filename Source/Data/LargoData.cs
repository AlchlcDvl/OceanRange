// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class LargoData : ActorData
{
    private static readonly Dictionary<string, Action<GameObject, SlimeDefinition>> DefinitionMethods = [];
    private static readonly Dictionary<string, Action<SlimeAppearance, AppearanceType>> AppearanceMethods = [];

    static LargoData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Largopedia)))
        {
            if (method.Name.EndsWith("AppearanceDetails", StringComparison.Ordinal))
                AppearanceMethods[method.Name] = Helpers.CompileAction<SlimeAppearance, AppearanceType>(method);
            else if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                DefinitionMethods[method.Name] = Helpers.CompileAction<GameObject, SlimeDefinition>(method);
        }
    }

    // TODO: Awaiting models for indices 1, 2 and 3 - Stick to index 0 for normal appearance for now
    [JsonRequired] public LargoAppearanceData[] Appearances;

    public DefinitionProps DefProps;

    // ReSharper disable once MemberCanBePrivate.Global
    public float? Jiggle;

    [JsonIgnore] public string Slime1;
    [JsonIgnore] public string Slime2;

    [JsonIgnore] public IdentifiableId Slime1Id;
    [JsonIgnore] public IdentifiableId Slime2Id;

    [JsonIgnore] public SlimeData Slime1Data;
    [JsonIgnore] public SlimeData Slime2Data;

    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitSlime1Details;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitSlime2Details;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitLargoDetails;

    [JsonIgnore] public Action<SlimeAppearance, AppearanceType> InitSlime1AppearanceDetails;
    [JsonIgnore] public Action<SlimeAppearance, AppearanceType> InitSlime2AppearanceDetails;
    [JsonIgnore] public Action<SlimeAppearance, AppearanceType> InitLargoAppearanceDetails;

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

        DefinitionMethods.TryGetValue("Init" + Slime1 + "Details", out InitSlime1Details);
        DefinitionMethods.TryGetValue("Init" + Slime2 + "Details", out InitSlime2Details);
        DefinitionMethods.TryGetValue("Init" + Slime1 + Slime2 + "Details", out InitLargoDetails);

        AppearanceMethods.TryGetValue("Init" + Slime1 + "AppearanceDetails", out InitSlime1AppearanceDetails);
        AppearanceMethods.TryGetValue("Init" + Slime2 + "AppearanceDetails", out InitSlime2AppearanceDetails);
        AppearanceMethods.TryGetValue("Init" + Slime1 + Slime2 + "AppearanceDetails", out InitLargoAppearanceDetails);

        Slimepedia.SlimeDataMap.TryGetValue(Slime1Id, out Slime1Data);
        Slimepedia.SlimeDataMap.TryGetValue(Slime2Id, out Slime2Data);

        Jiggle ??= ((Slime1Data?.Jiggle ?? 1f) + (Slime2Data?.Jiggle ?? 1f)) / 2f;

        foreach (var appearance in Appearances)
            appearance.SetJiggle(Jiggle.Value);
    }
}

public sealed class LargoAppearanceData : JsonData
{
    public LargoAppearanceProps LargoProps;
    public AppearanceType AppProps;

    public ModelData BodyStruct;

    public ModelData[] Slime1Structs;
    public ModelData[] Slime2Structs;

    public float? Jiggle;

    protected override void OnDeserialise()
    {
        if (BodyStruct == null)
            return;

        BodyStruct.MeshData.IsBody = true;
        // BodyStruct.MeshData.Mesh ??= "slime_default";
    }

    public void SetJiggle(float jiggle)
    {
        Jiggle ??= jiggle;

        BodyStruct?.MeshData.Jiggle ??= Jiggle;

        if (!Slime1Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime1Structs)
                feature.MeshData.Jiggle ??= Jiggle;
        }

        if (!Slime2Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime2Structs)
                feature.MeshData.Jiggle ??= Jiggle;
        }
    }
}