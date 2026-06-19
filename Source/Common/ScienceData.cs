namespace OceanRange.Data;

[Serializable]
public sealed class ScienceItemData : SpawnedActorData
{
    public MaterialOverrideData[] MaterialOverrides;
    public ExtractorDropData[] ExtractorDrops;

#if UNITY
    [JsonRequired] public string BaseItemId;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(BaseItemId);
        Array.ForEach(MaterialOverrides, x => x.FindStrings(pooler));
        Array.ForEach(ExtractorDrops, x => x.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(BaseItemId);
        writer.WriteArray(MaterialOverrides, (w, x) => x.WriteTo(w));
        writer.WriteArray(ExtractorDrops, (w, x) => x.WriteTo(w));
    }
#else
    public IdentifiableId BaseItemId;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        MaterialOverrides = reader.ReadArray(r => { var x = new MaterialOverrideData(); x.ReadFrom(r); return x; })!;
        ExtractorDrops = reader.ReadArray(r => { var x = new ExtractorDropData(); x.ReadFrom(r); return x; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(MaterialOverrides, x => x.OnDeserialise());
        Array.ForEach(ExtractorDrops, x => x.OnDeserialise());
    }
#endif
}

[Serializable]
public sealed class MaterialOverrideData : JsonData
{
    public int[] ChildPath;
    public Dictionary<string, Color> ColorProperties;
    public Dictionary<string, float> FloatProperties;
}

[Serializable]
public sealed class ExtractorDropData : JsonData
{
    public GadgetId ExtractorId;
    public float Chance;
    public ZoneDirector.Zone Zone;
    public bool RestrictZone;
    public int SpawnFxIndex;
}