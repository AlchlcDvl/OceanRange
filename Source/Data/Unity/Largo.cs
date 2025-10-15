namespace OceanRange.Data;

public sealed partial class LargoData :
#if UNITY
    ModData
#else
    ActorData
#endif
{
    [JsonProperty("props"), JsonRequired]public string[] PropsUnity;

    [JsonIgnore, Optional] public OptionalData<float> JiggleUnity;

    [JsonProperty("jiggle")]
    public float? JiggleJson
    {
        get => JiggleUnity;
        set => JiggleUnity = value;
    }

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(PropsUnity, Helpers.WriteString);
        writer.WriteModData(BodyStructData);
        writer.WriteArray(Slime1StructData, Helpers.WriteModData);
        writer.WriteArray(Slime2StructData, Helpers.WriteModData);
        writer.WriteNullable(JiggleJson, Helpers.WriteFloat);
    }
}