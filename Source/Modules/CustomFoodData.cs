using System.Runtime.Serialization;

namespace OceanRange.Modules;

public abstract class CustomFoodData : CustomActorData
{
    [JsonProperty("group")]
    public FoodGroup Group;

    [JsonProperty("favouredBy"), JsonRequired]
    public IdentifiableId[] FavouredBy;

    [JsonProperty("pediaFavouredBy"), JsonRequired]
    public string PediaFavouredBy;

    [JsonProperty("about"), JsonRequired]
    public string About;
}

public sealed class CustomChimkenData : CustomFoodData
{
    [JsonProperty("zones"), JsonRequired]
    public Zone[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 1f;

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
        MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.ParseEnum<IdentifiableId>(upper + "_CHICK");
        MainEntry = Helpers.ParseEnum<PediaId>(upper + "_HEN_ENTRY");
        ChickEntry = Helpers.ParseEnum<PediaId>(upper + "_CHICK_ENTRY");
        Group = FoodGroup.MEAT;
        Progress ??= [];
    }
}

public sealed class CustomPlantData : CustomFoodData
{
    [JsonProperty("type"), JsonRequired]
    public string Type;

    [JsonProperty("garden"), JsonRequired]
    public string Garden;

    [JsonProperty("resource"), JsonRequired]
    public string ResourceIdSuffix;

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
        MainId = Helpers.ParseEnum<IdentifiableId>(upper + "_" + typeUpper);
        MainEntry = Helpers.ParseEnum<PediaId>(upper + "_" + typeUpper + "_ENTRY");

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.ParseEnum<SpawnResourceId>(resource);
        DlxResourceId = Helpers.ParseEnum<SpawnResourceId>(resource + "_DLX");

        Progress ??= [];
    }
}