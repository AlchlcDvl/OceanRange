namespace OceanRange.Managers;

public sealed class RancherData : JsonData
{
    [JsonProperty("id"), JsonRequired]
    public string RancherId;

    [JsonProperty("fullName"), JsonRequired]
    public string FullName;

    [JsonProperty("dialogues"), JsonRequired]
    public string[] Dialogues;

    [JsonProperty("specialDialogue"), JsonRequired]
    public string SpecialDialogue;

    [JsonProperty("loadingText"), JsonRequired]
    public string LoadingText;

    // [JsonIgnore]
    // public RancherName RancherName;

    [JsonIgnore]
    public ExchangeDirector.Rancher Rancher;

    [OnDeserialized]
    public void PopulateData(StreamingContext _) => Helpers.AddEnumValue<RancherName>(RancherId.ToUpperInvariant());
}