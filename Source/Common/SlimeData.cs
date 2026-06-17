// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global
// ReSharper disable MemberCanBePrivate.Global

#if !UNITY
using OceanRange.Saves;
#endif

namespace OceanRange.Data;

[Serializable]
public sealed class SlimeData : SpawnedActorData
{
#if !UNITY
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
#endif

    protected override bool SerialiseName => true;

    public bool NightSpawn;
    public bool CanBeRefined;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;

    public bool Vaccable = true;
    public bool Exchangeable = true;
    public string GordoCell;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    [JsonProperty] public string OnomicsType = "pearls";

    [JsonProperty("gordoEat")] public int GordoEatAmount = 25;

#if UNITY
    [JsonRequired] public string FavToy;
    [JsonRequired] public string[] Zones;

    public Optional<string> FavFood;
    public Optional<string> Diet;

    public string BaseSlime = "PINK_SLIME";
    public string BasePlort = "PINK_PLORT";
    public string BaseGordo = "PINK_GORDO";

    public Optional<string> ComponentBase;
    public Optional<string> GordoZone;
    public string[] GordoRewards;

    [JsonProperty("toAdd")] public string[] ComponentsToAdd;
    [JsonProperty("toRemove")] public string[] ComponentsToRemove;

    [JsonRequired] public SlimeAppearanceData NormalAppearance;
    public Optional<SlimeAppearanceData> SSAppearance;
#else
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
#endif

#if UNITY
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(FavToy);
        pooler.PoolStrings(Zones);
        pooler.PoolString(FavFood);
        pooler.PoolString(Diet);
        pooler.PoolString(BaseSlime);
        pooler.PoolString(BasePlort);
        pooler.PoolString(BaseGordo);
        pooler.PoolString(ComponentBase);
        pooler.PoolString(GordoZone);
        pooler.PoolStrings(GordoRewards);
        pooler.PoolString(GordoCell);

        pooler.PoolString(OnomicsType);

        pooler.PoolStrings(ComponentsToAdd);
        pooler.PoolStrings(ComponentsToRemove);

        NormalAppearance.FindStrings(pooler);

        if (SSAppearance.HasValue)
            SSAppearance.Value.FindStrings(pooler);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(FavToy);
        writer.WriteStringArray(Zones);
        writer.WriteString(FavFood);
        writer.WriteString(Diet);

        writer.WriteString(BaseSlime);
        writer.WriteString(BasePlort);
        writer.WriteString(BaseGordo);

        writer.WriteBool(CanBeRefined);

        writer.WriteString(ComponentBase);
        writer.WriteString(GordoZone);
        writer.WritePackedFloat(SpawnAmount);
        writer.WriteBool(HasGordo);
        writer.WriteStringArray(GordoRewards);

        writer.WriteBool(Vaccable);
        writer.WriteBool(Exchangeable);
        writer.WriteString(GordoCell);

        writer.WriteOrientation(GordoOrientation);
        writer.WriteBool(NaturalGordoSpawn);

        writer.WritePackedUInt((uint)PlortExchangeWeight);
        writer.WritePackedFloat(Jiggle);

        writer.WriteString(OnomicsType);

        writer.WriteStringArray(ComponentsToAdd);
        writer.WriteStringArray(ComponentsToRemove);

        writer.WritePackedUInt((uint)GordoEatAmount);

        NormalAppearance.WriteTo(writer);

        var hasSS = SSAppearance.HasValue;
        writer.WriteBool(hasSS);

        if (hasSS)
            SSAppearance.Value.WriteTo(writer);
    }
#else
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
#endif
}

[Serializable]
public sealed class SlimeAppearanceData : JsonData
{
    [JsonRequired] public ModelData[] SlimeFeatures;
    [JsonRequired] public ModelData[] GordoFeatures;
    [JsonRequired] public ModelData[] PlortFeatures;

#if UNITY
    [JsonRequired] public string MainAmmoColor;

    public string TopMouthColor;
    public string MiddleMouthColor;
    public string BottomMouthColor;
    public string RedEyeColor;
    public string GreenEyeColor;
    public string BlueEyeColor;
    public string TopPaletteColor;
    public string MiddlePaletteColor;
    public string BottomPaletteColor;
    public string PlortAmmoColor;
    public string EyesOrigin;
    public string MouthOrigin;

    public float? Jiggle;
#else
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
#endif

#if UNITY
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolSubstring(MainAmmoColor, 1);

        pooler.PoolSubstring(TopMouthColor, 1);
        pooler.PoolSubstring(MiddleMouthColor, 1);
        pooler.PoolSubstring(BottomMouthColor, 1);

        pooler.PoolSubstring(RedEyeColor, 1);
        pooler.PoolSubstring(GreenEyeColor, 1);
        pooler.PoolSubstring(BlueEyeColor, 1);

        pooler.PoolSubstring(TopPaletteColor, 1);
        pooler.PoolSubstring(MiddlePaletteColor, 1);
        pooler.PoolSubstring(BottomPaletteColor, 1);

        pooler.PoolSubstring(PlortAmmoColor, 1);

        pooler.PoolString(EyesOrigin);
        pooler.PoolString(MouthOrigin);

        Array.ForEach(SlimeFeatures, f => f.FindStrings(pooler));
        Array.ForEach(GordoFeatures, f => f.FindStrings(pooler));
        Array.ForEach(PlortFeatures, f => f.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteSubstring(MainAmmoColor, 1);

        writer.WriteSubstring(TopMouthColor, 1);
        writer.WriteSubstring(MiddleMouthColor, 1);
        writer.WriteSubstring(BottomMouthColor, 1);

        writer.WriteSubstring(RedEyeColor, 1);
        writer.WriteSubstring(GreenEyeColor, 1);
        writer.WriteSubstring(BlueEyeColor, 1);

        writer.WriteSubstring(TopPaletteColor, 1);
        writer.WriteSubstring(MiddlePaletteColor, 1);
        writer.WriteSubstring(BottomPaletteColor, 1);

        writer.WriteSubstring(PlortAmmoColor, 1);

        writer.WriteArray(SlimeFeatures, (w, f) => f.WriteTo(w));
        writer.WriteArray(GordoFeatures, (w, f) => f.WriteTo(w));
        writer.WriteArray(PlortFeatures, (w, f) => f.WriteTo(w));

        writer.WriteNullablePackedFloat(Jiggle);

        writer.WriteString(EyesOrigin);
        writer.WriteString(MouthOrigin);
    }
#else
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

        Main.Console.Log($"Read appearance data for {Name}");
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
        {
            MiddlePaletteColor = middleColor;
            Main.Console.Log($"Overwriting middle color - {(Color32)middleColor}");
        }
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
#endif
}