namespace OceanRange.Data;

[Serializable]
public sealed partial class ModelData : ModData
{
    [JsonProperty] public string Pattern;

    [JsonProperty] public bool CloneSameAs;
    [JsonProperty] public bool CloneMatOrigin = true;
    [JsonProperty] public bool CloneFallback = true;

    // [JsonProperty] public string Shader;

    [JsonProperty] public string Mesh;

    [JsonProperty] public bool SkipNull;
    [JsonProperty] public bool Skip;

    [JsonProperty] public bool IgnoreLodIndex;
    [JsonProperty] public bool InvertColorOriginColors;

    public ModelData() { }
}