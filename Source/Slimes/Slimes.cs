using SRML.SR.Translation;
using SRML.Utils;
using Newtonsoft.Json;
using MonomiPark.SlimeRancher.Regions;
using SimpleSRmodLibrary.Creation;

namespace TheOceanRange.Slimes;

public static class Slimes
{
    private static readonly int EyeRed = Shader.PropertyToID("_EyeRed");
    private static readonly int EyeGreen = Shader.PropertyToID("_EyeGreen");
    private static readonly int EyeBlue = Shader.PropertyToID("_EyeBlue");
    private static readonly int MouthTop = Shader.PropertyToID("_MouthTop");
    private static readonly int MouthMid = Shader.PropertyToID("_MouthMid");
    private static readonly int MouthBot = Shader.PropertyToID("_MouthBot");
    private static readonly int TopColor = Shader.PropertyToID("_TopColor");
    private static readonly int BottomColor = Shader.PropertyToID("_BottomColor");
    private static readonly int MiddleColor = Shader.PropertyToID("_MiddleColor");
    private static readonly int SpecColor = Shader.PropertyToID("_SpecColor");
    private static readonly int Shininess = Shader.PropertyToID("_Shininess");
    private static readonly int Gloss = Shader.PropertyToID("_Gloss");

    public static void PreLoadAllSlimes()
    {
        var json = JsonConvert.DeserializeObject<Dictionary<string, PediaJsonEntry>>(AssetManager.GetJson("Slimepedia"));
        BasePreLoadSlime(Ids.ROSA_SLIME, Ids.ROSA_PLORT, Ids.ROSA_SLIME_ENTRY, json["ROSA_SLIME"]);
        // BasePreLoadSlime(Ids.COCO_SLIME, Ids.COCO_PLORT, Ids.COCO_SLIME_ENTRY, json["COCO_SLIME"]);
        // BasePreLoadSlime(Ids.SAND_SLIME, Ids.SAND_PLORT, Ids.SAND_SLIME_ENTRY, json["SAND_SLIME"]);
        // BasePreLoadSlime(Ids.MINE_SLIME, Ids.MINE_PLORT, Ids.MINE_SLIME_ENTRY, json["MINE_SLIME"]);
        // BasePreLoadSlime(Ids.LANTERN_SLIME, Ids.LANTERN_PLORT, Ids.LANTERN_SLIME_ENTRY, json["LANTERN_SLIME"]);
    }

    private static void BasePreLoadSlime(IdentifiableId slimeId, IdentifiableId plortId, PediaId entry, PediaJsonEntry json)
    {
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, plortId);
        PediaRegistry.RegisterIdentifiableMapping(entry, slimeId);
        PediaRegistry.SetPediaCategory(entry, PediaCategory.SLIMES);
        new SlimePediaEntryTranslation(entry)
            .SetTitleTranslation(json.Title)
            .SetIntroTranslation(json.Intro)
            .SetDietTranslation(json.Diet)
            .SetFavoriteTranslation(json.Fav)
            .SetSlimeologyTranslation(json.Slimeology)
            .SetPlortonomicsTranslation(json.Plortonomics);
    }

    public static void LoadAllSlimes()
    {
        BaseLoadSlime("Rosa", Ids.ROSA_SLIME, 0, 0, [], [IdentifiableId.OCTO_BUDDY_TOY], [FoodGroup.MEAT, FoodGroup.FRUIT, FoodGroup.VEGGIES], [], false, IdentifiableId.PINK_SLIME,
            IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, [Zone.REEF], 0.25f, Ids.ROSA_PLORT, InitRosaDetails, true);
        // BaseLoadSlime("Coco", Ids.COCO_SLIME, 0, 0, [], [IdentifiableId.TREASURE_CHEST_TOY], [FoodGroup.MEAT], [], false, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, [Zone.REEF],
            // 0.25f, Ids.COCO_PLORT, InitCocoDetails);
        // BaseLoadSlime("Sand", Ids.SAND_SLIME, 0, 0, [], [IdentifiableId.TREASURE_CHEST_TOY], [FoodGroup.VEGGIES], [], false, IdentifiableId.PINK_SLIME, IdentifiableId.PINK_PLORT, [Zone.REEF],
            // 0.25f, Ids.SAND_PLORT, IniSandDetails);
        // BaseLoadSlime("Mine", Ids.MINE_SLIME, 0, 0, [], [IdentifiableId.BOMB_BALL_TOY], [FoodGroup.MEAT], [], false, IdentifiableId.BOOM_SLIME, IdentifiableId.BOOM_PLORT, [Zone.REEF], 0.25f,
            // Ids.MINE_PLORT, InitMineDetails);
        // BaseLoadSlime("Lantern", Ids.LANTERN_SLIME, 0, 0, [], [IdentifiableId.NIGHT_LIGHT_TOY], [FoodGroup.FRUIT], [], false, IdentifiableId.PHOSPHOR_SLIME, IdentifiableId.PHOSPHOR_PLORT,
            // [Zone.REEF], 0.25f, Ids.LANTERN_PLORT, InitLanternDetails);
    }

    private static void BaseLoadSlime
    (
        string name,
        IdentifiableId slimeId,
        IdentifiableId gordoId,
        IdentifiableId baitId,
        IdentifiableId[] productIds,
        IdentifiableId[] favs,
        FoodGroup[] dietIds,
        IdentifiableId[] additionalFoodIds,
        bool canLargofy,
        IdentifiableId baseSlimeDef,
        IdentifiableId baseSlimeObj,
        IdentifiableId baseSlimePlort,
        Zone[] zones,
        float weight,
        IdentifiableId plortId,
        Action<GameObject, SlimeAppearanceApplicator, SlimeAppearance, SlimeDefinition> initSlimeDetailsAction,
        bool canBeEatenByTarr
    )
    {
        var customSlimeData = new CustomSlimeData
        {
            Id = slimeId,
            GordoId = gordoId,
            BaitId = baitId,
            Zones = zones,
            Weight = weight,
        };

        var slimeByIdentifiableId = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(baseSlimeDef);

        var val = slimeByIdentifiableId.DeepCopy();

        val.Diet.Produces = [..productIds, plortId];
        val.Diet.MajorFoodGroups = dietIds;
        val.Diet.AdditionalFoods = [..additionalFoodIds, IdentifiableId.SPICY_TOFU];
        val.Diet.Favorites = favs;
        val.Diet.EatMap?.Clear();
        val.CanLargofy = canLargofy;
        val.Name = val.name = name;
        val.IdentifiableId = slimeId;

        var pinkPrefab = GameInstance.Instance.LookupDirector.GetPrefab(baseSlimeObj);

        var val2 = pinkPrefab.CreatePrefab();
        val2.name = name;
        val2.GetComponent<PlayWithToys>().slimeDefinition = val;
        val2.GetComponent<SlimeEat>().slimeDefinition = val;
        val2.GetComponent<Identifiable>().id = slimeId;
        val2.GetComponent<Vacuumable>().size = 0;

        if (val2.TryGetComponent<PinkSlimeFoodTypeTracker>(out var tracker))
            tracker.Destroy();

        var val3 = slimeByIdentifiableId.AppearancesDefault[0].DeepCopy();
        val.AppearancesDefault = [ val3 ];
        val3.Structures =
        [
            val3.Structures[0],
            new(val3.Structures[0]),
            new(val3.Structures[0])
        ];

        var val2App = val2.GetComponent<SlimeAppearanceApplicator>();
        val2App.SlimeDefinition = val;
        val2App.Appearance = val3;

        var val8 = PrefabUtils.CopyPrefab(GameInstance.Instance.LookupDirector.GetPrefab(baseSlimePlort));
        val8.name = $"{name}Plort";
        val8.GetComponent<Identifiable>().id = slimeId;
        val8.GetComponent<Vacuumable>().size = 0;

        var val9 = AssetManager.GetSprite($"{name}Icon");
        val3.Icon = val9;

        var defBase = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(baseSlimeObj);

        if (defBase.AppearancesDefault[0].ExplosionAppearance)
            val3.ExplosionAppearance = defBase.AppearancesDefault[0].ExplosionAppearance;

        if (defBase.AppearancesDefault[0].TornadoAppearance)
            val3.TornadoAppearance = defBase.AppearancesDefault[0].TornadoAppearance;

        if (defBase.AppearancesDefault[0].CrystalAppearance)
            val3.CrystalAppearance = defBase.AppearancesDefault[0].CrystalAppearance;

        if (defBase.AppearancesDefault[0].VineAppearance)
            val3.VineAppearance = defBase.AppearancesDefault[0].VineAppearance;

        if (defBase.AppearancesDefault[0].DeathAppearance)
            val3.DeathAppearance = defBase.AppearancesDefault[0].DeathAppearance;

        if (defBase.AppearancesDefault[0].GlintAppearance)
            val3.GlintAppearance = defBase.AppearancesDefault[0].GlintAppearance;

        if (defBase.AppearancesDefault[0].QubitAppearance)
            val3.QubitAppearance = defBase.AppearancesDefault[0].QubitAppearance;

        if (defBase.AppearancesDefault[0].ShockedAppearance)
            val3.ShockedAppearance = defBase.AppearancesDefault[0].ShockedAppearance;

        if (canBeEatenByTarr)
        {
            GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TARR_SLIME).Diet.EatMap.Add(new()
            {
                eats = slimeId,
                becomesId = IdentifiableId.TARR_SLIME,
                driver = SlimeEmotions.Emotion.NONE,
                extraDrive = 999999f
            });
        }

        initSlimeDetailsAction(val2, val2App, val3, slimeByIdentifiableId);

        LookupRegistry.RegisterIdentifiablePrefab(val2);
        SlimeRegistry.RegisterSlimeDefinition(val);
        AmmoRegistry.RegisterAmmoPrefab(0, val2);
        Identifiable.SLIME_CLASS.Add(slimeId);

        LookupRegistry.RegisterVacEntry(slimeId, val3.ColorPalette.Ammo, val9);
        TranslationPatcher.AddActorTranslation($"l.{name}_slime", $"{name} Slime");
        LookupRegistry.RegisterIdentifiablePrefab(val8);
        AmmoRegistry.RegisterAmmoPrefab(0, val8);

        LookupRegistry.RegisterVacEntry(VacItemDefinition.CreateVacItemDefinition(plortId, Color.white, AssetManager.GetSprite($"{name}Plort")));
        AmmoRegistry.RegisterSiloAmmo(x => x is 0 or SiloStorage.StorageType.PLORT, plortId);
        PlortRegistry.AddEconomyEntry(plortId, 12f, 4f);
        PlortRegistry.AddPlortEntry(plortId);
        DroneRegistry.RegisterBasicTarget(plortId);
        AmmoRegistry.RegisterRefineryResource(plortId);
        TranslationPatcher.AddActorTranslation($"l.{name}_plort", $"{name} Plort");
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, plortId);
        Identifiable.PLORT_CLASS.Add(plortId);
        Identifiable.NON_SLIMES_CLASS.Add(plortId);

        customSlimeData.Definition = val;
        customSlimeData.Prefab = val2;

        CreateSpawner(customSlimeData);

        SlimeManager.SlimesMap[slimeId] = customSlimeData;
    }

    private static void InitRosaDetails(GameObject val2, SlimeAppearanceApplicator val2App, SlimeAppearance val3, SlimeDefinition slimeByIdentifiableId)
    {
        var val4 = val3.Structures[0].DefaultMaterials[0].Clone();
        val4.SetColor(TopColor, new Color32(230, 199, 210, 255));
        val4.SetColor(MiddleColor, new Color32(230, 199, 210, 255));
        val4.SetColor(BottomColor, new Color32(230, 199, 210, 255));
        val4.SetColor(SpecColor, new Color32(230, 199, 210, 255));
        val4.SetFloat(Shininess, 1f);
        val4.SetFloat(Gloss, 1f);
        val3.Structures[0].DefaultMaterials = val3.Structures[1].DefaultMaterials = [ val4 ];

        var val4Clone = val4.Clone();
        val4Clone.SetColor(TopColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(MiddleColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(BottomColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(SpecColor, new Color32(178, 62, 101, 255));
        val3.Structures[2].DefaultMaterials = [ val4Clone ];

        foreach (var val5 in val3.Face.ExpressionFaces)
        {
            if (val5.Mouth)
            {
                val5.Mouth.SetColor(MouthBot, Color.black);
                val5.Mouth.SetColor(MouthMid, Color.black);
                val5.Mouth.SetColor(MouthTop, Color.black);
            }

            if (!val5.Eyes)
                continue;

            val5.Eyes.SetColor(EyeRed, Color.black);
            val5.Eyes.SetColor(EyeGreen, Color.black);
            val5.Eyes.SetColor(EyeBlue, Color.black);
        }

        val3.Face.OnEnable();
        val3.ColorPalette = new()
        {
            Top = new Color32(249, 229, 240, 255),
            Middle = new Color32(249, 229, 240, 255),
            Bottom = new Color32(249, 229, 240, 255)
        };

        var val6 = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].Element.Prefabs[0];
        var elem1 = val3.Structures[0].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab1 = val6.gameObject.CreatePrefabCopy().GetComponent<SlimeAppearanceObject>();
        elem1.Prefabs = [ prefab1 ];
        var mesh1 = prefab1.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("slime_rosa");

        if (!mesh1)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa mesh");

        var elem2 = val3.Structures[1].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab2 = val6.CreatePrefab();
        elem2.Prefabs = [ prefab2 ];
        var mesh2 = prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("slime_tendrals");
        val3.Structures[1].SupportsFaces = false;

        if (!mesh2)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa tendril mesh");

        var elem3 = val3.Structures[2].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab3 = val6.CreatePrefab();
        elem3.Prefabs = [ prefab3 ];
        var mesh3 = prefab3.GetComponent<SkinnedMeshRenderer>().sharedMesh = AssetManager.GetMesh("slime_frills");
        val3.Structures[2].SupportsFaces = false;

        if (!mesh3)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa frill mesh");

        var val7 = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].Element.Prefabs[0].CreatePrefab();
        val7.GetComponent<SkinnedMeshRenderer>().sharedMesh = UObject.Instantiate(val7.GetComponent<SkinnedMeshRenderer>().sharedMesh);
        AssetsLib.MeshUtils.GenerateBoneData(val2App, val7, 0.25f, 1f, [ prefab1, prefab2, prefab3 ]);

        var val8 = PrefabUtils.CopyPrefab(GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.PINK_PLORT));
        val8.name = "RosaPlort";
        val8.GetComponent<Identifiable>().id = Ids.ROSA_PLORT;
        val8.GetComponent<Vacuumable>().size = 0;

        var meshRend = val8.GetComponent<MeshRenderer>();
        meshRend.material = new(meshRend.material);
        meshRend.material.SetColor(TopColor, new Color32(237, 169, 96, 255));
        meshRend.material.SetColor(MiddleColor, new Color32(237, 169, 96, 255));
        meshRend.material.SetColor(BottomColor, new Color32(237, 169, 96, 255));

        val3.ColorPalette.Ammo = new Color32(80, 0, 0, 255);

        val2.AddComponent<RosaBehaviour>();
    }

    private static void CreateSpawner(CustomSlimeData data)
    {
        SRCallbacks.PreSaveGameLoad += _ =>
        {
            foreach (var item in UObject.FindObjectsOfType<DirectedSlimeSpawner>().Where(x =>
            {
                var zoneId = x.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || data.Zones.Contains(zoneId);
            }))
            {
                foreach (var val in item.constraints)
                {
                    val.slimeset.members = [.. val.slimeset.members, new()
                    {
                        prefab = data.Prefab,
                        weight = data.Weight
                    }];
                }
            }
        };
    }
}