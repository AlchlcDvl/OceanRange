using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;
using SRML;

namespace TheOceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// TODO: Create Rosi gordo at -10.6085 4.6748 17.2529
public static class SlimeManager
{
    public static readonly Dictionary<IdentifiableId, CustomSlimeData> SlimesMap = [];
    private static bool SamExists;

    private static readonly int TopColor = Shader.PropertyToID("_TopColor");
    private static readonly int MiddleColor = Shader.PropertyToID("_MiddleColor");
    private static readonly int BottomColor = Shader.PropertyToID("_BottomColor");
    private static readonly int SpecColor = Shader.PropertyToID("_SpecColor");
    private static readonly int Shininess = Shader.PropertyToID("_Shininess");
    private static readonly int Gloss = Shader.PropertyToID("_Gloss");
    private static readonly int StripeTexture = Shader.PropertyToID("_StripeTexture");

    public static void PreLoadAllSlimes()
    {
        BasePreLoadSlime(Ids.ROSI_SLIME, Ids.ROSI_PLORT, true, 0.25f, [Zone.REEF], "Rosi");
        BasePreLoadSlime(Ids.COCO_SLIME, Ids.COCO_PLORT, false, 0.25f, [Zone.REEF, Zone.MOSS], "Coco");
        BasePreLoadSlime(Ids.MINE_SLIME, Ids.MINE_PLORT, true, 0.25f, [Zone.QUARRY, Zone.RUINS], "Mine");
        BasePreLoadSlime(Ids.LANTERN_SLIME, Ids.LANTERN_PLORT, true, 0.25f, [Zone.MOSS, Zone.RUINS], "Lantern");
        // BasePreLoadSlime(Ids.SAND_SLIME, Ids.SAND_PLORT, true, 0.25f, [Zone.MOSS, Zone.REEF, Zone.QUARRY], "Sand");
    }

    private static void BasePreLoadSlime(IdentifiableId slimeId, IdentifiableId plortId, bool isPearl, float spawnAmount, Zone[] zones, string slimeName)
    {
        PlortCreation.PlortPreLoad(plortId, $"{slimeName} {(isPearl ? "Pearl" : "Plort")}", false);

        SRCallbacks.PreSaveGameLoad += delegate
        {
            var prefab = GameContext.Instance.LookupDirector.GetPrefab(slimeId);

            foreach (var item in UObject.FindObjectsOfType<DirectedSlimeSpawner>().Where(spawner =>
            {
                var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || zones.Contains(zoneId);
            }))
            {
                foreach (var constraint in item.constraints)
                {
                    constraint.slimeset.members =
                    [
                        .. constraint.slimeset.members,
                        new()
                        {
                            prefab = prefab,
                            weight = spawnAmount
                        }
                    ];
                }
            }
        };
    }

    public static void LoadAllSlimes()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");

        var json = JsonConvert.DeserializeObject<Dictionary<string, SlimePediaEntry>>(AssetManager.GetJson("Slimepedia"));

        BaseLoadSlime("Rosi", Ids.ROSI_SLIME, 0, IdentifiableId.HEN, IdentifiableId.OCTO_BUDDY_TOY, Ids.ROSI_PLORT, 0, false, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, InitRosiDetails,
            true, 1f, 1f, "#F9E5F0", "#E6C7D2", "#F68ED9", "#E6C7D2", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F46CB7",
            "#E6C7D2", "#F9E5F0", 10f, 100f, "#F9E5F0", Ids.ROSI_SLIME_ENTRY, json["ROSI_SLIME"], true, null, []);
        BaseLoadSlime("Coco", Ids.COCO_SLIME, 0, Ids.SANDY_CHICKEN, IdentifiableId.BEACH_BALL_TOY, Ids.COCO_PLORT, FoodGroup.MEAT, false, IdentifiableId.PINK_SLIME, IdentifiableId.PUDDLE_PLORT,
            null, true, 0.1f, 0.11f, "#FEFCFF", "#A1662F", "#966F33", "#FEFCFF", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#FEFCFF", "#A1662F", "#966F33",
            "#966F33", "#FEFCFF", "#DCDADD", "#FEFCFF", 20f, 100f, "#FEFCFF", Ids.COCO_SLIME_ENTRY, json["COCO_SLIME"], false, null, []);
        BaseLoadSlime("Mine", Ids.MINE_SLIME, 0, IdentifiableId.CARROT_VEGGIE, IdentifiableId.BOMB_BALL_TOY, Ids.MINE_PLORT, FoodGroup.VEGGIES, false, IdentifiableId.BOOM_SLIME,
            IdentifiableId.BOOM_PLORT, InitMineDetails, true, 1f, 1f, "#445660", "#445660", "#445660", "#445660", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#9EA16f",
            "#445660", "#212A2F", "#9EA16f", "#445660", "#445660", "#445660", 40f, 125f, "#9EA16f", Ids.MINE_SLIME_ENTRY, json["MINE_SLIME"], true, null, [ProgressType.UNLOCK_QUARRY,
            ProgressType.UNLOCK_RUINS]);
        BaseLoadSlime("Lantern", Ids.LANTERN_SLIME, 0, IdentifiableId.ROOSTER, IdentifiableId.NIGHT_LIGHT_TOY, Ids.LANTERN_PLORT, FoodGroup.MEAT, false, IdentifiableId.PINK_SLIME,
            IdentifiableId.PHOSPHOR_PLORT, InitLanternDetails, true, 1f, 1f, "#752C86", "#9445A7", "#B15EC8", "#752C86", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#752C86",
            "#EBDB6A", "#B15EC8", "#B15EC8", "#B15EC8", "#EBDB6A", "#752C86", 35f, 125f, "#752C86", Ids.LANTERN_SLIME_ENTRY, json["LANTERN_SLIME"], true, null, [ProgressType.UNLOCK_MOSS,
            ProgressType.UNLOCK_RUINS]);
        // BaseLoadSlime("Sand", Ids.LANTERN_SLIME, 0, IdentifiableId.ROOSTER, IdentifiableId.NIGHT_LIGHT_TOY, Ids.LANTERN_PLORT, FoodGroup.MEAT, false, IdentifiableId.PHOSPHOR_SLIME,
        //     IdentifiableId.PHOSPHOR_SLIME, InitLanternDetails, true, 1f, 1f, "#445660", "#445660", "#445660", "#445660", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#9EA16f",
        //     "#445660", "#212A2F", "#9EA16f", "#445660", "#445660", "#445660", 95f, 125f, "#9EA16f", Ids.MINE_SLIME_ENTRY, json["MINE_SLIME"], true, null, [ProgressType.UNLOCK_QUARRY,
        //     ProgressType.UNLOCK_RUINS]); // WIP
    }

    private static void BaseLoadSlime
    (
        string name,
        IdentifiableId slimeId,
        IdentifiableId gordoId,
        IdentifiableId favFood,
        IdentifiableId favToy,
        IdentifiableId plortId,
        FoodGroup diet,
        bool canLargofy,
        IdentifiableId baseSlime,
        IdentifiableId basePlort,
        Action<GameObject, SlimeDefinition> initSlimeDetails,
        bool canBeEatenByTarr,
        float shininess,
        float glossiness,
        string topColorBase,
        string middleColorBase,
        string bottomColorBase,
        string specialColorBase,
        string topColorMouth,
        string middleColorMouth,
        string bottomColorMouth,
        string redEyeColor,
        string greenEyeColor,
        string blueEyeColor,
        string topPaletteColor,
        string middlePaletteColor,
        string bottomPaletteColor,
        string slimeAmmoColor,
        string topPlortColor,
        string middlePlortColor,
        string bottomPlortColor,
        float basePlortPrice,
        float saturation,
        string plortAmmoColor,
        PediaId entry,
        SlimePediaEntry json,
        bool isPearl,
        Action<GameObject> initPlortDetails,
        ProgressType[] progress
    )
    {
        var plort = PlortCreation.CreatePlort($"{name} {(isPearl ? "Pearl" : "Plort")}", plortId, 0, middlePlortColor.HexToColor32(), topPlortColor.HexToColor(), bottomPlortColor.HexToColor(),
            basePlort);

        if (isPearl)
            plort.GetComponent<MeshFilter>().mesh = AssetManager.GetMesh("pearl");

        initPlortDetails?.Invoke(plort);
        PlortCreation.PlortLoad(plortId, basePlortPrice, saturation, plort, AssetManager.GetSprite($"{name}Plort"), plortAmmoColor.HexToColor32(), true, true, progress);

        var icon = AssetManager.GetSprite($"{name}Slime");

        var tuple = SlimeCreation.SlimeBaseCreate(slimeId, $"{name.ToLower()}_slime", json.Title, $"slime{name}", json.Title, baseSlime, baseSlime, baseSlime, baseSlime, diet, favFood,
            IdentifiableId.SPICY_TOFU, favToy, plortId, canLargofy, icon, 0, canBeEatenByTarr, shininess, glossiness, topColorBase.HexToColor32(), middleColorBase.HexToColor32(),
            bottomColorBase.HexToColor32(), specialColorBase.HexToColor32(), topColorMouth.HexToColor32(), middleColorMouth.HexToColor32(), bottomColorMouth.HexToColor32(),
            redEyeColor.HexToColor32(), greenEyeColor.HexToColor32(), blueEyeColor.HexToColor32(), topPaletteColor.HexToColor32(), middlePaletteColor.HexToColor32(),
            bottomPaletteColor.HexToColor32(), slimeAmmoColor.HexToColor32());
        var (definition, prefab) = tuple;
        initSlimeDetails?.Invoke(prefab, definition);
        SlimeCreation.LoadSlime(tuple);

        Identifiable.SLIME_CLASS.Add(slimeId);

        SlimesMap[slimeId] = new()
        {
            GordoId = gordoId,
            BaitId = favFood,
            PlortId = plortId,
        };

        SlimePediaCreation.PreLoadSlimePediaConnection(entry, slimeId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(entry, slimeId, json.Title, json.Intro, json.Diet, json.Fav, json.Slimeology, json.Risks, json.Plortonomics);
        SlimePediaCreation.LoadSlimePediaIcon(entry, icon);

        if (SamExists)
            TypeLoadExceptionBypass(slimeId, plortId, progress);
    }

    private static void TypeLoadExceptionBypass(IdentifiableId slimeId, IdentifiableId plortId, ProgressType[] progress)
    {
        try
        {
            SlimesAndMarket.ExtraSlimes.RegisterSlime(slimeId, plortId, progress: progress); // Since it's a soft dependency but still requires the code from the mod to work, this method was made
        }
        catch (Exception e)
        {
            Main.Instance.ConsoleInstance.LogError(e);
        }
    }

    private static void BasicInitSlimeAppearance
    (
        GameObject prefab,
        SlimeDefinition definition,
        string[] meshes,
        Action<int, SlimeAppearanceStructure> materialHandler,
        Action<GameObject> behaviourAdder,
        Action<GameObject> behaviourRemover
    )
    {
        behaviourRemover?.Invoke(prefab);

        var appearance = definition.AppearancesDefault[0];
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        var firstStructure = appearance.Structures[0];
        var elemPrefab = firstStructure.Element.Prefabs[0];

        var newStructures = new SlimeAppearanceStructure[meshes.Length];
        newStructures[0] = firstStructure;

        for (var i = 1; i < meshes.Length; i++)
            newStructures[i] = new(firstStructure);

        appearance.Structures = newStructures;

        SlimeAppearanceObject slimeBase = null;
        var prefabsForBoneData = new SlimeAppearanceObject[meshes.Length - 1];

        foreach (var (i, structure) in appearance.Structures.Indexed())
        {
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab();
            elem.Prefabs = [prefab2];
            var meshRend = prefab2.GetComponent<SkinnedMeshRenderer>();
            var meshName = meshes[i];
            meshRend.sharedMesh = meshName == null ? UObject.Instantiate(meshRend.sharedMesh) : AssetManager.GetMesh(meshName);
            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            materialHandler?.Invoke(i, structure);

            if (structure.SupportsFaces)
                slimeBase = prefab2;
            else if (i > 0)
                prefabsForBoneData[i - 1] = prefab2;
        }

        AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefabsForBoneData);

        behaviourAdder?.Invoke(prefab);
    }

    private static void InitRosiDetails(GameObject prefab, SlimeDefinition definition)
    {
        definition.Diet.MajorFoodGroups = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).Diet.MajorFoodGroups;
        definition.Diet.Favorites = [];

        BasicInitSlimeAppearance
        (
            prefab, definition, ["rosi_body", "rosi_stalk", "rosi_frills"],
            (i, structure) =>
            {
                if (i != 2)
                    return;

                var mat = structure.DefaultMaterials[0].Clone();
                var color = "#F46CB7".HexToColor();
                mat.SetColor(TopColor, color);
                mat.SetColor(MiddleColor, color);
                mat.SetColor(BottomColor, color);
                mat.SetColor(SpecColor, color);
                structure.DefaultMaterials[0] = mat;
            },
            p => p.AddComponent<RosiBehaviour>(),
            null
        );
    }

    // Coco mesh doesn't work atm
    // private static void InitCocoDetails(GameObject prefab, SlimeDefinition definition) => BasicInitSlimeAppearance
    // (
    //     prefab, definition, ["coco_body", "coco_brows"],
    //     (i, structure) =>
    //     {
    //         if (i == 0)
    //             return;

    //         var color = "#966F33".HexToColor();
    //         var material = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
    //         material.SetColor("_TopColor", color);
    //         material.SetColor("_MiddleColor", color);
    //         material.SetColor("_BottomColor", color);
    //         material.SetColor("_SpecColor", color);
    //         material.SetFloat("_Shininess", 1f);
    //         material.SetFloat("_Gloss", 1f);
    //         structure.DefaultMaterials[0] = material;
    //     },
    //     p => p.AddComponent<CocoBehaviour>(),
    //     null
    // );

    private static void InitMineDetails(GameObject prefab, SlimeDefinition definition)
    {
        var color = "#445660".HexToColor();
        var color2 = "#9ea16f".HexToColor();
        var color3 = "#212A2F".HexToColor();

        var material = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TABBY_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color2);
        material.SetColor(MiddleColor, color2);
        material.SetColor(BottomColor, color);
        material.SetColor(SpecColor, color);
        material.SetFloat(Shininess, 1f);
        material.SetFloat(Gloss, 1f);

        var material2 = material.Clone();
        material2.SetColor(TopColor, color3);
        material2.SetColor(MiddleColor, color3);
        material2.SetColor(BottomColor, color3);
        material2.SetColor(SpecColor, color2);

        material.SetTexture(StripeTexture, AssetManager.GetTexture2D("MinePattern"));

        BasicInitSlimeAppearance
        (
            prefab, definition, [null, "mine_spikes", "mine_ring"],
            (_, structure) => structure.DefaultMaterials[0] = structure.SupportsFaces ? material : material2,
            p => p.AddComponent<MineBehaviour>(),
            p =>
            {
                p.RemoveComponent<BoomSlimeExplode>();
                p.RemoveComponent<BoomMaterialAnimator>();
            }
        );
    }

    private static void InitLanternDetails(GameObject prefab, SlimeDefinition definition)
    {
        var color = "#752C86".HexToColor();
        var color2 = "#B15EC8".HexToColor();

        var material = definition.AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color);
        material.SetColor(MiddleColor, "#9445A7".HexToColor());
        material.SetColor(BottomColor, color2);
        material.SetColor(SpecColor, color);
        material.SetFloat(Shininess, 1f);
        material.SetFloat(Gloss, 1f);

        var material2 = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TABBY_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material2.SetColor(TopColor, color);
        material2.SetColor(MiddleColor, color);
        material2.SetColor(BottomColor, color2);
        material2.SetColor(SpecColor, color);
        material2.SetFloat(Shininess, 1f);
        material2.SetFloat(Gloss, 1f);
        material2.SetTexture(StripeTexture, AssetManager.GetTexture2D("LanternPattern"));

        var color3 = "#EBDB6A".HexToColor();
        var material3 = material.Clone();
        material3.SetColor(TopColor, color3);
        material3.SetColor(MiddleColor, color3);
        material3.SetColor(BottomColor, color3);
        material3.SetColor(SpecColor, color3);
        material3.SetFloat(Shininess, 5f);

        BasicInitSlimeAppearance
        (
            prefab, definition, [null, "lantern_fins", "lantern_stalk", "lantern_lure"],
            (i, structure) => structure.DefaultMaterials[0] = i switch
            {
                1 => material2,
                3 => material3,
                _ => material
            },
            null,
            null
            // p => p.AddComponent<MineBehaviour>(),
            // p =>
            // {
            //     p.RemoveComponent<BoomSlimeExplode>();
            //     p.RemoveComponent<BoomMaterialAnimator>();
            // }
        );
    }
}