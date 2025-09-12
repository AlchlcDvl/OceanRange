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

    [JsonProperty("colorsSameAs")]
    public int? ColorsSameAs;

    [JsonProperty("cloneSameAs")]
    public bool CloneSameAs;

    [JsonProperty("cloneMatOrigin")]
    public bool CloneMatOrigin = true;

    [JsonProperty("matOrigin")]
    public IdentifiableId? MatOriginSlime;

    [JsonProperty("colorsOrigin")]
    public IdentifiableId? ColorsOrigin;

    // [JsonProperty("shader")]
    // public string Shader;

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

        foreach (var (prop, color) in MiscColorPropsJson.ToArray())
        {
            if (!prop.Contains("TopColor"))
                continue;

            var middle = prop.Replace("Top", "Middle");
            var bottom = prop.Replace("Top", "Bottom");

            if (!MiscColorPropsJson.ContainsKey(middle))
                MiscColorPropsJson[middle] = color;

            if (!MiscColorPropsJson.ContainsKey(bottom))
                MiscColorPropsJson[bottom] = color;
        }

        foreach (var (prop, value) in MiscColorPropsJson)
            MiscColorProps[ShaderUtils.GetOrSet(prop)] = value;
    }
}