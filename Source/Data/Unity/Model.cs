namespace OceanRange.Data;

public sealed partial class ModelData : ModData
{
    [JsonIgnore, Optional]
    public OptionalData<float> GlossUnity;

    [JsonProperty("gloss")]
    public float? GlossJson
    {
        get => GlossUnity;
        set => GlossUnity = value;
    }

    [JsonIgnore, Optional] public OptionalData<int> SameAsUnity;
    [JsonIgnore, Optional] public OptionalData<int> MatSameAsUnity;
    [JsonIgnore, Optional] public OptionalData<int> ColorsSameAsUnity;

    [JsonProperty("sameAs")]
    public int? SameAsJson
    {
        get => SameAsUnity;
        set => SameAsUnity = value;
    }

    [JsonProperty("matSameAs")]
    public int? MatSameAsJson
    {
        get => MatSameAsUnity;
        set => MatSameAsUnity = value;
    }

    [JsonProperty("colorsSameAs")]
    public int? ColorsSameAsJson
    {
        get => ColorsSameAsUnity;
        set => ColorsSameAsUnity = value;
    }

    [JsonProperty("matOrigin")] public string MatOriginUnity;
    [JsonProperty("colorsOrigin")] public string ColorsOriginUnity;

    [JsonProperty("colorProps")] public List<StringColorDictEntry> ColorPropsUnity;

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
        writer.WriteString(MatOriginUnity);
        writer.WriteString(ColorsOriginUnity);
        // writer.WriteString(Shader);
        writer.WriteDictionary(ColorPropsUnity, Helpers.WriteColor);
        writer.WriteString(Mesh);
        writer.Write(SkipNull);
        writer.Write(IgnoreLodIndex);
        writer.Write(Skip);
        writer.Write(InvertColorOriginColors);
    }
}