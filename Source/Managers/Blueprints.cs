// // ReSharper disable UnassignedField.Global

// namespace OceanRange.Managers;

// public delegate GadgetDefinition.CraftCost[] CreateCraftCosts(IdentifiableId plortId, IdentifiableId resourceId);

// public sealed class Schematics : JsonData
// {
//     [JsonRequired] public LampData[] Lamps;
//     [JsonRequired] public WarpDepotData[] WarpDepots;
//     [JsonRequired] public TeleporterData[] Teleporters;

// #if UNITY
//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         Array.ForEach(Lamps, x => x.FindStrings(pooler));
//         Array.ForEach(WarpDepots, x => x.FindStrings(pooler));
//         Array.ForEach(Teleporters, x => x.FindStrings(pooler));
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteArray(Lamps, (w, x) => x.WriteTo(w));
//         writer.WriteArray(WarpDepots, (w, x) => x.WriteTo(w));
//         writer.WriteArray(Teleporters, (w, x) => x.WriteTo(w));
//     }
// #else
//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         Lamps = reader.ReadArray(r => { var x = new LampData(); x.ReadFrom(r); return x; });
//         WarpDepots = reader.ReadArray(r => { var x = new WarpDepotData(); x.ReadFrom(r); return x; });
//         Teleporters = reader.ReadArray(r => { var x = new TeleporterData(); x.ReadFrom(r); return x; });
//     }

//     public override void OnDeserialise()
//     {
//         base.OnDeserialise();
//         Array.ForEach(Lamps, x => x.OnDeserialise());
//         Array.ForEach(WarpDepots, x => x.OnDeserialise());
//         Array.ForEach(Teleporters, x => x.OnDeserialise());
//     }
// #endif
// }

// public abstract class GadgetData : JsonData
// {
//     public GadgetDefinition.CraftCost[] CraftCosts;

// #if !UNITY
//     protected virtual string Prefix => string.Empty;

//     [JsonIgnore] public GadgetId Id;

//     public override void OnDeserialise()
//     {
//         base.OnDeserialise();
//         Id = Helpers.AddEnumValue<GadgetId>(Prefix + (Prefix.Length > 0 ? "_" : string.Empty) + Name.ToUpperInvariant());
//     }
// #endif
// }

// public abstract class VariantGadgetData : GadgetData
// {
// #if !UNITY
//     public abstract GadgetId BaseGadget { get; }
// #endif
// }

// public abstract class SlimeGadgetData : VariantGadgetData
// {
// #if UNITY
//     [JsonRequired] public string PlortId;
//     [JsonRequired] public string ResourceId;
//     [JsonRequired] public string SlimeId;

//     public string ColorHex;

//     public override void FindStrings(StringPooler pooler)
//     {
//         base.FindStrings(pooler);
//         pooler.PoolString(PlortId);
//         pooler.PoolString(ResourceId);
//         pooler.PoolString(SlimeId);
//         pooler.PoolSubstring(ColorHex, 1);
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteString(PlortId);
//         writer.WriteString(ResourceId);
//         writer.WriteString(SlimeId);
//         writer.WriteSubstring(ColorHex, 1);
//     }
// #else
//     protected abstract CreateCraftCosts CostCreator { get; }

//     public abstract string TypePrefix { get; }

//     [JsonRequired] public IdentifiableId PlortId;
//     [JsonRequired] public IdentifiableId ResourceId;
//     [JsonRequired] public IdentifiableId SlimeId;

//     public Color Color;

//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         PlortId = reader.ReadEnum<IdentifiableId>();
//         ResourceId = reader.ReadEnum<IdentifiableId>();
//         SlimeId = reader.ReadEnum<IdentifiableId>();

//         var hex = reader.ReadString();
//         if (!string.IsNullOrEmpty(hex))
//             Color = ("#" + hex).HexToColor();
//     }

//     public override void OnDeserialise()
//     {
//         base.OnDeserialise();
//         CraftCosts ??= CostCreator(PlortId, ResourceId);
//     }
// #endif
// }

// public sealed class LampData : SlimeGadgetData
// {
// #if !UNITY
//     public override GadgetId BaseGadget => GadgetId.LAMP_RED;
//     public override string TypePrefix => "decorSlimeLamp";

//     protected override string Prefix => "LAMP";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateLampCraftCosts;
// #endif
// }

// public sealed class WarpDepotData : SlimeGadgetData
// {
// #if !UNITY
//     public override GadgetId BaseGadget => GadgetId.WARP_DEPOT_RED;
//     public override string TypePrefix => "gadgetWarpDepot";

//     protected override string Prefix => "WARP_DEPOT";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateWarpDepotCraftCosts;
// #endif
// }

// public sealed class TeleporterData : SlimeGadgetData
// {
// #if !UNITY
//     public override GadgetId BaseGadget => GadgetId.TELEPORTER_PINK;
//     public override string TypePrefix => "gadgetTeleport";

//     protected override string Prefix => "TELEPORTER";
//     protected override CreateCraftCosts CostCreator => Blueprints.CreateTeleporterCraftCosts;
// #endif
// }

// public abstract class GadgetLangData : LangData
// {
// #if !UNITY
//     protected virtual string Prefix => string.Empty;
//     protected virtual string DescId => string.Empty;

//     public override sealed void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
//     {
//         var pedia = translations.GetBundle("pedia");
//         var part = Prefix + (Prefix.Length > 0 ? "_" : string.Empty) + Name.ToLowerInvariant();
//         pedia.AddTranslation("m.gadget.name." + part, TranslatedName, "pedia");
//         pedia.AddTranslation("m.gadget.desc." + part, "@m.gadget.desc." + DescId, "pedia");
//     }
// #endif
// }

// public sealed class LampLangData : GadgetLangData
// {
// #if !UNITY
//     protected override string DescId => "lamp_pink";
//     protected override string Prefix => "lamp";
// #endif
// }

// public sealed class WarpLangData : GadgetLangData
// {
// #if !UNITY
//     protected override string DescId => "warp_depot_pink";
//     protected override string Prefix => "warp_depot";
// #endif
// }

// public sealed class TeleporterLangData : GadgetLangData
// {
// #if !UNITY
//     protected override string DescId => "teleporter_pink";
//     protected override string Prefix => "teleporter";
// #endif
// }

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

// #if DEBUG
//     [TimeDiagnostic("Blueprints Preload")]
// #endif
//     [PreloadMethod]
//     public static void PreloadBlueprintData()
//     {
//         var schematics = Inventory.GetJson<Schematics>("blueprints");
//     }

//     private static void CreateGadget(SlimeGadgetData gadgetData)
//     {
//         var gadgetDefinition = gadgetData.BaseGadget.GetGadgetDefinition();

//         var prefab = gadgetDefinition.prefab.CreatePrefab();
//         prefab.name = gadgetData.TypePrefix + gadgetData.Name;
//         prefab.GetComponent<Gadget>().id = gadgetData.Id;

//         if (gadgetData is LampData lampData)
//             CreateLamp(lampData, prefab);
//         else if (gadgetData is WarpDepotData warpDepotData)
//             CreateWarpDepot(warpDepotData, prefab);
//         else if (gadgetData is TeleporterData teleporterData)
//             CreateTeleporter(teleporterData, prefab);

//         LookupRegistry.RegisterGadget(CopyGadgetDefinition(gadgetDefinition, gadgetData.Id, Inventory.GetSprite($"{gadgetData.Name}_icon"), prefab, gadgetData.CraftCosts));
//     }

//     private static void CreateTeleporter(TeleporterData teleporterData, GameObject prefab)
//     {
//         prefab.GetComponentInChildren<TeleporterGadget>().linkName = "gadgetTeleport" + teleporterData.Name + "_linked";

//         var component = prefab.transform.Find("model_telepad/mesh_telepad").GetComponent<SkinnedMeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "Telepad_" + teleporterData.Name;
//         material.SetColors(teleporterData.Color, Color00, Color01, Color20, Color21);
//         component.sharedMaterial = material;
//     }

//     private static void CreateWarpDepot(WarpDepotData warpDepotData, GameObject prefab)
//     {
//         var component = prefab.transform.Find("warpdepot").GetComponent<MeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "WarpDepot_" + warpDepotData.Name;
//         material.SetColors(warpDepotData.Color, Color11, Color20, Color21, Color30, Color31);
//         component.sharedMaterial = material;
//     }

//     private static void CreateLamp(LampData lampData, GameObject prefab)
//     {
//         var slimeByIdentifiableId = lampData.SlimeId.GetSlimeDefinition();
//         var defaultMaterials = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].DefaultMaterials;
//         var palette = SlimeAppearance.Palette.FromMaterial(defaultMaterials[0]);

//         var component = prefab.transform.Find("slimeslime").GetComponent<SkinnedMeshRenderer>();
//         var component2 = prefab.transform.Find("glass_inside").GetComponent<MeshRenderer>();
//         var material = component2.sharedMaterial.Clone();
//         material.name = "SlimeLamp_body_" + lampData.Name;
//         material.SetColors((Slimepedia.TopColor, palette.Top), (Slimepedia.MiddleColor, palette.Middle), (Slimepedia.BottomColor, palette.Bottom));
//         component.sharedMaterial = defaultMaterials[0];
//         component2.sharedMaterial = material;
//     }

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