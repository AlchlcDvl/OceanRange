// namespace OceanRange.Managers;

// public static class Blueprints
// {
//     private static readonly int Color00 = ShaderUtils.GetOrSet("_Color00");
//     private static readonly int Color01 = ShaderUtils.GetOrSet("_Color01");
//     private static readonly int Color11 = ShaderUtils.GetOrSet("_Color11");
//     private static readonly int Color20 = ShaderUtils.GetOrSet("_Color20");
//     private static readonly int Color21 = ShaderUtils.GetOrSet("_Color21");
//     private static readonly int Color30 = ShaderUtils.GetOrSet("_Color30");

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