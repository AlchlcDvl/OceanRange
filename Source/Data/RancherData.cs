namespace OceanRange.Data;

public sealed class RancherData : JsonData
{
    [JsonRequired] public Category[] Rewards;
    [JsonRequired] public Category[] Requests;
    [JsonRequired] public Category[] RareRewards;

    public IdentifiableId[] IndivRewards;
    public IdentifiableId[] IndivRequests;
    public IdentifiableId[] IndivRareRewards;

    [JsonIgnore] public string RancherId;
    [JsonIgnore] public RancherName RancherName;
    [JsonIgnore] public ExchangeDirector.Rancher Rancher;

    protected override void OnDeserialise()
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