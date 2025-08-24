using AssetsLib;
using SRML.SR.Utils;

namespace OceanRange.Managers;

public static class LargoManager
{
    /*
    Largo Naming Hierarchy:

    PLORT:
    Pink
    Coco
    Saber
    Quantum
    Honey
    Phosphor
    Mosaic
    Tangle
    Boom
    Rad
    Rock
    Tabby
    Hunter
    Crystal
    Dervish
    Mesmer
    Hermit

    PEARL:
    Rosi
    Mine
    Lantern
    */

    public static readonly Dictionary<IdentifiableId, List<(IdentifiableId, IdentifiableId)>> LargoMaps = [];

    public static void AddLargoEatMap(Identifiable.Id largoId, Identifiable.Id slimeId1, Identifiable.Id slimeId2)
    {
        if (!LargoMaps.TryGetValue(slimeId1, out var slime1Values))
            slime1Values = LargoMaps[slimeId1] = [];

        if (!LargoMaps.TryGetValue(slimeId2, out var slime2Values))
            slime2Values = LargoMaps[slimeId2] = [];

        slime1Values.Add((largoId, slimeId2));
        slime2Values.Add((largoId, slimeId1));
    }
    public static void LoadAllLargos()
    {
        //COCO LARGOS
        SlimeRegistry.CraftLargo(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_SABER_LARGO, IdentifiableId.SABER_SLIME, Ids.COCO_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_SABER_LARGO, IdentifiableId.SABER_SLIME, Ids.COCO_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME);
        SlimeRegistry.CraftLargo(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME);
        //SlimeRegistry.CraftLargo(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        //AddLargoEatMap(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME);

        //MESMER LARGOS
        SlimeRegistry.CraftLargo(Ids.PINK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PINK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PINK_SLIME);
        SlimeRegistry.CraftLargo(Ids.SABER_MESMER_LARGO, IdentifiableId.SABER_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.SABER_MESMER_LARGO, IdentifiableId.SABER_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.QUANTUM_MESMER_LARGO, IdentifiableId.QUANTUM_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.REPLACE_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.QUANTUM_MESMER_LARGO, IdentifiableId.QUANTUM_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.HONEY_MESMER_LARGO, IdentifiableId.HONEY_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.REPLACE_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HONEY_MESMER_LARGO, IdentifiableId.HONEY_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.PHOSPHOR_MESMER_LARGO, IdentifiableId.PHOSPHOR_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PHOSPHOR_MESMER_LARGO, IdentifiableId.PHOSPHOR_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.MOSAIC_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.MOSAIC_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.MOSAIC_SLIME);
        SlimeRegistry.CraftLargo(Ids.TANGLE_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TANGLE_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TANGLE_SLIME);
        SlimeRegistry.CraftLargo(Ids.BOOM_MESMER_LARGO, IdentifiableId.BOOM_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.REPLACE_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.BOOM_MESMER_LARGO, IdentifiableId.BOOM_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.RAD_MESMER_LARGO, IdentifiableId.RAD_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.REPLACE_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.RAD_MESMER_LARGO, IdentifiableId.RAD_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.ROCK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROCK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.ROCK_SLIME);
        SlimeRegistry.CraftLargo(Ids.TABBY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TABBY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TABBY_SLIME);
        SlimeRegistry.CraftLargo(Ids.HUNTER_MESMER_LARGO, IdentifiableId.HUNTER_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.SWAP_MOUTH | SlimeRegistry.LargoProps.SWAP_EYES | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HUNTER_MESMER_LARGO, IdentifiableId.HUNTER_SLIME, Ids.MESMER_SLIME);
        SlimeRegistry.CraftLargo(Ids.CRYSTAL_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.CRYSTAL_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.CRYSTAL_SLIME);
        SlimeRegistry.CraftLargo(Ids.DERVISH_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.DERVISH_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.DERVISH_SLIME);
        // SlimeRegistry.CraftLargo(Ids.MESMER_HERMIT_LARGO, Ids.MESMER_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.MESMER_HERMIT_LARGO, Ids.MESMER_SLIME, Ids.HERMIT_SLIME);

        //HERMIT LARGOS
        /*SlimeRegistry.CraftLargo(Ids.PINK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PINK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PINK_SLIME);
        SlimeRegistry.CraftLargo(Ids.SABER_HERMIT_LARGO, IdentifiableId.SABER_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.SABER_HERMIT_LARGO, IdentifiableId.SABER_SLIME, Ids.HERMIT_SLIME);
        SlimeRegistry.CraftLargo(Ids.QUANTUM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.QUANTUM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.QUANTUM_SLIME);
        SlimeRegistry.CraftLargo(Ids.HONEY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HONEY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HONEY_SLIME);
        SlimeRegistry.CraftLargo(Ids.PHOSPHOR_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PHOSPHOR_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PHOSPHOR_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PHOSPHOR_SLIME);
        SlimeRegistry.CraftLargo(Ids.MOSAIC_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.MOSAIC_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.MOSAIC_SLIME);
        SlimeRegistry.CraftLargo(Ids.TANGLE_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TANGLE_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TANGLE_SLIME);
        SlimeRegistry.CraftLargo(Ids.BOOM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.BOOM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.BOOM_SLIME);
        SlimeRegistry.CraftLargo(Ids.RAD_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.RAD_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.RAD_SLIME);
        SlimeRegistry.CraftLargo(Ids.ROCK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROCK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.ROCK_SLIME);
        SlimeRegistry.CraftLargo(Ids.TABBY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TABBY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TABBY_SLIME);
        SlimeRegistry.CraftLargo(Ids.HUNTER_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HUNTER_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HUNTER_SLIME);
        SlimeRegistry.CraftLargo(Ids.CRYSTAL_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.CRYSTAL_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.CRYSTAL_SLIME);
        SlimeRegistry.CraftLargo(Ids.DERVISH_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.DERVISH_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.DERVISH_SLIME);*/

        //ROSI LARGOS
        SlimeRegistry.CraftLargo(Ids.ROSI_MINE_LARGO, Ids.ROSI_SLIME, Ids.MINE_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROSI_MINE_LARGO, Ids.ROSI_SLIME, Ids.MINE_SLIME);
        SlimeRegistry.CraftLargo(Ids.ROSI_LANTERN_LARGO, Ids.ROSI_SLIME, Ids.LANTERN_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROSI_LANTERN_LARGO, Ids.ROSI_SLIME, Ids.LANTERN_SLIME);

        //MINE LARGOS
        SlimeRegistry.CraftLargo(Ids.MINE_LANTERN_LARGO, Ids.MINE_SLIME, Ids.LANTERN_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.MINE_LANTERN_LARGO, Ids.MINE_SLIME, Ids.LANTERN_SLIME);
    }
    public static void LargoTweaks()
    {
        //Rosi Mine
        //Rosi Lantern
        //Tabby Mesmer
        //Hunter Mesmer
        //Tabby Hermit
        //Hunter Hermit
        //Mesmer Hermit
    }
}