namespace OceanRange.Data;

public abstract partial class ModData : UObject
{
    public virtual void DeserialiseFrom(BinaryReader reader) => Name = reader.ReadString2();

    public ModData Deserialise(BinaryReader reader)
    {
        DeserialiseFrom(reader);
        OnDeserialise();
        return this;
    }
}

public abstract partial class Holder : ModData;

public abstract partial class ValueArrayHolder<T> : Holder where T : ModData, new()
{
    public sealed override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Values = reader.ReadArray(Helpers.ReadModData<T>);
    }
}

public abstract partial class DualValueArrayHolder<T1, T2> : Holder
    where T1 : ModData, new()
    where T2 : ModData, new()
{
    public sealed override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Values1 = reader.ReadArray(Helpers.ReadModData<T1>);
        Values2 = reader.ReadArray(Helpers.ReadModData<T2>);
    }
}