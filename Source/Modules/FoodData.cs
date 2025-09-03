namespace OceanRange.Modules;

public abstract class FoodData : SpawnedActorData
{
    [JsonProperty("group")]
    public FoodGroup Group;

    [JsonProperty("pediaFavouredBy"), JsonRequired]
    public string PediaFavouredBy;

    [JsonProperty("about"), JsonRequired]
    public string About;
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

    [JsonIgnore]
    public PediaId ChickEntry;

    [JsonProperty("chickIntro"), JsonRequired]
    public string ChickIntro;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        MainEntry = Helpers.AddEnumValue<PediaId>(upper + "_HEN_ENTRY");
        ChickEntry = Helpers.AddEnumValue<PediaId>(upper + "_CHICK_ENTRY");

        Group = FoodGroup.MEAT;
        Progress ??= [];
    }
}

public sealed class PlantData : FoodData
{
    [JsonProperty("type"), JsonRequired]
    public string Type;

    [JsonProperty("garden"), JsonRequired]
    public string Garden;

    [JsonProperty("resource"), JsonRequired]
    public string ResourceIdSuffix;

    [JsonIgnore]
    public bool IsVeggie;

    [JsonIgnore]
    public SpawnResourceId ResourceId;

    [JsonIgnore]
    public SpawnResourceId DlxResourceId;

    [JsonProperty("spawnLocations"), JsonRequired]
    public Dictionary<string, Dictionary<string, Vector3[]>> SpawnLocations;

    [OnDeserialized]
    public void PopulateRemainingValues(StreamingContext _)
    {
        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_" + typeUpper);
        MainEntry = Helpers.AddEnumValue<PediaId>(upper + "_" + typeUpper + "_ENTRY");

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");

        IsVeggie = Group == FoodGroup.VEGGIES;

        Progress ??= [];
    }
}