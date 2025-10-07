namespace OceanRange.Modules;

public sealed class Ingredients(BinaryReader reader) : Holder(reader)
{
    public PlantData[] Plants;
    public ChimkenData[] Chimkens;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Plants = reader.ReadArray(Helpers.ReadModData<PlantData>);
        Chimkens = reader.ReadArray(Helpers.ReadModData<ChimkenData>);
    }
}

public sealed class ChimkenData : SpawnedActorData
{
    public Zone[] Zones;
    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

    public IdentifiableId ChickId;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        SpawnAmount = reader.ReadSingle();
        ChickSpawnAmount = reader.ReadSingle();
        Zones = reader.ReadArray(Helpers.ReadEnum<Zone>);
    }

    public override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");
    }
}

public sealed class PlantData : SpawnedActorData
{
    public string Type;
    public string ResourceIdSuffix;
    public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;
    public bool IsVeggie;

    public SpawnResourceId ResourceId;
    public SpawnResourceId DlxResourceId;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Type = reader.ReadString();
        ResourceIdSuffix = reader.ReadString();
        IsVeggie = reader.ReadBoolean();
        SpawnLocations = reader.ReadDictionary(Helpers.ReadString2, x => x.ReadDictionary(Helpers.ReadString2, y => y.ReadArray(Helpers.ReadVector3)));
    }

    public override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + '_' + typeUpper);

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");
    }
}