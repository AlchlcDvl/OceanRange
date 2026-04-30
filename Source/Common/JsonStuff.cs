// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

public abstract class JsonData
{
    public string Name;

    public virtual void ReadFrom(DataReader reader) => Name = reader.ReadString();

#if UNITY
    public virtual void FindStrings(DataWriter writer) => writer.PoolString(Name);

    public virtual void WriteTo(DataWriter writer) => writer.WriteString(Name);
#endif
}

public abstract class ActorData : JsonData
{
    [JsonIgnore] public IdentifiableId MainId;
}

public abstract class SpawnedActorData : ActorData
{
#if !UNITY
    public ProgressType[] Progress;
#else
    public string[] Progress;
#endif

    public int ExchangeWeight = 20;

    [JsonRequired] public float BasePrice;
    [JsonRequired] public float Saturation;

    public Color? MainAmmoColor;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        ExchangeWeight = (int)reader.ReadPackedInt();
        BasePrice = reader.ReadPackedFloat();
        Saturation = reader.ReadPackedFloat();

        if (reader.ReadBool())
        MainAmmoColor = reader.ReadColor();

        var count = reader.ReadPackedInt();
        Progress = new ProgressType[count];

        for (var i = 0; i < count; i++)
            Progress[i] = Helpers.ParseEnum<ProgressType>(reader.ReadString());
    }

    public void WriteTo(DataWriter writer)
    {
        // base.WriteTo(writer);
        writer.WritePackedInt((uint)ExchangeWeight);
        writer.WritePackedFloat(BasePrice);
        writer.WritePackedFloat(Saturation);
        writer.WriteBool(MainAmmoColor.HasValue);

        if (MainAmmoColor.HasValue)
            writer.WriteColor(MainAmmoColor.Value);
    }

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Progress);
    }
#endif
}

// To be removed later since this is no longer an asset to be loaded, technically
public sealed class Json(string text) : TextAsset(text);