using System.Reflection;
using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public sealed class CustomSlimeData
{
    [JsonProperty("name")]
    public string Name;

    [JsonIgnore]
    public IdentifiableId SlimeId;

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
    public string BaseSlimeJson;

    [JsonProperty("basePlort")]
    public string BasePlortJson;

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

    [JsonProperty("topSlimeColor")]
    public string TopSlimeColor;

    [JsonProperty("middleSlimeColor")]
    public string MiddleSlimeColor;

    [JsonProperty("bottomSlimeColor")]
    public string BottomSlimeColor;

    [JsonProperty("specialSlimeColor")]
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

    [JsonProperty("topPaletteColor")]
    public string TopPaletteColor;

    [JsonProperty("middlePaletteColor")]
    public string MiddlePaletteColor;

    [JsonProperty("bottomPaletteColor")]
    public string BottomPaletteColor;

    [JsonProperty("slimeAmmoColor")]
    public string SlimeAmmoColor;

    [JsonProperty("topPlortColor")]
    public string TopPlortColor;

    [JsonProperty("middlePlortColor")]
    public string MiddlePlortColor;

    [JsonProperty("bottomPlortColor")]
    public string BottomPlortColor;

    [JsonProperty("specialPlortColor")]
    public string SpecialPlortColor;

    [JsonProperty("basePlortPrice")]
    public float BasePlortPrice;

    [JsonProperty("saturation")]
    public float Saturation;

    [JsonProperty("plortAmmoColor")]
    public string PlortAmmoColor;

    [JsonIgnore]
    public PediaId Entry;

    [JsonProperty("intro")]
    public string Intro;

    [JsonProperty("pediaDiet")]
    public string PediaDiet;

    [JsonProperty("fav")]
    public string Fav;

    [JsonProperty("slimeology")]
    public string Slimeology;

    [JsonProperty("risks")]
    public string Risks;

    [JsonProperty("plortonomics")]
    public string Plortonomics;

    [JsonProperty("plortType")]
    public string PlortType;

    [JsonProperty("canBeRefined")]
    public bool CanBeRefined;

    [JsonProperty("progress")]
    public ProgressType[] Progress;

    [JsonProperty("zones")]
    public Zone[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 0.25f;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpper();
        SlimeId = Helpers.ParseEnum<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.ParseEnum<IdentifiableId>(upper + "_PLORT");
        BaseSlime = Helpers.ParseEnum<IdentifiableId>(BaseSlimeJson + "_SLIME");
        BasePlort = Helpers.ParseEnum<IdentifiableId>(BasePlortJson + "_PLORT");
        GordoId = Enum.TryParse<IdentifiableId>(upper + "_GORDO", out var id) ? id : 0; // Not all slimes have gordos
        Entry = Helpers.ParseEnum<PediaId>(upper + "_SLIME_ENTRY");
        InitSlimeDetails = AccessTools.Method(typeof(SlimeManager), "Init" + Name + "SlimeDetails");
        InitPlortDetails = AccessTools.Method(typeof(SlimeManager), "Init" + Name + "PlortDetails");
        Progress ??= [];

        // Newton soft is stupid and keeps throwing null refs for these fields
        Diet = Helpers.ParseEnum<FoodGroup>(DietJson);
        FavFood = Helpers.ParseEnum<IdentifiableId>(FavFoodJson);
        FavToy = Helpers.ParseEnum<IdentifiableId>(FavToyJson);
    }
}