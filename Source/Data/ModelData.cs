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
    private static readonly int TopLength = Top.Length;

    private static readonly List<string> TempKeys = [];

    protected override void OnDeserialise()
    {
        if (ColorPropsJson.IsNullOrEmpty())
        {
            if (Pattern == null && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
                IsModified = false;

            return;
        }

        TempKeys.Clear();

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

    protected override void OnDeserialise()
    {
        if (InstantiatePrefabs)
            SkipNull = true;
    }
}