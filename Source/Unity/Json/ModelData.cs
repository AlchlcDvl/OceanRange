namespace OceanRange.Unity.Json;

[Serializable]
public sealed class ModelData : JsonData
{
    [JsonProperty("gloss")]
    public float? GlossJson
    {
        get => GlossUnity;
        set => GlossUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<float> GlossUnity;

    [JsonProperty("pattern")]
    public string Pattern;

    [JsonProperty("sameAs")]
    public int? SameAsJson
    {
        get => SameAsUnity;
        set => SameAsUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<int> SameAsUnity;

    [JsonProperty("matSameAs")]
    public int? MatSameAsJson
    {
        get => MatSameAsUnity;
        set => MatSameAsUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<int> MatSameAsUnity;

    [JsonProperty("colorsSameAs")]
    public int? ColorsSameAsJson
    {
        get => ColorsSameAsUnity;
        set => ColorsSameAsUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<int> ColorsSameAsUnity;

    [JsonProperty("cloneSameAs")]
    public bool CloneSameAs;

    [JsonProperty("cloneMatOrigin")]
    public bool CloneMatOrigin = true;

    [JsonProperty("cloneBase")]
    public bool CloneFallback = true;

    [JsonProperty("matOrigin")]
    public string MatOrigin;

    [JsonProperty("colorsOrigin")]
    public string ColorsOrigin;

    // [JsonProperty("shader")]
    // public string Shader;

    [JsonProperty("colorProps")]
    public List<SerializableStringColorPair> ColorPropsJson;

    [JsonProperty("mesh")]
    public string Mesh;

    [JsonProperty("skipNull")]
    public bool SkipNull;

    [JsonProperty("ignoreLodIndex")]
    public bool IgnoreLodIndex;

    [JsonProperty("skip")]
    public bool Skip;

    [JsonProperty("invert")]
    public bool InvertColorOriginColors;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteNullable(GlossJson, Helpers.WriteFloat);
        writer.WriteString(Pattern);
        writer.WriteNullable(SameAsJson, Helpers.WriteInt);
        writer.WriteNullable(MatSameAsJson, Helpers.WriteInt);
        writer.WriteNullable(ColorsSameAsJson, Helpers.WriteInt);
        writer.Write(CloneSameAs);
        writer.Write(CloneMatOrigin);
        writer.Write(CloneFallback);
        writer.WriteString(MatOrigin);
        writer.WriteString(ColorsOrigin);
        // writer.WriteString(Shader);
        writer.WriteDictionary(ColorPropsJson, Helpers.WriteString, Helpers.WriteColor);
        writer.WriteString(Mesh);
        writer.Write(SkipNull);
        writer.Write(IgnoreLodIndex);
        writer.Write(Skip);
        writer.Write(InvertColorOriginColors);
    }
}