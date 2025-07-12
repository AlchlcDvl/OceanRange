namespace TheOceanRange.Modules;

public abstract class JsonData
{
    [JsonProperty("name"), JsonRequired]
    public string Name;

    [JsonIgnore]
    public IdentifiableId MainId;

    [JsonIgnore]
    public PediaId MainEntry;

    [JsonProperty("progress")]
    public ProgressType[] Progress;

    [JsonProperty("basePrice"), JsonRequired]
    public float BasePrice;

    [JsonProperty("saturation"), JsonRequired]
    public float Saturation;

    [JsonProperty("exchangeWeight")]
    public float ExchangeWeight = 20f;

    [JsonProperty("intro"), JsonRequired]
    public string MainIntro;
}