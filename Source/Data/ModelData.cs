// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class ModelData : JsonData
{
    public ModelData() { }

    private ModelData(ModelData data, bool includeMeshData) : this()
    {
        Gloss = data?.Gloss;
        SameAs = data?.SameAs;
        // Shader = data?.Shader;
        Pattern = data?.Pattern;
        MatSameAs = data?.MatSameAs;
        MatOrigin = data?.MatOrigin;
        ColorsOrigin = data?.ColorsOrigin;
        ColorsSameAs = data?.ColorsSameAs;
        CachedMaterial = data?.CachedMaterial;
        ColorPropsJson = data?.ColorPropsJson;

        if (includeMeshData)
        {
            Mesh = data?.Mesh;
            Jiggle = data?.Jiggle;
            PrefabLength = data?.PrefabLength;
        }

        if (data == null)
            return;

        IsBody = data.IsBody;
        CloneSameAs = data.CloneSameAs;
        CloneFallback = data.CloneFallback;
        CloneMatOrigin = data.CloneMatOrigin;
        InvertColorOriginColors = data.InvertColorOriginColors;

        if (!includeMeshData)
            return;

        Skip = data.Skip;
        SkipNull = data.SkipNull;
        SkipRigging = data.SkipRigging;
        UseBaseStruct = data.UseBaseStruct;
        IgnoreLodIndex = data.IgnoreLodIndex;
        InstantiatePrefabs = data.InstantiatePrefabs;
    }

    public float? Gloss;

    public string Pattern;

    public int? SameAs;
    public int? MatSameAs;
    public int? ColorsSameAs;

    public bool CloneSameAs;
    public bool CloneMatOrigin = true;
    public bool CloneFallback = true;
    public bool SkipRigging;

    public IdentifiableId? MatOrigin;
    public IdentifiableId? ColorsOrigin;

    // public string Shader;

    public string Mesh;
    public bool IgnoreLodIndex;

    public bool Skip;
    public bool SkipNull;
    public bool UseBaseStruct;
    public bool InstantiatePrefabs;

    public float? Jiggle;
    public int? PrefabLength;

    [JsonProperty("invert")] public bool InvertColorOriginColors;
    [JsonProperty("colorProps")] private Dictionary<string, Color> ColorPropsJson;

    [JsonIgnore] public bool IsBody;
    [JsonIgnore] public readonly Dictionary<int, Color> ColorProps = [];
    [JsonIgnore] public Material CachedMaterial;

    private const string Top = "TopColor";
    private static readonly int TopLength = Top.Length;

    protected override void OnDeserialise()
    {
        if (InstantiatePrefabs)
            SkipNull = true;

        if (ColorPropsJson == null)
            return;

        foreach (var (prop, color) in ColorPropsJson.ToArray())
        {
            if (!prop.EndsWith(Top, StringComparison.Ordinal))
                continue;

            var baseName = prop.Substring(0, prop.Length - TopLength);

            var middleColor = ColorPropsJson.GetOrAdd(baseName + "MiddleColor", color);

            var bottom = baseName + "BottomColor";

            if (!ColorPropsJson.ContainsKey(bottom))
                ColorPropsJson[bottom] = middleColor;
        }

        foreach (var (prop, value) in ColorPropsJson)
            ColorProps[ShaderUtils.GetOrSet(prop)] = value;
    }

    public ModelData Clone(bool includeMeshData, string defaultMeshName)
    {
        var result = new ModelData(this, includeMeshData);
        // result.Mesh ??= defaultMeshName;
        result.OnDeserialise();
        return result;
    }
}