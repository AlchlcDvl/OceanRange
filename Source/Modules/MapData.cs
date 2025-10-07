namespace OceanRange.Modules;

public sealed class ZoneRequirementData : ModData
{
    public int CorporateLevelMin = 0;
    public int CorporateLevelMax = int.MaxValue;
    public int ExchangeProgress;
    public string PathToGameObject;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        CorporateLevelMin = reader.ReadInt();
        CorporateLevelMax = reader.ReadInt();
        ExchangeProgress = reader.ReadInt();
        PathToGameObject = reader.ReadString();
    }
}

public enum RequirementType
{
    CorporateLevel,
    ExchangeProgress,
    DevCommand,

    // add more?
}

public sealed class ZoneData : ModData
{
    public RegionId Region;
    public Orientation TeleporterOrientation;
    public string TeleporterLocation;
    public string AssetName;
    public Dictionary<RequirementType, ZoneRequirementData> Requirements = [];

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
        TeleporterLocation = reader.ReadString();
        Requirements = reader.ReadDictionary(Helpers.ReadEnum<RequirementType>, Helpers.ReadModData<ZoneRequirementData>);
        AssetName = reader.ReadString();
    }

    public override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        Zone = Helpers.AddEnumValue<Zone>(upper);
        PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
        Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
    }
}

public sealed class RegionData : ModData
{
    public float InitialWorldSize;
    public Vector3 InitialWorldPos;
    public float MinNodeSize;
    public float LoosenessVal;

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

public sealed class World(BinaryReader reader) : Holder(reader)
{
    public ZoneData[] Zones;
    public RegionData[] Regions;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Regions = reader.ReadArray(Helpers.ReadModData<RegionData>);
        Zones = reader.ReadArray(Helpers.ReadModData<ZoneData>);
    }
}