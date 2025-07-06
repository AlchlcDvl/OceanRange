using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;
using SRML;

namespace TheOceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// TODO: Create Rosi gordo at -10.6085 4.6748 17.2529
public static class SlimeManager
{
    public static readonly Dictionary<IdentifiableId, CustomSlimeData> SlimesMap = [];
    private static bool SAMExists;

    public static void PreLoadAllSlimes()
    {
        BasePreLoadSlime(Ids.ROSI_SLIME, Ids.ROSI_PLORT, true, 0.25f, [Zone.REEF], "Rosi");
        BasePreLoadSlime(Ids.COCO_SLIME, Ids.COCO_PLORT, false, 0.25f, [Zone.REEF], "Coco");
        BasePreLoadSlime(Ids.MINE_SLIME, Ids.MINE_PLORT, true, 0.25f, [Zone.QUARRY], "Mine");
    }

    private static void BasePreLoadSlime(IdentifiableId slimeId, IdentifiableId plortId, bool isPearl, float spawnAmount, Zone[] zones, string slimeName)
    {
        PlortCreation.PlortPreLoad(plortId, $"{slimeName} {(isPearl ? "Pearl" : "Plort")}", false);

        SRCallbacks.PreSaveGameLoad += delegate
        {
            var prefab = GameInstance.Instance.LookupDirector.GetPrefab(slimeId);

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
        SAMExists = SRModLoader.IsModPresent("slimesandmarket");

        var json = JsonConvert.DeserializeObject<Dictionary<string, SlimePediaEntry>>(AssetManager.GetJson("Slimepedia"));

        BaseLoadSlime("Rosi", Ids.ROSI_SLIME, 0, IdentifiableId.HEN, IdentifiableId.OCTO_BUDDY_TOY, Ids.ROSI_PLORT, 0, false, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, InitRosiDetails,
            true, 1f, 1f, "#F9E5F0", "#E6C7D2", "#F68ED9", "#E6C7D2", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F46CB7",
            "#E6C7D2", "#F9E5F0", 10f, 100f, "#F9E5F0", Ids.ROSI_SLIME_ENTRY, json["ROSI_SLIME"], true, null);
        BaseLoadSlime("Coco", Ids.COCO_SLIME, 0, Ids.SANDY_CHICKEN, IdentifiableId.BEACH_BALL_TOY, Ids.COCO_PLORT, FoodGroup.MEAT, false, IdentifiableId.PINK_SLIME, IdentifiableId.PUDDLE_PLORT,
            InitCocoDetails, true, 0.1f, 0.11f, "#FEFCFF", "#A1662F", "#966F33", "#FEFCFF", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#FEFCFF", "#A1662F", "#966F33",
            "#966F33", "#FEFCFF", "#DCDADD", "#FEFCFF", 20f, 100f, "#FEFCFF", Ids.COCO_SLIME_ENTRY, json["COCO_SLIME"], false, null);
        BaseLoadSlime("Mine", Ids.MINE_SLIME, 0, IdentifiableId.CARROT_VEGGIE, IdentifiableId.BOMB_BALL_TOY, Ids.MINE_PLORT, FoodGroup.VEGGIES, false, IdentifiableId.BOOM_SLIME,
            IdentifiableId.BOOM_PLORT, InitMineDetails, true, 0.5f, 0.5f, "#445660", "#445660", "#445660", "#445660", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#9ea16f",
            "#445660", "#212A2F", "#9ea16f", "#445660", "#445660", "#445660", 95f, 125f, "#9ea16f", Ids.MINE_SLIME_ENTRY, json["MINE_SLIME"], true, null);
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
        Action<GameObject> initPearlDetails
    )
    {
        var customSlimeData = new CustomSlimeData
        {
            GordoId = gordoId,
            BaitId = favFood,
            PlortId = plortId,
        };

        var plort = PlortCreation.CreatePlort($"{name} {(isPearl ? "Pearl" : "Plort")}", plortId, 0, middlePlortColor.HexToColor(), topPlortColor.HexToColor(), bottomPlortColor.HexToColor(),
            basePlort);

        // if (isPearl)
        //     plort.GetComponent<MeshFilter>().mesh = AssetManager.GetMesh("pearl"); // No pearl mesh yet

        initPearlDetails?.Invoke(plort);

        PlortCreation.PlortLoad(plortId, basePlortPrice, saturation, plort, AssetManager.GetSprite($"{name}Plort"), plortAmmoColor.HexToColor(), true, true, false);

        var icon = AssetManager.GetSprite($"{name}Slime");

        var tuple = SlimeCreation.SlimeBaseCreate(slimeId, $"{name.ToLower()}_slime", json.Title, $"slime{name}", json.Title, baseSlime, baseSlime, baseSlime, baseSlime, diet, favFood,
            IdentifiableId.SPICY_TOFU, favToy, plortId, canLargofy, icon, 0, canBeEatenByTarr, shininess, glossiness, topColorBase.HexToColor(), middleColorBase.HexToColor(),
            bottomColorBase.HexToColor(), specialColorBase.HexToColor(), topColorMouth.HexToColor(), middleColorMouth.HexToColor(), bottomColorMouth.HexToColor(), redEyeColor.HexToColor(),
            greenEyeColor.HexToColor(), blueEyeColor.HexToColor(), topPaletteColor.HexToColor(), middlePaletteColor.HexToColor(), bottomPaletteColor.HexToColor(), slimeAmmoColor.HexToColor());

        var (definition, prefab) = tuple;

        initSlimeDetails?.Invoke(prefab, definition);

        SlimeCreation.LoadSlime(tuple);

        Identifiable.SLIME_CLASS.Add(slimeId);

        SlimesMap[slimeId] = customSlimeData;

        SlimePediaCreation.PreLoadSlimePediaConnection(entry, slimeId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(entry, slimeId, json.Title, json.Intro, json.Diet, json.Fav, json.Slimeology, json.Risks, json.Plortonomics);
        SlimePediaCreation.LoadSlimePediaIcon(entry, icon);

        if (SAMExists)
            TypeLoadExceptionBypass(slimeId, plortId);
    }

    private static void TypeLoadExceptionBypass(IdentifiableId slimeId, IdentifiableId plortId)
    {
        try
        {
            SlimesAndMarket.ExtraSlimes.RegisterSlime(slimeId, plortId); // Since it's a soft dependency but still requires the code from the mod to work, this method was made
        }
        catch (Exception e)
        {
            Main.Instance.ConsoleInstance.LogError(e);
        }
    }

    private static void InitRosiDetails(GameObject prefab, SlimeDefinition definition)
    {
        definition.Diet.MajorFoodGroups = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).Diet.MajorFoodGroups;
        definition.Diet.Favorites = [];

        var appearance = definition.AppearancesDefault[0];
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        var first = appearance.Structures[0];

        appearance.Structures =
        [
            first,
            new(first),
            new(first)
        ];

        var elemPrefab = first.Element.Prefabs[0];
        var meshes = new[] { "rosi_body", "rosi_stalk", "rosi_frills" };
        var prefabs = new SlimeAppearanceObject[2];
        SlimeAppearanceObject slimeBase = null;

        foreach (var (i, structure) in appearance.Structures.Indexed())
        {
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab(prefab.transform);
            elem.Prefabs = [prefab2];
            prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh(meshes[i]);
            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            if (i == 0)
                slimeBase = prefab2;
            else
                prefabs[i - 1] = prefab2;

            if (i != 2)
                continue;

            var mat = structure.DefaultMaterials[0].Clone();
            var color = "#F46CB7".HexToColor();
            mat.SetColor("_TopColor", color);
            mat.SetColor("_MiddleColor", color);
            mat.SetColor("_BottomColor", color);
            mat.SetColor("_SpecColor", color);
            structure.DefaultMaterials[0] = mat;
        }

        AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefabs);

        prefab.AddComponent<RosiBehaviour>();
    }

    private static void InitCocoDetails(GameObject prefab, SlimeDefinition definition)
    {
        // Incomplete mesh for coco slime, so tentative code for now
        // var appearance = definition.AppearancesDefault[0];
        // var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        // var structure = appearance.Structures[0];

        // var elemPrefab = structure.Element.Prefabs[0];

        // var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        // var prefab2 = elemPrefab.CreatePrefab();
        // elem.Prefabs = [prefab2];
        // prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("coco_body");
        // prefab2.IgnoreLODIndex = true;
        // structure.SupportsFaces = true;

        // var slimeBase = elemPrefab.CreatePrefab();
        // var skin = slimeBase.GetComponent<SkinnedMeshRenderer>();
        // skin.sharedMesh = UObject.Instantiate(skin.sharedMesh);

        // AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefab2);

        prefab.AddComponent<CocoBehaviour>();
    }

    private static void InitMineDetails(GameObject prefab, SlimeDefinition definition)
    {
        var appearance = definition.AppearancesDefault[0];
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        var color = "#445660".HexToColor();
        var color2 = "#9ea16f".HexToColor();
        var color3 = "#212A2F".HexToColor();

        var material = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TABBY_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material.SetColor("_TopColor", color2);
        material.SetColor("_MiddleColor", color2);
        material.SetColor("_BottomColor", color);
        material.SetColor("_SpecColor", color);
        material.SetFloat("_Shininess", 1f);
        material.SetFloat("_Gloss", 1f);

        var material2 = material.Clone();
        material.SetTexture("_StripeTexture", AssetManager.GetTexture2D("MinePattern"));
        material2.SetColor("_TopColor", color3);
        material2.SetColor("_MiddleColor", color3);
        material2.SetColor("_BottomColor", color3);
        material2.SetColor("_SpecColor", color2);

        var first = appearance.Structures[0];

        appearance.Structures =
        [
            first,
            new(first),
            new(first)
        ];

        var elemPrefab = first.Element.Prefabs[0];
        var meshes = new[] { null, "mine_spikes", "mine_ring" };
        var prefabs = new SlimeAppearanceObject[2];
        SlimeAppearanceObject slimeBase = null;

        foreach (var (i, structure) in appearance.Structures.Indexed())
        {
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab(prefab.transform);
            elem.Prefabs = [prefab2];
            var meshRend = prefab2.GetComponent<SkinnedMeshRenderer>();
            var meshName = meshes[i];
            meshRend.sharedMesh = meshName == null ? UObject.Instantiate(meshRend.sharedMesh) : AssetManager.GetMesh(meshName);
            prefab2.IgnoreLODIndex = true;

            if (i == 0)
            {
                slimeBase = prefab2;
                structure.SupportsFaces = true;
                structure.DefaultMaterials[0] = material;
            }
            else
            {
                prefabs[i - 1] = prefab2;
                structure.SupportsFaces = false;
                structure.DefaultMaterials[0] = material2;
            }
        }

        AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefabs);

        prefab.RemoveComponent<BoomSlimeExplode>();
        prefab.RemoveComponent<BoomMaterialAnimator>();
        prefab.AddComponent<MineBehaviour>();
    }
}