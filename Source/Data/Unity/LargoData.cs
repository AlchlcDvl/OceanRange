#if UNITY
namespace OceanRange.Data;

public sealed partial class LargoData
{
    public string[] DefProps;

    public Optional<float> Jiggle;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(DefProps);
        Array.ForEach(Appearances, a => a.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteArray(Appearances, (w, a) => a.WriteTo(w));
        writer.WriteStringArray(DefProps);
        writer.WriteNullablePackedFloat(Jiggle);
    }
}

public sealed partial class LargoAppearanceData
{
    public string[] LargoProps;
    public string[] AppProps;

    public Optional<ModelData> BodyStruct;

    public Optional<float> Jiggle;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolStrings(LargoProps);
        pooler.PoolStrings(AppProps);

        if (BodyStruct.HasValue)
            BodyStruct.Value.FindStrings(pooler);

        if (!Slime1Structs.IsNullOrEmpty())
            Array.ForEach(Slime1Structs, s => s.FindStrings(pooler));

        if (!Slime2Structs.IsNullOrEmpty())
            Array.ForEach(Slime2Structs, s => s.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteStringArray(LargoProps);
        writer.WriteStringArray(AppProps);

        writer.WriteBool(BodyStruct.HasValue);

        if (BodyStruct.HasValue)
            BodyStruct.Value.WriteTo(writer);

        writer.WriteArray(Slime1Structs, (w, s) => s.WriteTo(w));
        writer.WriteArray(Slime2Structs, (w, s) => s.WriteTo(w));

        writer.WriteNullablePackedFloat(Jiggle);
    }
}
#endif
