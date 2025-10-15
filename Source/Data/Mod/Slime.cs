namespace OceanRange.Data;

public sealed partial class SlimeData : SpawnedActorData
{
    private static readonly Dictionary<string, MethodInfo> Methods = [];

    static SlimeData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Slimepedia)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

    public IdentifiableId GordoId;
    public IdentifiableId PlortId;

    public MethodInfo InitSlimeDetails;
    public MethodInfo InitPlortDetails;
    public MethodInfo InitGordoDetails;

    public bool IsPopped;

    [JsonProperty] public IdentifiableId? FavFood;
    [JsonProperty] public IdentifiableId FavToy;

    [JsonProperty] public FoodGroup? Diet;

    [JsonProperty] public IdentifiableId BaseSlime;
    [JsonProperty] public IdentifiableId BasePlort;
    [JsonProperty] public IdentifiableId BaseGordo;

    [JsonProperty] public Color? TopMouthColor;
    [JsonProperty] public Color? MiddleMouthColor;
    [JsonProperty] public Color? BottomMouthColor;

    [JsonProperty] public Color? RedEyeColor;
    [JsonProperty] public Color? GreenEyeColor;
    [JsonProperty] public Color? BlueEyeColor;

    [JsonProperty] public Color? TopPaletteColor;
    [JsonProperty] public Color? MiddlePaletteColor;
    [JsonProperty] public Color? BottomPaletteColor;

    [JsonProperty] public Color? PlortAmmoColor;

    [JsonProperty] public Zone GordoZone;
    [JsonProperty] public IdentifiableId[] GordoRewards;

    [JsonProperty] public Zone[] Zones;

    [JsonProperty] public IdentifiableId? ComponentBase;

    [JsonProperty("toAdd")] public Type[] ComponentsToAdd;
    [JsonProperty("toRemove")] public Type[] ComponentsToRemove;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        FavFood = reader.ReadNullableEnum<IdentifiableId>();
        FavToy = reader.ReadEnum<IdentifiableId>();
        NightSpawn = reader.ReadBoolean();
        Diet = reader.ReadNullableEnum<FoodGroup>();
        BaseSlime = reader.ReadEnum<IdentifiableId>();
        BasePlort = reader.ReadEnum<IdentifiableId>();
        BaseGordo = reader.ReadEnum<IdentifiableId>();

        TopMouthColor = reader.ReadNullable(Helpers.ReadColor);
        MiddleMouthColor = reader.ReadNullable(Helpers.ReadColor);
        BottomMouthColor = reader.ReadNullable(Helpers.ReadColor);
        RedEyeColor = reader.ReadNullable(Helpers.ReadColor);
        GreenEyeColor = reader.ReadNullable(Helpers.ReadColor);
        BlueEyeColor = reader.ReadNullable(Helpers.ReadColor);
        TopPaletteColor = reader.ReadNullable(Helpers.ReadColor);
        MiddlePaletteColor = reader.ReadNullable(Helpers.ReadColor);
        BottomPaletteColor = reader.ReadNullable(Helpers.ReadColor);
        PlortAmmoColor = reader.ReadNullable(Helpers.ReadColor);

        PlortType = reader.ReadString2();
        CanBeRefined = reader.ReadBoolean();
        Zones = reader.ReadArray(Helpers.ReadEnum<Zone>);

        GordoZone = reader.ReadEnum<Zone>();

        SpawnAmount = reader.ReadSingle();
        HasGordo = reader.ReadBoolean();
        GordoRewards = reader.ReadArray(Helpers.ReadEnum<IdentifiableId>);
        GordoOrientation = reader.ReadOrientation();
        GordoCell = reader.ReadString2();
        NaturalGordoSpawn = reader.ReadBoolean();
        PlortExchangeWeight = reader.ReadInt32();
        Jiggle = reader.ReadSingle();
        SlimeFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        GordoFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        PlortFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        ComponentsToAdd = reader.ReadArray(Helpers.ReadType);
        ComponentsToRemove = reader.ReadArray(Helpers.ReadType);
        ExcludedSpawners = reader.ReadArray(Helpers.ReadString2);

        Vaccable = reader.ReadBoolean();
        GordoEatAmount = reader.ReadInt32();
        ComponentBase = reader.ReadNullableEnum<IdentifiableId>();
    }

    public override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.AddEnumValue<IdentifiableId>(upper + "_PLORT");

        var init = "Init" + Name;
        Methods.TryGetValue(init + "SlimeDetails", out InitSlimeDetails);
        Methods.TryGetValue(init + "PlortDetails", out InitPlortDetails);

        HasGordo |= Slimepedia.MgExists && upper == "SAND";

        if (HasGordo)
        {
            GordoId = Helpers.AddEnumValue<IdentifiableId>(upper + "_GORDO");
            Methods.TryGetValue(init + "GordoDetails", out InitGordoDetails);
        }

        if (NaturalGordoSpawn)
            NaturalGordoSpawn &= HasGordo;

        if (SlimeFeatures.Length > 0)
        {
            var matData = SlimeFeatures[0];
            matData.IsBody = true;

            if (!TopPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.TopColor, out var topColor))
                TopPaletteColor = topColor;

            if (!MiddlePaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.MiddleColor, out var middleColor))
                MiddlePaletteColor = middleColor;

            if (!BottomPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.BottomColor, out var bottomColor))
                BottomPaletteColor = bottomColor;
        }

        PlortAmmoColor ??= MainAmmoColor;

        Progress ??= [];

        if (PlortFeatures?.Length is null or 0 || GordoFeatures?.Length is null or 0)
        {
            var copy = SlimeFeatures.Select(x => new ModelData(x, false)).ToArray();

            if (PlortFeatures?.Length is null or 0)
                PlortFeatures = copy;

            if (GordoFeatures?.Length is null or 0)
                GordoFeatures = copy;
        }

        Vaccable |= Slimepedia.MvExists;
    }
}