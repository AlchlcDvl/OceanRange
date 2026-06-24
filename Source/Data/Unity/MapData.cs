#if UNITY
namespace OceanRange.Data;

public sealed partial class ZoneRequirementData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(PathToGameObject);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedUInt((uint)CorporateLevelMin);
        writer.WritePackedUInt((uint)CorporateLevelMax);
        writer.WritePackedUInt((uint)ExchangeProgress);
        writer.WriteString(PathToGameObject);
    }
}

public sealed partial class ZoneData
{
    [JsonRequired] public string Region;
    [SerializeField] public Dictionary<string, ZoneRequirementData> Requirements;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Region);
        pooler.PoolString(TeleporterLocation);
        pooler.PoolString(AssetName);

        if (Requirements.IsNullOrEmpty())
            return;

        pooler.PoolStrings(Requirements.Keys);

        foreach (var req in Requirements.Values)
            req.FindStrings(pooler);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Region);
        writer.WriteOrientation(TeleporterOrientation);
        writer.WriteString(TeleporterLocation);
        writer.WriteString(AssetName);

        writer.WriteDictionary(Requirements,
            (w, k) => w.WriteString(k),
            (w, v) => v.WriteTo(w)
        );
    }
}

public sealed partial class RegionData
{
    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedFloat(MinNodeSize);
        writer.WritePackedFloat(LoosenessVal);
        writer.WritePackedFloat(InitialWorldSize);
        writer.WriteVector3(InitialWorldPos);
    }
}

public sealed partial class World
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        Array.ForEach(Regions, r => r.FindStrings(pooler));
        Array.ForEach(Zones, z => z.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteArray(Regions, (w, r) => r.WriteTo(w));
        writer.WriteArray(Zones, (w, z) => z.WriteTo(w));
    }
}
#endif
