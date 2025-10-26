using SRML;

namespace OceanRange.Managers;

public static class Cookbook
{
    /// <summary>
    /// The array containing all meat related data.
    /// </summary>
    private static ChimkenData[] Chimkens;

    /// <summary>
    /// The array containing all plant related data.
    /// </summary>
    private static PlantData[] Plants;

    private static bool StmExists; // Mod check flag

    // Shader properties
    private static readonly int RampRed = ShaderUtils.GetOrSet("_RampRed");
    private static readonly int RampGreen = ShaderUtils.GetOrSet("_RampGreen");
    private static readonly int RampBlue = ShaderUtils.GetOrSet("_RampBlue");
    private static readonly int RampBlack = ShaderUtils.GetOrSet("_RampBlack");
    private static readonly int SwayStrength = ShaderUtils.GetOrSet("_SwayStrength");

#if DEBUG
    [TimeDiagnostic("Foods Preload")]
#endif
    public static void PreloadFoodData()
    {
        StmExists = SRModLoader.IsModPresent("sellthingsmod");

        var food = Inventory.GetJson<Ingredients>("cookbook");

        Chimkens = food.Chimkens;
        Plants = food.Plants;

        Ids.DIRT.RegisterId(IdentifiableId.SILKY_SAND_CRAFT);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
        SRCallbacks.OnSaveGameLoaded += OnSaveLoaded;
    }

#if DEBUG
    [TimeDiagnostic("Foods OnSavePreload")]
#endif
    private static void PreOnSaveLoad(SceneContext _)
    {
        var spawners = UObject.FindObjectsOfType<DirectedAnimalSpawner>();

        foreach (var chimkenData in Chimkens)
        {
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
                            weight = chimkenData.SpawnAmount
                        },
                        new()
                        {
                            prefab = chickPrefab,
                            weight = chimkenData.ChickSpawnAmount
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
        var veggiePrefab = Array.Find(resources, x => x.name == "patchCarrot02" && x.transform.parent?.name == "Resources");
        var fruitPrefab = Array.Find(resources, x => x.name == "treePogo02" && x.transform.parent?.name == "Resources");
        var dirt = Inventory.GetMesh("dirt");

        // FIXME: Dirt in veggie patches are invisible for some reason
        foreach (var plantData in Plants)
        {
            var prefab = plantData.IsVeggie ? veggiePrefab : fruitPrefab;
            var lower = plantData.ResourceIdSuffix.ToLowerInvariant();
            var array = new[] { plantData.MainId.GetPrefab() };

            foreach (var (zone, spawnLocations) in plantData.SpawnLocations)
            {
                foreach (var (cell, orientations) in spawnLocations)
                {
                    var parent = GameObject.Find("zone" + zone + "/cell" + cell + "/Sector/Resources").transform;

                    for (var i = 0; i < orientations.Length; i++)
                    {
                        var pos = orientations[i];
                        var resource = prefab.Instantiate(parent);
                        resource.transform.position = pos.Position;
                        resource.transform.localEulerAngles = pos.Rotation;
                        resource.name = lower + plantData.Name + "0" + i;
                        resource.ObjectsToSpawn = resource.BonusObjectsToSpawn = array;

                        if (plantData.IsVeggie)
                            resource.gameObject.FindChild("Dirt", true).GetComponent<MeshFilter>().sharedMesh = dirt;

                        context.GameModel.RegisterResourceSpawner(pos.Position, resource);
                    }
                }
            }
        }
    }

#if DEBUG
    [TimeDiagnostic("Foods Load")]
#endif
    public static void LoadAllFoods()
    {
        Array.ForEach(Chimkens, BaseCreateChimken);
        Array.ForEach(Plants, BaseCreatePlant);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseCreateChimken(ChimkenData chimkenData)
    {
        // Fetch ramps and caching values because reusing them is tedious
        var lower = chimkenData.Name.ToLowerInvariant();
        var ramp = $"{lower}_ramp_";
        var red = Inventory.GetTexture2D($"{ramp}red");
        var green = Inventory.GetTexture2D($"{ramp}green");
        var blue = Inventory.GetTexture2D($"{ramp}blue");
        var black = Inventory.GetTexture2D($"{ramp}black");

        // Find and create the prefab for chicks and set values
        var chickPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.ChickId, IdentifiableId.CHICK, "Chickadoo", "Chick");
        var henPrefab = CreateChimken(chimkenData.Name, red, green, blue, black, chimkenData.MainId, IdentifiableId.HEN, "Hen Hen", "Hen");

        // Set specific data for each prefab
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        chickPrefab.GetComponent<TransformAfterTime>().options[0].targetPrefab = henPrefab;

        // Register both chicks and hens
        var chickIcon = Inventory.GetSprite($"{lower}_chick");
        RegisterFood(chickPrefab, chickIcon, chimkenData.MainAmmoColor, chimkenData.ChickId, -1, chimkenData.Progress, StorageType.NON_SLIMES);

        var henIcon = Inventory.GetSprite($"{lower}_hen");
        RegisterFood(henPrefab, henIcon, chimkenData.MainAmmoColor, chimkenData.MainId, chimkenData.ExchangeWeight, chimkenData.Progress, StorageType.NON_SLIMES, StorageType.FOOD);

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
        prefab.GetComponent<Identifiable>().id = id;
        prefab.GetComponent<Vacuumable>().size = 0;

        var component = prefab.transform.Find($"{modelName}/mesh_body1").GetComponent<SkinnedMeshRenderer>();
        var component2 = prefab.transform.Find($"{modelName}/root/handle_cog/loc_core/mesh_body MED").GetComponent<MeshRenderer>();
        var component3 = prefab.transform.Find($"{modelName}/root/handle_cog/loc_core/mesh_body LOW").GetComponent<MeshRenderer>();

        var materials = new Material[3];
        materials[0] = component.sharedMaterial = component.sharedMaterial.Clone();
        materials[1] = component2.sharedMaterial = component2.sharedMaterial.Clone();
        materials[2] = component3.sharedMaterial = component3.sharedMaterial.Clone();

        foreach (var material in materials)
        {
            material.SetTexture(RampRed, red);
            material.SetTexture(RampGreen, green);
            material.SetTexture(RampBlue, blue);
            material.SetTexture(RampBlack, black);
        }

        return prefab;
    }

    private static void RegisterFood(GameObject prefab, Sprite icon, Color ammo, IdentifiableId id, int exchangeWeight, ProgressType[] progress, params StorageType[] siloStorage)
    {
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, id);
        LookupRegistry.RegisterVacEntry(id, ammo, icon);
        PediaRegistry.RegisterIdEntry(Helpers.ParseEnum<PediaId>(id.ToString() + "_ENTRY"), icon);
        AmmoRegistry.RegisterSiloAmmo(siloStorage.Contains, id);

        if (exchangeWeight != -1)
            Helpers.CreateRanchExchangeOffer(id, exchangeWeight, progress);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseCreatePlant(PlantData plantData)
    {
        var prefab = plantData.BasePlant.GetPrefab().CreatePrefab();
        prefab.name = plantData.Type.ToLowerInvariant() + plantData.Name;
        prefab.GetComponent<Identifiable>().id = plantData.MainId;
        prefab.GetComponent<Vacuumable>().size = 0;

        var meshModel = prefab.FindChildWithPartialName("model_");

        var lower = plantData.Name.ToLowerInvariant();
        meshModel.GetComponent<MeshFilter>().sharedMesh = Inventory.GetMesh(lower + "_" + plantData.Type.ToLowerInvariant());

        var meshRend = meshModel.GetComponent<MeshRenderer>();
        var cycle = prefab.GetComponent<ResourceCycle>();

        var materials = new Material[2];
        materials[0] = meshRend.sharedMaterial = meshRend.sharedMaterial.Clone();
        materials[1] = cycle.rottenMat = cycle.rottenMat.Clone();

        var ramp = $"{lower}_ramp_";
        var redExists = Inventory.TryGetTexture2D($"{ramp}red", out var red);
        var greenExists = Inventory.TryGetTexture2D($"{ramp}green", out var green);
        var blueExists = Inventory.TryGetTexture2D($"{ramp}blue", out var blue);
        var blackExists = Inventory.TryGetTexture2D($"{ramp}black", out var black);

        foreach (var material in materials)
        {
            material.SetFloat(SwayStrength, 0.01f);

            if (redExists)
                material.SetTexture(RampRed, red);

            if (greenExists)
                material.SetTexture(RampGreen, green);

            if (blueExists)
                material.SetTexture(RampBlue, blue);

            if (blackExists)
                material.SetTexture(RampBlack, black);
        }

        var icon = Inventory.GetSprite(lower);
        RegisterFood(prefab, icon, plantData.MainAmmoColor, plantData.MainId, plantData.ExchangeWeight, plantData.Progress, StorageType.NON_SLIMES, StorageType.FOOD);

        var resource = CreateFarmSetup(plantData.BaseResource, plantData.Name + plantData.ResourceIdSuffix, plantData.ResourceId, prefab, lower);
        var resourceDlx = CreateFarmSetup(plantData.BaseResourceDlx, plantData.Name + plantData.ResourceIdSuffix + "Dlx", plantData.DlxResourceId, prefab, lower);
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

    private static GameObject CreateFarmSetup(SpawnResourceId baseFarm, string patchName, SpawnResourceId spawnResource, GameObject plant, string lowerName)
    {
        var prefab = baseFarm.GetResourcePrefab().CreatePrefab();
        prefab.name = patchName;
        var component = prefab.GetComponent<SpawnResource>();
        component.id = spawnResource;
        component.ObjectsToSpawn = [plant];
        component.BonusObjectsToSpawn = [];
        TranslateModel(prefab.FindChildren("Sprout"), Inventory.GetMesh(lowerName + "_sprout"), null);
        var partial = plant.FindChildWithPartialName("model_");
        TranslateModel(component.SpawnJoints.Select(x => x.gameObject), partial.GetComponent<MeshFilter>().sharedMesh, partial.GetComponent<MeshRenderer>().sharedMaterial);
        return prefab;
    }

    private static void TranslateModel(IEnumerable<GameObject> gameObjects, Mesh mesh, Material material)
    {
        foreach (var gameObj in gameObjects)
        {
            gameObj.GetComponent<MeshFilter>().sharedMesh = mesh;

            if (material)
                gameObj.GetComponent<MeshRenderer>().sharedMaterial = material;
        }
    }
}