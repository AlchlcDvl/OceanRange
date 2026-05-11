// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class ModelData : JsonData
{
    public MatData MatData;
    public MeshData MeshData;

#if !UNITY
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
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        MatData?.FindStrings(writer);
        MeshData?.FindStrings(writer);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        var matExists = MatData != null;
        writer.WriteBool(matExists);
        MatData?.WriteTo(writer);

        var meshExists = MeshData != null;
        writer.WriteBool(meshExists);
        MeshData?.WriteTo(writer);
    }
#endif
}

public sealed class MatData : JsonData
{
    public float? Gloss;
    public string Pattern;

    public int? SameAs;
    public int? MatSameAs;
    public int? ColorsSameAs;

    public bool UseSSMat;

    [JsonProperty("invert")] public bool InvertColorOriginColors;

#if !UNITY
    public IdentifiableId? MatOrigin;
    public IdentifiableId? ColorsOrigin;

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

        SameAs = (int?)reader.ReadNullablePackedUInt();
        MatSameAs = (int?)reader.ReadNullablePackedUInt();
        ColorsSameAs = (int?)reader.ReadNullablePackedUInt();

        UseSSMat = reader.ReadBool();

        MatOrigin = reader.ReadNullableEnum<IdentifiableId>();
        ColorsOrigin = reader.ReadNullableEnum<IdentifiableId>();

        InvertColorOriginColors = reader.ReadBool();

        var count = reader.ReadPackedUInt();

        if (count == 0)
            return;

        var jsonProps = new string[count];

        for (var i = 0; i < count; i++)
            jsonProps[i] = reader.ReadString();

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
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        if (!ColorProps.IsNullOrEmpty())
            return;

        if (Pattern == null && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
            IsModified = false;
    }
#else
    public string MatOrigin;
    public string ColorsOrigin;

    private Dictionary<string, string> ColorProps;

    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        writer.PoolString(Pattern);
        writer.PoolString(MatOrigin);
        writer.PoolString(ColorsOrigin);

        if (ColorProps.IsNullOrEmpty())
            return;

        writer.PoolSubstrings(ColorProps.Keys, 1);
        writer.PoolSubstrings(ColorProps.Values, 1);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(Pattern);

        writer.WriteNullablePackedFloat(Gloss);

        writer.WriteNullablePackedUInt((uint?)SameAs);
        writer.WriteNullablePackedUInt((uint?)MatSameAs);
        writer.WriteNullablePackedUInt((uint?)ColorsSameAs);

        writer.WriteBool(UseSSMat);

        writer.WriteString(MatOrigin);
        writer.WriteString(ColorsOrigin);

        writer.WriteBool(InvertColorOriginColors);

        writer.WritePackedUInt((uint)(ColorProps?.Count ?? 0));

        if (ColorProps.IsNullOrEmpty())
            return;

        foreach (var key in ColorProps.Keys)
            writer.WriteSubstring(key, 1);

        foreach (var val in ColorProps.Values)
            writer.WriteSubstring(val, 1);
    }
#endif
}

public sealed class MeshData : JsonData
{
    public string Mesh;

    public bool Skip;
    public bool UseBaseStruct;
    public bool IgnoreLodIndex;

    public float? Jiggle;
    public int? PrefabLength;

#if !UNITY
    public bool IsBody;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Mesh = reader.ReadString();
        IgnoreLodIndex = reader.ReadBool();
        Skip = reader.ReadBool();
        UseBaseStruct = reader.ReadBool();
        Jiggle = reader.ReadNullablePackedFloat();
        PrefabLength = (int?)reader.ReadNullablePackedUInt();
    }
#else
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Mesh);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(Mesh);

        writer.WriteBool(IgnoreLodIndex);
        writer.WriteBool(Skip);
        writer.WriteBool(UseBaseStruct);

        writer.WriteNullablePackedFloat(Jiggle);

        writer.WriteNullablePackedUInt((uint?)PrefabLength);
    }
#endif
}