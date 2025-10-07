namespace OceanRange.Modules;

public abstract class ModData : UObject
{
    public string Name;

    public virtual void DeserialiseFrom(BinaryReader reader) => Name = reader.ReadNullableString();

    public virtual void OnDeserialise() { }
}

public abstract class ActorData : ModData
{
    public IdentifiableId MainId;
}

public abstract class SpawnedActorData : ActorData
{
    public ProgressType[] Progress;
    public float BasePrice;
    public float Saturation;
    public int ExchangeWeight = 20;
    public Color MainAmmoColor;

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

public abstract class Holder : ModData
{
    protected Holder(BinaryReader reader)
    {
        DeserialiseFrom(reader);
        OnDeserialise();
    }
}