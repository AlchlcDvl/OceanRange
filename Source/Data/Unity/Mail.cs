namespace OceanRange.Data;

public sealed partial class MailData : ModData
{
    [JsonIgnore, Optional] public OptionalData<double> UnlockAfterUnity;

    [JsonProperty("unlockAfter")]
    public double? UnlockAfterJson
    {
        get => UnlockAfterUnity;
        set => UnlockAfterUnity = value;
    }

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteString(Id);
        writer.WriteNullable(UnlockAfterJson, Helpers.WriteDouble);
    }
}