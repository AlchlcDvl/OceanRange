// // ReSharper disable UnassignedField.Global
//
// namespace OceanRange.Managers;
//
// public delegate GadgetDefinition.CraftCost[] CreateCraftCosts(IdentifiableId plortId, IdentifiableId resourceId);
//
// public sealed class Schematics
// {
//     [JsonRequired] public LampData[] Lamps;
//     [JsonRequired] public WarpDepotData[] WarpDepots;
//     [JsonRequired] public TeleporterData[] Teleporters;
// }
//
// public abstract class GadgetData : JsonData
// {
//     protected virtual string Prefix => string.Empty;
//
//     public GadgetDefinition.CraftCost[] CraftCosts;
//
//     [JsonIgnore] public GadgetId Id;
//
//     protected override void OnDeserialise()
//     {
//         Id = Helpers.AddEnumValue<GadgetId>(Prefix + (Prefix.Length > 0 ? "_" : string.Empty) + Name.ToUpperInvariant());
//     }
// }
//
// public abstract class VariantGadgetData : GadgetData
// {
//     public abstract GadgetId BaseGadget { get; }
// }
//
// public abstract class SlimeGadgetData : VariantGadgetData
// {
//     protected abstract CreateCraftCosts CostCreator { get; }
//
//     public abstract string TypePrefix { get; }
//
//     [JsonRequired] public IdentifiableId PlortId;
//     [JsonRequired] public IdentifiableId ResourceId;
//     [JsonRequired] public IdentifiableId SlimeId;
//
//     public Color Color;
//
//     protected override void OnDeserialise()
//     {
//         base.OnDeserialise();
//         CraftCosts ??= CostCreator(PlortId, ResourceId);
//     }
// }
//
// public sealed class LampData : SlimeGadgetData
// {
//     public override GadgetId BaseGadget => GadgetId.LAMP_RED;
//     public override string TypePrefix => "decorSlimeLamp";
//
//     protected override string Prefix => "LAMP";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateLampCraftCosts;
// }
//
// public sealed class WarpDepotData : SlimeGadgetData
// {
//     public override GadgetId BaseGadget => GadgetId.WARP_DEPOT_RED;
//     public override string TypePrefix => "gadgetWarpDepot";
//
//     protected override string Prefix => "WARP_DEPOT";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateWarpDepotCraftCosts;
// }
//
// public sealed class TeleporterData : SlimeGadgetData
// {
//     public override GadgetId BaseGadget => GadgetId.TELEPORTER_PINK;
//     public override string TypePrefix => "gadgetTeleport";
//
//     protected override string Prefix => "TELEPORTER";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateTeleporterCraftCosts;
// }
//
// public abstract class GadgetLangData : LangData
// {
//     protected virtual string Prefix => string.Empty;
//     protected virtual string DescId => string.Empty;
//
//     public override sealed void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
//     {
//         var pedia = translations.GetBundle("pedia");
//         var part = Prefix + (Prefix.Length > 0 ? "_" : string.Empty) + Name.ToLowerInvariant();
//         pedia.AddTranslation("m.gadget.name." + part, TranslatedName, "pedia");
//         pedia.AddComplexTranslation("m.gadget.desc." + part, "@m.gadget.desc." + DescId, "pedia");
//     }
// }
//
// public sealed class LampLangData : GadgetLangData
// {
//     protected override string DescId => "lamp_pink";
//     protected override string Prefix => "lamp";
// }
//
// public sealed class WarpLangData : GadgetLangData
// {
//     protected override string DescId => "warp_depot_pink";
//     protected override string Prefix => "warp_depot";
// }
//
// public sealed class TeleporterLangData : GadgetLangData
// {
//     protected override string DescId => "teleporter_pink";
//     protected override string Prefix => "teleporter";
// }
//
// [Manager(ManagerType.Blueprints)]
// public static class Blueprints
// {
//     private static readonly int Color00 = ShaderUtils.GetOrSet("_Color00");
//     private static readonly int Color01 = ShaderUtils.GetOrSet("_Color01");
//     private static readonly int Color11 = ShaderUtils.GetOrSet("_Color11");
//     private static readonly int Color20 = ShaderUtils.GetOrSet("_Color20");
//     private static readonly int Color21 = ShaderUtils.GetOrSet("_Color21");
//     private static readonly int Color30 = ShaderUtils.GetOrSet("_Color30");
//     private static readonly int Color31 = ShaderUtils.GetOrSet("_Color31");
//
// #if DEBUG
//     [TimeDiagnostic("Blueprints Preload")]
// #endif
//     [PreloadMethod]
//     public static void PreloadBlueprintData()
//     {
//         var schematics = Inventory.GetJson<Schematics>("blueprints");
//     }
//
//     private static void CreateGadget(SlimeGadgetData gadgetData)
//     {
//         var gadgetDefinition = gadgetData.BaseGadget.GetGadgetDefinition();
//
//         var prefab = gadgetDefinition.prefab.CreatePrefab();
//         prefab.name = gadgetData.TypePrefix + gadgetData.Name;
//         prefab.GetComponent<Gadget>().id = gadgetData.Id;
//
//         if (gadgetData is LampData lampData)
//             CreateLamp(lampData, prefab);
//         else if (gadgetData is WarpDepotData warpDepotData)
//             CreateWarpDepot(warpDepotData, prefab);
//         else if (gadgetData is TeleporterData teleporterData)
//             CreateTeleporter(teleporterData, prefab);
//
//         LookupRegistry.RegisterGadget(CopyGadgetDefinition(gadgetDefinition, gadgetData.Id, Inventory.GetSprite($"{gadgetData.Name}_icon"), prefab, gadgetData.CraftCosts));
//     }
//
//     private static void CreateTeleporter(TeleporterData teleporterData, GameObject prefab)
//     {
//         prefab.GetComponentInChildren<TeleporterGadget>().linkName = "gadgetTeleport" + teleporterData.Name + "_linked";
//
//         var component = prefab.transform.Find("model_telepad/mesh_telepad").GetComponent<SkinnedMeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "Telepad_" + teleporterData.Name;
//         material.SetColors(teleporterData.Color, Color00, Color01, Color20, Color21);
//         component.sharedMaterial = material;
//     }
//
//     private static void CreateWarpDepot(WarpDepotData warpDepotData, GameObject prefab)
//     {
//         var component = prefab.transform.Find("warpdepot").GetComponent<MeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "WarpDepot_" + warpDepotData.Name;
//         material.SetColors(warpDepotData.Color, Color11, Color20, Color21, Color30, Color31);
//         component.sharedMaterial = material;
//     }
//
//     private static void CreateLamp(LampData lampData, GameObject prefab)
//     {
//         var slimeByIdentifiableId = lampData.SlimeId.GetSlimeDefinition();
//         var defaultMaterials = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].DefaultMaterials;
//         var palette = SlimeAppearance.Palette.FromMaterial(defaultMaterials[0]);
//
//         var component = prefab.transform.Find("slimeslime").GetComponent<SkinnedMeshRenderer>();
//         var component2 = prefab.transform.Find("glass_inside").GetComponent<MeshRenderer>();
//         var material = component2.sharedMaterial.Clone();
//         material.name = "SlimeLamp_body_" + lampData.Name;
//         material.SetColors((Slimepedia.TopColor, palette.Top), (Slimepedia.MiddleColor, palette.Middle), (Slimepedia.BottomColor, palette.Bottom));
//         component.sharedMaterial = defaultMaterials[0];
//         component2.sharedMaterial = material;
//     }
//
//     private static GadgetDefinition CopyGadgetDefinition(GadgetDefinition gadgetDefinition, GadgetId id, Sprite sprite, GameObject prefab, GadgetDefinition.CraftCost[] craftCost)
//     {
//         var definition = ScriptableObject.CreateInstance<GadgetDefinition>();
//         definition.id = id;
//         definition.icon = sprite;
//         definition.prefab = prefab;
//         definition.craftCosts = craftCost;
//         definition.pediaLink = gadgetDefinition.pediaLink;
//         definition.countLimit = gadgetDefinition.countLimit;
//         definition.buyInPairs = gadgetDefinition.buyInPairs;
//         definition.countOtherIds = gadgetDefinition.countOtherIds;
//         definition.blueprintCost = gadgetDefinition.blueprintCost;
//         definition.buyCountLimit = gadgetDefinition.buyCountLimit;
//         definition.destroyOnRemoval = gadgetDefinition.destroyOnRemoval;
//         return definition;
//     }
//
//     public static GadgetDefinition.CraftCost[] CreateWarpDepotCraftCosts(IdentifiableId plortId, IdentifiableId resourceId) =>
//     [
//         new()
//         {
//             id = plortId,
//             amount = 1
//         },
//         new()
//         {
//             id = resourceId,
//             amount = 6
//         },
//         new()
//         {
//             id = IdentifiableId.SLIME_FOSSIL_CRAFT,
//             amount = 3
//         },
//         new()
//         {
//             id = IdentifiableId.LAVA_DUST_CRAFT,
//             amount = 1
//         }
//     ];
//
//     public static GadgetDefinition.CraftCost[] CreateLampCraftCosts(IdentifiableId plortId, IdentifiableId resourceId) =>
//     [
//         new()
//         {
//             id = IdentifiableId.PHOSPHOR_PLORT,
//             amount = 12
//         },
//         new()
//         {
//             id = plortId,
//             amount = 12
//         },
//         new()
//         {
//             id = resourceId,
//             amount = 8
//         },
//         new()
//         {
//             id = IdentifiableId.SPIRAL_STEAM_CRAFT,
//             amount = 8
//         }
//     ];
//
//     public static GadgetDefinition.CraftCost[] CreateTeleporterCraftCosts(IdentifiableId plortId, IdentifiableId resourceId) =>
//     [
//         new()
//         {
//             id = plortId,
//             amount = 25
//         },
//         new()
//         {
//             id = resourceId,
//             amount = 10
//         },
//         new()
//         {
//             id = IdentifiableId.SPIRAL_STEAM_CRAFT,
//             amount = 5
//         },
//         new()
//         {
//             id = IdentifiableId.STRANGE_DIAMOND_CRAFT,
//             amount = 1
//         }
//     ];
// }