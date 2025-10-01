namespace OceanRange.Managers;

public sealed class RancherData : JsonData
{
    [JsonProperty("requests"), JsonRequired]
    public Category[] Requests;

    [JsonProperty("rewards"), JsonRequired]
    public Category[] Rewards;

    [JsonProperty("rareRewards"), JsonRequired]
    public Category[] RareRewards;

    [JsonProperty("indivRequests")]
    public IdentifiableId[] IndivRequests;

    [JsonProperty("indivRewards")]
    public IdentifiableId[] IndivReward;

    [JsonProperty("indivRareRewards")]
    public IdentifiableId[] IndivRareRewards;

    [JsonIgnore]
    public RancherName RancherName;

    [JsonIgnore]
    public ExchangeDirector.Rancher Rancher;

    [JsonIgnore]
    public string RancherId;

    [OnDeserialized]
    public void PopulateData(StreamingContext _)
    {
        RancherId = Name.ToLowerInvariant();
        RancherName = Helpers.AddEnumValue<RancherName>(Name.ToUpperInvariant());

        Rancher = new()
        {
            name = RancherId,
            defaultImg = Inventory.GetSprite(RancherId + "_default"),
            icon = Inventory.GetSprite(RancherId),
            requestCategories = Requests,
            rewardCategories = Rewards,
            rareRewardCategories = RareRewards,
            indivRequests = IndivRequests ?? [],
            indivRewards = IndivRequests ?? [],
            indivRareRewards = IndivRequests ?? []
        };
    }
}