using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;
using SRML;

namespace TheOceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code, like gordo stuff
public static class SlimeManager
{
    public static readonly Dictionary<IdentifiableId, CustomSlimeData> SlimesMap = [];
    private static bool SAMExists;

    public static void PreLoadAllSlimes()
    {
        BasePreLoadSlime(Ids.ROSI_SLIME, Ids.ROSI_PLORT, 0.25f, [Zone.REEF], "Rosi");
        BasePreLoadSlime(Ids.COCO_SLIME, Ids.COCO_PLORT, 0.25f, [Zone.REEF], "Coco");
        // BasePreLoadSlime(Ids.MINE_SLIME, Ids.MINE_PLORT, 0.25f, [Zone.QUARRY], "Mine");
    }

    private static void BasePreLoadSlime(IdentifiableId slimeId, IdentifiableId plortId, float spawnAmount, Zone[] zones, string slimeName)
    {
        PlortCreation.PlortPreLoad(plortId, $"{slimeName} Plort", false);

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
        BaseLoadSlime("Rosi", Ids.ROSI_SLIME, 0, 0, 0, IdentifiableId.OCTO_BUDDY_TOY, Ids.ROSI_PLORT, FoodGroup.PLORTS, false, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME,
            IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, InitRosiDetails, true, 1f, 1f, "#E6C7D2", "#E6C7D2", "#E6C7D2", "#E6C7D2", "#000000", "#000000",
            "#000000", "#000000", "#000000", "#000000", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F46CB7", "#E6C7D2", "#F9E5F0", 10f, 100f, "#F9E5F0", Ids.ROSI_SLIME_ENTRY, json["ROSI_SLIME"],
            InitPearlPlort);
        BaseLoadSlime("Coco", Ids.COCO_SLIME, 0, Ids.SANDY_CHICKEN, Ids.SANDY_CHICKEN, IdentifiableId.BEACH_BALL_TOY, Ids.COCO_PLORT, FoodGroup.MEAT, false, IdentifiableId.PINK_SLIME,
            IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PUDDLE_PLORT, InitCocoDetails, true, 0.1f, 0.11f, "#FEFCFF", "#A1662F", "#966F33",
            "#FEFCFF", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#F9E5F0", "#A1662F", "#966F33", "#966F33", "#FEFCFF", "#DCDADD", "#FEFCFF", 20f, 100f, "#FEFCFF",
            Ids.COCO_SLIME_ENTRY, json["COCO_SLIME"], null);
    }

    private static void BaseLoadSlime
    (
        string name,
        IdentifiableId slimeId,
        IdentifiableId gordoId,
        IdentifiableId baitId,
        IdentifiableId favFood,
        IdentifiableId favToy,
        IdentifiableId plortId,
        FoodGroup diet,
        bool canLargofy,
        IdentifiableId baseSlimeDef,
        IdentifiableId baseSlimeObj,
        IdentifiableId baseSlimeVis,
        IdentifiableId baseSlimeVis2,
        IdentifiableId baseSlimePlort,
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
        string ammoColor,
        string topPlortColor,
        string middlePlortColor,
        string bottomPlortColor,
        float basePlortPrice,
        float saturation,
        string plortFill,
        PediaId entry,
        SlimePediaEntry json,
        Action<GameObject> initPlortDetails
    )
    {
        var customSlimeData = new CustomSlimeData
        {
            GordoId = gordoId,
            BaitId = baitId,
            PlortId = plortId,
        };

        var plort = PlortCreation.CreatePlort($"{name} Plort", plortId, 0, middlePlortColor.HexToColor(), topPlortColor.HexToColor(), bottomPlortColor.HexToColor(), baseSlimePlort);

        initPlortDetails?.Invoke(plort);

        PlortCreation.PlortLoad(plortId, basePlortPrice, saturation, plort, AssetManager.GetSprite($"{name}Plort"), plortFill.HexToColor(), true, true, false);

        var icon = AssetManager.GetSprite($"{name}Slime");

        var tuple = SlimeCreation.SlimeBaseCreate(slimeId, $"{name.ToLower()}_slime", json.Title, $"slime{name}", json.Title, baseSlimeDef, baseSlimeObj, baseSlimeVis, baseSlimeVis2,
            diet, favFood, IdentifiableId.SPICY_TOFU, favToy, plortId, canLargofy, icon, 0, canBeEatenByTarr, shininess, glossiness, topColorBase.HexToColor(), middleColorBase.HexToColor(),
            bottomColorBase.HexToColor(), specialColorBase.HexToColor(), topColorMouth.HexToColor(), middleColorMouth.HexToColor(), bottomColorMouth.HexToColor(), redEyeColor.HexToColor(),
            greenEyeColor.HexToColor(), blueEyeColor.HexToColor(), topPaletteColor.HexToColor(), middlePaletteColor.HexToColor(), bottomPaletteColor.HexToColor(), ammoColor.HexToColor());

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

    private static void InitPearlPlort(GameObject prefab)
    {
        // prefab.GetComponent<MeshFilter>().mesh = AssetManager.GetMesh("pearl");
    }

    private static void InitRosiDetails(GameObject prefab, SlimeDefinition definition)
    {
        definition.Diet.MajorFoodGroups = [FoodGroup.MEAT, FoodGroup.VEGGIES, FoodGroup.FRUIT, FoodGroup.GINGER];

        var appearance = definition.AppearancesDefault[0];
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        appearance.Structures =
        [
            appearance.Structures[0],
            new(appearance.Structures[0]),
            new(appearance.Structures[0])
        ];

        var elemPrefab = appearance.Structures[0].Element.Prefabs[0];
        var meshes = new[] { "rosi_body", "rosi_stalk", "rosi_frills" };
        var prefabs = new SlimeAppearanceObject[3];

        foreach (var (i, structure) in appearance.Structures.Indexed())
        {
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = prefabs[i] = elemPrefab.CreatePrefab(prefab.transform);
            elem.Prefabs = [prefab2];
            prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh(meshes[i]);
            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;
        }

        var slimeBase = elemPrefab.CreatePrefab(prefab.transform);
        var skin = slimeBase.GetComponent<SkinnedMeshRenderer>();
        skin.sharedMesh = UObject.Instantiate(skin.sharedMesh);

        AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefabs);

        prefab.AddComponent<RosiBehaviour>();
    }

    private static void InitCocoDetails(GameObject prefab, SlimeDefinition definition)
    {
        // var appearance = definition.AppearancesDefault[0];
        // var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        // var structure = appearance.Structures[0];

        // var elemPrefab = structure.Element.Prefabs[0];

        // var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        // var prefab2 = elemPrefab.CreatePrefab();
        // elem.Prefabs = [prefab2];
        // prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("CoconutSlime");
        // prefab2.IgnoreLODIndex = true;
        // structure.SupportsFaces = true;

        // var slimeBase = elemPrefab.CreatePrefab();
        // var skin = slimeBase.GetComponent<SkinnedMeshRenderer>();
        // skin.sharedMesh = UObject.Instantiate(skin.sharedMesh);
        // AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefab2);

        prefab.AddComponent<CocoBehaviour>();
    }
}