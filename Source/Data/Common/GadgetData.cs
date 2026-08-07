// namespace OceanRange.Data;

// [Serializable]
// public sealed partial class Schematics : JsonData
// {
//     [JsonRequired] public LampData[] Lamps;
//     [JsonRequired] public WarpDepotData[] WarpDepots;
//     [JsonRequired] public TeleporterData[] Teleporters;
//     [JsonRequired] public DecorationData[] Decorations;
// }

// [Serializable]
// public sealed partial class CraftCost : JsonData
// {
//     public int Amount;
// }

// public abstract partial class GadgetData : JsonData
// {
//     protected override bool SerialiseName => true;

//     public CraftCost[] CraftCosts;
// }

// // Rename later to PrefabGadgetData in case we need to use it for more than deco
// [Serializable]
// public sealed partial class DecorationData : GadgetData
// {
//     [JsonProperty("path")] public string PrefabPath;
//     [JsonProperty("centerName")] public string PrefabCenterPath;
// }

// public abstract partial class VariantGadgetData : GadgetData;

// public abstract partial class SlimeGadgetData : VariantGadgetData;

// [Serializable]
// public sealed partial class LampData : SlimeGadgetData;

// [Serializable]
// public sealed partial class WarpDepotData : SlimeGadgetData;

// [Serializable]
// public sealed partial class TeleporterData : SlimeGadgetData;
