namespace OceanRange.Data;

public abstract partial class SpawnedActorData
{
    [JsonProperty, JsonRequired] public float BasePrice;
    [JsonProperty, JsonRequired] public float Saturation;
    [JsonProperty, JsonRequired] public Color MainAmmoColor;

    [JsonProperty] public int ExchangeWeight = 20;
}