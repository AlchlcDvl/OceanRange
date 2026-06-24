#if UNITY
namespace OceanRange.Data;

public abstract partial class JsonData
{
    public Optional<string> Name;

    public virtual void FindStrings(StringPooler pooler)
    {
        if (SerialiseName)
            pooler.PoolString(Name);
    }

    public virtual void WriteTo(DataWriter writer)
    {
        if (SerialiseName)
            writer.WriteString(Name);
    }
}

public abstract partial class ActorData;

public abstract partial class SpawnedActorData
{
    public string[] Progress;
    public Optional<Color32> MainAmmoColor;

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedUInt((uint)ExchangeWeight);
        writer.WritePackedFloat(BasePrice);
        writer.WritePackedFloat(Saturation);
        writer.WriteString(MainAmmoColor.ToHex());
        writer.WriteStringArray(Progress);
    }

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Progress);
        pooler.PoolString(MainAmmoColor.ToHex());
    }
}
#endif