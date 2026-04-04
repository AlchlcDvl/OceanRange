// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global
// ReSharper disable MemberCanBePrivate.Global

using OceanRange.Saves;

namespace OceanRange.Data;

public sealed class SlimeData : SpawnedActorData
{
    private static readonly Dictionary<string, Action<SlimeAppearance, SlimeAppearanceData>> AppearanceMethods = [];
    private static readonly Dictionary<string, Action<GameObject, SlimeDefinition>> DefinitionMethods = [];

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

    [JsonRequired] public IdentifiableId FavToy;
    [JsonRequired] public Zone[] Zones;
    [JsonRequired] public SlimeAppearanceData NormalAppearance;

    public SlimeAppearanceData SSAppearance;

    public bool NightSpawn;

    public IdentifiableId? FavFood;
    public FoodGroup? Diet;

    public IdentifiableId BaseSlime = IdentifiableId.PINK_SLIME;
    public IdentifiableId BasePlort = IdentifiableId.PINK_PLORT;
    public IdentifiableId BaseGordo = IdentifiableId.PINK_GORDO;

    public bool CanBeRefined;

    public IdentifiableId? ComponentBase;
    public Zone GordoZone;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;
    public IdentifiableId[] GordoRewards;

    public bool Vaccable = true;
    public bool Exchangeable = true;
    public string GordoCell;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    [JsonProperty] private string OnomicsType = "pearls";

    [JsonProperty("toAdd")] public Type[] ComponentsToAdd;
    [JsonProperty("toRemove")] public Type[] ComponentsToRemove;

    [JsonProperty("gordoEat")] public int GordoEatAmount = 25;

    [JsonIgnore] public IdentifiableId GordoId;
    [JsonIgnore] public IdentifiableId PlortId;

    [JsonIgnore] public PediaId PediaId;

    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitSlimeDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitPlortDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitGordoDetails;
    [JsonIgnore] public Action<SlimeAppearance, SlimeAppearanceData> InitAppearanceDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_SLIME");
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
    }
}

public sealed class SlimeAppearanceData : JsonData
{
    [JsonRequired] public ModelData[] SlimeFeatures;
    [JsonRequired] public ModelData[] GordoFeatures;
    [JsonRequired] public ModelData[] PlortFeatures;

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

    public float? Jiggle;

    [JsonIgnore] public bool IsSS;
    [JsonIgnore] public bool HasMouthColors;
    [JsonIgnore] public bool HasEyeColors;
    [JsonIgnore] public bool ChangedFace;

    protected override void OnDeserialise()
    {
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

        // foreach (var feature in SlimeFeatures)
        //     feature.MeshData.Mesh ??= "slime_default";

        // foreach (var feature in GordoFeatures)
        //     feature.MeshData.Mesh ??= "slime_gordo";

        // foreach (var feature in PlortFeatures)
        //     feature.MeshData.Mesh ??= "plort";

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