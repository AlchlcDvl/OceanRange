namespace TheOceanRange.Modules;

public sealed class CustomMailData
{
    [JsonProperty("id")]
    public string Id;

    [JsonProperty("title")]
    public string Title;

    [JsonProperty("from")]
    public string From;

    [JsonProperty("body")]
    public string Body;

    [JsonProperty("unlockAfter")]
    public float UnlockAfter;

    [JsonIgnore]
    public bool Sent;

    [JsonIgnore]
    public bool Read;
}