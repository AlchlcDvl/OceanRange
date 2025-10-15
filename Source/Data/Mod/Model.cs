namespace OceanRange.Data;

public sealed partial class ModelData
{
    [JsonProperty] public float? Gloss;

    [JsonProperty] public int? SameAs;
    [JsonProperty] public int? MatSameAs;
    [JsonProperty] public int? ColorsSameAs;

    [JsonProperty] public IdentifiableId? MatOrigin;
    [JsonProperty] public IdentifiableId? ColorsOrigin;

    [JsonProperty("colorProps")] private Dictionary<string, Color> ColorPropsJson;

    public bool IsBody;

    public readonly Dictionary<int, Color> ColorProps = [];

    public Material CachedMaterial;

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

        if (data == null)
            return;

        IsBody = data.IsBody;
        CloneSameAs = data.CloneSameAs;
        CloneFallback = data.CloneFallback;
        CloneMatOrigin = data.CloneMatOrigin;

        foreach (var (id, color) in data.ColorProps)
            ColorProps[id] = color;

        if (!includeMeshData)
            return;

        Skip = data.Skip;
        SkipNull = data.SkipNull;
        IgnoreLodIndex = data.IgnoreLodIndex;
}

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Gloss = reader.ReadNullable(Helpers.ReadFloat);
        Pattern = reader.ReadString2();
        SameAs = reader.ReadNullable(Helpers.ReadInt);
        MatSameAs = reader.ReadNullable(Helpers.ReadInt);
        ColorsSameAs = reader.ReadNullable(Helpers.ReadInt);
        CloneSameAs = reader.ReadBoolean();
        CloneMatOrigin = reader.ReadBoolean();
        CloneFallback = reader.ReadBoolean();
        MatOrigin = reader.ReadNullableEnum<IdentifiableId>();
        ColorsOrigin = reader.ReadNullableEnum<IdentifiableId>();
        // Shader = reader.ReadString2();
        ColorPropsJson = reader.ReadDictionary(Helpers.ReadColor);
        Mesh = reader.ReadString2();
        SkipNull = reader.ReadBoolean();
        IgnoreLodIndex = reader.ReadBoolean();
        Skip = reader.ReadBoolean();
        InvertColorOriginColors = reader.ReadBoolean();
    }

    private const string Top = "TopColor";

    public override void OnDeserialise()
    {
        if (ColorPropsJson == null)
            return;

        foreach (var (prop, color) in ColorPropsJson)
        {
            ColorProps[ShaderUtils.GetOrSet(prop)] = color;

            if (!prop.EndsWith(Top, StringComparison.Ordinal))
                continue;

            var baseName = prop.Replace(Top, "");

            var middle = baseName + "MiddleColor";

            if (ColorPropsJson.TryGetValue(middle, out var middleColor))
                ColorProps[ShaderUtils.GetOrSet(middle)] = middleColor;
            else
                ColorProps[ShaderUtils.GetOrSet(middle)] = middleColor = color;

            var bottom = baseName + "BottomColor";

            if (!ColorPropsJson.ContainsKey(bottom))
                ColorProps[ShaderUtils.GetOrSet(bottom)] = middleColor;
        }
    }
}