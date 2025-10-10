namespace OceanRange.Modules;

public sealed class ModelData : ModData
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

    private Dictionary<string, Color> ColorPropsJson;

    public string Mesh;

    public bool SkipNull;
    public bool IgnoreLodIndex;
    public bool Skip;

    public bool InvertColorOriginColors;

    public bool IsBody;

    public readonly Dictionary<int, Color> ColorProps = [];

    public Material CachedMaterial;

    private const string Top = "TopColor";
    private static readonly int TopLength = Top.Length;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        2.DoLog();
        Gloss = reader.ReadNullable(Helpers.ReadFloat);
        2.DoLog();
        Pattern = reader.ReadString();
        2.DoLog();
        SameAs = reader.ReadNullable(Helpers.ReadInt);
        2.DoLog();
        MatSameAs = reader.ReadNullable(Helpers.ReadInt);
        2.DoLog();
        ColorsSameAs = reader.ReadNullable(Helpers.ReadInt);
        2.DoLog();
        CloneSameAs = reader.ReadBoolean();
        2.DoLog();
        CloneMatOrigin = reader.ReadBoolean();
        2.DoLog();
        CloneFallback = reader.ReadBoolean();
        2.DoLog();
        MatOrigin = reader.ReadNullableEnum<IdentifiableId>();
        2.DoLog();
        ColorsOrigin = reader.ReadNullableEnum<IdentifiableId>();
        2.DoLog();
        // Shader = reader.ReadString();
        2.DoLog();
        ColorPropsJson = reader.ReadDictionary(Helpers.ReadString2, Helpers.ReadColor);
        2.DoLog();
        Mesh = reader.ReadString();
        2.DoLog();
        SkipNull = reader.ReadBoolean();
        2.DoLog();
        IgnoreLodIndex = reader.ReadBoolean();
        2.DoLog();
        Skip = reader.ReadBoolean();
        2.DoLog();
        InvertColorOriginColors = reader.ReadBoolean();
        2.DoLog();
    }

    public override void OnDeserialise()
    {
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