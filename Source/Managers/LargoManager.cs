using SRML.SR.Utils;
using AssetsLib;

namespace OceanRange.Managers;

// All hail the json gods, for they look upon me favourably
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

    public static readonly HashSet<IdentifiableId> MesmerLargos = new(Identifiable.idComparer)
    {
        // Ids.PINK_MESMER_LARGO,
        // Ids.COCO_MESMER_LARGO,
        // Ids.SABER_MESMER_LARGO,
        // Ids.QUANTUM_MESMER_LARGO,
        // Ids.HONEY_MESMER_LARGO,
        // Ids.PHOSPHOR_MESMER_LARGO,
        // Ids.MOSAIC_MESMER_LARGO,
        // Ids.TANGLE_MESMER_LARGO,
        // Ids.BOOM_MESMER_LARGO,
        // Ids.RAD_MESMER_LARGO,
        // Ids.ROCK_MESMER_LARGO,
        // Ids.TABBY_MESMER_LARGO,
        // Ids.HUNTER_MESMER_LARGO,
        // Ids.CRYSTAL_MESMER_LARGO,
        // Ids.DERVISH_MESMER_LARGO,
        // Ids.MESMER_HERMIT_LARGO
    };

    public static readonly Dictionary<IdentifiableId, List<(IdentifiableId, IdentifiableId)>> LargoMaps = [];

    private static Material QuantumMat;
    private static float DefaultRadius;

    private static LargoData[] Largos;
    private static readonly int GhostToggle = ShaderUtils.GetOrSet("_GhostToggle");

    #if DEBUG
    [TimeDiagnostic("Largo Preload")]
#endif
    public static void PreLoadLargoData() => Largos = AssetManager.GetJsonArray<LargoData>("largopedia");

#if DEBUG
    [TimeDiagnostic("Largo Load")]
#endif
    public static void LoadAllLargos()
    {
        QuantumMat = IdentifiableId.QUANTUM_SLIME.GetSlimeDefinition().AppearancesDefault[0].QubitAppearance.Structures[0].DefaultMaterials[0];
        DefaultRadius = IdentifiableId.PINK_SLIME.GetPrefab().GetComponent<SphereCollider>().radius;

        Array.ForEach(Largos, CreateLargo);

        //COCO LARGOS
        // SlimeRegistry.CraftLargo(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_SABER_LARGO, IdentifiableId.SABER_SLIME, Ids.COCO_SLIME, LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_SABER_LARGO, IdentifiableId.SABER_SLIME, Ids.COCO_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME, LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME, LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME);
        // SlimeRegistry.CraftLargo(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME);
        //SlimeRegistry.CraftLargo(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        //AddLargoEatMap(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME);

        //MESMER LARGOS
        // SlimeRegistry.CraftLargo(Ids.PINK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PINK_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.RECOLOR_SLIME1_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.PINK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PINK_SLIME);
        // SlimeRegistry.CraftLargo(Ids.SABER_MESMER_LARGO, IdentifiableId.SABER_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.SABER_MESMER_LARGO, IdentifiableId.SABER_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.QUANTUM_MESMER_LARGO, IdentifiableId.QUANTUM_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.REPLACE_SLIME2_ADDON_MATS | LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.QUANTUM_MESMER_LARGO, IdentifiableId.QUANTUM_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.HONEY_MESMER_LARGO, IdentifiableId.HONEY_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.REPLACE_SLIME2_ADDON_MATS | LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.HONEY_MESMER_LARGO, IdentifiableId.HONEY_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.PHOSPHOR_MESMER_LARGO, IdentifiableId.PHOSPHOR_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.RECOLOR_SLIME1_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.PHOSPHOR_MESMER_LARGO, IdentifiableId.PHOSPHOR_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.MOSAIC_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.MOSAIC_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.MOSAIC_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.MOSAIC_SLIME);
        // SlimeRegistry.CraftLargo(Ids.TANGLE_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TANGLE_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.RECOLOR_SLIME1_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.TANGLE_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TANGLE_SLIME);
        // SlimeRegistry.CraftLargo(Ids.BOOM_MESMER_LARGO, IdentifiableId.BOOM_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.REPLACE_SLIME2_ADDON_MATS | LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.BOOM_MESMER_LARGO, IdentifiableId.BOOM_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.RAD_MESMER_LARGO, IdentifiableId.RAD_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.REPLACE_SLIME2_ADDON_MATS | LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.RAD_MESMER_LARGO, IdentifiableId.RAD_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.ROCK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.ROCK_SLIME, LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.ROCK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.ROCK_SLIME);
        // SlimeRegistry.CraftLargo(Ids.TABBY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TABBY_SLIME, LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.TABBY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TABBY_SLIME);
        // SlimeRegistry.CraftLargo(Ids.HUNTER_MESMER_LARGO, IdentifiableId.HUNTER_SLIME, Ids.MESMER_SLIME, LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | LargoProps.RECOLOR_SLIME1_ADDON_MATS | LargoProps.SWAP_MOUTH | LargoProps.SWAP_EYES | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.HUNTER_MESMER_LARGO, IdentifiableId.HUNTER_SLIME, Ids.MESMER_SLIME);
        // SlimeRegistry.CraftLargo(Ids.CRYSTAL_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.CRYSTAL_SLIME, LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.CRYSTAL_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.CRYSTAL_SLIME);
        // SlimeRegistry.CraftLargo(Ids.DERVISH_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.DERVISH_SLIME, LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.DERVISH_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.DERVISH_SLIME);
        // SlimeRegistry.CraftLargo(Ids.MESMER_HERMIT_LARGO, Ids.MESMER_SLIME, Ids.HERMIT_SLIME, LargoProps.RECOLOR_SLIME2_ADDON_MATS | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        // AddLargoEatMap(Ids.MESMER_HERMIT_LARGO, Ids.MESMER_SLIME, Ids.HERMIT_SLIME);

        //HERMIT LARGOS
        /*SlimeRegistry.CraftLargo(Ids.PINK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PINK_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PINK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PINK_SLIME);
        SlimeRegistry.CraftLargo(Ids.SABER_HERMIT_LARGO, IdentifiableId.SABER_SLIME, Ids.HERMIT_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.SABER_HERMIT_LARGO, IdentifiableId.SABER_SLIME, Ids.HERMIT_SLIME);
        SlimeRegistry.CraftLargo(Ids.QUANTUM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.QUANTUM_SLIME, LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.QUANTUM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.QUANTUM_SLIME);
        SlimeRegistry.CraftLargo(Ids.HONEY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HONEY_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HONEY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HONEY_SLIME);
        SlimeRegistry.CraftLargo(Ids.PHOSPHOR_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PHOSPHOR_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.PHOSPHOR_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PHOSPHOR_SLIME);
        SlimeRegistry.CraftLargo(Ids.MOSAIC_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.MOSAIC_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.MOSAIC_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.MOSAIC_SLIME);
        SlimeRegistry.CraftLargo(Ids.TANGLE_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TANGLE_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TANGLE_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TANGLE_SLIME);
        SlimeRegistry.CraftLargo(Ids.BOOM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.BOOM_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.BOOM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.BOOM_SLIME);
        SlimeRegistry.CraftLargo(Ids.RAD_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.RAD_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.RAD_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.RAD_SLIME);
        SlimeRegistry.CraftLargo(Ids.ROCK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.ROCK_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.ROCK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.ROCK_SLIME);
        SlimeRegistry.CraftLargo(Ids.TABBY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TABBY_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.TABBY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TABBY_SLIME);
        SlimeRegistry.CraftLargo(Ids.HUNTER_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HUNTER_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.HUNTER_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HUNTER_SLIME);
        SlimeRegistry.CraftLargo(Ids.CRYSTAL_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.CRYSTAL_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.CRYSTAL_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.CRYSTAL_SLIME);
        SlimeRegistry.CraftLargo(Ids.DERVISH_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.DERVISH_SLIME, LargoProps.GENERATE_NAME | LargoProps.GENERATE_SECRET_STYLES);
        AddLargoEatMap(Ids.DERVISH_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.DERVISH_SLIME);*/
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateLargo(LargoData largoData)
    {
        var slime1 = largoData.Slime1Id.GetSlimeDefinition();
        var slime2 = largoData.Slime2Id.GetSlimeDefinition();

        var definition = ScriptableObject.CreateInstance<SlimeDefinition>();
        definition.BaseSlimes = [slime1, slime2];
        definition.CanLargofy = false;
        definition.IdentifiableId = largoData.MainId;
        definition.IsLargo = true;
        definition.Name = slime1.Name + " " + slime2.Name;
        definition.PrefabScale = 2f;
        definition.Sounds = largoData.Props.HasFlag(LargoProps.UseSlime2ForSound) ? slime2.Sounds : slime1.Sounds;
        definition.LoadLargoDiet();
        definition.FavoriteToys = [];

        var props = largoData.Props;
        var useSlime2Body = props.HasFlag(LargoProps.UseSlime2ForBody);

        var slime1Prefab = (useSlime2Body ? largoData.Slime2Id : largoData.Slime1Id).GetPrefab();
        var slime2Prefab = (useSlime2Body ? largoData.Slime1Id : largoData.Slime2Id).GetPrefab();

        var prefab = slime1Prefab.CreatePrefab();
        prefab.name = "slime" + largoData.Slime1 + largoData.Slime2;
        prefab.transform.localScale = Vector3.one * definition.PrefabScale;
        prefab.GetComponent<SlimeEat>().slimeDefinition = definition;
        prefab.GetComponent<Identifiable>().id = definition.IdentifiableId;
        prefab.GetComponent<Vacuumable>().size = Vacuumable.Size.LARGE;
        prefab.GetComponent<Rigidbody>().mass += slime2Prefab.GetComponent<Rigidbody>().mass;
        prefab.GetComponent<AweTowardsLargos>().Destroy();

        if (prefab.TryGetComponent<PinkSlimeFoodTypeTracker>(out var tracker))
            tracker.Destroy();

        if (slime1.FavoriteToys != null)
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime1.FavoriteToys, Identifiable.idComparer)];

        if (slime2.FavoriteToys != null)
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime2.FavoriteToys, Identifiable.idComparer)];

        var appearance1 = slime1.AppearancesDefault[0];
        var appearance2 = slime2.AppearancesDefault[0];

        var appearance = ScriptableObject.CreateInstance<SlimeAppearance>();
        appearance.AnimatorOverride = appearance1.AnimatorOverride ?? appearance2.AnimatorOverride;
        appearance.DependentAppearances = [appearance1, appearance2];
        appearance.Face = appearance1.Face.DeepCopy();
        appearance.Face._expressionToFaceLookup.Clear();

        var eyes = props.HasFlag(LargoProps.UseSlime2ForEyes) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;
        var mouth = props.HasFlag(LargoProps.UseSlime2ForMouth) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;

        foreach (var expression in appearance1.Face._expressionToFaceLookup.Keys.Union(appearance2.Face._expressionToFaceLookup.Keys))
        {
            appearance.Face._expressionToFaceLookup.Add(expression, new()
            {
                SlimeExpression = expression,
                Eyes = eyes.TryGetValue(expression, out var eyesInner) ? eyesInner.Eyes : null,
                Mouth = mouth.TryGetValue(expression, out var mouthInner) ? mouthInner.Mouth : null
            });
        }

        appearance.Face.ExpressionFaces = [.. appearance.Face._expressionToFaceLookup.Values];
        appearance.NameXlateKey = appearance1.NameXlateKey;
        appearance.SaveSet = SlimeAppearance.AppearanceSaveSet.CLASSIC;

        var allCustomModels = props.HasFlag(LargoProps.CustomStructureSource);
        var customBody = false;
        var customMats = false;
        var customMats2 = false;
        var struct1LastIndex = 0;

        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();
        applicator.SlimeDefinition = definition;

        if (allCustomModels)
            SlimeManager.BasicInitSlimeAppearance(appearance, applicator, (useSlime2Body ? slime2 : slime1).AppearancesDefault[0].Structures[0], largoData.Meshes, largoData.SkipNull, largoData.Jiggle.Value, largoData.Name, largoData.MatData);
        else
        {
            var list = new List<SlimeAppearanceStructure>(appearance1.Structures.Length + appearance2.Structures.Length - 1);
            customBody = props.HasFlag(LargoProps.CustomBodyMaterial);
            customMats = props.HasFlag(LargoProps.CustomSlime1StructureMaterials);
            customMats2 = props.HasFlag(LargoProps.CustomSlime2StructureMaterials);

            var slime1Body = appearance1.Structures.FirstOrDefault(x => x.Element.Name.Contains("Body"));
            var slime2Body = appearance2.Structures.FirstOrDefault(x => x.Element.Name.Contains("Body"));

            var body = new SlimeAppearanceStructure(useSlime2Body ? slime2Body : slime1Body);

            list.Add(body);

            var bodyMat = (props.HasFlag(LargoProps.UseSlime2ForBodyMaterial) ? slime2Body : slime1Body).DefaultMaterials[0];
            body.DefaultMaterials[0] = customBody ? SlimeManager.GenerateMaterial(largoData.BodyMatData, null, bodyMat, largoData.Name) : bodyMat.Clone();

            var num = appearance1.Structures.IndexOfItem(slime1Body);

            for (var i = 0; i < appearance1.Structures.Length; i++)
            {
                if (i == num)
                    continue;

                var structure = new SlimeAppearanceStructure(appearance1.Structures[i]);

                if (customMats)
                    structure.DefaultMaterials[0] = SlimeManager.GenerateMaterial(largoData.Slime1StructMatData[i], largoData.Slime1Data?.SlimeMatData, structure.DefaultMaterials[0], largoData.Name);

                list.Add(structure);
            }

            struct1LastIndex = list.Count;
            var num2 = appearance2.Structures.IndexOfItem(slime2Body);

            for (var i = 0; i < appearance2.Structures.Length; i++)
            {
                if (i == num2)
                    continue;

                var structure = new SlimeAppearanceStructure(appearance2.Structures[i]);

                if (customMats2)
                    structure.DefaultMaterials[0] = SlimeManager.GenerateMaterial(largoData.Slime2StructMatData[i], largoData.Slime2Data?.SlimeMatData, structure.DefaultMaterials[0], largoData.Name);

                list.Add(structure);
            }

            appearance.Structures = [.. list];
        }

        appearance.ColorPalette = SlimeAppearance.Palette.FromMaterial(appearance.Structures[0].DefaultMaterials[0]);
        appearance.CrystalAppearance = appearance1.CrystalAppearance ?? appearance2.CrystalAppearance;
        appearance.DeathAppearance = appearance1.DeathAppearance ?? appearance2.DeathAppearance;
        appearance.ExplosionAppearance = appearance1.ExplosionAppearance ?? appearance2.ExplosionAppearance;
        appearance.GlintAppearance = appearance1.GlintAppearance ?? appearance2.GlintAppearance;
        appearance.ShockedAppearance = appearance1.ShockedAppearance ?? appearance2.ShockedAppearance;
        appearance.TornadoAppearance = appearance1.TornadoAppearance ?? appearance2.TornadoAppearance;
        appearance.VineAppearance = appearance1.VineAppearance ?? appearance2.VineAppearance;

        if (appearance1.QubitAppearance != null || appearance2.QubitAppearance != null)
        {
            var qubitAppearance = appearance.QubitAppearance = appearance.DeepCopy();
            var material = QuantumMat.Clone();
            material.SetFloat(GhostToggle, 1f);

            for (var i = 0; i < appearance.Structures.Length; i++)
            {
                var structure = qubitAppearance.Structures[i] = new(appearance.Structures[i]);
                var length = structure.DefaultMaterials.Length;
                structure.DefaultMaterials = new Material[length];

                for (var j = 0; j < length; j++)
                {
                    var mat = material.Clone();

                    if (allCustomModels)
                        SlimeManager.SetMatProperties(largoData.MatData[i], mat);
                    else if (j == 0 && customBody)
                        SlimeManager.SetMatProperties(largoData.BodyMatData, mat);
                    else if (j < struct1LastIndex && customMats)
                        SlimeManager.SetMatProperties(largoData.Slime1StructMatData[i - 1], mat);
                    else if (customMats2)
                        SlimeManager.SetMatProperties(largoData.Slime2StructMatData[i - struct1LastIndex], mat);
                    else
                    {
                        var og = structure.DefaultMaterials[j];
                        mat.SetColor(SlimeManager.TopColor, og.GetColor(SlimeManager.TopColor));
                        mat.SetColor(SlimeManager.MiddleColor, og.GetColor(SlimeManager.MiddleColor));
                        mat.SetColor(SlimeManager.BottomColor, og.GetColor(SlimeManager.BottomColor));
                    }

                    structure.DefaultMaterials[j] = mat;
                }
            }
        }

        definition.AppearancesDefault = [appearance];

        if (!LargoMaps.TryGetValue(largoData.Slime1Id, out var slime1Values))
            LargoMaps[largoData.Slime1Id] = slime1Values = [];

        if (!LargoMaps.TryGetValue(largoData.Slime2Id, out var slime2Values))
            LargoMaps[largoData.Slime2Id] = slime2Values = [];

        slime1Values.Add((largoData.MainId, largoData.Slime2Id));
        slime2Values.Add((largoData.MainId, largoData.Slime1Id));

        if (prefab.TryGetComponent<PlayWithToys>(out var toys))
            toys.slimeDefinition = definition;

        if (prefab.TryGetComponent<ReactToToyNearby>(out var react))
            react.slimeDefinition = definition;

        foreach (var component in slime2Prefab.GetComponents<Component>())
        {
            var type = component.GetType();

            if (!prefab.HasComponent(type))
                prefab.AddComponent(type).GetCopyOf(component);
        }

        if (definition.Sounds)
            prefab.GetComponent<SlimeAudio>().slimeSounds = definition.Sounds;

        if (prefab.TryGetComponent<SphereCollider>(out var collider) && slime2Prefab.TryGetComponent<SphereCollider>(out var collider2) && collider.radius == DefaultRadius && collider2.radius != DefaultRadius)
        {
            collider.radius = collider2.radius;
            collider.center = collider2.center;
        }

        foreach (Transform item in prefab.transform)
        {
            if (!prefab.transform.Find(item.name))
                prefab.GetChildCopy(item.name).transform.SetParent(prefab.transform);
        }

        if (largoData.Slime1Data?.ComponentsToRemove != null)
        {
            foreach (var component in largoData.Slime1Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (largoData.Slime2Data?.ComponentsToRemove != null)
        {
            foreach (var component in largoData.Slime2Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (prefab.TryGetComponent<MineBehaviour>(out var mine))
            mine.IsLargo = true;

        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterAppearance(definition, appearance);
        SlimeRegistry.RegisterSlimeDefinition(definition);
        TranslationPatcher.AddActorTranslation("l." + largoData.MainId.ToString().ToLowerInvariant(), SlimeRegistry.GenerateLargoName(largoData.MainId));
    }
}