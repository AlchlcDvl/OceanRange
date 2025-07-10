namespace TheOceanRange.Managers;

public static class FoodManager
{
    public static readonly List<CustomFoodData> Foods = [];

    private static readonly List<CustomChimkenData> Chimkens = [];
    // private static readonly List<CustomPlantData> Plants = [];

    public static Dictionary<FoodGroup, IdentifiableId[]> FoodGroupIds;

    private static readonly int RampRed = Shader.PropertyToID("_RampRed");
    private static readonly int RampGreen = Shader.PropertyToID("_RampGreen");
    private static readonly int RampBlue = Shader.PropertyToID("_RampBlue");
    private static readonly int RampBlack = Shader.PropertyToID("_RampBlack");

    public static void PreLoadFoodData()
    {
        Chimkens.AddRange(AssetManager.GetJson<CustomChimkenData[]>("Chimkenpedia"));
        // Plants.AddRange(AssetManager.GetJson<CustomPlantData[]>("Plantpedia"));
        Foods.AddRange(Chimkens);
        // FoodsMap.AddRange(Plants);
        AssetManager.JsonData.AddRange(Foods);

        FoodGroupIds = AccessTools.Field(typeof(SlimeEat), "foodGroupIds").GetValue(null) as Dictionary<FoodGroup, IdentifiableId[]>;

        new FoodGroup[] { FoodGroup.VEGGIES, FoodGroup.FRUIT, FoodGroup.MEAT }.Do(x => FoodGroupIds[x] = [.. FoodGroupIds[x], .. Foods.Where(y => y.Group == x).Select(y => y.MainId)]);
    }

    public static void PreLoadFoods()
    {
        Chimkens.ForEach(BasePreLoadChimken);
        // Plants.ForEach(BasePreloadPlant);
    }

    private static void BasePreLoadChimken(CustomChimkenData chimkenData)
    {
        Identifiable.NON_SLIMES_CLASS.Add(chimkenData.ChickId);
        Identifiable.NON_SLIMES_CLASS.Add(chimkenData.MainId);

        Identifiable.CHICK_CLASS.Add(chimkenData.ChickId);

        Identifiable.FOOD_CLASS.Add(chimkenData.MainId);
        Identifiable.MEAT_CLASS.Add(chimkenData.MainId);

        var amount = chimkenData.SpawnAmount / 2;

        SRCallbacks.PreSaveGameLoad += _ =>
        {
            var lookupDir = GameContext.Instance.LookupDirector;
            var henPrefab = lookupDir.GetPrefab(chimkenData.MainId);
            var chickPrefab = lookupDir.GetPrefab(chimkenData.ChickId);

            foreach (var directedAnimalSpawner2 in UObject.FindObjectsOfType<DirectedAnimalSpawner>().Where(spawner =>
            {
                var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || chimkenData.Zones.Contains(zoneId);
            }))
            {
                foreach (var constraint in directedAnimalSpawner2.constraints)
                {
                    constraint.slimeset.members =
                    [
                        .. constraint.slimeset.members,
                        new()
                        {
                            prefab = henPrefab,
                            weight = amount
                        },
                        new()
                        {
                            prefab = chickPrefab,
                            weight = amount
                        }
                    ];
                }
            }
        };
    }

    // private static void BasePreloadPlant(CustomPlantData plantData)
    // {
    //     Identifiable.NON_SLIMES_CLASS.Add(plantData.PlantId);
    //     Identifiable.FOOD_CLASS.Add(plantData.PlantId);

    //     if (plantData.Group == FoodGroup.FRUIT)
    //         Identifiable.FRUIT_CLASS.Add(plantData.PlantId);
    //     else if (plantData.Group == FoodGroup.VEGGIES)
    //         Identifiable.VEGGIE_CLASS.Add(plantData.PlantId);
    // }

    public static void LoadFoods()
    {
        Chimkens.ForEach(BaseCreateChimken);
        // Plants.ForEach(BaseCreatePlant);
    }

    private const string CommonHenRanchPedia = "%type% hens in close proximity to roostros will periodically lay eggs that produce %type% chickadoos. However, keeping too many hens or roostros in close proximity makes them anxious and egg production will come to a halt. Savvy ranchers with an understanding of the complex nature of chicken romance always keep their coops from exceeding 12 grown chickens.";
    private const string CommonChickAboutPedia = "%type% chickadoos are baby chickens that will eventually grow into a %type% hen or more rarely, a roostro.\n\nChickadoos of all varieties will never be eaten by slimes. Some believe this is because slimes are too kind-hearted to do such a thing. Others believe it's because chickadoos don't yet have enough meat on their bones.";
    private const string CommonChickRanchPedia = "Keep %type% Chickadoos in a safe place and they'll eventually grow into a %type% Hen or Roostro.";

    private static void BaseCreateChimken(CustomChimkenData chimkenData)
    {
        // Fetch ramps
        var skin = AssetManager.GetTexture2D($"{chimkenData.Name}SkinRamp");
        var dark = AssetManager.GetTexture2D($"{chimkenData.Name}SkinRampDarker");

        // Cache values because reusing them is tedious
        var ammo = chimkenData.AmmoColor.HexToColor();
        var lookupDir = GameContext.Instance.LookupDirector;

        // Find and create the prefab for chicks and set values
        var chickPrefab = lookupDir.GetPrefab(IdentifiableId.CHICK).CreatePrefab();
        chickPrefab.name = $"birdChick{chimkenData.Name}";
        var component = chickPrefab.transform.Find("Chickadoo/mesh_body1").GetComponent<SkinnedMeshRenderer>();
        var material = component.sharedMaterial = component.sharedMaterial.Clone();
        material.SetTexture(RampRed, dark);
        material.SetTexture(RampGreen, skin);
        material.SetTexture(RampBlue, skin);
        material.SetTexture(RampBlack, skin);
        chickPrefab.GetComponent<Identifiable>().id = chimkenData.ChickId;
        chickPrefab.GetComponent<Vacuumable>().size = 0;

        // Same for hens
        var henPrefab = lookupDir.GetPrefab(IdentifiableId.HEN).CreatePrefab();
        henPrefab.name = $"birdHen{chimkenData.Name}";
        var component2 = henPrefab.transform.Find("Hen Hen/mesh_body1").GetComponent<SkinnedMeshRenderer>();
        var material2 = component2.sharedMaterial = component2.sharedMaterial.Clone();
        material2.SetTexture(RampRed, dark);
        material2.SetTexture(RampGreen, skin);
        material2.SetTexture(RampBlue, skin);
        material2.SetTexture(RampBlack, skin);
        henPrefab.GetComponent<Identifiable>().id = chimkenData.MainId;
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        henPrefab.GetComponent<Vacuumable>().size = 0;
        var transformChance = henPrefab.GetComponent<TransformChanceOnReproduce>();
        transformChance.targetPrefab = lookupDir.GetPrefab(IdentifiableId.ELDER_HEN);
        transformChance.transformChance = 2.5f;

        chickPrefab.GetComponent<TransformAfterTime>().options =
        [
            new()
            {
                targetPrefab = henPrefab,
                weight = 4.5f
            },
            new()
            {
                targetPrefab = lookupDir.GetPrefab(IdentifiableId.ROOSTER),
                weight = 3.5f
            }
        ];

        // Register both chicks and hens

        LookupRegistry.RegisterIdentifiablePrefab(chickPrefab);
        var chickIcon = AssetManager.GetSprite($"{chimkenData.Name}Chick");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, chimkenData.ChickId);
        LookupRegistry.RegisterVacEntry(chimkenData.ChickId, ammo, chickIcon);
        SlimePediaCreation.PreLoadSlimePediaConnection(chimkenData.ChickEntry, chimkenData.ChickId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.ChickEntry, chimkenData.Name + " Chick", chimkenData.ChickIntro, "Future Meat", "None",
            CommonChickAboutPedia.Replace("%type%",  chimkenData.Name), CommonChickRanchPedia.Replace("%type%", chimkenData.Name));
        PediaRegistry.RegisterIdEntry(chimkenData.ChickEntry, chickIcon);
        AmmoRegistry.RegisterSiloAmmo(x => x is SiloStorage.StorageType.NON_SLIMES or SiloStorage.StorageType.FOOD, chimkenData.ChickId);

        LookupRegistry.RegisterIdentifiablePrefab(henPrefab);
        var henIcon = AssetManager.GetSprite($"{chimkenData.Name}Hen");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, chimkenData.MainId);
        LookupRegistry.RegisterVacEntry(chimkenData.MainId, ammo, henIcon);
        SlimePediaCreation.PreLoadSlimePediaConnection(chimkenData.MainEntry, chimkenData.MainId, PediaCategory.RESOURCES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.MainEntry, chimkenData.Name + " Hen", chimkenData.HenIntro, "Meat", chimkenData.PediaFavouredBy, chimkenData.About,
            CommonHenRanchPedia.Replace("%type%", chimkenData.Name));
        PediaRegistry.RegisterIdEntry(chimkenData.MainEntry, henIcon);
        AmmoRegistry.RegisterSiloAmmo(x => x is SiloStorage.StorageType.NON_SLIMES or SiloStorage.StorageType.FOOD, chimkenData.MainId);
    }

    // private const string CommonPlantPedia = "Deposit a %type% into a garden's depositor and you'll have a large %type% %food% of your very own.";

    // private static void BaseCreatePlant(CustomPlantData plantData)
    // {
    //     SlimePediaCreation.PreLoadSlimePediaConnection(plantData.Entry, plantData.PlantId, PediaCategory.RESOURCES);
    //     SlimePediaCreation.CreateSlimePediaForItemWithName(plantData.Entry, plantData.Name, plantData.Intro, plantData.Type, plantData.PediaFavouredBy, plantData.About,
    //         CommonPlantPedia.Replace("%type%", plantData.Name).Replace("%food%", plantData.Garden));
    //     PediaRegistry.RegisterIdEntry(plantData.Entry, AssetManager.GetSprite(plantData.Name));
    //     AmmoRegistry.RegisterSiloAmmo(x => x is SiloStorage.StorageType.NON_SLIMES or SiloStorage.StorageType.FOOD, plantData.MainId);
    // }
}