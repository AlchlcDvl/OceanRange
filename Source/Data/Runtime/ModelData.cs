#if !UNITY
namespace OceanRange.Data;

public sealed partial class ModelData
{
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
}

public sealed partial class MatData
{
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
            return;

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
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        if (!ColorProps.IsNullOrEmpty())
            return;

        if (string.IsNullOrEmpty(Pattern) && !Gloss.HasValue && !ColorsOrigin.HasValue && !InvertColorOriginColors)
            IsModified = false;
    }
}

public sealed partial class MeshData
{
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
}
#endif
