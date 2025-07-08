namespace TheOceanRange.Managers;

public static class FoodManager
{
    public static readonly Dictionary<IdentifiableId, CustomFoodData> FoodsMap = [];

    private static readonly int RampRed = Shader.PropertyToID("_RampRed");
    private static readonly int RampGreen = Shader.PropertyToID("_RampGreen");
    private static readonly int RampBlue = Shader.PropertyToID("_RampBlue");
    private static readonly int RampBlack = Shader.PropertyToID("_RampBlack");

    public static void PreLoadFoods()
    {
        PreLoadChimkens();
        PreLoadPlants();
    }

    private static void PreLoadChimkens()
    {
        BasePreLoadChimken(Ids.SANDY_HEN, Ids.SANDY_CHICK, [Zone.REEF, Zone.RUINS, Zone.MOSS], 1f);
    }

    private static void BasePreLoadChimken(IdentifiableId henId, IdentifiableId chickId, Zone[] spawnZones, float spawnWeight)
    {
        Identifiable.NON_SLIMES_CLASS.Add(chickId);
        Identifiable.NON_SLIMES_CLASS.Add(henId);

        Identifiable.CHICK_CLASS.Add(chickId);
        Identifiable.FOOD_CLASS.Add(henId);

        SRCallbacks.PreSaveGameLoad += _ =>
        {
            foreach (var directedAnimalSpawner2 in UObject.FindObjectsOfType<DirectedAnimalSpawner>().Where(spawner =>
            {
                var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || spawnZones.Contains(zoneId);
            }))
            {
                foreach (var constraint in directedAnimalSpawner2.constraints)
                {
                    constraint.slimeset.members =
                    [
                        .. constraint.slimeset.members,
                        new()
                        {
                            prefab = GameContext.Instance.LookupDirector.GetPrefab(henId),
                            weight = spawnWeight / 2
                        },
                        new()
                        {
                            prefab = GameContext.Instance.LookupDirector.GetPrefab(chickId),
                            weight = spawnWeight / 2
                        }
                    ];
                }
            }
        };
    }

    private static void PreLoadPlants()
    {
        // BasePreloadPlant(Ids.BLOWTATO_VEGGIE, FoodGroup.VEGGIES);
    }

    // private static void BasePreloadPlant(IdentifiableId plantId, FoodGroup group)
    // {
    //     Identifiable.NON_SLIMES_CLASS.Add(plantId);
    //     Identifiable.FOOD_CLASS.Add(plantId);

    //     if (group == FoodGroup.FRUIT)
    //         Identifiable.FRUIT_CLASS.Add(plantId);
    //     else if (group == FoodGroup.VEGGIES)
    //         Identifiable.VEGGIE_CLASS.Add(plantId);
    // }

    public static void LoadFoods()
    {
        CreateChimkens(AssetManager.GetJson<Dictionary<string, FoodPediaEntry>>("Chimkenpedia"));
        CreatePlants(AssetManager.GetJson<Dictionary<string, FoodPediaEntry>>("Plantpedia"));
    }

    private const string CommonHenRanchPedia = "%type% hens in close proximity to roostros will periodically lay eggs that produce %type% chickadoos. However, keeping too many hens or roostros in close proximity makes them anxious and egg production will come to a halt. Savvy ranchers with an understanding of the complex nature of chicken romance always keep their coops from exceeding 12 grown chickens.";
    private const string CommonChickAboutPedia = "%type% chickadoos are baby chickens that will eventually grow into a %type% hen or more rarely, a roostro.\n\nChickadoos of all varieties will never be eaten by slimes. Some believe this is because slimes are too kind-hearted to do such a thing. Others believe it's because chickadoos don't yet have enough meat on their bones.";
    private const string CommonChickRanchPedia = "Keep %type% Chickadoos in a safe place and they'll eventually grow into a %type% Hen or Roostro.";

    private static void CreateChimkens(Dictionary<string, FoodPediaEntry> json)
    {
        BaseCreateChimken("Sandy", Ids.SANDY_HEN, Ids.SANDY_HEN_ENTRY, json["SANDY_HEN"], Ids.SANDY_CHICK, Ids.SANDY_CHICK_ENTRY, json["SANDY_CHICK"], [Ids.COCOA_SLIME], "#C2B280");
    }

    private static void BaseCreateChimken
    (
        string name,
        IdentifiableId henId,
        PediaId henEntry,
        FoodPediaEntry henJson,
        IdentifiableId chickId,
        PediaId chickEntry,
        FoodPediaEntry chickJson,
        IdentifiableId[] favouredBy,
        string ammoColor
    )
    {
        var skin = AssetManager.GetTexture2D($"{name}SkinRamp");
        var dark = AssetManager.GetTexture2D($"{name}SkinRampDarker");
        var ammo = ammoColor.HexToColor();

        var chickPrefab = GameContext.Instance.LookupDirector.GetPrefab(IdentifiableId.CHICK).CreatePrefab();
        chickPrefab.name = $"{name} Chick";
        var component = chickPrefab.transform.Find("Chickadoo/mesh_body1").gameObject.GetComponent<SkinnedMeshRenderer>();
        var material = UObject.Instantiate(component.sharedMaterial);
        material.SetTexture(RampRed, dark);
        material.SetTexture(RampGreen, skin);
        material.SetTexture(RampBlue, skin);
        material.SetTexture(RampBlack, skin);
        component.sharedMaterial = material;
        chickPrefab.GetComponent<Identifiable>().id = chickId;
        chickPrefab.GetComponent<Vacuumable>().size = 0;
        LookupRegistry.RegisterIdentifiablePrefab(chickPrefab);
        var chickIcon = AssetManager.GetSprite($"{name}Chick");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, chickId);
        LookupRegistry.RegisterVacEntry(chickId, ammo, chickIcon);
        SlimePediaCreation.PreLoadSlimePediaConnection(chickEntry, chickId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chickEntry, chickJson.Title, chickJson.Intro, "Future Meat", "None", chickJson.About ?? CommonChickAboutPedia.Replace("%type%",
            name), chickJson.Ranch ?? CommonChickRanchPedia.Replace("%type%", name));
        PediaRegistry.RegisterIdEntry(chickEntry, chickIcon);

        var henPrefab = GameContext.Instance.LookupDirector.GetPrefab(IdentifiableId.HEN).CreatePrefab();
        henPrefab.name = $"{name} Chicken";
        var component2 = henPrefab.transform.Find("Hen Hen/mesh_body1").gameObject.GetComponent<SkinnedMeshRenderer>();
        var material2 = UObject.Instantiate(component2.sharedMaterial);
        material2.SetTexture(RampRed, dark);
        material2.SetTexture(RampGreen, skin);
        material2.SetTexture(RampBlue, skin);
        material2.SetTexture(RampBlack, skin);
        component2.sharedMaterial = material2;
        henPrefab.GetComponent<Identifiable>().id = henId;
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        henPrefab.GetComponent<Vacuumable>().size = 0;
        var transformChance = henPrefab.GetComponent<TransformChanceOnReproduce>();
        transformChance.targetPrefab = GameContext.Instance.LookupDirector.GetPrefab(IdentifiableId.ELDER_HEN);
        transformChance.transformChance = 2.5f;
        LookupRegistry.RegisterIdentifiablePrefab(henPrefab);
        var henIcon = AssetManager.GetSprite($"{name}Hen");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, henId);
        LookupRegistry.RegisterVacEntry(henId, ammo, henIcon);
        SlimePediaCreation.PreLoadSlimePediaConnection(henEntry, henId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(henEntry, henJson.Title, henJson.Intro, "Meat", henJson.FavouredBy, henJson.About, henJson.Ranch ??
            CommonHenRanchPedia.Replace("%type%", name));
        PediaRegistry.RegisterIdEntry(henEntry, henIcon);

        chickPrefab.GetComponent<TransformAfterTime>().options =
        [
            new()
            {
                targetPrefab = henPrefab,
                weight = 4.5f
            },
            new()
            {
                targetPrefab = GameContext.Instance.LookupDirector.GetPrefab(IdentifiableId.ROOSTER),
                weight = 3.5f
            }
        ];

        FoodsMap[henId] = new()
        {
            FavouredBy = favouredBy,
            Group = FoodGroup.MEAT
        };
    }

    // private const string CommonPlantPedia = "Deposit a %type% into a garden's depositor and you'll have a large %type% %food% of your very own.";

    private static void CreatePlants(Dictionary<string, FoodPediaEntry> json)
    {
        // BaseCreatePlant("Blowtato", Ids.BLOWTATO_VEGGIE, Ids.BLOWTATO_VEGGIE_ENTRY, json["BLOWTATO_VEGGIE"], [Ids.MINE_SLIME], "#FFFFFF", "crop");
    }

    // private static void BaseCreatePlant
    // (
    //     string name,
    //     IdentifiableId plantId,
    //     PediaId plantEntry,
    //     FoodPediaEntry plantJson,
    //     IdentifiableId[] favouredBy,
    //     string ammoColor,
    //     FoodGroup group,
    //     string type
    // )
    // {
    //     SlimePediaCreation.PreLoadSlimePediaConnection(plantEntry, plantId, PediaCategory.RESOURCES);
    //     SlimePediaCreation.CreateSlimePediaForItemWithName(plantEntry, plantJson.Title, plantJson.Intro, type, plantJson.FavouredBy, plantJson.About, plantJson?.Ranch ??
    //         CommonPlantPedia.Replace("%type%", name).Replace("%food%", type));
    //     PediaRegistry.RegisterIdEntry(plantEntry, null);

    //     FoodsMap[plantId] = new()
    //     {
    //         FavouredBy = favouredBy,
    //         Group = group
    //     };
    // }
}