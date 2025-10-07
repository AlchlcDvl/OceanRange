using System.Reflection;

namespace OceanRange.Modules;

public sealed class SlimeHolder(BinaryReader reader) : Holder(reader)
{
    public SlimeData[] Slimes;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Slimes = reader.ReadArray(Helpers.ReadModData<SlimeData>);
    }
}

public sealed class SlimeData : SpawnedActorData
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

    public IdentifiableId? FavFood;
    public IdentifiableId FavToy;

    public bool NightSpawn;

    public FoodGroup? Diet;

    public IdentifiableId BaseSlime = IdentifiableId.PINK_SLIME;
    public IdentifiableId BasePlort = IdentifiableId.PINK_PLORT;
    public IdentifiableId BaseGordo = IdentifiableId.PINK_GORDO;

    public MethodInfo InitSlimeDetails;
    public MethodInfo InitPlortDetails;
    public MethodInfo InitGordoDetails;

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

    public string PlortType = "Pearl";

    public bool CanBeRefined;

    public Zone GordoZone;
    public bool HasGordo = true;
    public IdentifiableId[] GordoRewards;
    public Orientation GordoOrientation;
    public string GordoCell;
    public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float JiggleAmount = 1f;

    public ModelData[] SlimeFeatures;
    public ModelData[] GordoFeatures;
    public ModelData[] PlortFeatures;

    public Type[] ComponentsToAdd;
    public Type[] ComponentsToRemove;

    public Zone[] Zones;
    public string[] ExcludedSpawners;
    public float SpawnAmount = 0.25f;

    public bool Vaccable = true;
    public int GordoEatAmount = 25;

    public IdentifiableId? ComponentBase;

    public bool IsPopped;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        FavFood = reader.ReadNullable(Helpers.ReadEnum<IdentifiableId>);
        FavToy = reader.ReadEnum<IdentifiableId>();
        NightSpawn = reader.ReadBoolean();
        Diet = reader.ReadNullable(Helpers.ReadEnum<FoodGroup>);
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

        PlortType = reader.ReadString();
        CanBeRefined = reader.ReadBoolean();
        Zones = reader.ReadArray(Helpers.ReadEnum<Zone>);

        GordoZone = reader.ReadEnum<Zone>();

        SpawnAmount = reader.ReadSingle();
        HasGordo = reader.ReadBoolean();
        GordoRewards = reader.ReadArray(Helpers.ReadEnum<IdentifiableId>);
        GordoOrientation = reader.ReadOrientation();
        GordoCell = reader.ReadNullableString();
        NaturalGordoSpawn = reader.ReadBoolean();
        PlortExchangeWeight = reader.ReadInt32();
        JiggleAmount = reader.ReadSingle();
        SlimeFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        GordoFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        PlortFeatures = reader.ReadArray(Helpers.ReadModData<ModelData>);
        ComponentsToAdd = reader.ReadArray(Helpers.ReadType);
        ComponentsToRemove = reader.ReadArray(Helpers.ReadType);
        ExcludedSpawners = reader.ReadArray(Helpers.ReadString2);

        Vaccable = reader.ReadBoolean();
        GordoEatAmount = reader.ReadInt32();
        ComponentBase = reader.ReadNullable(Helpers.ReadEnum<IdentifiableId>);
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