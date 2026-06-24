#if !UNITY
namespace OceanRange.Data;

public sealed partial class LargoData
{
    private static readonly Dictionary<string, Action<GameObject, SlimeDefinition>> DefinitionMethods = new(StringComparer.Ordinal);
    private static readonly Dictionary<string, Action<SlimeAppearance, AppearanceType>> AppearanceMethods = new(StringComparer.Ordinal);

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

    public DefinitionProps DefProps;

    public float? Jiggle;

    [JsonIgnore] public string Slime1;
    [JsonIgnore] public string Slime2;

    [JsonIgnore] public IdentifiableId Slime1Id;
    [JsonIgnore] public IdentifiableId Slime2Id;

    [JsonIgnore] public SlimeData? Slime1Data;
    [JsonIgnore] public SlimeData? Slime2Data;

    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitSlime1Details;
    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitSlime2Details;
    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitLargoDetails;

    [JsonIgnore] public Action<SlimeAppearance, AppearanceType>? InitSlime1AppearanceDetails;
    [JsonIgnore] public Action<SlimeAppearance, AppearanceType>? InitSlime2AppearanceDetails;
    [JsonIgnore] public Action<SlimeAppearance, AppearanceType>? InitLargoAppearanceDetails;

    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SS1Appearance;
    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SS2Appearance;
    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SSBothAppearance;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Appearances = reader.ReadArray(r => { var a = new LargoAppearanceData(); a.ReadFrom(r); return a; })!;
        DefProps = reader.ReadFlagEnum<DefinitionProps>();
        Jiggle = reader.ReadNullablePackedFloat();
    }

    public override void OnDeserialise()
    {
        var parts = Name!.TrueSplit(' ');

        Slime1 = parts[0];
        Slime2 = parts[1];

        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.ParseOrAddEnumValue<IdentifiableId>(slime1Upper + "_" + slime2Upper + "_LARGO");
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

        Array.ForEach(Appearances, a => a.OnDeserialise());
    }
}

public sealed partial class LargoAppearanceData
{
    public LargoAppearanceProps LargoProps;
    public AppearanceType AppProps;

    public ModelData? BodyStruct;

    public float? Jiggle;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        LargoProps = reader.ReadFlagEnum<LargoAppearanceProps>();
        AppProps = reader.ReadFlagEnum<AppearanceType>();

        if (reader.ReadBool())
        {
            BodyStruct = new ModelData();
            BodyStruct.ReadFrom(reader);
        }

        Slime1Structs = reader.ReadArray(r => { var m = new ModelData(); m.ReadFrom(r); return m; });
        Slime2Structs = reader.ReadArray(r => { var m = new ModelData(); m.ReadFrom(r); return m; });

        Jiggle = reader.ReadNullablePackedFloat();
    }

    public override void OnDeserialise() => BodyStruct?.MeshData.IsBody = true;

    public void SetJiggle(float jiggle)
    {
        Jiggle ??= jiggle;

        BodyStruct?.MeshData.Jiggle ??= Jiggle;

        if (!Slime1Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime1Structs!)
                feature.MeshData.Jiggle ??= Jiggle;
        }

        if (!Slime2Structs.IsNullOrEmpty())
        {
            foreach (var feature in Slime2Structs!)
                feature.MeshData.Jiggle ??= Jiggle;
        }
    }
}
#endif
