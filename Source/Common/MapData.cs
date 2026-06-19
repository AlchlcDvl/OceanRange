// ReSharper disable UnassignedField.Global
// ReSharper disable UnusedMember.Global

namespace OceanRange.Data;

[Serializable]
public sealed class ZoneRequirementData : JsonData
{
    [JsonProperty("minLevel")] public int CorporateLevelMin;
    [JsonProperty("maxLevel")] public int CorporateLevelMax = int.MaxValue;

    [JsonProperty("rancherProgress")] public int ExchangeProgress;

    [JsonRequired] public string PathToGameObject;

#if UNITY
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(PathToGameObject);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedUInt((uint)CorporateLevelMin);
        writer.WritePackedUInt((uint)CorporateLevelMax);
        writer.WritePackedUInt((uint)ExchangeProgress);
        writer.WriteString(PathToGameObject);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        CorporateLevelMin = (int)reader.ReadPackedUInt();
        CorporateLevelMax = (int)reader.ReadPackedUInt();
        ExchangeProgress = (int)reader.ReadPackedUInt();
        PathToGameObject = reader.ReadString()!;
    }
#endif
}

#if !UNITY
public enum RequirementType : byte
{
    CorporateLevel,
    ExchangeProgress,
    DevCommand,

    // add more?
}
#endif

[Serializable]
public sealed class ZoneData : JsonData
{
    protected override bool SerialiseName => true;

#if UNITY
    [JsonRequired] public string Region;
    [SerializeField] public Dictionary<string, ZoneRequirementData> Requirements;
#else
    [JsonRequired] public RegionId Region;
    public Dictionary<RequirementType, ZoneRequirementData>? Requirements;
#endif

    [JsonProperty("teleporterOri"), JsonRequired] public Orientation TeleporterOrientation;
    [JsonProperty("teleporterLoc"), JsonRequired] public string TeleporterLocation;
    [JsonProperty("prefab"), JsonRequired] public string AssetName;

#if !UNITY
    [JsonIgnore] public Zone Zone;
    [JsonIgnore] public PediaId PediaId;
    [JsonIgnore] public Ambiance Ambiance;
    [JsonIgnore] public bool PrefabsPrepped;
    [JsonIgnore] public GameObject Prefab;
    [JsonIgnore] public AmbianceDirectorZoneSetting AmbianceSetting;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Region = reader.ReadEnum<RegionId>();
        TeleporterOrientation = reader.ReadOrientation();
        TeleporterLocation = reader.ReadString()!;
        AssetName = reader.ReadString()!;

        Requirements = reader.ReadDictionary(
            r => r.ReadEnum<RequirementType>(),
            r => { var z = new ZoneRequirementData(); z.ReadFrom(r); return z; }
        );
    }

    public override void OnDeserialise()
    {
        if (Requirements != null)
        {
            foreach (var req in Requirements.Values)
                req.OnDeserialise();
        }

        var upper = Name!.ToUpperInvariant();

        Zone = Helpers.AddEnumValue<Zone>(upper);
        PediaId = Helpers.AddEnumValue<PediaId>(upper + "_ENTRY");
        Ambiance = Helpers.AddEnumValue<Ambiance>(upper + "_AMBIANCE");
    }
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Region);
        pooler.PoolString(TeleporterLocation);
        pooler.PoolString(AssetName);

        if (Requirements.IsNullOrEmpty())
            return;

        pooler.PoolStrings(Requirements.Keys);

        foreach (var req in Requirements.Values)
            req.FindStrings(pooler);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Region);
        writer.WriteOrientation(TeleporterOrientation);
        writer.WriteString(TeleporterLocation);
        writer.WriteString(AssetName);

        writer.WriteDictionary(Requirements,
            (w, k) => w.WriteString(k),
            (w, v) => v.WriteTo(w)
        );
    }
#endif
}

[Serializable]
public sealed class RegionData : JsonData
{
    protected override bool SerialiseName => true;

    [JsonRequired] public float MinNodeSize;
    [JsonRequired] public float LoosenessVal;
    [JsonRequired] public float InitialWorldSize;

    [JsonRequired] public Vector3 InitialWorldPos;

#if !UNITY
    [JsonIgnore] public RegionId Region;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        MinNodeSize = reader.ReadPackedFloat();
        LoosenessVal = reader.ReadPackedFloat();
        InitialWorldSize = reader.ReadPackedFloat();
        InitialWorldPos = reader.ReadVector3();
        // have to put it here bc Az put the thing that
        // grabs this enum inside the ZoneData.ReadFrom,
        // which happens before OnDeserialize on this class.
        Region = Helpers.AddEnumValue<RegionId>(Name!.ToUpperInvariant());
    }

    // public override void OnDeserialise()
    // {
    //     base.OnDeserialise();
    //     Region = Helpers.AddEnumValue<RegionId>(Name.ToUpperInvariant());
    // }
#else
    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedFloat(MinNodeSize);
        writer.WritePackedFloat(LoosenessVal);
        writer.WritePackedFloat(InitialWorldSize);
        writer.WriteVector3(InitialWorldPos);
    }
#endif
}

[Serializable]
public sealed class World : JsonData
{
    [JsonRequired] public RegionData[] Regions;
    [JsonRequired] public ZoneData[] Zones;

#if UNITY
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        Array.ForEach(Regions, r => r.FindStrings(pooler));
        Array.ForEach(Zones, z => z.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteArray(Regions, (w, r) => r.WriteTo(w));
        writer.WriteArray(Zones, (w, z) => z.WriteTo(w));
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Regions = reader.ReadArray(r => { var d = new RegionData(); d.ReadFrom(r); return d; })!;
        Zones = reader.ReadArray(r => { var d = new ZoneData(); d.ReadFrom(r); return d; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(Regions, r => r.OnDeserialise());
        Array.ForEach(Zones, z => z.OnDeserialise());
    }
#endif
}