namespace OceanRange.Data;

public abstract partial class JsonData
{
    protected virtual bool SerialiseName => false;
}

public abstract partial class ActorData : JsonData;

public abstract partial class SpawnedActorData : ActorData
{
    public int ExchangeWeight = 20;

    [JsonRequired] public float BasePrice;
    [JsonRequired] public float Saturation;
}