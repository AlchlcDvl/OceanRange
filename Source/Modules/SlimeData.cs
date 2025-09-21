using System.Reflection;

namespace OceanRange.Modules;

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

    [JsonIgnore]
    public IdentifiableId GordoId;

    [JsonIgnore]
    public IdentifiableId PlortId;

    [JsonProperty("favFood")]
    public IdentifiableId FavFood;

    [JsonProperty("favToy"), JsonRequired]
    public IdentifiableId FavToy;

    [JsonProperty("nightSpawn")]
    public bool NightSpawn;

    [JsonProperty("diet")]
    public FoodGroup Diet;

    [JsonProperty("baseSlime")]
    public IdentifiableId BaseSlime = IdentifiableId.PINK_SLIME;

    [JsonProperty("basePlort")]
    public IdentifiableId BasePlort = IdentifiableId.PINK_PLORT;

    [JsonProperty("baseGordo")]
    public IdentifiableId BaseGordo = IdentifiableId.PINK_GORDO;

    [JsonIgnore]
    public MethodInfo InitSlimeDetails;

    [JsonIgnore]
    public MethodInfo InitPlortDetails;

    [JsonIgnore]
    public MethodInfo InitGordoDetails;

    [JsonProperty("topMouthColor")]
    public Color? TopMouthColor;

    [JsonProperty("middleMouthColor")]
    public Color? MiddleMouthColor;

    [JsonProperty("bottomMouthColor")]
    public Color? BottomMouthColor;

    [JsonProperty("redEyeColor")]
    public Color? RedEyeColor;

    [JsonProperty("greenEyeColor")]
    public Color? GreenEyeColor;

    [JsonProperty("blueEyeColor")]
    public Color? BlueEyeColor;

    [JsonProperty("topPaletteColor")]
    public Color? TopPaletteColor;

    [JsonProperty("middlePaletteColor")]
    public Color? MiddlePaletteColor;

    [JsonProperty("bottomPaletteColor")]
    public Color? BottomPaletteColor;

    [JsonProperty("plortAmmoColor")]
    public Color? PlortAmmoColor;

    [JsonProperty("pediaDiet"), JsonRequired]
    public string PediaDiet;

    [JsonProperty("fav"), JsonRequired]
    public string Fav;

    [JsonProperty("slimeology"), JsonRequired]
    public string Slimeology;

    [JsonProperty("risks"), JsonRequired]
    public string Risks;

    [JsonProperty("plortonomics"), JsonRequired]
    public string Plortonomics;

    [JsonProperty("plortType")]
    public string PlortType = "Pearl";

    [JsonProperty("canBeRefined")]
    public bool CanBeRefined;

    [JsonProperty("zones"), JsonRequired]
    public Zone[] Zones;

    [JsonProperty("gordoZone")]
    public Zone GordoZone;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 0.25f;

    [JsonProperty("hasGordo")]
    public bool HasGordo = true;

    [JsonProperty("gordoRewards")]
    public IdentifiableId[] GordoRewards;

    [JsonProperty("gordoOri")]
    public Orientation GordoOrientation;

    [JsonProperty("gordoLoc")]
    public string GordoCell;

    [JsonProperty("natGordoSpawn")]
    public bool NaturalGordoSpawn = true;

    [JsonProperty("plortExchangeWeight")]
    public int PlortExchangeWeight = 16;

    [JsonProperty("jiggle")]
    public float JiggleAmount = 1f;

    [JsonIgnore]
    public bool IsPopped;

    [JsonProperty("slimeFeatures"), JsonRequired]
    public ModelData[] SlimeFeatures;

    [JsonProperty("gordoFeatures")]
    public ModelData[] GordoFeatures;

    [JsonProperty("plortFeatures")]
    public ModelData[] PlortFeatures;

    [JsonProperty("toAdd")]
    public Type[] ComponentsToAdd;

    [JsonProperty("toRemove")]
    public Type[] ComponentsToRemove;

    [JsonProperty("spawners")]
    public string[] ExcludedSpawners;

    [JsonProperty("vaccable")]
    public bool Vaccable = true;

    [JsonProperty("gordoEat")]
    public int GordoEatAmount = 25;

    [JsonProperty("componentBase")]
    public IdentifiableId? ComponentBase;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.AddEnumValue<IdentifiableId>(upper + "_PLORT");
        MainEntry = Helpers.AddEnumValue<PediaId>(upper + "_SLIME_ENTRY");

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

        PlortFeatures ??= [.. SlimeFeatures.Select(x => new ModelData(x, false))];
        GordoFeatures ??= [.. SlimeFeatures.Select(x => new ModelData(x, false))];

        Vaccable |= Slimepedia.MvExists;
    }
}