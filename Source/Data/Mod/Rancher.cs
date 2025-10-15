namespace OceanRange.Data;

public sealed partial class RancherData : ModData
{
    [JsonProperty, JsonRequired] public Category[] Requests;
    [JsonProperty, JsonRequired] public Category[] Rewards;
    [JsonProperty, JsonRequired] public Category[] RareRewards;

    [JsonProperty] public IdentifiableId[] IndivRequests;
    [JsonProperty] public IdentifiableId[] IndivReward;
    [JsonProperty] public IdentifiableId[] IndivRareRewards;

    public string RancherId;
    public RancherName RancherName;
    public ExchangeDirector.Rancher Rancher;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Requests = reader.ReadArray(Helpers.ReadEnum<Category>);
        Rewards = reader.ReadArray(Helpers.ReadEnum<Category>);
        RareRewards = reader.ReadArray(Helpers.ReadEnum<Category>);
        IndivRequests = reader.ReadArray(Helpers.ReadEnum<IdentifiableId>);
        IndivReward = reader.ReadArray(Helpers.ReadEnum<IdentifiableId>);
        IndivRareRewards = reader.ReadArray(Helpers.ReadEnum<IdentifiableId>);
    }

    public override void OnDeserialise()
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