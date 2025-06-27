using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;

namespace TheOceanRange.Slimes;

public static class Slimes
{
    public static void PreLoadAllSlimes()
    {
        BasePreLoadSlime(Ids.ROSA_SLIME, Ids.ROSA_PLORT, 0.25f, [Zone.REEF], "Rosa");
        // BasePreLoadSlime(Ids.COCO_SLIME, Ids.COCO_PLORT, 0.25f, [Zone.REEF], "Coco");
    }

    private static void BasePreLoadSlime(IdentifiableId slimeId, IdentifiableId plortId, float spawnAmount, Zone[] zones, string slimeName)
    {
        PlortCreation.PlortPreLoad(plortId, $"{slimeName} Plort", false);
        zones.Do(x => SpawnCreation.CreateSingleZoneSpawner(slimeId, x, spawnAmount));
    }

    public static void LoadAllSlimes()
    {
        var json = JsonConvert.DeserializeObject<Dictionary<string, PediaJsonEntry>>(AssetManager.GetJson("Slimepedia"));
        BaseLoadSlime("Rosa", "rosa_slime", Ids.ROSA_SLIME, 0, 0, 0, IdentifiableId.OCTO_BUDDY_TOY, Ids.ROSA_PLORT, [FoodGroup.MEAT, FoodGroup.FRUIT, FoodGroup.VEGGIES], false,
            IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, InitRosaDetails, true, 1f, 1f, "#E6C7D2",
            "#E6C7D2", "#E6C7D2", "#E6C7D2", "#000000", "#000000", "#000000", "#000000", "#000000", "#000000", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#F9E5F0", "#E35BA6", "#E6C7D2", "#F9E5F0", 10f, 7f,
            "#F9E5F0", Ids.ROSA_SLIME_ENTRY, json["ROSA_SLIME"]);
    }

    private static void BaseLoadSlime
    (
        string name,
        string id,
        IdentifiableId slimeId,
        IdentifiableId gordoId,
        IdentifiableId baitId,
        IdentifiableId favFood,
        IdentifiableId favToy,
        IdentifiableId plortId,
        FoodGroup[] dietIds,
        bool canLargofy,
        IdentifiableId baseSlimeDef,
        IdentifiableId baseSlimeObj,
        IdentifiableId baseSlimeVis,
        IdentifiableId baseSlimeVis2,
        IdentifiableId baseSlimePlort,
        Action<GameObject, SlimeDefinition, SlimeDefinition> initSlimeDetailsAction,
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
        float plortPriceVariance,
        string plortFill,
        PediaId entry,
        PediaJsonEntry json
    )
    {
        var customSlimeData = new CustomSlimeData
        {
            Id = slimeId,
            GordoId = gordoId,
            BaitId = baitId
        };

        var icon = AssetManager.GetSprite($"{name}Slime");
        var gameObject = PlortCreation.CreatePlort($"{name} Plort", plortId, 0, middlePlortColor.HexToColor(), topPlortColor.HexToColor(), bottomPlortColor.HexToColor(), baseSlimePlort);
        PlortCreation.PlortLoad(plortId, basePlortPrice, plortPriceVariance, gameObject, AssetManager.GetSprite($"{name}Plort"), plortFill.HexToColor(), true, true, false);

        var tuple = SlimeCreation.SlimeBaseCreate(slimeId, id, $"{name} Slime", $"slime{name}", $"{name} Slime", baseSlimeDef, baseSlimeObj, baseSlimeVis, baseSlimeVis2, 0, favFood,
            IdentifiableId.SPICY_TOFU, favToy, plortId, canLargofy, icon, Vacuumable.Size.NORMAL, canBeEatenByTarr, shininess, glossiness, topColorBase.HexToColor(), middleColorBase.HexToColor(),
            bottomColorBase.HexToColor(), specialColorBase.HexToColor(), topColorMouth.HexToColor(), middleColorMouth.HexToColor(), bottomColorMouth.HexToColor(), redEyeColor.HexToColor(),
            greenEyeColor.HexToColor(), blueEyeColor.HexToColor(), topPaletteColor.HexToColor(), middlePaletteColor.HexToColor(), bottomPaletteColor.HexToColor(), ammoColor.HexToColor());

        var (definition, prefab) = tuple;
        definition.Diet.MajorFoodGroups = dietIds;

        var defBase = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(baseSlimeDef);

        initSlimeDetailsAction?.Invoke(prefab, definition, defBase);

        SlimeCreation.LoadSlime(tuple);

        Identifiable.SLIME_CLASS.Add(slimeId);

        SlimeManager.SlimesMap[slimeId] = customSlimeData;

        SlimePediaCreation.PreLoadSlimePediaConnection(entry, slimeId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(entry, slimeId, json.Title, json.Intro, json.Diet, json.Fav, json.Slimeology, json.Risks, json.Plortonomics);
        SlimePediaCreation.LoadSlimePediaIcon(entry, icon);
    }

    private static void InitRosaDetails(GameObject prefab, SlimeDefinition definition, SlimeDefinition defBase)
    {
        var appearance = definition.AppearancesDefault[0];
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        appearance.Structures =
        [
            appearance.Structures[0],
            new(appearance.Structures[0]),
            new(appearance.Structures[0])
        ];

        var elemPrefab = defBase.AppearancesDefault[0].Structures[0].Element.Prefabs[0];
        var meshes = new[] { "lantern_body", "frills_stalk", "frills_actual" };
        var prefabs = new SlimeAppearanceObject[3];

        foreach (var (i, structure) in appearance.Structures.Indexed())
        {
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = prefabs[i] = elemPrefab.CreatePrefab();
            elem.Prefabs = [prefab2];
            prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh(meshes[i]);
            structure.SupportsFaces = i == 0;
        }

        var val7 = elemPrefab.CreatePrefab();
        var skin = val7.GetComponent<SkinnedMeshRenderer>();
        skin.sharedMesh = UObject.Instantiate(skin.sharedMesh);
        AssetsLib.MeshUtils.GenerateBoneData(applicator, val7, 0.25f, 1f, prefabs);

        prefab.AddComponent<RosaBehaviour>();
    }

    private static void InitCocoDetails(GameObject prefab, SlimeDefinition definition, SlimeDefinition defBase)
    {
        prefab.AddComponent<CocoBehaviour>();
    }
}