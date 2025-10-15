namespace OceanRange.Modules;

public sealed class Ingredients
{
    [JsonProperty("plants")]
    public PlantData[] Plants;

    [JsonProperty("chimkens")]
    public ChimkenData[] Chimkens;
}

public abstract class FoodData : SpawnedActorData
{
    [JsonProperty("group")]
    public FoodGroup Group;
}

public sealed class ChimkenData : FoodData
{
    [JsonProperty("zones"), JsonRequired]
    public Zone[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 1f;

    [JsonProperty("chickSpawnAmount")]
    public float ChickSpawnAmount = 1f;

    [JsonIgnore]
    public IdentifiableId ChickId;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        Group = FoodGroup.MEAT;
        Progress ??= [];
    }
}

public sealed class PlantData : FoodData
{
    [JsonProperty("type"), JsonRequired]
    public string Type;

    [JsonProperty("resource"), JsonRequired]
    public string ResourceIdSuffix;

    [JsonProperty("spawnLocations"), JsonRequired]
    public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;

    [JsonIgnore]
    public bool IsVeggie;

    [JsonIgnore]
    public SpawnResourceId ResourceId;

    [JsonIgnore]
    public SpawnResourceId DlxResourceId;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_" + typeUpper);

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");

        IsVeggie = Group == FoodGroup.VEGGIES;

        Progress ??= [];
    }
}