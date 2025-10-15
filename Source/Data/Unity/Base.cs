using System.Runtime.Serialization;

namespace OceanRange.Data;

public abstract partial class ModData
{
    public virtual void SerialiseTo(BinaryWriter writer) => writer.WriteString(Name);

    [OnDeserialized]
    public void OnDeserialise(StreamingContext _) => OnDeserialise();
}

#if UNITY
public abstract partial class Holder : ScriptableObject
{
    [JsonProperty] public string Name;

    public virtual void SerialiseTo(BinaryWriter writer) => writer.WriteString(Name);

    public virtual void OnDeserialise() => Name ??= "";

    [OnDeserialized]
    public void OnDeserialise(StreamingContext _) => OnDeserialise();
}
#endif

public abstract partial class ValueArrayHolder<T> : Holder where T : ModData, new()
{
    public sealed override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Values, Helpers.WriteModData);
    }
}

public abstract partial class DualValueArrayHolder<T1, T2> : Holder
    where T1 : ModData, new()
    where T2 : ModData, new()
{
    public sealed override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteArray(Values1, Helpers.WriteModData);
        writer.WriteArray(Values2, Helpers.WriteModData);
    }
}