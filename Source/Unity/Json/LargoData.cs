namespace OceanRange.Unity.Json;

[Serializable]
public sealed class LargoData : JsonData
{
    [JsonProperty("props"), JsonRequired]
    public string[] Props;

    [JsonProperty("bodyMesh")]
    public ModelData BodyStructData;

    [JsonProperty("slime1Meshes")]
    public ModelData[] Slime1StructData;

    [JsonProperty("slime2Meshes")]
    public ModelData[] Slime2StructData;

    [JsonProperty("jiggle")]
    public float? JiggleJson
    {
        get => JiggleUnity;
        set => JiggleUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<float> JiggleUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Props, Helpers.WriteString);
        writer.WriteJsonData(BodyStructData);
        writer.WriteArray(Slime1StructData, Helpers.WriteJsonData);
        writer.WriteArray(Slime2StructData, Helpers.WriteJsonData);
        writer.WriteNullable(JiggleJson, Helpers.WriteFloat);
    }
}