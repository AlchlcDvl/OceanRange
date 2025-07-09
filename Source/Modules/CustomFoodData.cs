using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public abstract class CustomFoodData
{
    [JsonProperty("name")]
    public string Name;

    [JsonIgnore]
    public IdentifiableId FoodId;

    [JsonProperty("group")]
    public string GroupJson;

    [JsonIgnore]
    public FoodGroup Group;

    [JsonProperty("favouriteModifier")]
    public int FavouriteModifier;

    [JsonProperty("minDrive")]
    public float MinDrive = 1f;

    [JsonProperty("favouredBy")]
    public string[] FavouredByJson;

    [JsonIgnore]
    public IdentifiableId[] FavouredBy;

    [JsonProperty("pediaFavouredBy")]
    public string PediaFavouredBy;

    [JsonProperty("about")]
    public string About;

    [JsonProperty("ammoColor")]
    public string AmmoColor;
}

public sealed class CustomChimkenData : CustomFoodData
{
    [JsonIgnore]
    public IdentifiableId HenId;

    [JsonIgnore]
    public IdentifiableId ChickId;

    [JsonProperty("zones")]
    public Zone[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 1f;

    [JsonIgnore]
    public PediaId HenEntry;

    [JsonIgnore]
    public PediaId ChickEntry;

    [JsonProperty("henIntro")]
    public string HenIntro;

    [JsonProperty("chickIntro")]
    public string ChickIntro;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        FavouredBy = [.. FavouredByJson.Select(Helpers.ParseEnum<IdentifiableId>)];
        var upper = Name.ToUpper();
        HenId = Helpers.ParseEnum<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.ParseEnum<IdentifiableId>(upper + "_CHICK");
        HenEntry = Helpers.ParseEnum<PediaId>(upper + "_HEN_ENTRY");
        ChickEntry = Helpers.ParseEnum<PediaId>(upper + "_CHICK_ENTRY");
        Group = FoodGroup.MEAT;
        FoodId = HenId;
    }
}

// public sealed class CustomPlantData : CustomFoodData
// {
//     [JsonIgnore]
//     public IdentifiableId PlantId;

//     [JsonProperty("type")]
//     public string Type;

//     [JsonProperty("intro")]
//     public string Intro;

//     [JsonProperty("garden")]
//     public string Garden;

//     [JsonIgnore]
//     public PediaId Entry;

//     [OnDeserialized]
//     public void PopulateRemainingValues(StreamingContext _)
//     {
//         FavouredBy = [.. FavouredByJson.Select(Helpers.ParseEnum<IdentifiableId>)];
//         var upper = Name.ToUpper();
//         var typeUpper = Type.ToUpper();
//         PlantId = Helpers.ParseEnum<IdentifiableId>(upper + "_" + typeUpper);
//         Entry = Helpers.ParseEnum<PediaId>(upper + "_" + typeUpper + "_ENTRY");
//         Group = Helpers.ParseEnum<FoodGroup>(GroupJson);
//         FoodId = PlantId;
//     }
// }