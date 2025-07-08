using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public sealed class CustomFoodData
{
    [JsonProperty("type")]
    public FoodGroup Group;

    [JsonProperty("type")]
    public int FavouriteModifier;

    [JsonProperty("minDrive")]
    public float MinDrive = 1f;

    [JsonProperty("favouredBy")]
    public IdentifiableId[] FavouredBy;

    // [JsonProperty("type")]
    // public string Type;

    // [JsonProperty("pediaFavouredBy")]
    // public string PediaFavouredBy;

    // [JsonProperty("about")]
    // public string About;

    // [JsonProperty("ranch")]
    // public string Ranch;
}