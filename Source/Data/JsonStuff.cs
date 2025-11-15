// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public abstract class JsonData
{
    public string Name;

    protected virtual void OnDeserialise() { }

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _) => OnDeserialise();
}

public abstract class ActorData : JsonData
{
    [JsonIgnore] public IdentifiableId MainId;
}

public abstract class SpawnedActorData : ActorData
{
    public ProgressType[] Progress;

    public int ExchangeWeight = 20;

    [JsonRequired] public float BasePrice;
    [JsonRequired] public float Saturation;

    [JsonRequired] public Color MainAmmoColor;

    protected override void OnDeserialise() => Progress ??= [];
}

public sealed class Json(string text) : TextAsset(text);