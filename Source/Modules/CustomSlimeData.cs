using System.Reflection;
using System.Runtime.Serialization;
// using SRML;

namespace TheOceanRange.Modules;

public sealed class CustomSlimeData : JsonData
{
    [JsonIgnore]
    public IdentifiableId GordoId;

    [JsonIgnore]
    public IdentifiableId FavFood;

    [JsonIgnore]
    public IdentifiableId FavToy;

    [JsonProperty("nightSpawn")]
    public bool NightSpawn;

    [JsonProperty("favFood")]
    public string FavFoodJson;

    [JsonProperty("favToy")]
    public string FavToyJson;

    [JsonIgnore]
    public IdentifiableId PlortId;

    [JsonIgnore]
    public FoodGroup Diet;

    [JsonProperty("diet")]
    public string DietJson;

    [JsonProperty("canLargofy")]
    public bool CanLargofy;

    [JsonProperty("baseSlime")]
    public string BaseSlimeJson = "PINK";

    [JsonProperty("basePlort")]
    public string BasePlortJson = "PINK";

    [JsonIgnore]
    public IdentifiableId BaseSlime;

    [JsonIgnore]
    public IdentifiableId BasePlort;

    [JsonIgnore]
    public MethodInfo InitSlimeDetails;

    [JsonIgnore]
    public MethodInfo InitPlortDetails;

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

    [JsonProperty("slimeAmmoColor"), JsonRequired]
    public string SlimeAmmoColor;

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

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 0.25f;

    [JsonProperty("specialDiet")]
    public bool SpecialDiet;

    [JsonProperty("plortExchangeWeight")]
    public float PlortExchangeWeight = 16f;

    // [JsonIgnore]
    // public readonly HashSet<IdentifiableId> Largos = [];

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpper();
        MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.ParseEnum<IdentifiableId>(upper + "_PLORT");
        BaseSlime = Helpers.ParseEnum<IdentifiableId>(BaseSlimeJson + "_SLIME");
        BasePlort = Helpers.ParseEnum<IdentifiableId>(BasePlortJson + "_PLORT");
        GordoId = Enum.TryParse<IdentifiableId>(upper + "_GORDO", out var id) ? id : 0; // Not all slimes have gordos
        MainEntry = Helpers.ParseEnum<PediaId>(upper + "_SLIME_ENTRY");
        InitSlimeDetails = AccessTools.Method(typeof(SlimeManager), "Init" + Name + "SlimeDetails");
        InitPlortDetails = AccessTools.Method(typeof(SlimeManager), "Init" + Name + "PlortDetails");
        Progress ??= [];

        // Newtonsoft is stupid and keeps throwing null refs for these fields
        FavFood = Helpers.ParseEnum<IdentifiableId>(FavFoodJson);
        FavToy = Helpers.ParseEnum<IdentifiableId>(FavToyJson);

        if (!SpecialDiet)
            Diet = Helpers.ParseEnum<FoodGroup>(DietJson);

        TopPaletteColor ??= TopSlimeColor;
        MiddlePaletteColor ??= MiddleSlimeColor;
        BottomPaletteColor ??= BottomSlimeColor;

        TopPlortColor ??= TopSlimeColor;
        MiddlePlortColor ??= MiddleSlimeColor;
        BottomPlortColor ??= BottomSlimeColor;

        PlortAmmoColor ??= SlimeAmmoColor;
    }

    // public void GenerateLargos(string[] modded)
    // {
    //     var upper = Name.ToUpper();
    //     var vanillaLargos = SlimeManager.VanillaSlimes.Select(x => Helpers.CreateIdentifiableId(x + "_" + upper + "_LARGO"));
    //     var moddedLargos = modded.Select(x => Helpers.CreateIdentifiableId(x + "_" + upper + "_LARGO"));
    //     Largos.UnionWith(vanillaLargos);
    //     Largos.UnionWith(moddedLargos);
    // }
}