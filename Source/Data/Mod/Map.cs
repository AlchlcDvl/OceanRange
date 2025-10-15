namespace OceanRange.Data;

public sealed partial class ZoneRequirementData : ModData
{
    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        CorporateLevelMin = reader.ReadInt();
        CorporateLevelMax = reader.ReadInt();
        ExchangeProgress = reader.ReadInt();
        PathToGameObject = reader.ReadString2();
    }
}

public enum RequirementType
{
    CorporateLevel,
    ExchangeProgress,
    DevCommand,

    // add more?
}

public sealed partial class ZoneData : ModData
{
    public RegionId Region;
    public Dictionary<RequirementType, ZoneRequirementData> Requirements;

    public Zone Zone;
    public PediaId PediaId;
    public Ambiance Ambiance;
    public bool PrefabsPrepped;
    public GameObject Prefab;
    public AmbianceDirectorZoneSetting AmbianceSetting;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Region = reader.ReadEnum<RegionId>();
        TeleporterOrientation = reader.ReadOrientation();
        TeleporterLocation = reader.ReadString2();
        Requirements = reader.ReadDictionary(Helpers.ReadEnum<RequirementType>, Helpers.ReadModData<ZoneRequirementData>);
        PrefabNamePart = reader.ReadString2();
    }

    public override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        Zone = Helpers.AddEnumValue<Zone>(upper);
        PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
        Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
    }
}

public sealed partial class RegionData : ModData
{
    public RegionId Region;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        InitialWorldSize = reader.ReadSingle();
        InitialWorldPos = reader.ReadVector3();
        MinNodeSize = reader.ReadSingle();
        LoosenessVal = reader.ReadSingle();
    }

    public override void OnDeserialise() => Region = Helpers.AddEnumValue<RegionId>(Name.ToUpperInvariant());
}