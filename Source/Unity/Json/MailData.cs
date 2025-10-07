namespace OceanRange.Unity.Json;

[Serializable]
public sealed class MailData : JsonData
{
    [JsonProperty("id"), JsonRequired]
    public string Id;

    [JsonProperty("unlockAfter")]
    public double? UnlockAfterJson
    {
        get => UnlockAfterUnity;
        set => UnlockAfterUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<double> UnlockAfterUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.Write(Id);
        writer.WriteNullable(UnlockAfterJson, Helpers.WriteDouble);
    }
}