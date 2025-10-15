namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/World")]
public sealed class World : DualValueArrayHolder<RegionData, ZoneData>;

[Serializable]
public sealed partial class ZoneRequirementData : ModData
{
    [JsonProperty, JsonRequired] public string PathToGameObject;

    [JsonProperty] public int CorporateLevelMin = 0;
    [JsonProperty] public int CorporateLevelMax = int.MaxValue;

    [JsonProperty] public int ExchangeProgress;
}

[Serializable]
public sealed partial class ZoneData : ModData
{
    [JsonProperty, JsonRequired] public string PrefabNamePart;

    [JsonProperty("teleporterOri"), JsonRequired] public Orientation TeleporterOrientation;
    [JsonProperty("teleporterLoc"), JsonRequired] public string TeleporterLocation;
}

[Serializable]
public sealed partial class RegionData : ModData
{
    [JsonProperty, JsonRequired] public float InitialWorldSize;
    [JsonProperty, JsonRequired] public float MinNodeSize;
    [JsonProperty, JsonRequired] public float LoosenessVal;

    [JsonProperty, JsonRequired] public Vector3 InitialWorldPos;
}