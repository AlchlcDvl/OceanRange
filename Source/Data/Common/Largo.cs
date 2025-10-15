namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Largos")]
public sealed class LargoHolder : ValueArrayHolder<LargoData>;

[Serializable]
public sealed partial class LargoData
{
    [JsonProperty("bodyStruct")] public ModelData BodyStructData;

    [JsonProperty("slime1Structs")] public ModelData[] Slime1StructData;
    [JsonProperty("slime2Structs")] public ModelData[] Slime2StructData;
}