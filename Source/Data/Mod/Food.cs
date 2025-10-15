namespace OceanRange.Data;

public sealed partial class Ingredients : DualValueArrayHolder<PlantData, ChimkenData>;

public sealed partial class ChimkenData : SpawnedActorData
{
    [JsonProperty, JsonRequired] public Zone[] Zones;

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
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");
    }
}

public sealed partial class PlantData : SpawnedActorData
{
    [JsonProperty, JsonRequired] public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;

    public SpawnResourceId ResourceId;
    public SpawnResourceId DlxResourceId;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Type = reader.ReadString2();
        ResourceIdSuffix = reader.ReadString2();
        IsVeggie = reader.ReadBoolean();
        SpawnLocations = reader.ReadDictionary(x => x.ReadDictionary(y => y.ReadArray(Helpers.ReadVector3)));
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        Type ??= "";
        ResourceIdSuffix ??= "";

        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + '_' + typeUpper);

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");
    }
}