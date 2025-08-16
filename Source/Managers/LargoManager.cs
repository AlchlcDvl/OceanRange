namespace OceanRange.Managers;

public static class LargoManager
{
    /*
    Slime 1 gives model and material, Slime 2 gives colour (and facial features??)
    
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

    public static void AddLargoEatMap(IdentifiableId largoId, IdentifiableId slimeId1, IdentifiableId slimeId2)
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
        SlimeRegistry.CraftLargo(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_SABER_LARGO, Ids.COCO_SLIME, IdentifiableId.SABER_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_SABER_LARGO, Ids.COCO_SLIME, IdentifiableId.SABER_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME);

        SlimeRegistry.CraftLargo(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME);

        //SlimeRegistry.CraftLargo(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);


        //SlimeRegistry.CraftLargo(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);

        //MESMER LARGOS

        //HERMIT LARGOS

        //ROSI LARGOS
        SlimeRegistry.CraftLargo(Ids.ROSI_MINE_LARGO, Ids.MINE_SLIME, Ids.ROSI_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROSI_MINE_LARGO, Ids.MINE_SLIME, Ids.ROSI_SLIME);

        SlimeRegistry.CraftLargo(Ids.ROSI_LANTERN_LARGO, Ids.LANTERN_SLIME, Ids.ROSI_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROSI_LANTERN_LARGO, Ids.LANTERN_SLIME, Ids.ROSI_SLIME);

        //MINE LARGOS
        SlimeRegistry.CraftLargo(Ids.MINE_LANTERN_LARGO, Ids.MINE_SLIME, Ids.LANTERN_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.MINE_LANTERN_LARGO, Ids.MINE_SLIME, Ids.LANTERN_SLIME);
    }
}