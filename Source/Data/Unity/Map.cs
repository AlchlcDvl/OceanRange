namespace OceanRange.Data;

public sealed partial class ZoneRequirementData : ModData
{
    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.Write(CorporateLevelMin);
        writer.Write(CorporateLevelMax);
        writer.Write(ExchangeProgress);
        writer.WriteString(PathToGameObject);
    }
}

public sealed partial class ZoneData : ModData
{
    [JsonProperty] public List<StringZoneRequirementDataDictEntry> RequirementsUnity;

    [JsonProperty("region"), JsonRequired] public string RegionUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteString(RegionUnity);
        writer.WriteOrientation(TeleporterOrientation);
        writer.WriteString(TeleporterLocation);
        writer.WriteDictionary(RequirementsUnity, Helpers.WriteModData);
        writer.WriteString(PrefabNamePart);
    }
}

public sealed partial class RegionData : ModData
{
    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.Write(InitialWorldSize);
        writer.WriteVector3(InitialWorldPos);
        writer.Write(MinNodeSize);
        writer.Write(LoosenessVal);
    }
}