namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Slimes")]
public sealed class SlimeHolder : ValueArrayHolder<SlimeData>;

[Serializable]
public sealed partial class SlimeData : SpawnedActorData
{
    [JsonProperty, JsonRequired] public ModelData[] SlimeFeatures;

    [JsonProperty] public ModelData[] GordoFeatures;
    [JsonProperty] public ModelData[] PlortFeatures;

    [JsonProperty] public bool NightSpawn;
    [JsonProperty] public bool CanBeRefined;

    [JsonProperty] public string GordoCell;

    [JsonProperty] public bool HasGordo = true;
    [JsonProperty] public bool Vaccable = true;

    [JsonProperty] public string[] ExcludedSpawners;

    [JsonProperty] public int PlortExchangeWeight = 16;
    [JsonProperty] public int GordoEatAmount = 25;

    [JsonProperty] public string PlortType = "Pearl";

    [JsonProperty] public float SpawnAmount = 0.25f;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;

    [JsonProperty("jiggle")] public float Jiggle = 1f;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;
}