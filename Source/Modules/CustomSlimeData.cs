using System.Reflection;
using System.Runtime.Serialization;
using Newtonsoft.Json;

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

    [JsonProperty("shininess")]
    public float Shininess = 1f;

    [JsonProperty("glossiness")]
    public float Glossiness = 1f;

    [JsonProperty("topSlimeColor"), JsonRequired]
    public string TopSlimeColor;

    [JsonProperty("middleSlimeColor"), JsonRequired]
    public string MiddleSlimeColor;

    [JsonProperty("bottomSlimeColor"), JsonRequired]
    public string BottomSlimeColor;

    [JsonProperty("specialSlimeColor"), JsonRequired]
    public string SpecialSlimeColor;

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

    [JsonProperty("topPaletteColor"), JsonRequired]
    public string TopPaletteColor;

    [JsonProperty("middlePaletteColor"), JsonRequired]
    public string MiddlePaletteColor;

    [JsonProperty("bottomPaletteColor"), JsonRequired]
    public string BottomPaletteColor;

    [JsonProperty("slimeAmmoColor"), JsonRequired]
    public string SlimeAmmoColor;

    [JsonProperty("topPlortColor"), JsonRequired]
    public string TopPlortColor;

    [JsonProperty("middlePlortColor"), JsonRequired]
    public string MiddlePlortColor;

    [JsonProperty("bottomPlortColor"), JsonRequired]
    public string BottomPlortColor;

    [JsonProperty("specialPlortColor"), JsonRequired]
    public string SpecialPlortColor;

    [JsonProperty("basePlortPrice"), JsonRequired]
    public float BasePlortPrice;

    [JsonProperty("saturation"), JsonRequired]
    public float Saturation;

    [JsonProperty("plortAmmoColor"), JsonRequired]
    public string PlortAmmoColor;

    [JsonProperty("intro"), JsonRequired]
    public string Intro;

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

        Category = ExchangeDirector.Category.SLIMES;
    }
}