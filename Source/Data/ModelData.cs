// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class ModelData() : JsonData
{
    public MatData MatData;
    public MeshData MeshData;

    public ModelData(ModelData data) : this()
    {
        MatData = data.MatData;
        MeshData = data.MeshData;
    }
}

public sealed class MatData : JsonData
{
    public MatData() => ColorProps = [];

    public MatData(MatData other)
    {
        Gloss = other.Gloss;
        SameAs = other.SameAs;
        Pattern = other.Pattern;
        UseSSMat = other.UseSSMat;
        MatSameAs = other.MatSameAs;
        MatOrigin = other.MatOrigin;
        ColorProps = other.ColorProps;
        IsModified = other.IsModified;
        ColorsOrigin = other.ColorsOrigin;
        ColorsSameAs = other.ColorsSameAs;
        CachedMaterial = other.CachedMaterial;
        ColorPropsJson = other.ColorPropsJson;
        InvertColorOriginColors = other.InvertColorOriginColors;
    }

    public float? Gloss;
    public string Pattern;

    public int? SameAs;
    public int? MatSameAs;
    public int? ColorsSameAs;

    public bool UseSSMat;

    public IdentifiableId? MatOrigin;
    public IdentifiableId? ColorsOrigin;

    [JsonProperty("invert")] public bool InvertColorOriginColors;
    [JsonProperty("colorProps")] private Dictionary<string, Color> ColorPropsJson;

    [JsonIgnore] public bool IsModified = true;
    [JsonIgnore] public Material CachedMaterial;
    [JsonIgnore] public readonly Dictionary<int, Color> ColorProps;

    private const string Top = "TopColor";
    private static readonly int TopLength = Top.Length;

    private static readonly List<string> _tempKeys = [];

    protected override void OnDeserialise()
    {
        if (ColorPropsJson?.Count is null or 0)
        {
            if (Pattern == null && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
                IsModified = false;

            return;
        }

        _tempKeys.Clear();

        foreach (var key in ColorPropsJson.Keys)
        {
            if (key.EndsWith(Top, StringComparison.Ordinal))
                _tempKeys.Add(key);
        }

        foreach (var prop in _tempKeys)
        {
            var baseName = prop.Substring(0, prop.Length - TopLength);
            var color = ColorPropsJson[prop];

            var middleColor = ColorPropsJson.GetOrAdd(baseName + "MiddleColor", color);

            var bottomKey = baseName + "BottomColor";

            if (!ColorPropsJson.ContainsKey(bottomKey))
                ColorPropsJson[bottomKey] = middleColor;
        }

        _tempKeys.Clear();

        foreach (var kvp in ColorPropsJson)
            ColorProps[ShaderUtils.GetOrSet(kvp.Key)] = kvp.Value;
    }
}

public sealed class MeshData() : JsonData
{
    public string Mesh;
    public bool IgnoreLodIndex;

    public bool Skip;
    public bool SkipNull;
    public bool UseBaseStruct;
    public bool InstantiatePrefabs;

    public float? Jiggle;
    public int? PrefabLength;

    public bool SkipRigging;

    [JsonIgnore] public bool IsBody;

    public MeshData(MeshData data) : this()
    {
        Mesh = data.Mesh;
        Skip = data.Skip;
        IsBody = data.IsBody;
        Jiggle = data.Jiggle;
        SkipNull = data.SkipNull;
        SkipRigging = data.SkipRigging;
        PrefabLength = data.PrefabLength;
        UseBaseStruct = data.UseBaseStruct;
        IgnoreLodIndex = data.IgnoreLodIndex;
        InstantiatePrefabs = data.InstantiatePrefabs;
    }

    protected override void OnDeserialise()
    {
        if (InstantiatePrefabs)
            SkipNull = true;
    }
}