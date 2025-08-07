using System.Reflection;
using System.Runtime.Serialization;
// using SRML;

namespace OceanRange.Modules;

public sealed class CustomSlimeData : JsonData
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
    public bool CanLargofy;

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

    [JsonProperty("gloss")]
    public float? Gloss = 1f;

    [JsonProperty("topSlimeColor")]
    public Color? TopSlimeColor;

    [JsonProperty("middleSlimeColor")]
    public Color? MiddleSlimeColor;

    [JsonProperty("bottomSlimeColor")]
    public Color? BottomSlimeColor;

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

    [JsonProperty("topPlortColor")]
    public Color? TopPlortColor;

    [JsonProperty("middlePlortColor")]
    public Color? MiddlePlortColor;

    [JsonProperty("bottomPlortColor")]
    public Color? BottomPlortColor;

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

    [JsonProperty("specialDiet")]
    public bool SpecialDiet;

    [JsonProperty("hasGordo")]
    public bool HasGordo = true;

    [JsonProperty("gordoRewards")]
    public IdentifiableId[] GordoRewards;

    [JsonProperty("gordoOri")]
    public Orientation GordoOrientation;

    [JsonProperty("gordoLoc")]
    public string GordoLocation;

    [JsonProperty("plortExchangeWeight")]
    public int PlortExchangeWeight = 16;

    [JsonProperty("jiggle")]
    public float JiggleAmount = 1f;

    [JsonIgnore]
    public bool IsPopped;

    // [JsonIgnore]
    // public readonly HashSet<IdentifiableId> Largos = [];

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpper();

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

        TopPaletteColor ??= TopSlimeColor;
        MiddlePaletteColor ??= MiddleSlimeColor;
        BottomPaletteColor ??= BottomSlimeColor;

        TopPlortColor ??= TopSlimeColor;
        MiddlePlortColor ??= MiddleSlimeColor;
        BottomPlortColor ??= BottomSlimeColor;

        PlortAmmoColor ??= MainAmmoColor;

        Progress ??= [];
    }

    // public void GenerateLargos(string[] modded) // WIP
    // {
    //     if (!CanLargofy)
    //         return;

    //     var upper = Name.ToUpper();
    //     var vanillaLargos = SlimeManager.VanillaSlimes.Select(x => Helpers.CreateIdentifiableId(x + "_" + upper + "_LARGO"));
    //     var moddedLargos = modded.Select(x => Helpers.CreateIdentifiableId(x + "_" + upper + "_LARGO"));
    //     Largos.UnionWith(vanillaLargos);
    //     Largos.UnionWith(moddedLargos);
    // }
}