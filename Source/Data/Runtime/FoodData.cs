#if !UNITY
namespace OceanRange.Data;

public sealed partial class Ingredients
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Groups = reader.ReadArray(r => { var d = new GroupData(); d.ReadFrom(r); return d; })!;
        Fruits = reader.ReadArray(r => { var d = new FruitData(); d.ReadFrom(r); return d; })!;
        Veggies = reader.ReadArray(r => { var d = new VeggieData(); d.ReadFrom(r); return d; })!;
        Chimkens = reader.ReadArray(r => { var d = new ChimkenData(); d.ReadFrom(r); return d; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(Groups, x => x.OnDeserialise());
        Array.ForEach(Fruits, x => x.OnDeserialise());
        Array.ForEach(Veggies, x => x.OnDeserialise());
        Array.ForEach(Chimkens, x => x.OnDeserialise());
    }
}

public sealed partial class GroupData
{
    public IdentifiableId[] Foods;

    public FoodGroup Group;

    public override void OnDeserialise() => Group = Helpers.ParseOrAddEnumValue<FoodGroup>(Name!.ToUpperInvariant());

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Foods = reader.ReadEnumArray<IdentifiableId>()!;
    }
}

public abstract partial class FoodData
{
    protected static readonly Dictionary<string, Action<GameObject>> Methods = new(StringComparer.Ordinal);

    static FoodData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Cookbook)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = Helpers.CompileAction<GameObject>(method);
        }
    }

    public Action<GameObject>? InitFoodDetails;

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Methods.TryGetValue("Init" + Name + "FoodDetails", out InitFoodDetails);
    }
}

public sealed partial class ChimkenData
{
    public Zone[] Zones;

    public IdentifiableId ChickId;
    public Action<GameObject>? InitHenDetails;
    public Action<GameObject>? InitChickDetails;

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name!.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_HEN");
        ChickId = Helpers.AddEnumValue<IdentifiableId>(upper + "_CHICK");

        Methods.TryGetValue("Init" + Name + "HenDetails", out InitHenDetails);
        Methods.TryGetValue("Init" + Name + "ChickDetails", out InitChickDetails);
    }

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        SpawnAmount = reader.ReadPackedFloat();
        ChickSpawnAmount = reader.ReadPackedFloat();
        Zones = reader.ReadEnumArray<Zone>()!;
    }
}

public abstract partial class PlantData
{
    public abstract bool IsFruit { get; }
    public abstract string Type { get; }
    public abstract string ResourceIdSuffix { get; }

    protected abstract IdentifiableId DefaultPlant { get; }
    protected abstract SpawnResourceId DefaultResource { get; }

    public IdentifiableId? BasePlant;
    public SpawnResourceId? BaseResource;

    public SpawnResourceId BaseResourceDlx;

    public SpawnResourceId ResourceId;
    public SpawnResourceId DlxResourceId;

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name!.ToUpperInvariant();

        var typeUpper = Type.ToUpperInvariant();
        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_" + typeUpper);

        var resource = upper + "_" + ResourceIdSuffix.ToUpperInvariant();
        ResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource);
        DlxResourceId = Helpers.AddEnumValue<SpawnResourceId>(resource + "_DLX");

        BasePlant ??= DefaultPlant;
        BaseResource ??= DefaultResource;

        BaseResourceDlx = Helpers.ParseEnum<SpawnResourceId>(BaseResource + "_DLX");
    }

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        BasePlant = reader.ReadNullableEnum<IdentifiableId>();
        BaseResource = reader.ReadNullableEnum<SpawnResourceId>();

        AdjustColliders = reader.ReadBool();
        SpawnLocations = reader.ReadDictionary(r => r.ReadString(), r => r.ReadArray(r2 => r2.ReadOrientation()), StringComparer.Ordinal)!;
    }
}

public sealed partial class VeggieData
{
    public override bool IsFruit => false;
    public override string Type => "Veggie";
    public override string ResourceIdSuffix => "Patch";
    protected override IdentifiableId DefaultPlant => IdentifiableId.CARROT_VEGGIE;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.CARROT_PATCH;
}

public sealed partial class FruitData
{
    public override bool IsFruit => true;
    public override string Type => "Fruit";
    public override string ResourceIdSuffix => "Tree";
    protected override IdentifiableId DefaultPlant => IdentifiableId.POGO_FRUIT;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.POGO_TREE;
}
#endif
