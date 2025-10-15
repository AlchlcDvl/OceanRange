namespace OceanRange.Data;

public abstract class ActorData : ModData
{
    public IdentifiableId MainId;
}

public abstract partial class SpawnedActorData : ActorData
{
    [JsonProperty] public ProgressType[] Progress;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Progress = reader.ReadArray(Helpers.ReadEnum<ProgressType>);
        BasePrice = reader.ReadSingle();
        Saturation = reader.ReadSingle();
        ExchangeWeight = reader.ReadInt32();
        MainAmmoColor = reader.ReadColor();
    }
}