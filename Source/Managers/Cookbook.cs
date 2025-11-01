using OceanRange.Foods;
using SRML;

namespace OceanRange.Managers;

public static class Cookbook
{
    /// <summary>
    /// The array containing all meat related data.
    /// </summary>
    private static ChimkenData[] Chimkens;

    /// <summary>
    /// The array containing all fruit related data.
    /// </summary>
    private static PlantData[] Fruits;

    /// <summary>
    /// The array containing all veggie related data.
    /// </summary>
    private static PlantData[] Veggies;

    private static bool StmExists; // Mod check flag

    // Shader properties
    private static readonly int Mask = ShaderUtils.GetOrSet("_Mask");
    private static readonly int RampRed = ShaderUtils.GetOrSet("_RampRed");
    private static readonly int RampBlue = ShaderUtils.GetOrSet("_RampBlue");
    private static readonly int RampGreen = ShaderUtils.GetOrSet("_RampGreen");
    private static readonly int RampBlack = ShaderUtils.GetOrSet("_RampBlack");
    private static readonly int SwayStrength = ShaderUtils.GetOrSet("_SwayStrength");
    private static readonly int AmbientOcclusion = ShaderUtils.GetOrSet("_AmbientOcclusion");

    private static Texture2D White;

#if DEBUG
    [TimeDiagnostic("Foods Preload")]
#endif
    public static void PreloadFoodData()
    {
        StmExists = SRModLoader.IsModPresent("sellthingsmod");

        var food = Inventory.GetJson<Ingredients>("cookbook");

        Fruits = food.Fruits;
        Veggies = food.Veggies;
        Chimkens = food.Chimkens;

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
        var dirt = Inventory.GetMesh("dirt");

        foreach (var veggieData in Veggies)
        {
            var lower = veggieData.ResourceIdSuffix.ToLowerInvariant();
            var array = new[] { veggieData.MainId.GetPrefab() };

            foreach (var (zone, spawnLocations) in veggieData.SpawnLocations)
            {
                foreach (var (cell, orientations) in spawnLocations)
                {
                    var parent = GameObject.Find("zone" + zone + "/cell" + cell + "/Sector/Resources").transform;

                    for (var i = 0; i < orientations.Length; i++)
                    {
                        var resource = CreateSpawner(orientations[i], veggiePrefab, parent, context, array, lower + veggieData.Name + "0" + i);
                        resource.gameObject.FindChild("Dirt", true).GetComponent<MeshFilter>().sharedMesh = dirt;
                    }
                }
            }
        }

        var fruitPrefab = Array.Find(resources, x => x.name == "treePogo02" && x.transform.parent?.name == "Resources");

        foreach (var fruitData in Fruits)
        {
            var lower = fruitData.ResourceIdSuffix.ToLowerInvariant();
            var array = new[] { fruitData.MainId.GetPrefab() };

            foreach (var (zone, spawnLocations) in fruitData.SpawnLocations)
            {
                foreach (var (cell, orientations) in spawnLocations)
                {
                    var parent = GameObject.Find("zone" + zone + "/cell" + cell + "/Sector/Resources").transform;

                    for (var i = 0; i < orientations.Length; i++)
                    {
                        var resource = CreateSpawner(orientations[i], fruitPrefab, parent, context, array, lower + fruitData.Name + "0" + i);
                        resource.gameObject.FindChild("tree_pogo", true).GetComponent<MeshFilter>().sharedMesh = Inventory.GetMesh(fruitData.Name.ToLowerInvariant() + "_tree");
                    }
                }
            }
        }
    }

    private static SpawnResource CreateSpawner(Orientation orientation, SpawnResource prefab, Transform parent, SceneContext context, GameObject[] array, string name)
    {
        var resource = prefab.Instantiate(parent);
        resource.transform.position = orientation.Position;
        resource.transform.localEulerAngles = orientation.Rotation;
        resource.name = name;
        resource.ObjectsToSpawn = resource.BonusObjectsToSpawn = array;
        context.GameModel.RegisterResourceSpawner(orientation.Position, resource);
        return resource;
    }

#if DEBUG
    [TimeDiagnostic("Foods Load")]
#endif
    public static void LoadAllFoods()
    {
        White = Inventory.GetTexture2D("all_white");

        Array.ForEach(Fruits, BaseCreatePlant);
        Array.ForEach(Veggies, BaseCreatePlant);
        Array.ForEach(Chimkens, BaseCreateChimken);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseCreateChimken(ChimkenData chimkenData)
    {
        // Fetch ramps and caching values because reusing them is tedious
        var lower = chimkenData.Name.ToLowerInvariant();

        var ramp = $"{lower}_ramp_";
        var redExists = Inventory.TryGetTexture2D($"{ramp}red", out var red);
        var greenExists = Inventory.TryGetTexture2D($"{ramp}green", out var green);
        var blueExists = Inventory.TryGetTexture2D($"{ramp}blue", out var blue);
        var blackExists = Inventory.TryGetTexture2D($"{ramp}black", out var black);

        // Find and create the prefab for chicks and set values
        var chickPrefab = CreateChimken(chimkenData.Name, red, redExists, green, greenExists, blue, blueExists, black, blackExists, chimkenData.ChickId, IdentifiableId.CHICK, "Chickadoo", "Chick");
        var henPrefab = CreateChimken(chimkenData.Name, red, redExists, green, greenExists, blue, blueExists, black, blackExists, chimkenData.MainId, IdentifiableId.HEN, "Hen Hen", "Hen");

        // Set specific data for each prefab
        henPrefab.GetComponent<Reproduce>().childPrefab = chickPrefab;
        chickPrefab.GetComponent<TransformAfterTime>().options[0].targetPrefab = henPrefab;

        chimkenData.InitFoodDetails?.Invoke(null, [henPrefab]);
        chimkenData.InitFoodDetails?.Invoke(null, [chickPrefab]);

        chimkenData.InitHenDetails?.Invoke(null, [henPrefab]);
        chimkenData.InitChickDetails?.Invoke(null, [chickPrefab]);

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

    private static GameObject CreateChimken(string name, Texture2D red, bool redExists, Texture2D green, bool greenExists, Texture2D blue, bool blueExists, Texture2D black, bool blackExists, IdentifiableId id, IdentifiableId baseId,
        string modelName, string type)
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
            if (redExists)
                material.SetTexture(RampRed, red);

            if (greenExists)
                material.SetTexture(RampGreen, green);

            if (blueExists)
                material.SetTexture(RampBlue, blue);

            if (blackExists)
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
        var prefab = plantData.BasePlant!.Value.GetPrefab().CreatePrefab();
        prefab.name = plantData.Type.ToLowerInvariant() + plantData.Name;
        prefab.GetComponent<Identifiable>().id = plantData.MainId;
        prefab.GetComponent<Vacuumable>().size = 0;

        var meshModel = prefab.FindChildWithPartialName("model_");

        var lower = plantData.Name.ToLowerInvariant();

        var mesh = Inventory.GetMesh(lower + "_" + plantData.Type.ToLowerInvariant());

        mesh.RecalculateBounds();
        mesh.RecalculateNormals();
        mesh.RecalculateTangents();

        meshModel.GetComponent<MeshFilter>().sharedMesh = mesh;
        prefab.GetComponent<MeshFilter>().sharedMesh = mesh;

        if (plantData.AdjustColliders)
        {
            var bounds = mesh.bounds;
            var size = bounds.size;
            var center = bounds.center;

            if (prefab.TryGetComponent<SphereCollider>(out var sphere))
            {
                sphere.center = center;
                sphere.radius = Mathf.Max(size.x, size.y, size.z) / 2f;
            }

            if (prefab.TryGetComponent<CapsuleCollider>(out var capsule))
            {
                capsule.center = center;

                var max = Mathf.Max(size.x, size.y, size.z);
                capsule.height = max;

                if (max == size.x)
                {
                    capsule.direction = 0;
                    capsule.radius = Mathf.Max(size.y, size.z) / 2f;
                }
                else if (max == size.y)
                {
                    capsule.direction = 1;
                    capsule.radius = Mathf.Max(size.x, size.z) / 2f;
                }
                else if (max == size.z)
                {
                    capsule.direction = 0;
                    capsule.radius = Mathf.Max(size.y, size.x) / 2f;
                }
            }

            prefab.GetComponent<Rigidbody>().WakeUp();
        }

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
        var maskExists = Inventory.TryGetTexture2D($"{ramp}mask", out var mask);
        var ambientExists = Inventory.TryGetTexture2D($"{ramp}ambient", out var ambient);

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

            if (maskExists)
                material.SetTexture(Mask, mask);

            material.SetTexture(AmbientOcclusion, ambientExists && maskExists ? ambient : White);
        }

        plantData.InitFoodDetails?.Invoke(null, [prefab]);

        var icon = Inventory.GetSprite(lower);
        RegisterFood(prefab, icon, plantData.MainAmmoColor, plantData.MainId, plantData.ExchangeWeight, plantData.Progress, StorageType.NON_SLIMES, StorageType.FOOD);

        var resource = CreateFarmSetup(plantData.BaseResource!.Value, plantData.Name + plantData.ResourceIdSuffix, plantData.ResourceId, prefab);
        var resourceDlx = CreateFarmSetup(plantData.BaseResourceDlx, plantData.Name + plantData.ResourceIdSuffix + "Dlx", plantData.DlxResourceId, prefab);

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

    private static GameObject CreateFarmSetup(SpawnResourceId baseFarm, string patchName, SpawnResourceId spawnResource, GameObject plant)
    {
        var prefab = baseFarm.GetResourcePrefab().CreatePrefab();
        prefab.name = patchName;
        var component = prefab.GetComponent<SpawnResource>();
        component.id = spawnResource;
        component.ObjectsToSpawn = [plant];
        component.BonusObjectsToSpawn = [];
        var partial = plant.FindChildWithPartialName("model_");
        var mesh = partial.GetComponent<MeshFilter>().sharedMesh;
        TranslateModel(prefab.FindChildren("Sprout"), mesh, null);
        TranslateModel(component.SpawnJoints.Select(x => x.gameObject), mesh, partial.GetComponent<MeshRenderer>().sharedMaterial);
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

    [UsedImplicitly]
    public static void InitBlowtatoFoodDetails(GameObject prefab)
    {
        prefab.AddComponent<BlowtatoBehaviour>();
        BlowtatoBehaviour.ExplodeFX = IdentifiableId.BOOM_SLIME.GetSlimeDefinition().AppearancesDefault[0].ExplosionAppearance.explodeFx.CreatePrefab();
    }

    [UsedImplicitly]
    public static void InitStickyFoodDetails(GameObject prefab)
    {
        foreach (var collider in prefab.GetComponents<Collider>())
        {
            collider.material.staticFriction *= 2f;
            collider.material.dynamicFriction *= 2f;
        }
    }

    [UsedImplicitly]
    public static void InitRadiantFoodDetails(GameObject prefab) => IdentifiableId.PHOSPHOR_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[3].Element.Prefabs[0].Instantiate(prefab.transform);

    [UsedImplicitly]
    public static void InitRadiantHenDetails(GameObject prefab) => prefab.transform.GetChild(3).localPosition = new(0f, -0.3f, 0f);

    [UsedImplicitly]
    public static void InitRadiantChickDetails(GameObject prefab)
    {
        var glow = prefab.transform.GetChild(4);
        glow.localPosition = new(0f, -0.3f, 0f);
        glow.localScale = Vector3.one / 2f;
    }
}