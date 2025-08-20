using System.Runtime.Serialization;

namespace OceanRange.Managers;

public sealed class CustomRancherData : JsonData
{
    [JsonProperty("id"), JsonRequired]
    public string RancherId;

    [JsonProperty("fullName"), JsonRequired]
    public string FullName;

    [JsonProperty("dialogues"), JsonRequired]
    public string[] Dialogues;

    [JsonProperty("specialDialogue"), JsonRequired]
    public string SpecialDialogue;

    [JsonIgnore]
    public RancherName RancherName;

    [JsonIgnore]
    public ExchangeDirector.Rancher Rancher;

    [OnDeserialized]
    public void PopulateData(StreamingContext _) => RancherName = Helpers.ParseEnum<RancherName>(RancherId.ToUpperInvariant());
}