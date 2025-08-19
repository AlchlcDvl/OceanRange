using System.Runtime.Serialization;

namespace OceanRange.Managers;

public sealed class CustomRancherData : JsonData
{
    [JsonProperty("id")]
    public string RancherId;

    [JsonIgnore]
    public RancherName RancherName;

    [JsonIgnore]
    public ExchangeDirector.Rancher Rancher;

    [OnDeserialized]
    public void PopulateData(StreamingContext _)
    {
        RancherName = Helpers.ParseEnum<RancherName>(Name.ToUpperInvariant());
        Rancher = new()
        {
            defaultImg = AssetManager.GetSprite("lisa_coffee"),
            icon = AssetManager.GetSprite("lisa_exchange"),
            numBlurbs = 1,
            requestCategories = [Ids.OCEAN],
            rewardCategories = [Ids.OCEAN, Category.SLIMES, Category.MEAT],
            rareRewardCategories = [Category.CRAFT_MATS, Category.PLORTS]
        };
    }
}