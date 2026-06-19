// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

[Serializable]
public sealed class Ingredients : JsonData
{
    [JsonRequired] public GroupData[] Groups;
    [JsonRequired] public FruitData[] Fruits;
    [JsonRequired] public VeggieData[] Veggies;
    [JsonRequired] public ChimkenData[] Chimkens;

#if !UNITY
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
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        Array.ForEach(Groups, x => x.FindStrings(pooler));
        Array.ForEach(Fruits, x => x.FindStrings(pooler));
        Array.ForEach(Veggies, x => x.FindStrings(pooler));
        Array.ForEach(Chimkens, x => x.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteArray(Groups, (w, g) => g.WriteTo(w));
        writer.WriteArray(Fruits, (w, f) => f.WriteTo(w));
        writer.WriteArray(Veggies, (w, v) => v.WriteTo(w));
        writer.WriteArray(Chimkens, (w, c) => c.WriteTo(w));
    }
#endif
}

[Serializable]
public sealed class GroupData : JsonData
{
    protected override bool SerialiseName => true;

#if !UNITY
    public IdentifiableId[] Foods;

    public FoodGroup Group;
#else
    [JsonRequired] public string[] Foods;
#endif

#if !UNITY
    public override void OnDeserialise() => Group = Helpers.ParseOrAddEnumValue<FoodGroup>(Name!.ToUpperInvariant());

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Foods = reader.ReadEnumArray<IdentifiableId>()!;
    }
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Foods);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteStringArray(Foods);
    }
#endif
}

public abstract class FoodData : SpawnedActorData
{
    protected override bool SerialiseName => true;

#if !UNITY
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
#endif
}

[Serializable]
public sealed class ChimkenData : FoodData
{
#if !UNITY
    public Zone[] Zones;
#else
    [JsonRequired] public string[] Zones;
#endif

    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;

#if !UNITY
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
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Zones);
        pooler.PoolString(CrestColor.ToHex());
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedFloat(SpawnAmount);
        writer.WritePackedFloat(ChickSpawnAmount);
        writer.WriteStringArray(Zones);
        writer.WriteString(CrestColor.ToHex());
    }
#endif
}

public abstract class PlantData : FoodData
{
#if !UNITY
    public abstract bool IsFruit { get; }
    public abstract string Type { get; }
    public abstract string ResourceIdSuffix { get; }

    protected abstract IdentifiableId DefaultPlant { get; }
    protected abstract SpawnResourceId DefaultResource { get; }

    public IdentifiableId? BasePlant;
    public SpawnResourceId? BaseResource;
#else
    public Optional<string> BasePlant;
    public Optional<string> BaseResource;
#endif

    // public bool HasOriginalSpawners = true; // TODO: Implement this in the future

#if UNITY
    [SerializeField]
#endif
    public Dictionary<string, Orientation[]> SpawnLocations;

    public bool AdjustColliders = true;

#if !UNITY
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
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(BasePlant);
        pooler.PoolString(BaseResource);

        if (SpawnLocations != null)
            pooler.PoolStrings(SpawnLocations.Keys);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(BasePlant);
        writer.WriteString(BaseResource);

        writer.WriteBool(AdjustColliders);

        writer.WriteDictionary(SpawnLocations, (w, v) => w.WriteString(v), (w, v) => w.WriteArray(v, (w2, v2) => w2.WriteOrientation(v2)));
    }
#endif
}

[Serializable]
public sealed class VeggieData : PlantData
{
#if !UNITY
    public override bool IsFruit => false;
    public override string Type => "Veggie";
    public override string ResourceIdSuffix => "Patch";
    protected override IdentifiableId DefaultPlant => IdentifiableId.CARROT_VEGGIE;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.CARROT_PATCH;
#endif
}

[Serializable]
public sealed class FruitData : PlantData
{
#if !UNITY
    public override bool IsFruit => true;
    public override string Type => "Fruit";
    public override string ResourceIdSuffix => "Tree";
    protected override IdentifiableId DefaultPlant => IdentifiableId.POGO_FRUIT;
    protected override SpawnResourceId DefaultResource => SpawnResourceId.POGO_TREE;
#endif
}