// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

public abstract class JsonData
{
    public string Name;

#if UNITY
    public virtual void FindStrings(StringPooler pooler) => pooler.PoolString(Name);

    public virtual void WriteTo(DataWriter writer) => writer.WriteString(Name);
#else
    public virtual void ReadFrom(DataReader reader) => Name = reader.ReadString();

    public virtual void OnDeserialise() { }
#endif
}

public abstract class ActorData : JsonData
{
#if !UNITY
    [JsonIgnore]
    public IdentifiableId MainId;
#endif
}

public abstract class SpawnedActorData : ActorData
{
#if !UNITY
    public ProgressType[] Progress;

    public Color? MainAmmoColor;
#else
    public string[] Progress;

    public string MainAmmoColor;
#endif

    public int ExchangeWeight = 20;

    [JsonRequired] public float BasePrice;
    [JsonRequired] public float Saturation;

#if UNITY
    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedUInt((uint)ExchangeWeight);
        writer.WritePackedFloat(BasePrice);
        writer.WritePackedFloat(Saturation);
        writer.WriteSubstring(MainAmmoColor, 1);
        writer.WriteStringArray(Progress);
    }

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Progress);
        pooler.PoolSubstring(MainAmmoColor, 1);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        ExchangeWeight = (int)reader.ReadPackedUInt();
        BasePrice = reader.ReadPackedFloat();
        Saturation = reader.ReadPackedFloat();

        var col = reader.ReadString();
        MainAmmoColor = string.IsNullOrEmpty(col) ? null : ("#" + col).HexToColor();

        Progress = reader.ReadEnumArray<ProgressType>();
    }
#endif
}

#if !UNITY
#if UNITY
[Serializable]
#endif
public sealed  class Json : ScriptableObject
{
    public byte[] Data;

    public void Initialise(byte[] data) => Data = data;
}
#endif