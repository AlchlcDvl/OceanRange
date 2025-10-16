// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

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
        MatOrigin = data?.MatOrigin;
        CachedMaterial = data?.CachedMaterial;
        ColorPropsJson = data?.ColorPropsJson;

        if (includeMeshData)
            Mesh = data?.Mesh;

        if (data != null)
        {
            IsBody = data.IsBody;
            CloneSameAs = data.CloneSameAs;
            CloneFallback = data.CloneFallback;
            CloneMatOrigin = data.CloneMatOrigin;

            if (includeMeshData)
            {
                Skip = data.Skip;
                SkipNull = data.SkipNull;
                IgnoreLodIndex = data.IgnoreLodIndex;
            }
        }

        OnDeserialise();
    }

    public float? Gloss;

    public string Pattern;

    public int? SameAs;
    public int? MatSameAs;
    public int? ColorsSameAs;

    public bool CloneSameAs;
    public bool CloneMatOrigin = true;
    public bool CloneFallback = true;

    public IdentifiableId? MatOrigin;
    public IdentifiableId? ColorsOrigin;

    // public string Shader;

    public string Mesh;
    public bool IgnoreLodIndex;

    public bool Skip;
    public bool SkipNull;

    [JsonProperty("invert")] public bool InvertColorOriginColors;
    [JsonProperty("colorProps")] private Dictionary<string, Color> ColorPropsJson;

    [JsonIgnore] public bool IsBody;
    [JsonIgnore] public readonly Dictionary<int, Color> ColorProps = [];
    [JsonIgnore] public Material CachedMaterial;

    private const string Top = "TopColor";
    private static readonly int TopLength = Top.Length;

    protected override void OnDeserialise()
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