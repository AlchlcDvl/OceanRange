namespace OceanRange.Modules;

public sealed class Contactsbook(BinaryReader reader) : Holder(reader)
{
    public RancherData[] Ranchers;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Ranchers = reader.ReadArray(Helpers.ReadModData<RancherData>);
    }
}

public sealed class RancherData : ModData
{
    public Category[] Requests;
    public Category[] Rewards;
    public Category[] RareRewards;

    public IdentifiableId[] IndivRequests;
    public IdentifiableId[] IndivReward;
    public IdentifiableId[] IndivRareRewards;

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