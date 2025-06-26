using Newtonsoft.Json;
using SimpleSRmodLibrary.Creation;

namespace TheOceanRange.Slimes;

public static class Slimes
{
    public static void PreLoadAllSlimes()
    {
        BasePreLoadSlime(Ids.ROSA_SLIME, Ids.ROSA_PLORT, 0.25f, [Zone.REEF], "Rosa");
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
            IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, InitRosaDetails, true, 1f, 1f,
            new(230, 199, 210, 255), new(230, 199, 210, 255), new(230, 199, 210, 255), new(230, 199, 210, 255), Color.black, Color.black, Color.black, Color.black, Color.black, Color.black,
            new(249, 229, 240, 255), new(249, 229, 240, 255), new(249, 229, 240, 255), new(80, 0, 0, 255), new(237, 169, 96, 255), new(237, 169, 96, 255), new(237, 169, 96, 255), 10f, 7f,
            new(237, 169, 96, 255), Ids.ROSA_SLIME_ENTRY, json["ROSA_SLIME"]);
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
        Action<GameObject, SlimeDefinition> initSlimeDetailsAction,
        bool canBeEatenByTarr,
        float shininess,
        float glossiness,
        Color32 topColorBase,
        Color32 middleColorBase,
        Color32 bottomColorBase,
        Color32 specialColorBase,
        Color32 topColorMouth,
        Color32 middleColorMouth,
        Color32 bottomColorMouth,
        Color32 redEyeColor,
        Color32 greenEyeColor,
        Color32 blueEyeColor,
        Color32 topPaletteColor,
        Color32 middlePaletteColor,
        Color32 bottomPaletteColor,
        Color32 ammoColor,
        Color32 topPlortColor,
        Color32 middlePlortColor,
        Color32 bottomPlortColor,
        float basePlortPrice,
        float plortPriceVariance,
        Color32 plortFill,
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
        var gameObject = PlortCreation.CreatePlort($"{name} Plort", plortId, 0, middlePlortColor, topPlortColor, bottomPlortColor, baseSlimePlort);
        PlortCreation.PlortLoad(plortId, basePlortPrice, plortPriceVariance, gameObject, AssetManager.GetSprite($"{name}Plort"), plortFill, true, true, false);

        var tuple = SlimeCreation.SlimeBaseCreate(slimeId, id, $"{name} Slime", $"slime{name}", $"{name} Slime", baseSlimeDef, baseSlimeObj, baseSlimeVis, baseSlimeVis2, 0, favFood,
            IdentifiableId.SPICY_TOFU, favToy, plortId, canLargofy, icon, Vacuumable.Size.NORMAL, canBeEatenByTarr, shininess, glossiness, topColorBase, middleColorBase, bottomColorBase,
            specialColorBase, topColorMouth, middleColorMouth, bottomColorMouth, redEyeColor, greenEyeColor, blueEyeColor, topPaletteColor, middlePaletteColor, bottomPaletteColor, ammoColor);

        var (definition, prefab) = tuple;

        definition.Diet.MajorFoodGroups = dietIds;

        initSlimeDetailsAction?.Invoke(prefab, definition);

        SlimeCreation.LoadSlime(tuple);

        Identifiable.SLIME_CLASS.Add(slimeId);

        SlimeManager.SlimesMap[slimeId] = customSlimeData;

        SlimePediaCreation.PreLoadSlimePediaConnection(entry, slimeId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(entry, slimeId, json.Title, json.Intro, json.Diet, json.Fav, json.Slimeology, json.Risks, json.Plortonomics);
        SlimePediaCreation.LoadSlimePediaIcon(entry, icon);
    }

    private static void InitRosaDetails(GameObject prefab, SlimeDefinition definition)
    {
        // var appearance = definition.AppearancesDefault[0].DeepCopy();
        // var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        // var val6 = definition.AppearancesDefault[0].Structures[0].Element.Prefabs[0];
        // var elem1 = appearance.Structures[0].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        // var prefab1 = val6.gameObject.CreatePrefabCopy().GetComponent<SlimeAppearanceObject>();
        // elem1.Prefabs = [ prefab1 ];
        // var mesh1 = prefab1.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("lantern_body");

        // if (!mesh1)
        //     Main.Instance.ConsoleInstance.Log("Couldn't load rosa mesh");

        // var elem2 = appearance.Structures[1].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        // var prefab2 = val6.CreatePrefab();
        // elem2.Prefabs = [ prefab2 ];
        // var mesh2 = prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("frills_stalk");
        // appearance.Structures[1].SupportsFaces = false;

        // if (!mesh2)
        //     Main.Instance.ConsoleInstance.Log("Couldn't load rosa tendril mesh");

        // var elem3 = appearance.Structures[2].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        // var prefab3 = val6.CreatePrefab();
        // elem3.Prefabs = [ prefab3 ];
        // var mesh3 = prefab3.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("frills_actual");
        // appearance.Structures[2].SupportsFaces = false;

        // if (!mesh3)
        //     Main.Instance.ConsoleInstance.Log("Couldn't load rosa frill mesh");

        // var val7 = definition.AppearancesDefault[0].Structures[0].Element.Prefabs[0].CreatePrefab();
        // var skin = val7.GetComponent<SkinnedMeshRenderer>();
        // skin.sharedMesh = UObject.Instantiate(skin.sharedMesh);
        // AssetsLib.MeshUtils.GenerateBoneData(applicator, val7, 0.25f, 1f, [ prefab1, prefab2, prefab3 ]);

        prefab.AddComponent<RosaBehaviour>();
    }
}