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

    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SS1Appearance;
    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SS2Appearance;
    [JsonIgnore] public DLCContentMetadata_SlimeAppearance SSBothAppearance;

    public override void OnDeserialise()
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
#if !UNITY
    public LargoAppearanceProps LargoProps;
    public AppearanceType AppProps;
#else
    public string[] LargoProps;
    public string[] AppProps;
#endif

    public ModelData BodyStruct;

    public ModelData[] Slime1Structs;
    public ModelData[] Slime2Structs;

    public float? Jiggle;

#if !UNITY
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        var flagCount = reader.ReadPackedUInt();
        var flags = new string[flagCount];

        for (var i = 0; i < flagCount; i++)
            flags[i] = reader.ReadString();

        LargoProps = CombineFlagStrings<LargoAppearanceProps>(flags);

        flagCount = reader.ReadPackedUInt();
        flags = new string[flagCount];

        for (var i = 0; i < flagCount; i++)
            flags[i] = reader.ReadString();

        AppProps = CombineFlagStrings<AppearanceType>(flags);

        if (reader.ReadBool())
        {
            BodyStruct = new ModelData();
            BodyStruct.ReadFrom(reader);
        }

        var count = reader.ReadPackedUInt();

        if (count > 0)
        {
            Slime1Structs = new ModelData[count];

            for (var i = 0; i < count; i++)
            {
                Slime1Structs[i] = new ModelData();
                Slime1Structs[i].ReadFrom(reader);
            }
        }

        count = reader.ReadPackedUInt();

        if (count > 0)
        {
            Slime2Structs = new ModelData[count];

            for (var i = 0; i < count; i++)
            {
                Slime2Structs[i] = new ModelData();
                Slime2Structs[i].ReadFrom(reader);
            }
        }

            if (reader.ReadBool())
            Jiggle = reader.ReadPackedFloat();
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        BodyStruct?.MeshData.IsBody = true;
    }

    private static T CombineFlagStrings<T>(string[] names) where T : struct, Enum
    {
        if (names == null || names.Length == 0)
            return default;

        var combined = 0;
        foreach (var name in names)
        {
            if (Enum.TryParse<T>(name, out var val))
                combined |= (int)(object)val;
        }
        return (T)(object)combined;
    }
#else
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        writer.PoolStrings(LargoProps);
        writer.PoolStrings(AppProps);

        BodyStruct?.FindStrings(writer);

        if (Slime1Structs != null)
        {
            foreach (var s in Slime1Structs)
                s.FindStrings(writer);
        }

        if (Slime2Structs != null)
        {
            foreach (var s in Slime2Structs)
                s.FindStrings(writer);
        }
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WritePackedUInt((uint)LargoProps.Length);

        foreach (var flag in LargoProps)
            writer.WriteString(flag);

        writer.WritePackedUInt((uint)AppProps.Length);

        foreach (var flag in AppProps)
            writer.WriteString(flag);

        writer.WriteBool(BodyStruct != null);
        BodyStruct?.WriteTo(writer);

        writer.WritePackedUInt((uint)(Slime1Structs?.Length ?? 0));

        if (Slime1Structs != null)
        {
            foreach (var s in Slime1Structs)
                s.WriteTo(writer);
        }

        writer.WritePackedUInt((uint)(Slime2Structs?.Length ?? 0));

        if (Slime2Structs != null)
        {
            foreach (var s in Slime2Structs)
                s.WriteTo(writer);
        }

        writer.WriteBool(Jiggle.HasValue);

        if (Jiggle.HasValue)
            writer.WritePackedFloat(Jiggle.Value);
    }
#endif

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