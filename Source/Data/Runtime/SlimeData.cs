#if !UNITY
using OceanRange.Saves;

namespace OceanRange.Data;

public sealed partial class SlimeData
{
    private static readonly Dictionary<string, Action<SlimeAppearance, SlimeAppearanceData>> AppearanceMethods = new(StringComparer.Ordinal);
    private static readonly Dictionary<string, Action<GameObject, SlimeDefinition>> DefinitionMethods = new(StringComparer.Ordinal);

    static SlimeData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Slimepedia)))
        {
            if (method.Name.EndsWith("AppearanceDetails", StringComparison.Ordinal))
                AppearanceMethods[method.Name] = Helpers.CompileAction<SlimeAppearance, SlimeAppearanceData>(method);
            else if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                DefinitionMethods[method.Name] = Helpers.CompileAction<GameObject, SlimeDefinition>(method);
        }
    }

    [JsonIgnore] public IdentifiableId GordoId;
    [JsonIgnore] public IdentifiableId PlortId;
    [JsonIgnore] public PediaId PediaId;

    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitSlimeDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitPlortDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition>? InitGordoDetails;
    [JsonIgnore] public Action<SlimeAppearance, SlimeAppearanceData>? InitAppearanceDetails;

    public IdentifiableId FavToy;
    public Zone[] Zones;

    public IdentifiableId? FavFood;
    public FoodGroup? Diet;

    public IdentifiableId BaseSlime;
    public IdentifiableId BasePlort;
    public IdentifiableId BaseGordo;

    public IdentifiableId? ComponentBase;
    public Zone? GordoZone;
    public IdentifiableId[] GordoRewards;

    public Type[] ComponentsToAdd;
    public Type[] ComponentsToRemove;

    public SlimeAppearanceData NormalAppearance;
    public SlimeAppearanceData? SSAppearance;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        FavToy = reader.ReadEnum<IdentifiableId>();
        Zones = reader.ReadEnumArray<Zone>()!;
        FavFood = reader.ReadNullableEnum<IdentifiableId>();
        Diet = reader.ReadNullableEnum<FoodGroup>();

        BaseSlime = reader.ReadEnum<IdentifiableId>();
        BasePlort = reader.ReadEnum<IdentifiableId>();
        BaseGordo = reader.ReadEnum<IdentifiableId>();

        CanBeRefined = reader.ReadBool();

        ComponentBase = reader.ReadNullableEnum<IdentifiableId>();
        GordoZone = reader.ReadNullableEnum<Zone>();
        SpawnAmount = reader.ReadPackedFloat();
        HasGordo = reader.ReadBool();
        GordoRewards = reader.ReadEnumArray<IdentifiableId>()!;

        Vaccable = reader.ReadBool();
        Exchangeable = reader.ReadBool();
        GordoCell = reader.ReadString()!;

        GordoOrientation = reader.ReadOrientation();
        NaturalGordoSpawn = reader.ReadBool();

        PlortExchangeWeight = (int)reader.ReadPackedUInt();
        Jiggle = reader.ReadPackedFloat();

        OnomicsType = reader.ReadString()!;

        ComponentsToAdd = reader.ReadArray(r => r.ReadType())!;
        ComponentsToRemove = reader.ReadArray(r => r.ReadType())!;

        GordoEatAmount = (int)reader.ReadPackedUInt();

        NormalAppearance = new SlimeAppearanceData();
        NormalAppearance.ReadFrom(reader);

        if (!reader.ReadBool())
            return;

        SSAppearance = new SlimeAppearanceData();
        SSAppearance.ReadFrom(reader);
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        NormalAppearance.OnDeserialise();
        SSAppearance?.OnDeserialise();

        var upper = Name!.ToUpperInvariant();

        MainId = Helpers.ParseOrAddEnumValue<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.AddEnumValue<IdentifiableId>(upper + "_PLORT");

        var init = "Init" + Name;
        DefinitionMethods.TryGetValue(init + "SlimeDetails", out InitSlimeDetails);
        DefinitionMethods.TryGetValue(init + "PlortDetails", out InitPlortDetails);
        AppearanceMethods.TryGetValue(init + "AppearanceDetails", out InitAppearanceDetails);

        HasGordo |= Slimepedia.MgExists && upper == "SAND";
        NaturalGordoSpawn &= HasGordo;

        if (HasGordo)
        {
            GordoId = Helpers.AddEnumValue<IdentifiableId>(upper + "_GORDO");
            DefinitionMethods.TryGetValue(init + "GordoDetails", out InitGordoDetails);

            if (NaturalGordoSpawn)
                GordoSaveDataV02.AddGordo(GordoId);
        }

        NormalAppearance.SetJiggle(Jiggle);

        if (SSAppearance != null)
        {
            SSAppearance.SetJiggle(Jiggle);
            SSAppearance.IsSS = true;
        }

        Vaccable |= Slimepedia.MvExists;
    }

    public void HandleTranslationData(SlimeLangData data)
    {
        Translator.SlimeToOnomicsMap[data.PediaKey] = OnomicsType;
        PediaId = data.PediaId;
        data.SsExists = SSAppearance != null;
    }
}

public sealed partial class SlimeAppearanceData
{
    [JsonRequired] public Color MainAmmoColor;

    public Color? TopMouthColor;
    public Color? MiddleMouthColor;
    public Color? BottomMouthColor;

    public Color? RedEyeColor;
    public Color? GreenEyeColor;
    public Color? BlueEyeColor;

    public Color? TopPaletteColor;
    public Color? MiddlePaletteColor;
    public Color? BottomPaletteColor;

    public Color? PlortAmmoColor;

    public IdentifiableId? EyesOrigin;
    public IdentifiableId? MouthOrigin;

    public float? Jiggle;

    public bool IsSS;
    public bool HasMouthColors;
    public bool HasEyeColors;
    public bool ChangedFace;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        MainAmmoColor = ReadHex(reader) ?? Color.white;
        TopMouthColor = ReadHex(reader);
        MiddleMouthColor = ReadHex(reader);
        BottomMouthColor = ReadHex(reader);
        RedEyeColor = ReadHex(reader);
        GreenEyeColor = ReadHex(reader);
        BlueEyeColor = ReadHex(reader);
        TopPaletteColor = ReadHex(reader);
        MiddlePaletteColor = ReadHex(reader);
        BottomPaletteColor = ReadHex(reader);
        PlortAmmoColor = ReadHex(reader);

        SlimeFeatures = reader.ReadArray(r => { var m = new ModelData(); m.ReadFrom(r); return m; })!;
        GordoFeatures = reader.ReadArray(r => { var m = new ModelData(); m.ReadFrom(r); return m; })!;
        PlortFeatures = reader.ReadArray(r => { var m = new ModelData(); m.ReadFrom(r); return m; })!;

        Jiggle = reader.ReadNullablePackedFloat();

        EyesOrigin = reader.ReadNullableEnum<IdentifiableId>();
        MouthOrigin = reader.ReadNullableEnum<IdentifiableId>();
    }

    private static Color? ReadHex(DataReader reader)
    {
        var col = reader.ReadString();
        return string.IsNullOrEmpty(col) ? null : ("#" + col).HexToColor();
    }

    public override void OnDeserialise()
    {
        Array.ForEach(SlimeFeatures, x => x.OnDeserialise());
        Array.ForEach(GordoFeatures, x => x.OnDeserialise());
        Array.ForEach(PlortFeatures, x => x.OnDeserialise());

        var modelData = SlimeFeatures[0];
        modelData.MeshData.IsBody = true;
        var matData = modelData.MatData;

        if (!TopPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.TopColor, out var topColor))
            TopPaletteColor = topColor;

        if (!MiddlePaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.MiddleColor, out var middleColor))
            MiddlePaletteColor = middleColor;

        if (!BottomPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.BottomColor, out var bottomColor))
            BottomPaletteColor = bottomColor;

        PlortAmmoColor ??= MainAmmoColor;

        HasMouthColors = TopMouthColor.HasValue || MiddleMouthColor.HasValue || BottomMouthColor.HasValue;
        HasEyeColors = RedEyeColor.HasValue || GreenEyeColor.HasValue || BlueEyeColor.HasValue;
        ChangedFace = HasMouthColors || HasEyeColors;
    }

    public void SetJiggle(float jiggle)
    {
        Jiggle ??= jiggle;

        foreach (var feature in SlimeFeatures)
            feature.MeshData.Jiggle ??= Jiggle;

        foreach (var feature in GordoFeatures)
            feature.MeshData.Jiggle ??= Jiggle;
    }
}
#endif
