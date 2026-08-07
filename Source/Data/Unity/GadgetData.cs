// #if UNITY
// namespace OceanRange.Data;

// public sealed partial class Schematics
// {
//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         Array.ForEach(Lamps, x => x.FindStrings(pooler));
//         Array.ForEach(WarpDepots, x => x.FindStrings(pooler));
//         Array.ForEach(Teleporters, x => x.FindStrings(pooler));
//         Array.ForEach(Decorations, x => x.FindStrings(pooler));
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteArray(Lamps, (w, x) => x.WriteTo(w));
//         writer.WriteArray(WarpDepots, (w, x) => x.WriteTo(w));
//         writer.WriteArray(Teleporters, (w, x) => x.WriteTo(w));
//         writer.WriteArray(Decorations, (w, x) => x.WriteTo(w));
//     }
// }

// public sealed partial class CraftCost
// {
//     public string Id;

//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         pooler.PoolString(Id);
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteString(Id);
//         writer.WritePackedUInt((uint)Amount);
//     }
// }

// public abstract partial class GadgetData
// {
//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         Array.ForEach(CraftCosts, x => x.FindStrings(pooler));
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteArray(CraftCosts, (w, x) => x.WriteTo(w));
//     }
// }

// public sealed partial class DecorationData
// {
//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         pooler.PoolString(PrefabPath);
//         pooler.PoolString(PrefabCenterPath);
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteString(PrefabPath);
//         writer.WriteString(PrefabCenterPath);
//     }
// }

// public abstract partial class SlimeGadgetData
// {
//     [JsonRequired] public string PlortId;
//     [JsonRequired] public string ResourceId;
//     [JsonRequired] public string SlimeId;

//     public Optional<Color32> Color;

//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         pooler.PoolString(PlortId);
//         pooler.PoolString(ResourceId);
//         pooler.PoolString(SlimeId);
//         pooler.PoolString(Color.ToHex());
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteString(PlortId);
//         writer.WriteString(ResourceId);
//         writer.WriteString(SlimeId);
//         writer.WriteString(Color.ToHex());
//     }
// }
// #endif
