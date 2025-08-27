namespace OceanRange.Modules;

public sealed class MaterialData
{
    [JsonProperty("topColor")]
    public Color? TopColor;

    [JsonProperty("middleColor")]
    public Color? MiddleColor;

    [JsonProperty("bottomColor")]
    public Color? BottomColor;

    [JsonProperty("gloss")]
    public float? Gloss;

    [JsonProperty("pattern")]
    public string Pattern;

    [JsonProperty("sameAs")]
    public int? SameAs;

    [JsonProperty("cloneSameAs")]
    public bool CloneSameAs;

    [JsonProperty("matOrigin")]
    public IdentifiableId? MatOriginSlime;

    [JsonProperty("orShaderName")]
    public string OrShaderName;

    [JsonProperty("miscColorProps")]
    private Dictionary<string, Color> MiscColorPropsJson;

    [JsonIgnore]
    public readonly Dictionary<int, Color> MiscColorProps = [];

    [JsonIgnore]
    public Material CachedMaterial;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        MiddleColor ??= TopColor;
        BottomColor ??= TopColor;

        if (MiscColorPropsJson == null)
            return;

        foreach (var (prop, value) in MiscColorPropsJson)
            MiscColorProps[ShaderUtils.GetOrSet(prop)] = value;
    }
}