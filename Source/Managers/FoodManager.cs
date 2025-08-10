using AssetsLib;
using SRML;

namespace OceanRange.Managers;

public static class FoodManager
{
    /// <summary>
    /// The array containing all meat related data.
    /// </summary>
    public static CustomChimkenData[] Chimkens;

    /// <summary>
    /// The array containing all plant related data.
    /// </summary>
    public static CustomPlantData[] Plants;

    private static bool StmExists; // Mod check flag

    // Shader properties
    private static readonly int RampRed = Shader.PropertyToID("_RampRed");
    private static readonly int RampGreen = Shader.PropertyToID("_RampGreen");
    private static readonly int RampBlue = Shader.PropertyToID("_RampBlue");
    private static readonly int RampBlack = Shader.PropertyToID("_RampBlack");

#if DEBUG
    [TimeDiagnostic("Foods Preload")]
#endif
    public static void PreLoadFoodData()
    {
        StmExists = SRModLoader.IsModPresent("sellthingsmod");

        Chimkens = AssetManager.GetJsonArray<CustomChimkenData>("chimkenpedia");
        Plants = AssetManager.GetJsonArray<CustomPlantData>("plantpedia");

        Ids.DIRT.RegisterId(IdentifiableId.SILKY_SAND_CRAFT);
        TranslationPatcher.AddUITranslation("m.foodgroup.dirt", "Dirt");

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
        SRCallbacks.OnSaveGameLoaded += OnSaveLoaded;
    }

#if DEBUG
    [TimeDiagnostic("Foods OnSavePreLoad")]
#endif
    private static void PreOnSaveLoad(SceneContext _)
    {
        var spawners = UObject.FindObjectsOfType<DirectedAnimalSpawner>();

        foreach (var chimkenData in Chimkens)
        {
            var amount = chimkenData.SpawnAmount / 2;
            var henPrefab = chimkenData.MainId.GetPrefab();
            var chickPrefab = chimkenData.ChickId.GetPrefab();

            foreach (var animalSpawner in spawners.Where(spawner => Helpers.IsValidZone(spawner, chimkenData.Zones)))
            {
                foreach (var constraint in animalSpawner.constraints)
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
        }
    }

#if DEBUG
    [TimeDiagnostic("Foods OnSaveLoad")]
#endif
    private static void OnSaveLoaded(SceneContext context)
    {
        var resources = UObject.FindObjectsOfType<SpawnResource>();
        var veggiePrefab = Array.Find(resources, IsPatch);
        var fruitPrefab = Array.Find(resources, IsTree);

        // FIXME: Dirt in veggie patches are invisible for some reason
        foreach (var plantData in Plants)
        {
            var prefab = plantData.Group == FoodGroup.VEGGIES ? veggiePrefab : fruitPrefab;
            var name = plantData.ResourceIdSuffix.ToLower() + plantData.Name + "0";
            var array = new[] { plantData.MainId.GetPrefab() };

            foreach (var (zone, spawnLocations) in plantData.SpawnLocations)
            {
                foreach (var (cell, positions) in spawnLocations)
                {
                    var parent = GameObject.Find("zone" + zone + "/cell" + cell + "/Sector/Resources").transform;

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
            }
        }
    }

    private static readonly Predicate<SpawnResource> IsPatch = IsCarrotPatch;
    private static readonly Predicate<SpawnResource> IsTree = IsPogoTree;

    private static bool IsCarrotPatch(SpawnResource x) => x.name == "patchCarrot02" && x.transform.parent?.name == "Resources";

    private static bool IsPogoTree(SpawnResource x) => x.name == "treePogo02" && x.transform.parent?.name == "Resources";

#if DEBUG
    [TimeDiagnostic("Foods Load")]
#endif
    public static void LoadAllFoods()
    {
        Array.ForEach(Chimkens, BaseCreateChimken);
        Array.ForEach(Plants, BaseCreatePlant);
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
        var ramp = $"{lower}_ramp_";
        var red = AssetManager.GetTexture2D($"{ramp}red");
        var green = AssetManager.GetTexture2D($"{ramp}green");
        var blue = AssetManager.GetTexture2D($"{ramp}blue");
        var black = AssetManager.GetTexture2D($"{ramp}black");

        // Find and create the prefab for chicks and set values
        var chickPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.ChickId, IdentifiableId.CHICK, "Chickadoo", "Chick");
        var henPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.MainId, IdentifiableId.HEN, "Hen Hen", "Hen");

        // Set specific data for each prefab
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        chickPrefab.GetComponent<TransformAfterTime>().options[0].targetPrefab = henPrefab;

        // Register both chicks and hens
        var chickIcon = AssetManager.GetSprite($"{lower}_chick");
        RegisterFood(chickPrefab, chickIcon, chimkenData.MainAmmoColor, chimkenData.ChickId, chimkenData.ChickEntry, -1, chimkenData.Progress, StorageType.NON_SLIMES);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.ChickEntry, chimkenData.Name + " Chick", chimkenData.ChickIntro, "Future Meat", "(not a slime food)",
            CommonChickAboutPedia.Replace("%type%", chimkenData.Name), CommonChickRanchPedia.Replace("%type%", chimkenData.Name));

        var henIcon = AssetManager.GetSprite($"{lower}_hen");
        RegisterFood(henPrefab, henIcon, chimkenData.MainAmmoColor, chimkenData.MainId, chimkenData.MainEntry, chimkenData.ExchangeWeight, chimkenData.Progress, StorageType.NON_SLIMES, StorageType.FOOD);
        SlimePediaCreation.CreateSlimePediaForItemWithName(chimkenData.MainEntry, chimkenData.Name + " Hen", chimkenData.MainIntro, "Meat", chimkenData.PediaFavouredBy, chimkenData.About,
            CommonHenRanchPedia.Replace("%type%", chimkenData.Name));

        if (Main.ClsExists)
        {
            Main.AddIconBypass(henIcon);
            Main.AddIconBypass(chickIcon);
        }

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

    private static void RegisterFood(GameObject prefab, Sprite icon, Color ammo, IdentifiableId id, PediaId pediaId, int exchangeWeight, ProgressType[] progress, params StorageType[] siloStorage)
    {
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, id);
        LookupRegistry.RegisterVacEntry(id, ammo, icon);
        SlimePediaCreation.PreLoadSlimePediaConnection(pediaId, id, PediaCategory.RESOURCES);
        PediaRegistry.RegisterIdEntry(pediaId, icon);
        AmmoRegistry.RegisterSiloAmmo(siloStorage.Contains, id);

        if (exchangeWeight != -1)
            Helpers.CreateRanchExchangeOffer(id, exchangeWeight, progress);
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

        var ramp = $"{lower}_ramp_";
        var red = AssetManager.GetTexture2D($"{ramp}red");
        var green = AssetManager.GetTexture2D($"{ramp}green");
        var blue = AssetManager.GetTexture2D($"{ramp}blue");
        var black = AssetManager.GetTexture2D($"{ramp}black");

        material.SetTexture(RampRed, red);
        material.SetTexture(RampGreen, green);
        material.SetTexture(RampBlue, blue);
        material.SetTexture(RampBlack, black);

        var cycle = prefab.GetComponent<ResourceCycle>();
        var material2 = cycle.rottenMat = cycle.rottenMat.Clone();

        material2.SetTexture(RampRed, red);
        material2.SetTexture(RampGreen, green);
        material2.SetTexture(RampBlue, blue);
        material2.SetTexture(RampBlack, black);

        var icon = AssetManager.GetSprite(lower);
        RegisterFood(prefab, icon, plantData.MainAmmoColor, plantData.MainId, plantData.MainEntry, plantData.ExchangeWeight, plantData.Progress, StorageType.NON_SLIMES, StorageType.FOOD);
        SlimePediaCreation.CreateSlimePediaForItemWithName(plantData.MainEntry, plantData.Name, plantData.MainIntro, plantData.Type, plantData.PediaFavouredBy, plantData.About,
            CommonPlantPedia.Replace("%type%", plantData.Name).Replace("%food%", plantData.Garden));

        var resource = CreateFarmSetup(isVeggie ? SpawnResource.Id.CARROT_PATCH : SpawnResource.Id.POGO_TREE, plantData.Name + plantData.ResourceIdSuffix, plantData.ResourceId, prefab);
        var resourceDlx = CreateFarmSetup(isVeggie ? SpawnResource.Id.CARROT_PATCH_DLX : SpawnResource.Id.POGO_TREE_DLX, plantData.Name + plantData.ResourceIdSuffix + "Dlx", plantData.DlxResourceId, prefab);
        LookupRegistry.RegisterSpawnResource(resource);
        LookupRegistry.RegisterSpawnResource(resourceDlx);
        PlantSlotRegistry.RegisterPlantSlot(new()
        {
            id = plantData.MainId,
            deluxePlantedPrefab = resourceDlx,
            plantedPrefab = resource
        });

        if (Main.ClsExists)
            Main.AddIconBypass(icon);

        if (!StmExists)
            return;

        PlortRegistry.AddEconomyEntry(plantData.MainId, plantData.BasePrice, plantData.Saturation);
        PlortRegistry.AddPlortEntry(plantData.MainId, plantData.Progress);
    }

    private static GameObject CreateFarmSetup(SpawnResource.Id baseFarm, string patchName, SpawnResource.Id spawnResource, GameObject plant)
    {
        var basePrefab = baseFarm.GetResourcePrefab();
        var prefab = basePrefab.CreatePrefab();
        prefab.name = patchName;
        var component = prefab.GetComponent<SpawnResource>();
        var prefabComponent = basePrefab.GetComponent<SpawnResource>();
        component.id = spawnResource;
        component.ObjectsToSpawn = [plant];
        component.BonusObjectsToSpawn = [];
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