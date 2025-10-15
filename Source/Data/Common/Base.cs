namespace OceanRange.Data;

[JsonObject(MemberSerialization = MemberSerialization.OptIn)]
public abstract partial class ModData
{
    [JsonProperty] public string Name;

    public virtual void OnDeserialise() => Name ??= "";
}

public abstract partial class Holder;

public abstract partial class ValueArrayHolder<T> : Holder where T : ModData, new()
{
    [JsonProperty, JsonRequired] public T[] Values;
}

public abstract partial class DualValueArrayHolder<T1, T2> : Holder
    where T1 : ModData, new()
    where T2 : ModData, new()
{
    [JsonProperty, JsonRequired] public T1[] Values1;
    [JsonProperty, JsonRequired] public T2[] Values2;
}