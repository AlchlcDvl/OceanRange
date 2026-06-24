#if UNITY
namespace OceanRange.Data;

public sealed partial class RancherData
{
    [JsonRequired] public string[] Rewards;
    [JsonRequired] public string[] Requests;
    [JsonRequired] public string[] RareRewards;

    public string[] IndivRewards;
    public string[] IndivRequests;
    public string[] IndivRareRewards;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolStrings(Rewards);
        pooler.PoolStrings(Requests);
        pooler.PoolStrings(RareRewards);
        pooler.PoolStrings(IndivRewards);
        pooler.PoolStrings(IndivRequests);
        pooler.PoolStrings(IndivRareRewards);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteStringArray(Rewards);
        writer.WriteStringArray(Requests);
        writer.WriteStringArray(RareRewards);
        writer.WriteStringArray(IndivRewards);
        writer.WriteStringArray(IndivRequests);
        writer.WriteStringArray(IndivRareRewards);
    }
}
#endif
