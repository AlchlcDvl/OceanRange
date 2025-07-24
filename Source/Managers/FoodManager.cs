using AssetsLib;
using SRML;

namespace OceanRange.Managers;

public static class FoodManager
{
    public static readonly List<CustomFoodData> Foods = [];

    private static bool StmExists;

    private static readonly List<CustomChimkenData> Chimkens = [];
    private static readonly List<CustomPlantData> Plants = [];

    private static readonly int RampRed = Shader.PropertyToID("_RampRed");
    private static readonly int RampGreen = Shader.PropertyToID("_RampGreen");
    private static readonly int RampBlue = Shader.PropertyToID("_RampBlue");
    private static readonly int RampBlack = Shader.PropertyToID("_RampBlack");
    private static readonly int Color1 = Shader.PropertyToID("_Color");

#if DEBUG
    [TimeDiagnostic("Foods Preload")]
#endif
    public static void PreLoadFoodData()
    {
        StmExists = SRModLoader.IsModPresent("sellthingsmod");

        Chimkens.AddRange(AssetManager.GetJson<CustomChimkenData[]>("chimkenpedia"));
        Plants.AddRange(AssetManager.GetJson<CustomPlantData[]>("plantpedia"));

        Foods.AddRange(Chimkens);
        Foods.AddRange(Plants);

        AssetManager.UnloadAsset<JsonAsset>("chimkenpedia");
        AssetManager.UnloadAsset<JsonAsset>("plantpedia");

        Chimkens.ForEach(BasePreLoadChimken);
        Plants.ForEach(BasePreloadPlant);

        new[] { FoodGroup.VEGGIES, FoodGroup.FRUIT, FoodGroup.MEAT }.Do(x => SlimeEat.foodGroupIds[x] = [..SlimeEat.foodGroupIds[x], ..Foods.Where(y => y.Group == x).Select(y => y.MainId)]);
    }

    private static void BasePreLoadChimken(CustomChimkenData chimkenData)
    {
        var amount = chimkenData.SpawnAmount / 2;

        SRCallbacks.PreSaveGameLoad += _ =>
        {
            var henPrefab = chimkenData.MainId.GetPrefab();
            var chickPrefab = chimkenData.ChickId.GetPrefab();

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

    private static SpawnResource VeggieSpawnPrefab;
    private static SpawnResource FruitSpawnPrefab;

    private static void BasePreloadPlant(CustomPlantData plantData) => SRCallbacks.PreSaveGameLoad += context =>
    {
        VeggieSpawnPrefab ??= AssetManager.GetResource<SpawnResource>("patchCarrot02");
        FruitSpawnPrefab ??= AssetManager.GetResource<SpawnResource>("treePogo02");

        var name = plantData.Name + plantData.ResourceIdSuffix + "0";
        var array = new GameObject[1] { plantData.MainId.GetPrefab() };
        var prefab = plantData.Group == FoodGroup.VEGGIES ? VeggieSpawnPrefab : FruitSpawnPrefab;

        foreach (var (cell, positions) in plantData.SpawnLocations)
        {
            var parent = AssetManager.GetResource<GameObject>("cell" + cell).FindChild("Sector/Resources").transform;

            for (var i = 0; i < positions.Length; i++)
            {
                var pos = positions[i];
                var resource = prefab.Instantiate(parent);
                resource.transform.position = pos;
                resource.name = name + i;
                resource.ObjectsToSpawn = resource.BonusObjectsToSpawn = array;
                context.GameModel.RegisterResourceSpawner(pos, resource);
            }
        }
    };

#if DEBUG
    [TimeDiagnostic("Foods Load")]
#endif
    public static void LoadFoods()
    {
        Chimkens.ForEach(BaseCreateChimken);
        Plants.ForEach(BaseCreatePlant);
    }

    private const string CommonHenRanchPedia = "%type% hens in close proximity to roostros will periodically lay eggs that produce %type% chickadoos. However, keeping too many hens or roostros in close proximity makes them anxious and egg production will come to a halt. Savvy ranchers with an understanding of the complex nature of chicken romance always keep their coops from exceeding 12 grown chickens.";
    private const string CommonChickAboutPedia = "%type% chickadoos are baby chickens that will eventually grow into a %type% hen or more rarely, a roostro.\n\nChickadoos of all varieties will never be eaten by slimes. Some believe this is because slimes are too kind-hearted to do such a thing. Others believe it's because chickadoos don't yet have enough meat on their bones.";
    private const string CommonChickRanchPedia = "Keep %type% Chickadoos in a safe place and they'll eventually grow into a %type% Hen or Roostro.";

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseCreateChimken(CustomChimkenData chimkenData)
    {
        // Fetch ramps and caching values because reusing them is tedious
        var lower = chimkenData.Name.ToLower();
        var ramp = $"{lower}skinramp";
        var red = AssetManager.GetTexture2D($"{ramp}red");
        var green = AssetManager.GetTexture2D($"{ramp}green");
        var blue = AssetManager.GetTexture2D($"{ramp}blue");
        var black = AssetManager.GetTexture2D($"{ramp}black");
        var ammo = chimkenData.MainAmmoColor.HexToColor();

        // Find and create the prefab for chicks and set values
        var chickPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.ChickId, IdentifiableId.CHICK, "Chickadoo", "Chick");
        var henPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.MainId, IdentifiableId.HEN, "Hen Hen", "Hen");

        // Set specific data for each prefab
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        var transformChance = henPrefab.GetComponent<TransformChanceOnReproduce>();
        transformChance.targetPrefab = IdentifiableId.ELDER_HEN.GetPrefab();
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
                targetPrefab = IdentifiableId.ROOSTER.GetPrefab(),
                weight = 3.5f
            }
        ];

        // Register both chicks and hens
        RegisterFood(chickPrefab, AssetManager.GetSprite($"{lower}chick"), ammo, chimkenData.ChickId, chimkenData.ChickEntry, [StorageType.NON_SLIMES]);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.ChickEntry, chimkenData.Name + " Chick", chimkenData.ChickIntro, "Future Meat", "(not a slime food)",
            CommonChickAboutPedia.Replace("%type%",  chimkenData.Name), CommonChickRanchPedia.Replace("%type%", chimkenData.Name));

        RegisterFood(henPrefab, AssetManager.GetSprite($"{lower}hen"), ammo, chimkenData.MainId, chimkenData.MainEntry, [StorageType.NON_SLIMES, StorageType.FOOD]);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.MainEntry, chimkenData.Name + " Hen", chimkenData.MainIntro, "Meat", chimkenData.PediaFavouredBy, chimkenData.About,
            CommonHenRanchPedia.Replace("%type%", chimkenData.Name));

        // Compatibility
        if (!StmExists)
            return;

        PlortRegistry.AddEconomyEntry(chimkenData.MainId, chimkenData.BasePrice, chimkenData.Saturation);
        PlortRegistry.AddPlortEntry(chimkenData.MainId, chimkenData.Progress);
    }

    private static GameObject CreateChimken(string name, Texture red, Texture green, Texture blue, Texture black, IdentifiableId id, IdentifiableId baseId, string modelName, string type)
    {
        var prefab = baseId.GetPrefab().CreatePrefab();
        prefab.name = $"bird{type}{name}";
        var component = prefab.transform.Find($"{modelName}/mesh_body1").GetComponent<SkinnedMeshRenderer>();
        var material = component.material = component.sharedMaterial = component.sharedMaterial.Clone();
        material.SetTexture(RampRed, red);
        material.SetTexture(RampGreen, green);
        material.SetTexture(RampBlue, blue);
        material.SetTexture(RampBlack, black);
        prefab.GetComponent<Identifiable>().id = id;
        prefab.GetComponent<Vacuumable>().size = 0;
        return prefab;
    }

    private static void RegisterFood(GameObject prefab, Sprite icon, Color ammo, IdentifiableId id, PediaId pediaId, StorageType[] siloStorage)
    {
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, id);
        LookupRegistry.RegisterVacEntry(id, ammo, icon);
        SlimePediaCreation.PreLoadSlimePediaConnection(pediaId, id, PediaCategory.RESOURCES);
        PediaRegistry.RegisterIdEntry(pediaId, icon);
        AmmoRegistry.RegisterSiloAmmo(siloStorage.Contains, id);
    }

    private const string CommonPlantPedia = "Deposit a %type% into a garden's depositor and you'll have a large %type% %food% of your very own.";

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseCreatePlant(CustomPlantData plantData)
    {
        var isVeggie = plantData.Group == FoodGroup.VEGGIES;

        var prefab = (isVeggie ? IdentifiableId.CARROT_VEGGIE : IdentifiableId.POGO_FRUIT).GetPrefab().CreatePrefab();
        prefab.name = plantData.Type.ToLower() + plantData.Name;
        prefab.GetComponent<Identifiable>().id = plantData.MainId;
        prefab.GetComponent<Vacuumable>().size = 0;

        var meshModel = prefab.FindChildWithPartialName("model_");
        var lower = plantData.Name.ToLower();
        meshModel.GetComponent<MeshFilter>().sharedMesh = AssetManager.GetMesh(lower);

        var meshRend = meshModel.GetComponent<MeshRenderer>();
        var material = meshRend.material = meshRend.material.Clone();

        var ramp = lower + "ramp";
        material.SetTexture(RampRed, AssetManager.GetTexture2D($"{ramp}red"));
        material.SetTexture(RampGreen, AssetManager.GetTexture2D($"{ramp}green"));
        material.SetTexture(RampBlue, AssetManager.GetTexture2D($"{ramp}blue"));
        material.SetTexture(RampBlack, AssetManager.GetTexture2D($"{ramp}black"));

        var material2 = prefab.GetComponent<ResourceCycle>().rottenMat = material.Clone();
        material2.SetColor(Color1, "#333333".HexToColor());

        RegisterFood(prefab, AssetManager.GetSprite(lower), plantData.MainAmmoColor.HexToColor(), plantData.MainId, plantData.MainEntry, [StorageType.NON_SLIMES, StorageType.FOOD]);
        SlimePediaCreation.CreateSlimePediaForItemWithName(plantData.MainEntry, plantData.Name, plantData.MainIntro, plantData.Type, plantData.PediaFavouredBy, plantData.About,
            CommonPlantPedia.Replace("%type%", plantData.Name).Replace("%food%", plantData.Garden));

        var resource = CreateFarmSetup(isVeggie ? SpawnResource.Id.CARROT_PATCH : SpawnResource.Id.POGO_TREE, plantData.Name + plantData.ResourceIdSuffix, plantData.ResourceId, prefab, default, false);
        var resourceDlx = CreateFarmSetup(isVeggie ? SpawnResource.Id.CARROT_PATCH_DLX : SpawnResource.Id.POGO_TREE_DLX, plantData.Name + plantData.ResourceIdSuffix + "Dlx", plantData.DlxResourceId, prefab, default, true);
        LookupRegistry.RegisterSpawnResource(resource);
        LookupRegistry.RegisterSpawnResource(resourceDlx);
        PlantSlotRegistry.RegisterPlantSlot(new()
        {
            id = plantData.MainId,
            deluxePlantedPrefab = resourceDlx,
            plantedPrefab = resource
        });

        if (!StmExists)
            return;

        PlortRegistry.AddEconomyEntry(plantData.MainId, plantData.BasePrice, plantData.Saturation);
        PlortRegistry.AddPlortEntry(plantData.MainId, plantData.Progress);
    }

    private static GameObject CreateFarmSetup(SpawnResource.Id baseFarm, string patchName, SpawnResource.Id spawnResource, GameObject plant, Vector3 transformPosition, bool isDlx)
    {
        var basePrefab = baseFarm.GetResourcePrefab();
        var prefab = basePrefab.CreatePrefab();
        prefab.transform.position -= transformPosition;
        prefab.name = patchName;
        var component = prefab.GetComponent<SpawnResource>();
        var prefabComponent = basePrefab.GetComponent<SpawnResource>();
        component.id = spawnResource;
        component.ObjectsToSpawn = [plant];
        component.BonusObjectsToSpawn = [plant];
        component.MaxObjectsSpawned = prefabComponent.MaxObjectsSpawned * (isDlx ? 1.5f : 1);
        component.MinObjectsSpawned = prefabComponent.MinObjectsSpawned * (isDlx ? 1.5f : 1);
        component.MinNutrientObjectsSpawned = prefabComponent.MinNutrientObjectsSpawned;
        component.MinSpawnIntervalGameHours = prefabComponent.MinSpawnIntervalGameHours;
        component.MaxSpawnIntervalGameHours = prefabComponent.MaxSpawnIntervalGameHours;
        component.BonusChance = prefabComponent.BonusChance * (isDlx ? 2 : 1);
        component.minBonusSelections = prefabComponent.minBonusSelections * (isDlx ? 2 : 1);
        var partial = plant.FindChildWithPartialName("model_");
        var mesh = partial.GetComponent<MeshFilter>().sharedMesh;
        var material = partial.GetComponent<MeshRenderer>().sharedMaterial;
        TranslateModel(prefab.FindChildren("Sprout"), mesh, material);
        TranslateModel(component.SpawnJoints.Select(x => x.gameObject), mesh, material);
        return prefab;
    }

    private static void TranslateModel(IEnumerable<GameObject> gameObjects, Mesh mesh, Material material)
    {
        foreach (var gameObj in gameObjects)
        {
            gameObj.GetComponent<MeshFilter>().sharedMesh = mesh;
            gameObj.GetComponent<MeshRenderer>().sharedMaterial = material;
        }
    }
}