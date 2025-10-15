namespace OceanRange.Data;

public sealed partial class RancherData : ModData
{
    [JsonProperty("requests"), JsonRequired] public string[] RequestsUnity;
    [JsonProperty("rewards"), JsonRequired] public string[] RewardsUnity;
    [JsonProperty("rareRewards"), JsonRequired] public string[] RareRewardsUnity;

    [JsonProperty("indivRequests")] public string[] IndivRequestsUnity;
    [JsonProperty("indivRewards")] public string[] IndivRewardUnity;
    [JsonProperty("indivRareRewards")] public string[] IndivRareRewardsUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(RequestsUnity, Helpers.WriteString);
        writer.WriteArray(RewardsUnity, Helpers.WriteString);
        writer.WriteArray(RareRewardsUnity, Helpers.WriteString);
        writer.WriteArray(IndivRequestsUnity, Helpers.WriteString);
        writer.WriteArray(IndivRewardUnity, Helpers.WriteString);
        writer.WriteArray(IndivRareRewardsUnity, Helpers.WriteString);
    }
}