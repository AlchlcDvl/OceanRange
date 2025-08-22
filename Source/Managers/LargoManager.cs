using SRML.SR.Utils;
using UnityEngine.UIElements;

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

    public static void CreateLargo(Identifiable.Id largoId, Identifiable.Id slime1, Identifiable.Id slime2, SlimeRegistry.LargoProps props, out SlimeDefinition largoDefinition, out SlimeAppearance largoAppearance, out GameObject largoObject, SlimeRegistry.LargoProps slime1SSProps = SlimeRegistry.LargoProps.NONE, SlimeRegistry.LargoProps slime2SSProps = SlimeRegistry.LargoProps.NONE, SlimeRegistry.LargoProps slime12SSProps = SlimeRegistry.LargoProps.NONE)
    {
        SlimeDefinition slime1Def = slime1.GetSlimeDefinition();
        SlimeDefinition slime2Def = slime2.GetSlimeDefinition();
        SlimeDefinition def = SlimeRegistry.CombineDefinitions(largoId, slime1Def, slime2Def, props);
        SlimeAppearance slimeAppearance = SlimeRegistry.CombineAppearances(slime1Def.AppearancesDefault[0], slime2Def.AppearancesDefault[0], SlimeAppearance.AppearanceSaveSet.CLASSIC, props);
        GameObject gameObject = SlimeRegistry.CombineSlimePrefabs(def);
        TranslationPatcher.AddActorTranslation("l." + largoId.ToString().ToLower(), SlimeRegistry.GenerateLargoName(largoId));

        /*SRSingleton<GameContext>.Instance.DLCDirector.onPackageInstalled += delegate (DLCPackage.Id x)
        {
            if (x == Id.SECRET_STYLE)
            {
                SlimeAppearance appearanceForSet = slime1Def.GetAppearanceForSet(SlimeAppearance.AppearanceSaveSet.SECRET_STYLE);
                SlimeAppearance appearanceForSet2 = slime2Def.GetAppearanceForSet(SlimeAppearance.AppearanceSaveSet.SECRET_STYLE);
                if (appearanceForSet != null && appearanceForSet2 != null)
                {
                    RegisterAppearance(def, CombineAppearances(appearanceForSet, appearanceForSet2, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, (slime12SSProps == LargoProps.NONE) ? props : slime12SSProps));
                    RegisterAppearance(def, CombineAppearances(slime1Def.AppearancesDefault[0], appearanceForSet2, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, (slime2SSProps == LargoProps.NONE) ? props : slime2SSProps));
                    RegisterAppearance(def, CombineAppearances(appearanceForSet, slime2Def.AppearancesDefault[0], SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, (slime1SSProps == LargoProps.NONE) ? props : slime1SSProps));
                }
                else if (appearanceForSet != null)
                {
                    RegisterAppearance(def, CombineAppearances(appearanceForSet, slime2Def.AppearancesDefault[0], SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, (slime1SSProps == LargoProps.NONE) ? props : slime1SSProps));
                }
                else if (appearanceForSet2 != null)
                {
                    RegisterAppearance(def, CombineAppearances(slime1Def.AppearancesDefault[0], appearanceForSet2, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, (slime2SSProps == LargoProps.NONE) ? props : slime2SSProps));
                }
            }
        };*/

        def.AppearancesDefault = new SlimeAppearance[1] { slimeAppearance };
        LookupRegistry.RegisterIdentifiablePrefab(gameObject);
        SlimeRegistry.RegisterAppearance(def, slimeAppearance);
        SlimeRegistry.RegisterSlimeDefinition(def);
        largoDefinition = def;
        largoAppearance = slimeAppearance;
        largoObject = gameObject;

        if (!LargoMaps.TryGetValue(slime1, out var slime1Values))
            slime1Values = LargoMaps[slime1] = [];

        if (!LargoMaps.TryGetValue(slime2, out var slime2Values))
            slime2Values = LargoMaps[slime2] = [];

        slime1Values.Add((largoId, slime2));
        slime2Values.Add((largoId, slime1));

        SlimeAppearanceStructure[] largoStructures = SRSingleton<GameContext>.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(largoId).AppearancesDefault[0].Structures;
        GameObject slime2object = SRSingleton<GameContext>.Instance.LookupDirector.GetIdentifiable(slime2).gameObject;
        foreach (SlimeAppearanceStructure structure in largoStructures)
        {
            SlimeAppearanceObject structureCopy = structure.Element.Prefabs[0].DeepCopy();
            structureCopy.AttachedBones =
            [
            SlimeAppearance.SlimeBone.Slime,
            SlimeAppearance.SlimeBone.JiggleRight,
            SlimeAppearance.SlimeBone.JiggleLeft,
            SlimeAppearance.SlimeBone.JiggleTop,
            SlimeAppearance.SlimeBone.JiggleBottom,
            SlimeAppearance.SlimeBone.JiggleFront,
            SlimeAppearance.SlimeBone.JiggleBack
            ];
            SlimeAppearanceApplicator slimeApp = slime2object.GetComponent<SlimeAppearanceApplicator>();
            var rootMatrix = slimeApp.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
            var poses = new Matrix4x4[structureCopy.AttachedBones.Length];
            for (var i = 0; i < structureCopy.AttachedBones.Length; i++)
            {
                var bone = structureCopy.AttachedBones[i];
                poses[i] = slimeApp.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
            }
            for (int i = 0; i < structure.Element.Prefabs.Length; i++)
            {
                structure.Element.Prefabs[i] = structureCopy;
            }
        }
        //fix texture wrap on Rosi largos.
    }
    public static void CreateLargo(Identifiable.Id largoId, Identifiable.Id slime1, Identifiable.Id slime2, SlimeRegistry.LargoProps props, SlimeRegistry.LargoProps slime1SSProps = SlimeRegistry.LargoProps.NONE, SlimeRegistry.LargoProps slime2SSProps = SlimeRegistry.LargoProps.NONE, SlimeRegistry.LargoProps slime12SSProps = SlimeRegistry.LargoProps.NONE)
    {
        CreateLargo(largoId, slime1, slime2, props, out var _, out var _, out var _, slime1SSProps, slime2SSProps, slime12SSProps);
    }
    public static void LoadAllLargos()
    {
        //COCO LARGOS
        CreateLargo(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_SABER_LARGO, Ids.COCO_SLIME, IdentifiableId.SABER_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_QUANTUM_LARGO, Ids.COCO_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2);
        CreateLargo(Ids.COCO_HONEY_LARGO, Ids.COCO_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_PHOSPHOR_LARGO, Ids.COCO_SLIME, IdentifiableId.PHOSPHOR_SLIME,  SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_MOSAIC_LARGO, Ids.COCO_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_TANGLE_LARGO, Ids.COCO_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_BOOM_LARGO, Ids.COCO_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_RAD_LARGO, Ids.COCO_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_ROCK_LARGO, Ids.COCO_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_TABBY_LARGO, Ids.COCO_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_HUNTER_LARGO, Ids.COCO_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_CRYSTAL_LARGO, Ids.COCO_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_DERVISH_LARGO, Ids.COCO_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.COCO_MESMER_LARGO, Ids.COCO_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.NONE);
        // CreateLargo(Ids.COCO_HERMIT_LARGO, Ids.COCO_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.NONE);

        //MESMER LARGOS
        CreateLargo(Ids.PINK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.SABER_MESMER_LARGO, IdentifiableId.SABER_SLIME, Ids.MESMER_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.QUANTUM_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2);
        CreateLargo(Ids.HONEY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.PHOSPHOR_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.PHOSPHOR_SLIME,  SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.MOSAIC_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.TANGLE_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.BOOM_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.RAD_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.ROCK_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.TABBY_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.HUNTER_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.CRYSTAL_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.DERVISH_MESMER_LARGO, Ids.MESMER_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.NONE);
        // CreateLargo(Ids.MESMER_HERMIT_LARGO, Ids.MESMER_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.NONE);

        //HERMIT LARGOS
        /*CreateLargo(Ids.PINK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.SABER_HERMIT_LARGO, IdentifiableId.SABER_SLIME, Ids.HERMIT_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.QUANTUM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.QUANTUM_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2);
        CreateLargo(Ids.HONEY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HONEY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.PHOSPHOR_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.PHOSPHOR_SLIME,  SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.MOSAIC_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.MOSAIC_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.TANGLE_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TANGLE_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.BOOM_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.BOOM_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.RAD_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.RAD_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.ROCK_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.ROCK_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.TABBY_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.TABBY_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.HUNTER_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.HUNTER_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.CRYSTAL_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.CRYSTAL_SLIME, SlimeRegistry.LargoProps.NONE);
        CreateLargo(Ids.DERVISH_HERMIT_LARGO, Ids.HERMIT_SLIME, IdentifiableId.DERVISH_SLIME, SlimeRegistry.LargoProps.NONE);*/

        //ROSI LARGOS
        CreateLargo(Ids.ROSI_MINE_LARGO, Ids.ROSI_SLIME, Ids.MINE_SLIME, SlimeRegistry.LargoProps.REPLACE_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS);
        CreateLargo(Ids.ROSI_LANTERN_LARGO, Ids.ROSI_SLIME, Ids.LANTERN_SLIME, SlimeRegistry.LargoProps.RECOLOR_BASE_MAT_AS_SLIME2 | SlimeRegistry.LargoProps.RECOLOR_SLIME1_ADDON_MATS);

        //MINE LARGOS
        CreateLargo(Ids.MINE_LANTERN_LARGO, Ids.MINE_SLIME, Ids.LANTERN_SLIME, SlimeRegistry.LargoProps.RECOLOR_SLIME2_ADDON_MATS);
    }
}