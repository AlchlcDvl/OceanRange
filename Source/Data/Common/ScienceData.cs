namespace OceanRange.Data;

[Serializable]
public sealed partial class ScienceItemData : SpawnedActorData
{
    public MaterialOverrideData[] MaterialOverrides;
    public ExtractorDropData[] ExtractorDrops;
}

[Serializable]
public sealed partial class MaterialOverrideData : JsonData
{
    public int[] ChildPath;
    public Dictionary<string, Color> ColorProperties;
    public Dictionary<string, float> FloatProperties;
}

[Serializable]
public sealed partial class ExtractorDropData : JsonData
{
    public float Chance;
    public bool RestrictZone;
    public int SpawnFxIndex;
}
