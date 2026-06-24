#if UNITY
namespace OceanRange.Data;

public sealed partial class Ingredients
{
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
}

public sealed partial class GroupData
{
    [JsonRequired] public string[] Foods;

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
}

public sealed partial class ChimkenData
{
    [JsonRequired] public string[] Zones;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Zones);
        pooler.PoolString(MainAmmoColor.ToHex());
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WritePackedFloat(SpawnAmount);
        writer.WritePackedFloat(ChickSpawnAmount);
        writer.WriteStringArray(Zones);
        writer.WriteString(MainAmmoColor.ToHex());
    }
}

public abstract partial class PlantData
{
    public Optional<string> BasePlant;
    public Optional<string> BaseResource;

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
}
#endif
