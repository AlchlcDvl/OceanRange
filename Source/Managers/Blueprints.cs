// using SRML.SR.Translation;

// namespace OceanRange.Managers;

// public abstract class GadgetData : JsonData
// {
//     public abstract GadgetId BaseGadget { get; }
//     protected abstract string Prefix { get; }

//     public GadgetDefinition.CraftCost[] CraftCosts;

//     [JsonIgnore] public GadgetId Id;

//     protected override void OnDeserialise()
//     {
//         Id = Helpers.AddEnumValue<GadgetId>(Prefix + "_" + Name.ToUpperInvariant());
//     }
// }

// public sealed class GadgetLangData : LangData
// {
//     public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
//     {
//         throw new NotImplementedException();
//     }
// }

// public static class Blueprints
// {
//     private static readonly int Color00 = ShaderUtils.GetOrSet("_Color00");
//     private static readonly int Color01 = ShaderUtils.GetOrSet("_Color01");
//     private static readonly int Color11 = ShaderUtils.GetOrSet("_Color11");
//     private static readonly int Color20 = ShaderUtils.GetOrSet("_Color20");
//     private static readonly int Color21 = ShaderUtils.GetOrSet("_Color21");
//     private static readonly int Color30 = ShaderUtils.GetOrSet("_Color30");
//     private static readonly int Color31 = ShaderUtils.GetOrSet("_Color31");

//     private static void CreateGadget(GadgetData gadgetData)
//     {
//         var gadgetDefinition = gadgetData.BaseGadget.GetGadgetDefinition();
//         var gameObject = gadgetDefinition.prefab.CreatePrefab();
//         gameObject.GetComponent<Gadget>().id = gadgetData.Id;
//         LookupRegistry.RegisterGadget(CopyGadgetDefinition(gadgetDefinition, gadgetData.Id, Inventory.GetSprite($"{gadgetData.Name}_icon"), gameObject, gadgetData.CraftCosts));
//     }

//     private static void CreateTeleporter(GadgetId gadgetId, string name, Sprite sprite, Color color, GadgetDefinition.CraftCost[] craftCosts = null)
//     {
//         var gadgetDefinition = GadgetId.TELEPORTER_PINK.GetGadgetDefinition();
//         var gameObject = gadgetDefinition.prefab.CreatePrefab();
//         gameObject.name = "gadgetTeleport" + name;
//         gameObject.GetComponentInChildren<TeleporterGadget>().linkName = "gadgetTeleport" + name + "_linked";

//         var component = gameObject.transform.Find("model_telepad/mesh_telepad").GetComponent<SkinnedMeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "Telepad_" + name;
//         material.SetColor(Color00, color);
//         material.SetColor(Color01, color);
//         material.SetColor(Color20, color);
//         material.SetColor(Color21, color);
//         component.sharedMaterial = material;

//         LookupRegistry.RegisterGadget(CopyGadgetDefinition(gadgetDefinition, gadgetId, sprite, gameObject, craftCosts));
//         gadgetId.GetTranslation().SetNameTranslation(name + " Teleport").SetDescriptionTranslation("A set of two teleporters that can be used to create your own quick travel link.");
//     }

//     private static GameObject CreateWarpDepot(GadgetId gadgetId, string name, Sprite sprite, Color color, GadgetDefinition.CraftCost[] craftCosts = null)
//     {
//         var gadgetDefinition = GadgetId.WARP_DEPOT_RED.GetGadgetDefinition();
//         var gameObject = gadgetDefinition.prefab.CreatePrefab();
//         gameObject.name = "gadgetWarpDepot" + name;
//         gameObject.GetComponent<Gadget>().id = gadgetId;
//         var component = gameObject.transform.Find("warpdepot").GetComponent<MeshRenderer>();
//         var material = component.sharedMaterial.Clone();
//         material.name = "WarpDepot_" + name;
//         material.SetColor(Color11, color);
//         material.SetColor(Color20, color);
//         material.SetColor(Color21, color);
//         material.SetColor(Color30, color);
//         material.SetColor(Color31, color);
//         component.sharedMaterial = material;
//         var gadgetDefinition2 = CopyGadgetDefinition(gadgetDefinition, gadgetId, sprite, gameObject, craftCosts);
//         LookupRegistry.RegisterGadget(gadgetDefinition2);
//         gadgetId.GetTranslation().SetNameTranslation(name + " Warp Depot").SetDescriptionTranslation("A set of two gadgets that allow you to remotely transfer resources between two points.");
//         return gameObject;
//     }

//     private static void CreateLamp(GadgetId gadgetId, string name, Sprite sprite, IdentifiableId slimeId, GadgetDefinition.CraftCost[] craftCosts = null)
//     {
//         var gadgetDefinition = GadgetId.LAMP_RED.GetGadgetDefinition();
//         var slimeByIdentifiableId = slimeId.GetSlimeDefinition();
//         var defaultMaterials = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].DefaultMaterials;
//         var palette = SlimeAppearance.Palette.FromMaterial(defaultMaterials[0]);
//         var gameObject = gadgetDefinition.prefab.CreatePrefab();

//         gameObject.name = "decorSlimeLamp" + name;
//         gameObject.GetComponent<Gadget>().id = gadgetId;

//         var component = gameObject.transform.Find("slimeslime").GetComponent<SkinnedMeshRenderer>();
//         var component2 = gameObject.transform.Find("glass_inside").GetComponent<MeshRenderer>();
//         var material = component2.sharedMaterial.Clone();
//         material.name = "SlimeLamp_body_" + name;
//         material.SetColor(Slimepedia.TopColor, palette.Top);
//         material.SetColor(Slimepedia.MiddleColor, palette.Middle);
//         material.SetColor(Slimepedia.BottomColor, palette.Bottom);
//         component.sharedMaterial = defaultMaterials[0];
//         component2.sharedMaterial = material;

//         var gadgetDefinition2 = CopyGadgetDefinition(gadgetDefinition, gadgetId, sprite, gameObject, craftCosts);
//         LookupRegistry.RegisterGadget(gadgetDefinition2);
//         gadgetId.GetTranslation().SetNameTranslation(name + " Slime Lamp").SetDescriptionTranslation("A decorative lamp housing a happy slime.");
//     }

//     private static GadgetDefinition CopyGadgetDefinition(GadgetDefinition gadgetDefinition, GadgetId id, Sprite sprite, GameObject prefab, GadgetDefinition.CraftCost[] craftCost)
//     {
//         var gadgetDefinition2 = ScriptableObject.CreateInstance<GadgetDefinition>();
//         gadgetDefinition2.icon = sprite;
//         gadgetDefinition2.id = id;
//         gadgetDefinition2.prefab = prefab;
//         gadgetDefinition2.blueprintCost = gadgetDefinition.blueprintCost;
//         gadgetDefinition2.countLimit = gadgetDefinition.countLimit;
//         gadgetDefinition2.craftCosts = craftCost;
//         gadgetDefinition2.pediaLink = gadgetDefinition.pediaLink;
//         gadgetDefinition2.buyCountLimit = gadgetDefinition.buyCountLimit;
//         gadgetDefinition2.buyInPairs = gadgetDefinition.buyInPairs;
//         gadgetDefinition2.countOtherIds = gadgetDefinition.countOtherIds;
//         gadgetDefinition2.destroyOnRemoval = gadgetDefinition.destroyOnRemoval;
//         return gadgetDefinition2;
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