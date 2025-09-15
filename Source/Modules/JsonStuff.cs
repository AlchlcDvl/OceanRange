namespace OceanRange.Modules;

public abstract class JsonData
{
    [JsonProperty("name")]
    public string Name;
}

public abstract class ActorData : JsonData
{
    [JsonIgnore]
    public IdentifiableId MainId;
}

public abstract class SpawnedActorData : ActorData
{
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
    public Color MainAmmoColor;
}

public sealed class Json(string text) : TextAsset(text);