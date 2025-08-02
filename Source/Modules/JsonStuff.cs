namespace OceanRange.Modules;

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
    public int ExchangeWeight = 20;

    [JsonProperty("intro"), JsonRequired]
    public string MainIntro;

    [JsonProperty("ammoColor"), JsonRequired]
    public string MainAmmoColor;
}

public sealed class Json(string text) : TextAsset(text);