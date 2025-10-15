namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Ingredients")]
public sealed partial class Ingredients : DualValueArrayHolder<PlantData, ChimkenData>;

[Serializable]
public sealed partial class ChimkenData : SpawnedActorData
{
    [JsonProperty] public float SpawnAmount = 1f;
    [JsonProperty] public float ChickSpawnAmount = 1f;
}

[Serializable]
public sealed partial class PlantData : SpawnedActorData
{
    [JsonProperty, JsonRequired] public string Type;
    [JsonProperty, JsonRequired] public bool IsVeggie;

    [JsonProperty("resourceSuffix"), JsonRequired] public string ResourceIdSuffix;
}