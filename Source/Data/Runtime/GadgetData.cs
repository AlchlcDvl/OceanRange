#if !UNITY
namespace OceanRange.Data;

public sealed partial class Schematics
{
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
}

public sealed partial class CraftCost
{
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
}

public abstract partial class GadgetData
{
    protected virtual string Prefix => string.Empty;

    [JsonIgnore] public GadgetId Id;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        CraftCosts = reader.ReadArray(r => { var x = new CraftCost(); x.ReadFrom(r); return x; })!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();
        Array.ForEach(CraftCosts, x => x.OnDeserialise());
        Id = Helpers.AddEnumValue<GadgetId>(Prefix + (string.IsNullOrEmpty(Prefix) ? string.Empty : "_") + Name!.ToUpperInvariant());
    }
}

public sealed partial class DecorationData
{
    protected override string Prefix => "DECO";

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        PrefabPath = reader.ReadString()!;
        PrefabCenterPath = reader.ReadString()!;
    }
}

public abstract partial class VariantGadgetData
{
    public abstract GadgetId BaseGadget { get; }
}

public abstract partial class SlimeGadgetData
{
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
}

public sealed partial class LampData
{
    public override GadgetId BaseGadget => GadgetId.LAMP_RED;
    public override string TypePrefix => "decorSlimeLamp";

    protected override string Prefix => "LAMP";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateLampCraftCosts;
}

public sealed partial class WarpDepotData
{
    public override GadgetId BaseGadget => GadgetId.WARP_DEPOT_RED;
    public override string TypePrefix => "gadgetWarpDepot";

    protected override string Prefix => "WARP_DEPOT";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateWarpDepotCraftCosts;
}

public sealed partial class TeleporterData
{
    public override GadgetId BaseGadget => GadgetId.TELEPORTER_PINK;
    public override string TypePrefix => "gadgetTeleport";

    protected override string Prefix => "TELEPORTER";
    protected override CreateCraftCosts CostCreator => Blueprints.CreateTeleporterCraftCosts;
}
#endif
