// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

[Serializable]
public sealed class ModelData : JsonData
{
#if !UNITY
    public MatData MatData;
    public MeshData MeshData;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        MatData = new MatData();

        if (reader.ReadBool())
            MatData.ReadFrom(reader);

        MeshData = new MeshData();

        if (reader.ReadBool())
            MeshData.ReadFrom(reader);
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        MatData.OnDeserialise();
        MeshData.OnDeserialise();
    }
#else
    public Optional<MatData> MatData;
    public Optional<MeshData> MeshData;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        if (MatData.HasValue)
            MatData.Value.FindStrings(pooler);

        if (MeshData.HasValue)
            MeshData.Value.FindStrings(pooler);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        var matExists = MatData.HasValue;
        writer.WriteBool(matExists);

        if (matExists)
            MatData.Value.WriteTo(writer);

        var meshExists = MeshData.HasValue;
        writer.WriteBool(meshExists);

        if (meshExists)
            MeshData.Value.WriteTo(writer);
    }
#endif
}

[Serializable]
public sealed class MatData : JsonData
{
    public bool UseSSMat;

    [JsonProperty("invert")] public bool InvertColorOriginColors;

#if !UNITY
    public IdentifiableId? MatOrigin;
    public IdentifiableId? ColorsOrigin;

    public float? Gloss;
    public string? Pattern;

    public int? SameAs;
    public int? MatSameAs;
    public int? ColorsSameAs;

    public readonly Dictionary<int, Color> ColorProps = [];

    public bool IsModified = true;
    public Material CachedMaterial;

    private const string Top = "TopColor";
    private const int TopLength = 8;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Pattern = reader.ReadString();

        Gloss = reader.ReadNullablePackedFloat();

        SameAs = reader.ReadNullablePackedInt();
        MatSameAs = reader.ReadNullablePackedInt();
        ColorsSameAs = reader.ReadNullablePackedInt();

        UseSSMat = reader.ReadBool();

        MatOrigin = reader.ReadNullableEnum<IdentifiableId>();
        ColorsOrigin = reader.ReadNullableEnum<IdentifiableId>();

        InvertColorOriginColors = reader.ReadBool();

        var count = reader.ReadPackedUInt();

        if (count == 0)
        {
            Main.Console.Log("ColorProps was empty!");
            return;
        }

        var jsonProps = new string[count];

        for (var i = 0; i < count; i++)
            jsonProps[i] = reader.ReadString()!;

        var keySet = new HashSet<string>(jsonProps, StringComparer.Ordinal);
        var tempKeys = new HashSet<string>((int)count, StringComparer.Ordinal);

        foreach (var key in jsonProps)
        {
            if (!key.EndsWith(Top, StringComparison.Ordinal))
                continue;

            var baseName = key.Substring(0, key.Length - TopLength);

            if (!keySet.Contains(baseName + "MiddleColor") || !keySet.Contains(baseName + "BottomColor"))
                tempKeys.Add(baseName);
        }

        for (var i = 0; i < count; i++)
            ColorProps[ShaderUtils.GetOrSet("_" + jsonProps[i])] = ("#" + reader.ReadString()).HexToColor();

        foreach (var baseName in tempKeys)
        {
            var color = ColorProps[ShaderUtils.GetOrSet("_" + baseName + "TopColor")];
            var middleColor = ColorProps.GetOrAdd(ShaderUtils.GetOrSet("_" + baseName + "MiddleColor"), color);
            var bottomKey = ShaderUtils.GetOrSet("_" + baseName + "BottomColor");

            if (!ColorProps.ContainsKey(bottomKey))
                ColorProps[bottomKey] = middleColor;
        }
        Main.Console.Log($"ColorProps: {string.Join("\n", ColorProps.Select(kvp => $"({kvp.Key})={(Color32)kvp.Value}\\(#{ColorUtility.ToHtmlStringRGB(kvp.Value)})"))}");
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        if (!ColorProps.IsNullOrEmpty())
            return;

        if (string.IsNullOrEmpty(Pattern) && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
            IsModified = false;
    }
#else
    public Optional<string> MatOrigin;
    public Optional<string> ColorsOrigin;

    public Optional<float> Gloss;
    public Optional<string> Pattern;

    public Optional<int> SameAs;
    public Optional<int> MatSameAs;
    public Optional<int> ColorsSameAs;

    [JsonProperty("colorProps"), SerializeField] public Dictionary<string, string> ColorProps;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(Pattern);
        pooler.PoolString(MatOrigin);
        pooler.PoolString(ColorsOrigin);

        if (ColorProps.IsNullOrEmpty())
            return;

        pooler.PoolSubstrings(ColorProps.Keys, 1);
        pooler.PoolSubstrings(ColorProps.Values, 1);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(Pattern);

        writer.WriteNullablePackedFloat(Gloss);

        writer.WriteNullablePackedInt(SameAs);
        writer.WriteNullablePackedInt(MatSameAs);
        writer.WriteNullablePackedInt(ColorsSameAs);

        writer.WriteBool(UseSSMat);

        writer.WriteString(MatOrigin);
        writer.WriteString(ColorsOrigin);

        writer.WriteBool(InvertColorOriginColors);

        writer.WritePackedUInt((uint)(ColorProps?.Count ?? 0));

        if (ColorProps.IsNullOrEmpty())
            return;

        foreach (var key in ColorProps!.Keys)
            writer.WriteSubstring(key, 1);

        foreach (var val in ColorProps!.Values)
            writer.WriteSubstring(val, 1);
    }
#endif
}

[Serializable]
public sealed class MeshData : JsonData
{
    public bool Skip;
    public bool UseBaseStruct;
    public bool IgnoreLodIndex;

#if !UNITY
    public bool IsBody;

    public string? Mesh;

    public float? Jiggle;
    public int? PrefabLength;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Mesh = reader.ReadString();
        IgnoreLodIndex = reader.ReadBool();
        Skip = reader.ReadBool();
        UseBaseStruct = reader.ReadBool();
        Jiggle = reader.ReadNullablePackedFloat();
        PrefabLength = reader.ReadNullablePackedInt();
    }
#else
    public Optional<string> Mesh;

    public Optional<float> Jiggle;
    public Optional<int> PrefabLength;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Mesh);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(Mesh);

        writer.WriteBool(IgnoreLodIndex);
        writer.WriteBool(Skip);
        writer.WriteBool(UseBaseStruct);

        writer.WriteNullablePackedFloat(Jiggle);

        writer.WriteNullablePackedInt(PrefabLength);
    }
#endif
}