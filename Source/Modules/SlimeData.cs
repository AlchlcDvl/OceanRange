using System.Reflection;

namespace OceanRange.Modules;

public sealed class SlimeData : SpawnedActorData
{
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

    [JsonProperty("canLargofy")]
    public bool CanLargofy = true;

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
    public string GordoLocation;

    [JsonProperty("natGordoSpawn")]
    public bool NaturalGordoSpawn = true;

    [JsonProperty("plortExchangeWeight")]
    public int PlortExchangeWeight = 16;

    [JsonProperty("jiggle")]
    public float JiggleAmount = 1f;

    [JsonIgnore]
    public bool IsPopped;

    [JsonProperty("slimeMeshes")]
    public string[] SlimeMeshes;

    [JsonProperty("gordoMeshes")]
    public string[] GordoMeshes;

    [JsonProperty("plortMeshes")]
    public string[] PlortMeshes;

    [JsonProperty("toAdd")]
    public Type[] ComponentsToAdd;

    [JsonProperty("toRemove")]
    public Type[] ComponentsToRemove;

    [JsonProperty("skipNull")]
    public bool SkipNullMesh;

    [JsonProperty("slimeMatData"), JsonRequired]
    public MaterialData[] SlimeMatData;

    [JsonProperty("plortMatData")]
    public MaterialData[] PlortMatData;

    [JsonProperty("gordoMatData")]
    public MaterialData[] GordoMatData;

    [JsonProperty("spawners")]
    public string[] ExcludedSpawners;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.ParseEnum<IdentifiableId>(upper + "_PLORT");
        MainEntry = Helpers.ParseEnum<PediaId>(upper + "_SLIME_ENTRY");

        var type = typeof(SlimeManager);
        var init = "Init" + Name;
        InitSlimeDetails = AccessTools.Method(type, init + "SlimeDetails");
        InitPlortDetails = AccessTools.Method(type, init + "PlortDetails");

        HasGordo |= SlimeManager.MgExists && MainId == Ids.SAND_SLIME;

        if (HasGordo)
        {
            GordoId = Helpers.ParseEnum<IdentifiableId>(upper + "_GORDO");
            InitGordoDetails = AccessTools.Method(type, init + "GordoDetails");
        }

        if (NaturalGordoSpawn)
            NaturalGordoSpawn &= HasGordo;

        if (SlimeMatData?.Length is > 0)
        {
            var matData = SlimeMatData[0];
            TopPaletteColor ??= matData.TopColor;
            MiddlePaletteColor ??= matData.MiddleColor;
            BottomPaletteColor ??= matData.BottomColor;
        }

        PlortAmmoColor ??= MainAmmoColor;

        Progress ??= [];

        SlimeMeshes ??= [null];
        PlortMeshes ??= [null];
        GordoMeshes ??= [null];

        PlortMatData ??= SlimeMatData;
        GordoMatData ??= SlimeMatData;
    }
}