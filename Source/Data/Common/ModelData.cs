// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class ModelData : JsonData;

[Serializable]
public sealed partial class MatData : JsonData
{
    public bool UseSSMat;

    [JsonProperty("invert")] public bool InvertColorOriginColors;
}

[Serializable]
public sealed partial class MeshData : JsonData
{
    public bool Skip;
    public bool UseBaseStruct;
    public bool IgnoreLodIndex;
}
