using System.Reflection;
using System.Runtime.Serialization;
// using SRML;

namespace TheOceanRange.Modules;

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
    public float Gloss = 1f;

    [JsonProperty("topSlimeColor")]
    public string TopSlimeColor;

    [JsonProperty("middleSlimeColor")]
    public string MiddleSlimeColor;

    [JsonProperty("bottomSlimeColor")]
    public string BottomSlimeColor;

    [JsonProperty("topMouthColor")]
    public string TopMouthColor = "#000000";

    [JsonProperty("middleMouthColor")]
    public string MiddleMouthColor = "#000000";

    [JsonProperty("bottomMouthColor")]
    public string BottomMouthColor = "#000000";

    [JsonProperty("redEyeColor")]
    public string RedEyeColor = "#000000";

    [JsonProperty("greenEyeColor")]
    public string GreenEyeColor = "#000000";

    [JsonProperty("blueEyeColor")]
    public string BlueEyeColor = "#000000";

    [JsonProperty("topPaletteColor")]
    public string TopPaletteColor;

    [JsonProperty("middlePaletteColor")]
    public string MiddlePaletteColor;

    [JsonProperty("bottomPaletteColor")]
    public string BottomPaletteColor;

    [JsonProperty("topPlortColor")]
    public string TopPlortColor;

    [JsonProperty("middlePlortColor")]
    public string MiddlePlortColor;

    [JsonProperty("bottomPlortColor")]
    public string BottomPlortColor;

    [JsonProperty("plortAmmoColor")]
    public string PlortAmmoColor;

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

    [JsonProperty("gordoPos")]
    public Vector3 GordoPos;

    [JsonProperty("gordoRot")]
    public Vector3 GordoRotation;

    [JsonProperty("gordoLoc")]
    public string GordoLocation;

    [JsonProperty("plortExchangeWeight")]
    public float PlortExchangeWeight = 16f;

    [JsonProperty("jiggle")]
    public float JiggleAmount = 1f;

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