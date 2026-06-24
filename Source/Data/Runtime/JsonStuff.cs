#if !UNITY
namespace OceanRange.Data;

public abstract partial class JsonData
{
    public string? Name;

    public virtual void ReadFrom(DataReader reader)
    {
        if (SerialiseName)
            Name = reader.ReadString();
    }

    public virtual void OnDeserialise() { }
}

public abstract partial class ActorData
{
    [JsonIgnore]
    public IdentifiableId MainId;
}

public abstract partial class SpawnedActorData
{
    public ProgressType[] Progress;
    public Color? MainAmmoColor;

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
}

public sealed class Json : ScriptableObject
{
    public byte[] Data;

    public void Initialise(byte[] data) => Data = data;
}
#endif