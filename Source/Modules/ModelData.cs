namespace OceanRange.Modules;

public sealed class ModelData : JsonData
{
    public ModelData() { }

    public ModelData(ModelData data, bool includeMeshData) : this()
    {
        Gloss = data?.Gloss;
        SameAs = data?.SameAs;
        // Shader = data?.Shader;
        Pattern = data?.Pattern;
        MatSameAs = data?.MatSameAs;
        ColorsOrigin = data?.ColorsOrigin;
        ColorsSameAs = data?.ColorsSameAs;
        MatOriginSlime = data?.MatOriginSlime;
        CachedMaterial = data?.CachedMaterial;
        ColorPropsJson = data?.ColorPropsJson;

        if (includeMeshData)
            Mesh = data?.Mesh;

        if (data != null)
        {
            CloneSameAs = data.CloneSameAs;
            CloneFallback = data.CloneFallback;
            CloneMatOrigin = data.CloneMatOrigin;

            if (includeMeshData)
            {
                Skip = data.Skip;
                SkipNull = data.SkipNull;
                LodLevels = data.LodLevels;
                SupportsFaces = data.SupportsFaces;
                IgnoreLodIndex = data.IgnoreLodIndex;
            }
        }

        PopulateRemainingValues(default);
    }

    [JsonProperty("gloss")]
    public float? Gloss;

    [JsonProperty("pattern")]
    public string Pattern;

    [JsonProperty("sameAs")]
    public int? SameAs;

    [JsonProperty("matSameAs")]
    public int? MatSameAs;

    [JsonProperty("colorsSameAs")]
    public int? ColorsSameAs;

    [JsonProperty("cloneSameAs")]
    public bool CloneSameAs;

    [JsonProperty("cloneMatOrigin")]
    public bool CloneMatOrigin = true;

    [JsonProperty("cloneBase")]
    public bool CloneFallback = true;

    [JsonProperty("matOrigin")]
    public IdentifiableId? MatOriginSlime;

    [JsonProperty("colorsOrigin")]
    public IdentifiableId? ColorsOrigin;

    // [JsonProperty("shader")]
    // public string Shader;

    [JsonProperty("colorProps")]
    private Dictionary<string, Color> ColorPropsJson;

    [JsonProperty("mesh")]
    public string Mesh;

    [JsonProperty("lodLevels")]
    public int LodLevels = 2;

    [JsonProperty("skipNull")]
    public bool SkipNull;

    [JsonProperty("supportsFaces")]
    public bool SupportsFaces;

    [JsonProperty("ignoreLodIndex")]
    public bool IgnoreLodIndex;

    [JsonProperty("skip")]
    public bool Skip;

    [JsonIgnore]
    public readonly Dictionary<int, Color> ColorProps = [];

    [JsonIgnore]
    public Material CachedMaterial;

    private const string Top = "TopColor";
    private static readonly int TopLength = Top.Length;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        if (ColorPropsJson == null)
            return;

        foreach (var (prop, color) in ColorPropsJson.ToArray())
        {
            if (!prop.EndsWith(Top, StringComparison.Ordinal))
                continue;

            var baseName = prop.Substring(0, prop.Length - TopLength);

            var middle = baseName + "MiddleColor";

            if (!ColorPropsJson.TryGetValue(middle, out var middleColor))
                ColorPropsJson[middle] = middleColor = color;

            var bottom = baseName + "BottomColor";

            if (!ColorPropsJson.ContainsKey(bottom))
                ColorPropsJson[bottom] = middleColor;
        }

        foreach (var (prop, value) in ColorPropsJson)
            ColorProps[ShaderUtils.GetOrSet(prop)] = value;
    }
}