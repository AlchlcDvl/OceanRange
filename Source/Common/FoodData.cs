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

#if !UNITY
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Groups = new GroupData[reader.ReadPackedUInt()];

        for (var i = 0; i < Groups.Length; i++)
        {
            Groups[i] = new GroupData();
            Groups[i].ReadFrom(reader);
        }

        Fruits = new FruitData[reader.ReadPackedUInt()];

        for (var i = 0; i < Fruits.Length; i++)
        {
            Fruits[i] = new FruitData();
            Fruits[i].ReadFrom(reader);
        }

        Veggies = new VeggieData[reader.ReadPackedUInt()];

        for (var i = 0; i < Veggies.Length; i++)
        {
            Veggies[i] = new VeggieData();
            Veggies[i].ReadFrom(reader);
        }

        Chimkens = new ChimkenData[reader.ReadPackedUInt()];

        for (var i = 0; i < Chimkens.Length; i++)
        {
            Chimkens[i] = new ChimkenData();
            Chimkens[i].ReadFrom(reader);
        }
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        foreach (var group in Groups)
            group.OnDeserialise();

        foreach (var fruit in Fruits)
            fruit.OnDeserialise();

        foreach (var veggie in Veggies)
            veggie.OnDeserialise();

        foreach (var chimken in Chimkens)
            chimken.OnDeserialise();
    }
#else
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

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WritePackedUInt((uint)Groups.Length);

        foreach (var g in Groups)
            g.WriteTo(writer);

        writer.WritePackedUInt((uint)Fruits.Length);

        foreach (var f in Fruits)
            f.WriteTo(writer);

        writer.WritePackedUInt((uint)Veggies.Length);

        foreach (var v in Veggies)
            v.WriteTo(writer);

        writer.WritePackedUInt((uint)Chimkens.Length);

        foreach (var c in Chimkens)
            c.WriteTo(writer);
    }
#endif
}

public sealed class GroupData : JsonData
{
#if !UNITY
    public IdentifiableId[] Foods;

    public FoodGroup Group;
#else
    [JsonRequired] public string[] Foods;
#endif

#if !UNITY
    public override void OnDeserialise() => Group = Helpers.ParseOrAddEnumValue<FoodGroup>(Name.ToUpperInvariant());

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        var count = reader.ReadPackedUInt();
        Foods = new IdentifiableId[count];

        for (var i = 0; i < count; i++)
            Foods[i] = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
    }
#else
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Foods);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedUInt((uint)Foods.Length);
        foreach (var food in Foods)
            writer.WriteString(food);
    }
#endif
}

public abstract class FoodData : SpawnedActorData
{
#if !UNITY
    protected static readonly Dictionary<string, Action<GameObject>> Methods = [];

    static FoodData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Cookbook)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = Helpers.CompileAction<GameObject>(method);
        }
    }

    public Action<GameObject> InitFoodDetails;

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Methods.TryGetValue("Init" + Name + "FoodDetails", out InitFoodDetails);
    }
#endif
}

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
    public Action<GameObject> InitHenDetails;
    public Action<GameObject> InitChickDetails;

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

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
        var count = reader.ReadPackedUInt();
        Zones = new Zone[count];

        for (var i = 0; i < count; i++)
            Zones[i] = Helpers.ParseEnum<Zone>(reader.ReadString());
    }
#else
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Zones);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedFloat(SpawnAmount);
        writer.WritePackedFloat(ChickSpawnAmount);
        writer.WritePackedUInt((uint)Zones.Length);

        foreach (var zone in Zones)
            writer.WriteString(zone);
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
    public string BasePlant;
    public string BaseResource;
#endif

    // public bool HasOriginalSpawners = true; // TODO: Implement this in the future

    // ReSharper disable once CollectionNeverUpdated.Global
    public Dictionary<string, Orientation[]> SpawnLocations;

    public bool AdjustColliders = true;

#if !UNITY
    public SpawnResourceId BaseResourceDlx;

    public SpawnResourceId ResourceId;
    public SpawnResourceId DlxResourceId;

    public override void OnDeserialise()
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

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        if (reader.ReadBool())
            BasePlant = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());

        if (reader.ReadBool())
            BaseResource = Helpers.ParseEnum<SpawnResourceId>(reader.ReadString());

        AdjustColliders = reader.ReadBool();

        var dictCount = reader.ReadPackedUInt();
        SpawnLocations = new Dictionary<string, Orientation[]>((int)dictCount);

        for (var i = 0; i < dictCount; i++)
        {
            var key = reader.ReadString();
            var arrLength = reader.ReadPackedUInt();
            var orientations = new Orientation[arrLength];

            for (var j = 0; j < arrLength; j++)
                orientations[j] = reader.ReadOrientation();

            SpawnLocations[key] = orientations;
        }
    }
#else
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        writer.PoolString(BasePlant?.ToString());
        writer.PoolString(BaseResource?.ToString());

        if (SpawnLocations != null)
            writer.PoolStrings(SpawnLocations.Keys);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(BasePlant);
        writer.WriteString(BaseResource);

        writer.WriteBool(AdjustColliders);

        if (SpawnLocations.IsNullOrEmpty())
        {
            writer.WritePackedUInt(0);
        }
        else
        {
            writer.WritePackedUInt((uint)SpawnLocations.Count);

            foreach (var kvp in SpawnLocations)
            {
                writer.WriteString(kvp.Key);
                writer.WritePackedUInt((uint)kvp.Value.Length);

                foreach (var orientation in kvp.Value)
                    writer.WriteString(orientation.ToString());
            }
        }
    }
#endif
}

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