// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

public abstract class JsonData
{
#if UNITY
    public Optional<string> Name;
#else
    public string? Name;
#endif

    protected virtual bool SerialiseName => false;

#if UNITY
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
#else
    public virtual void ReadFrom(DataReader reader)
    {
        if (SerialiseName)
            Name = reader.ReadString();
    }

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

    public Optional<Color32> MainAmmoColor;
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
        writer.WriteString(MainAmmoColor.ToHex());
        writer.WriteStringArray(Progress);
    }

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Progress);
        pooler.PoolString(MainAmmoColor.ToHex());
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

        Progress = reader.ReadEnumArray<ProgressType>()!;
    }
#endif
}

#if !UNITY
public sealed class Json : ScriptableObject
{
    public byte[] Data;

    public void Initialise(byte[] data) => Data = data;
}
#endif