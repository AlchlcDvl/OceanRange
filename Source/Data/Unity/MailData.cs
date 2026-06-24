#if UNITY
namespace OceanRange.Data;

public sealed partial class MailData
{
    [JsonProperty] public Optional<double> UnlockAfter;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Id);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Id);
        writer.WriteNullableDouble(UnlockAfter);
    }
}
#endif
