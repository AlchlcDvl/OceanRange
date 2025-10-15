namespace OceanRange.Unity.Json;

[Serializable]
public sealed class ZoneRequirementData : JsonData
{
    [JsonProperty("minLevel")]
    public int CorporateLevelMin = 0;

    [JsonProperty("maxLevel")]
    public int CorporateLevelMax = int.MaxValue;

    [JsonProperty("rancherProgress")]
    public int ExchangeProgress;

    [JsonProperty("modifyPath"), JsonRequired]
    public string PathToGameObject;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.Write(CorporateLevelMin);
        writer.Write(CorporateLevelMax);
        writer.Write(ExchangeProgress);
        writer.WriteString(PathToGameObject);
    }
}

[Serializable]
public sealed class ZoneData : JsonData
{
    [JsonProperty("region"), JsonRequired]
    public string Region;

    [JsonProperty("teleporterOri"), JsonRequired]
    public Orientation TeleporterOrientation;

    [JsonProperty("teleporterLoc"), JsonRequired]
    public string TeleporterLocation;

    [JsonProperty("requirements")]
    public List<SerializableStringZoneRequirementDataPair> Requirements;

    [JsonProperty("prefab"), JsonRequired]
    public string AssetName;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteString(Region);
        writer.WriteOrientation(TeleporterOrientation);
        writer.WriteString(TeleporterLocation);
        writer.WriteDictionary(Requirements, Helpers.WriteString, Helpers.WriteJsonData);
        writer.WriteString(AssetName);
    }
}

[Serializable]
public sealed class RegionData : JsonData
{
    [JsonProperty("initialWorldSize"), JsonRequired]
    public float InitialWorldSize;

    [JsonProperty("initialWorldPos"), JsonRequired]
    public Vector3 InitialWorldPos;

    [JsonProperty("minNodeSize"), JsonRequired]
    public float MinNodeSize;

    [JsonProperty("loosenessVal"), JsonRequired]
    public float LoosenessVal;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.Write(InitialWorldSize);
        writer.WriteVector3(InitialWorldPos);
        writer.Write(MinNodeSize);
        writer.Write(LoosenessVal);
    }
}

[Serializable]
public sealed class World : JsonData
{
    [JsonProperty("zones"), JsonRequired]
    public ZoneData[] Zones;

    [JsonProperty("regions"), JsonRequired]
    public RegionData[] Regions;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Regions, Helpers.WriteJsonData);
        writer.WriteArray(Zones, Helpers.WriteJsonData);
    }
}