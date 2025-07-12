using System.Runtime.Serialization;

namespace TheOceanRange.Modules;

public abstract class CustomFoodData : JsonData
{
    [JsonProperty("group")]
    public string GroupJson;

    [JsonIgnore]
    public FoodGroup Group;

    [JsonProperty("favouriteModifier")]
    public int FavouriteModifier;

    [JsonProperty("minDrive")]
    public float MinDrive = 1f;

    [JsonProperty("favouredBy"), JsonRequired]
    public string[] FavouredByJson;

    [JsonIgnore]
    public IdentifiableId[] FavouredBy;

    [JsonProperty("pediaFavouredBy"), JsonRequired]
    public string PediaFavouredBy;

    [JsonProperty("about"), JsonRequired]
    public string About;

    [JsonProperty("ammoColor"), JsonRequired]
    public string AmmoColor;
}

public sealed class CustomChimkenData : CustomFoodData
{
    [JsonProperty("zones"), JsonRequired]
    public Zone[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 1f;

    [JsonIgnore]
    public IdentifiableId ChickId;

    [JsonIgnore]
    public PediaId ChickEntry;

    [JsonProperty("chickIntro"), JsonRequired]
    public string ChickIntro;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        FavouredBy = [.. FavouredByJson.Select(Helpers.ParseEnum<IdentifiableId>)];
        var upper = Name.ToUpper();
        MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.ParseEnum<IdentifiableId>(upper + "_CHICK");
        MainEntry = Helpers.ParseEnum<PediaId>(upper + "_HEN_ENTRY");
        ChickEntry = Helpers.ParseEnum<PediaId>(upper + "_CHICK_ENTRY");
        Group = FoodGroup.MEAT;
    }
}

// public sealed class CustomPlantData : CustomFoodData
// {
//     [JsonProperty("type"), JsonRequired]
//     public string Type;

//     [JsonProperty("garden"), JsonRequired]
//     public string Garden;

//     [OnDeserialized]
//     public void PopulateRemainingValues(StreamingContext _)
//     {
//         FavouredBy = [.. FavouredByJson.Select(Helpers.ParseEnum<IdentifiableId>)];
//         var upper = Name.ToUpper();
//         var typeUpper = Type.ToUpper();
//         MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_" + typeUpper);
//         MainEntry = Helpers.ParseEnum<PediaId>(upper + "_" + typeUpper + "_ENTRY");
//         Group = Helpers.ParseEnum<FoodGroup>(GroupJson);
//         Category = typeUpper == "VEGGIES" ? ExchangeDirector.Category.VEGGIES : ExchangeDirector.Category.FRUIT;
//     }
// }