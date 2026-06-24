#if UNITY
namespace OceanRange.Data;

public sealed partial class ScienceItemData
{
    [JsonRequired] public string BaseItemId;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(BaseItemId);
        Array.ForEach(MaterialOverrides, x => x.FindStrings(pooler));
        Array.ForEach(ExtractorDrops, x => x.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(BaseItemId);
        writer.WriteArray(MaterialOverrides, (w, x) => x.WriteTo(w));
        writer.WriteArray(ExtractorDrops, (w, x) => x.WriteTo(w));
    }
}
#endif
