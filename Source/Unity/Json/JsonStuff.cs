namespace OceanRange.Unity.Json;

[Serializable]
public abstract class JsonData
{
    [JsonProperty("name")]
    public string Name;

    public virtual void SerialiseTo(BinaryWriter writer) => writer.WriteNullableString(Name);
}

[Serializable]
public abstract class SpawnedActorData : JsonData
{
    [JsonProperty("progress")]
    public string[] Progress;

    [JsonProperty("basePrice"), JsonRequired]
    public float BasePrice;

    [JsonProperty("saturation"), JsonRequired]
    public float Saturation;

    [JsonProperty("exchangeWeight")]
    public int ExchangeWeight = 20;

    [JsonProperty("ammoColor"), JsonRequired]
    public Color MainAmmoColor;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteArray(Progress, Helpers.WriteString);
        writer.Write(BasePrice);
        writer.Write(Saturation);
        writer.Write(ExchangeWeight);
        writer.WriteColor(MainAmmoColor);
    }
}