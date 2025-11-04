// ReSharper disable UnassignedField.Global

using System.Reflection;

namespace OceanRange.Data;

public sealed class Ingredients : JsonData
{
    [JsonRequired] public FruitData[] Fruits;
    [JsonRequired] public VeggieData[] Veggies;
    [JsonRequired] public ChimkenData[] Chimkens;
}

public abstract class FoodData : SpawnedActorData
{
    protected static readonly Dictionary<string, MethodInfo> Methods = [];

    static FoodData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Cookbook)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

    [JsonIgnore] public MethodInfo InitFoodDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();
        Methods.TryGetValue("Init" + Name + "FoodDetails", out InitFoodDetails);
    }
}

public sealed class ChimkenData : FoodData
{
    [JsonRequired] public Zone[] Zones;

    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

    [JsonIgnore] public IdentifiableId ChickId;

    [JsonIgnore] public MethodInfo InitHenDetails;
    [JsonIgnore] public MethodInfo InitChickDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        Methods.TryGetValue("Init" + Name + "HenDetails", out InitHenDetails);
        Methods.TryGetValue("Init" + Name + "ChickDetails", out InitChickDetails);
    }
}

public abstract class PlantData : FoodData
{
    public abstract string Type { get; }
    public abstract string ResourceIdSuffix { get; }
    protected abstract IdentifiableId DefaultPlant { get; }
    protected abstract SpawnResourceId DefaultResource { get; }

    // public bool HasOriginalSpawners = true; // TODO: Implement this in the future

    // ReSharper disable once CollectionNeverUpdated.Global
    public Dictionary<string, Dictionary<string, Orientation[]>> SpawnLocations;

    public IdentifiableId? BasePlant;
    public SpawnResourceId? BaseResource;

    public bool AdjustColliders = true;

    [JsonIgnore] public SpawnResourceId BaseResourceDlx;

    [JsonIgnore] public SpawnResourceId ResourceId;
    [JsonIgnore] public SpawnResourceId DlxResourceId;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_" + typeUpper);

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");

        BasePlant ??= DefaultPlant;
        BaseResource ??= DefaultResource;

        BaseResourceDlx = Helpers.ParseEnum<SpawnResourceId>(BaseResource + "_DLX");
    }
}

public sealed class VeggieData : PlantData
{
    public override string Type => "Veggie";
    public override string ResourceIdSuffix => "Patch";
    protected override IdentifiableId DefaultPlant => IdentifiableId.CARROT_VEGGIE;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.CARROT_PATCH;
}

public sealed class FruitData : PlantData
{
    public override string Type => "Fruit";
    public override string ResourceIdSuffix => "Tree";
    protected override IdentifiableId DefaultPlant => IdentifiableId.POGO_FRUIT;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.POGO_TREE;
}