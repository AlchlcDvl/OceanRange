namespace OceanRange.Data;

[Serializable]
public sealed partial class ScienceItemData : SpawnedActorData
{
    public MaterialOverrideData[] MaterialOverrides;
    public ExtractorDropData[] ExtractorDrops;
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
    public Zone Zone;
    public bool RestrictZone;
    public int SpawnFxIndex;
}
