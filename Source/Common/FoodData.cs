// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

public sealed class Ingredients : JsonData
{
    [JsonRequired] public GroupData[] Groups;
    [JsonRequired] public FruitData[] Fruits;
    [JsonRequired] public VeggieData[] Veggies;
    [JsonRequired] public ChimkenData[] Chimkens;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        foreach (var group in Groups)
            group.FindStrings(writer);

        foreach (var fruit in Fruits)
            fruit.FindStrings(writer);

        foreach (var veggie in Veggies)
            veggie.FindStrings(writer);

        foreach (var chimken in Chimkens)
            chimken.FindStrings(writer);
    }
#endif
}

public sealed class GroupData : JsonData
{
#if !UNITY
    [JsonRequired] public IdentifiableId[] Foods;
#else
    [JsonRequired] public string[] Foods;
#endif

    [JsonIgnore] public FoodGroup Group;

    protected override void OnDeserialise() => Group = Helpers.ParseOrAddEnumValue<FoodGroup>(Name.ToUpperInvariant());

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Foods);
    }
#endif
}

public abstract class FoodData : SpawnedActorData
{
    protected static readonly Dictionary<string, Action<GameObject>> Methods = [];

    static FoodData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Cookbook)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = Helpers.CompileAction<GameObject>(method);
        }
    }

    [JsonIgnore] public Action<GameObject> InitFoodDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();
        Methods.TryGetValue("Init" + Name + "FoodDetails", out InitFoodDetails);
    }
}

public sealed class ChimkenData : FoodData
{
#if !UNITY
    [JsonRequired] public Zone[] Zones;
#else
    [JsonRequired] public string[] Zones;
#endif

    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

#if !UNITY
    [JsonIgnore] public IdentifiableId ChickId;

    [JsonIgnore] public Action<GameObject> InitHenDetails;
    [JsonIgnore] public Action<GameObject> InitChickDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        Methods.TryGetValue("Init" + Name + "HenDetails", out InitHenDetails);
        Methods.TryGetValue("Init" + Name + "ChickDetails", out InitChickDetails);
    }

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Zones);
    }
#endif
}

public abstract class PlantData : FoodData
{
    public abstract bool IsFruit { get; }
    public abstract string Type { get; }
    public abstract string ResourceIdSuffix { get; }
    protected abstract IdentifiableId DefaultPlant { get; }
    protected abstract SpawnResourceId DefaultResource { get; }

    // public bool HasOriginalSpawners = true; // TODO: Implement this in the future

    // ReSharper disable once CollectionNeverUpdated.Global
    public Dictionary<string, Orientation[]> SpawnLocations;

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

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(BasePlant);
        writer.PoolString(BaseResource);
        writer.PoolStrings(SpawnLocations.Keys);
    }
#endif
}

public sealed class VeggieData : PlantData
{
    public override bool IsFruit => false;
    public override string Type => "Veggie";
    public override string ResourceIdSuffix => "Patch";
    protected override IdentifiableId DefaultPlant => IdentifiableId.CARROT_VEGGIE;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.CARROT_PATCH;
}

public sealed class FruitData : PlantData
{
    public override bool IsFruit => true;
    public override string Type => "Fruit";
    public override string ResourceIdSuffix => "Tree";
    protected override IdentifiableId DefaultPlant => IdentifiableId.POGO_FRUIT;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.POGO_TREE;
}