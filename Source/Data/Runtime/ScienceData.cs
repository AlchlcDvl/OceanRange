#if !UNITY
namespace OceanRange.Data;

public sealed partial class ScienceItemData
{
    public IdentifiableId BaseItemId;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        MaterialOverrides = reader.ReadArray(r => { var x = new MaterialOverrideData(); x.ReadFrom(r); return x; })!;
        ExtractorDrops = reader.ReadArray(r => { var x = new ExtractorDropData(); x.ReadFrom(r); return x; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(MaterialOverrides, x => x.OnDeserialise());
        Array.ForEach(ExtractorDrops, x => x.OnDeserialise());
    }
}
#endif
