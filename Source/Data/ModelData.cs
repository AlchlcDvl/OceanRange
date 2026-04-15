// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class ModelData : JsonData
{
    public MatData MatData;
    public MeshData MeshData;

    protected override void OnDeserialise()
    {
        MatData ??= new();
        MeshData ??= new();
    }
}

public sealed class MatData : JsonData
{
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
    [JsonIgnore] public readonly Dictionary<int, Color> ColorProps = [];

    private const string Top = "TopColor";
    private const int TopLength = 8;

    private static readonly List<string> TempKeys = [];

    protected override void OnDeserialise()
    {
        if (ColorPropsJson.IsNullOrEmpty())
        {
            if (Pattern == null && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
                IsModified = false;

            return;
        }

        foreach (var key in ColorPropsJson.Keys)
        {
            if (key.EndsWith(Top, StringComparison.Ordinal))
                TempKeys.Add(key);
        }

        foreach (var prop in TempKeys)
        {
            var baseName = prop.Substring(0, prop.Length - TopLength);
            var color = ColorPropsJson[prop];

            var middleColor = ColorPropsJson.GetOrAdd(baseName + "MiddleColor", color);

            var bottomKey = baseName + "BottomColor";

            if (!ColorPropsJson.ContainsKey(bottomKey))
                ColorPropsJson[bottomKey] = middleColor;
        }

        TempKeys.Clear();

        foreach (var (id, color) in ColorPropsJson)
            ColorProps[ShaderUtils.GetOrSet(id)] = color;
    }
}

public sealed class MeshData : JsonData
{
    public string Mesh;

    public bool IgnoreLodIndex;

    public bool Skip;
    public bool UseBaseStruct;

    public float? Jiggle;
    public int? PrefabLength;

    [JsonIgnore] public bool IsBody;
}