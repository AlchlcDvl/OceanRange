#if UNITY
namespace OceanRange.Data;

public sealed partial class ModelData
{
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
}

public sealed partial class MatData
{
    public Optional<string> MatOrigin;
    public Optional<string> ColorsOrigin;

    public Optional<float> Gloss;
    public Optional<string> Pattern;

    public Optional<int> SameAs;
    public Optional<int> MatSameAs;
    public Optional<int> ColorsSameAs;

    [JsonProperty("colorProps"), SerializeField] public Dictionary<string, Color32> ColorProps;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(Pattern);
        pooler.PoolString(MatOrigin);
        pooler.PoolString(ColorsOrigin);

        if (ColorProps.IsNullOrEmpty())
            return;

        pooler.PoolSubstrings(ColorProps.Keys, 1);
        pooler.PoolStrings(ColorProps.Values.Select(x => x.ToHex()));
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
            writer.WriteString(val.ToHex());
    }
}

public sealed partial class MeshData
{
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
}
#endif
