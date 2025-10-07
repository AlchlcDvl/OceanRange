namespace OceanRange.Unity.Json;

[Serializable]
public sealed class RancherData : JsonData
{
    [JsonProperty("requests"), JsonRequired]
    public string[] Requests;

    [JsonProperty("rewards"), JsonRequired]
    public string[] Rewards;

    [JsonProperty("rareRewards"), JsonRequired]
    public string[] RareRewards;

    [JsonProperty("indivRequests")]
    public string[] IndivRequests;

    [JsonProperty("indivRewards")]
    public string[] IndivReward;

    [JsonProperty("indivRareRewards")]
    public string[] IndivRareRewards;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Requests, Helpers.WriteString);
        writer.WriteArray(Rewards, Helpers.WriteString);
        writer.WriteArray(RareRewards, Helpers.WriteString);
        writer.WriteArray(IndivRequests, Helpers.WriteString);
        writer.WriteArray(IndivReward, Helpers.WriteString);
        writer.WriteArray(IndivRareRewards, Helpers.WriteString);
    }
}