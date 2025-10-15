namespace OceanRange.Data;

public sealed class Ingredients : JsonData
{
    public PlantData[] Plants;
    public ChimkenData[] Chimkens;
}

public sealed class ChimkenData : SpawnedActorData
{
    [JsonRequired] public Zone[] Zones;

    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

    [JsonIgnore] public IdentifiableId ChickId;

    protected override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        Progress ??= [];
    }
}

public sealed class PlantData : SpawnedActorData
{
    [JsonRequired] public bool IsVeggie;

    [JsonRequired] public string Type;
    [JsonRequired] public string ResourceIdSuffix;

    [JsonRequired] public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;

    [JsonIgnore] public SpawnResourceId ResourceId;
    [JsonIgnore] public SpawnResourceId DlxResourceId;

    protected override void OnDeserialise()
    {
        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + '_' + typeUpper);

        var resource = upper + '_' + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");

        Progress ??= [];
    }
}