namespace OceanRange.Data;

public abstract partial class SpawnedActorData
#if UNITY
    : ModData
#endif
{
    [JsonProperty("progress")] public string[] ProgressUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteArray(ProgressUnity, Helpers.WriteString);
        writer.Write(BasePrice);
        writer.Write(Saturation);
        writer.Write(ExchangeWeight);
        writer.WriteColor(MainAmmoColor);
    }
}