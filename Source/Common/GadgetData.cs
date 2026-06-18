namespace OceanRange.Data;

[Serializable]
public sealed class Schematics : JsonData
{
    [JsonRequired] public LampData[] Lamps;
    [JsonRequired] public WarpDepotData[] WarpDepots;
    [JsonRequired] public TeleporterData[] Teleporters;
    [JsonRequired] public DecorationData[] Decorations;

#if UNITY
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        Array.ForEach(Lamps, x => x.FindStrings(pooler));
        Array.ForEach(WarpDepots, x => x.FindStrings(pooler));
        Array.ForEach(Teleporters, x => x.FindStrings(pooler));
        Array.ForEach(Decorations, x => x.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteArray(Lamps, (w, x) => x.WriteTo(w));
        writer.WriteArray(WarpDepots, (w, x) => x.WriteTo(w));
        writer.WriteArray(Teleporters, (w, x) => x.WriteTo(w));
        writer.WriteArray(Decorations, (w, x) => x.WriteTo(w));
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Lamps = reader.ReadArray(r => { var x = new LampData(); x.ReadFrom(r); return x; })!;
        WarpDepots = reader.ReadArray(r => { var x = new WarpDepotData(); x.ReadFrom(r); return x; })!;
        Teleporters = reader.ReadArray(r => { var x = new TeleporterData(); x.ReadFrom(r); return x; })!;
        Decorations = reader.ReadArray(r => { var x = new DecorationData(); x.ReadFrom(r); return x; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(Lamps, x => x.OnDeserialise());
        Array.ForEach(WarpDepots, x => x.OnDeserialise());
        Array.ForEach(Teleporters, x => x.OnDeserialise());
        Array.ForEach(Decorations, x => x.OnDeserialise());
    }
#endif
}

[Serializable]
public sealed class CraftCost : JsonData
{
    public int Amount;

#if !UNITY
    public IdentifiableId Id;

    public static implicit operator GadgetDefinition.CraftCost(CraftCost self)
        => new() { amount = self.Amount, id = self.Id };

    public static implicit operator CraftCost(GadgetDefinition.CraftCost self)
        => new() { Amount = self.amount, Id = self.id };

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Id = reader.ReadEnum<IdentifiableId>();
        Amount = (int)reader.ReadPackedUInt();
    }
#else
    public string Id;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Id);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Id);
        writer.WritePackedUInt((uint)Amount);
    }
#endif
}

public abstract class GadgetData : JsonData
{
    protected override bool SerialiseName => true;

    public CraftCost[] CraftCosts;

#if !UNITY
    protected virtual string Prefix => string.Empty;

    [JsonIgnore] public GadgetId Id;

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Id = Helpers.AddEnumValue<GadgetId>(Prefix + (string.IsNullOrEmpty(Prefix) ? string.Empty : "_") + Name!.ToUpperInvariant());
    }
#endif
}

// Rename later to PrefabGadgetData in case we need to use it for more than deco
[Serializable]
public sealed class DecorationData : GadgetData
{
    [JsonProperty("path")] public string PrefabPath;
    [JsonProperty("centerName")] public string PrefabCenterPath;

#if !UNITY
    // Remove this if we do rename it
    protected override string Prefix => "DECO";

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        PrefabPath = reader.ReadString()!;
        PrefabCenterPath = reader.ReadString()!;
    }
#else
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(PrefabPath);
        pooler.PoolString(PrefabCenterPath);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(PrefabPath);
        writer.WriteString(PrefabCenterPath);
    }
#endif
}

public abstract class VariantGadgetData : GadgetData
{
#if !UNITY
    public abstract GadgetId BaseGadget { get; }
#endif
}

public abstract class SlimeGadgetData : VariantGadgetData
{
#if UNITY
    [JsonRequired] public string PlortId;
    [JsonRequired] public string ResourceId;
    [JsonRequired] public string SlimeId;

    public Optional<Color32> Color;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(PlortId);
        pooler.PoolString(ResourceId);
        pooler.PoolString(SlimeId);
        pooler.PoolString(Color.ToHex());
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(PlortId);
        writer.WriteString(ResourceId);
        writer.WriteString(SlimeId);
        writer.WriteString(Color.ToHex());
    }
#else
    protected abstract CreateCraftCosts CostCreator { get; }

    public abstract string TypePrefix { get; }

    [JsonRequired] public IdentifiableId PlortId;
    [JsonRequired] public IdentifiableId ResourceId;
    [JsonRequired] public IdentifiableId SlimeId;

    public Color? Color;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        PlortId = reader.ReadEnum<IdentifiableId>();
        ResourceId = reader.ReadEnum<IdentifiableId>();
        SlimeId = reader.ReadEnum<IdentifiableId>();

        var hex = reader.ReadString();

        if (!string.IsNullOrEmpty(hex))
            Color = ("#" + hex).HexToColor();
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        CraftCosts ??= [.. CostCreator(PlortId, ResourceId)];
    }
#endif
}

[Serializable]
public sealed class LampData : SlimeGadgetData
{
#if !UNITY
    public override GadgetId BaseGadget => GadgetId.LAMP_RED;
    public override string TypePrefix => "decorSlimeLamp";

    protected override string Prefix => "LAMP";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateLampCraftCosts;
#endif
}

[Serializable]
public sealed class WarpDepotData : SlimeGadgetData
{
#if !UNITY
    public override GadgetId BaseGadget => GadgetId.WARP_DEPOT_RED;
    public override string TypePrefix => "gadgetWarpDepot";

    protected override string Prefix => "WARP_DEPOT";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateWarpDepotCraftCosts;
#endif
}

[Serializable]
public sealed class TeleporterData : SlimeGadgetData
{
#if !UNITY
    public override GadgetId BaseGadget => GadgetId.TELEPORTER_PINK;
    public override string TypePrefix => "gadgetTeleport";

    protected override string Prefix => "TELEPORTER";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateTeleporterCraftCosts;
#endif
}