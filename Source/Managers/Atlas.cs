// using RichPresence;

// namespace OceanRange.Managers;

// [Manager]
// public static class Atlas
// {
//     private static ZoneData[] Zones;
//     private static RegionData[] Regions;

//     private static GameObject WaterSourceBase;
//     private static GameObject TeleporterPrefab;

// #if DEBUG
//     [TimeDiagnostic("Atlas Preload")]
// #endif
//     public static void PreloadMapData()
//     {
//         var world = Inventory.GetJson<World>("atlas");

//         Regions = world.Regions;
//         Zones = world.Zones;

//         SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
//     }

// #if DEBUG
//     [TimeDiagnostic("Atlas PreOnSaveLoad")]
// #endif
//     [PreloadMethod(0)]
//     private static void PreOnSaveLoad(SceneContext context)
//     {
//         // Load regions before the zones or the game implodes

//         if (!WaterSourceBase)
//             WaterSourceBase = GameObject.Find("/zoneREEF/cellReef_Hub/Sector/Resources/waterFountain01");

//         foreach (var region in Regions)
//             PreLoadRegion(context, region);

//         foreach (var zone in Zones)
//             PreLoadZone(context, zone);

//         context.AmbianceDirector.zoneSettings = [.. context.AmbianceDirector.zoneSettings, .. Zones.Select(x => x.AmbianceSetting)];
//     }

//     private static void PreLoadRegion(SceneContext context, RegionData region)
//     {
//         context.RegionRegistry.managedWithSets.Add(region.Region, []);
//         context.RegionRegistry.regionsTrees.Add(region.Region, new(region.InitialWorldSize, region.InitialWorldPos, region.MinNodeSize, region.LoosenessVal));
//     }

//     private static void PreLoadZone(SceneContext context, ZoneData zoneData)
//     {
//         context.AmbianceDirector.zoneDict.Add(zoneData.Ambiance, zoneData.AmbianceSetting);

//         if (!zoneData.PrefabsPrepped)
//         {
//             PrepWaterSources(zoneData.Prefab);
//             PrepFoodSpawners(zoneData.Prefab);
//             PrepSpawners(zoneData.Prefab);
//             PrepMaterials(zoneData.Prefab.GetComponentsInChildren<Renderer>());

//             zoneData.PrefabsPrepped = true;
//         }

//         var enterPortal = TeleporterPrefab.Instantiate(GameObject.Find(zoneData.TeleporterLocation).transform);
//         enterPortal.transform.eulerAngles = zoneData.TeleporterOrientation.Rotation;
//         PrepTeleporter(context, enterPortal.GetComponent<TeleportDestination>(), zoneData.TeleporterOrientation.Position);
//         PrepMaterials(enterPortal.GetComponent<MeshRenderer>());

//         var zoneObject = zoneData.Prefab.Instantiate();

//         foreach (var tp in zoneObject.GetComponentsInChildren<TeleportDestination>())
//             PrepTeleporter(context, tp, Vector3.zero);

//         zoneObject.SetActive(true);

//         if (zoneData.Requirements == null)
//             return;

//         foreach (var (key, value) in zoneData.Requirements)
//         {
//             var obj = GameObject.Find(value.PathToGameObject);

//             switch (key)
//             {
//                 case RequirementType.CorporateLevel:
//                     var progress = obj.AddComponent<ActivateOnProgressRange>();

//                     progress.progressType = ProgressType.CORPORATE_PARTNER;
//                     progress.maxProgress = value.CorporateLevelMax;
//                     progress.minProgress = value.CorporateLevelMin;

//                     break;
//                     // TODO: Do other requirements.
//             }
//         }
//     }

// #if DEBUG
//     [TimeDiagnostic("Atlas Load")]
// #endif
//     [LoadMethod(0)]
//     public static void LoadMap()
//     {
//         TeleporterPrefab = Inventory.GetPrefab("TeleporterDevEntrance");

//         Array.ForEach(Zones, LoadZoneData);
//     }

//     private static void LoadZoneData(ZoneData zoneData)
//     {
//         PediaRegistry.RegisterIdEntry(zoneData.PediaId, null);
//         Director.RICH_PRESENCE_ZONE_LOOKUP.Add(zoneData.Zone, "ranch");

//         ZoneDirector.zonePediaIdLookup.Add(zoneData.Zone, zoneData.PediaId);

//         zoneData.AmbianceSetting = Inventory.GetScriptable<AmbianceDirectorZoneSetting>(zoneData.AssetName + "Amb");
//         zoneData.AmbianceSetting.zone = zoneData.Ambiance;

//         zoneData.Prefab = Inventory.GetPrefab("zone" + zoneData.AssetName);
//         zoneData.Prefab.SetActive(false);

//         zoneData.Prefab.GetComponent<ZoneDirector>().zone = zoneData.Zone;

//         foreach (var cell in zoneData.Prefab.GetComponentsInChildren<CellDirector>())
//         {
//             cell.ambianceZone = zoneData.Ambiance;
//             cell.GetComponent<Region>().bounds.center += cell.transform.position;
//         }
//     }

//     private static void PrepMaterials(params Renderer[] renderers)
//     {
//         foreach (var renderer in renderers)
//         {
//             var mat = renderer.material;
//             var shader = ShaderUtils.FindShader(mat.shader.name);

//             if (shader != null)
//                 mat.shader = shader;
//         }
//     }

//     private static void PrepSpawner(DirectedSlimeSpawner ss)
//     {
//         foreach (var constraint in ss.constraints)
//         {
//             for (var i = 0; i < constraint.slimeset.members.Length; i++)
//             {
//                 var prefab = constraint.slimeset.members[i];

//                 if (!prefab.prefab)
//                     Main.Console.Log($"Error - Null Object in constraint.slimeset.members[{i}]");
//                 else
//                     prefab.prefab = Helpers.ParseEnum<IdentifiableId>(prefab.prefab.name).GetPrefab();
//             }
//         }
//     }

//     private static void PrepSpawners(GameObject zone) => Array.ForEach(zone.GetComponentsInChildren<DirectedSlimeSpawner>(true), PrepSpawner);

//     /// <summary>
//     /// Make sure all water sources in your zone have a number at the end!
//     /// Example: _WaterSource.1707111978
//     /// The '.' NEEDS to be there.
//     /// </summary>
//     /// <param name="zone">The zone.</param>
//     private static void PrepWaterSources(GameObject zone)
//     {
//         foreach (var source in zone.GetComponentsInChildren<LiquidSource>())
//         {
//             var split = source.name.TrueSplit('.');

//             if (split.Count != 1)
//                 Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Invalid ID)");

//             if (source.name.Contains("_WaterSource"))
//             {
//                 source.GetComponent<LiquidSource>().Destroy();

//                 WaterSourceBase.SetActive(false);

//                 var srcBase = WaterSourceBase.Instantiate();
//                 srcBase.transform.SetParent(source.transform, false);

//                 var water = srcBase.GetComponentInChildren<LiquidSource>();
//                 water.director = zone.GetComponent<IdDirector>();
//                 water.director.persistenceDict.Add(water, water.IdPrefix() + split[1]);
//                 water.enabled = true;

//                 srcBase.transform.localPosition = Vector3.zero;
//                 srcBase.SetActive(true);

//                 WaterSourceBase.SetActive(true);
//             }
//             // todo: add more source types (else if)
//             else
//             {
//                 Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Unknown Name)");
//             }
//         }
//     }

//     private static void PrepTeleporter(SceneContext context, TeleportDestination teleporter, Vector3 position)
//     {
//         if (teleporter.transform.childCount < 2)
//         {
//             Main.Console.LogError($"Failed to register teleport destination {teleporter.name}. (Invalid Teleporter Child Count)");
//             return;
//         }

//         var region = teleporter.transform.GetChild(1);

//         if (!region.name.StartsWith('_'))
//         {
//             Main.Console.LogError($"Failed to register teleport destination {teleporter.name}. (Invalid Teleporter _Region: {region.name})");
//             return;
//         }

//         teleporter.regionSetId = Helpers.ParseEnum<RegionId>(region.name.Replace("_", string.Empty));
//         context.TeleportNetwork.Register(teleporter);

//         if (position != Vector3.zero)
//             teleporter.transform.position = position;
//     }

//     private static void PrepFoodSpawners(GameObject zone)
//     {
//         foreach (var spawnResource in zone.GetComponentsInChildren<SpawnResource>())
//         {
//             PrepFoodPrefabs(spawnResource.ObjectsToSpawn, "ObjectsToSpawn");
//             PrepFoodPrefabs(spawnResource.BonusObjectsToSpawn, "BonusObjectsToSpawn");
//         }
//     }

//     private static void PrepFoodPrefabs(GameObject[] array, string arrayName)
//     {
//         for (var i = 0; i < array.Length; i++)
//         {
//             var food = array[i];

//             if (!food)
//                 Main.Console.Log($"Error - Null Object in {arrayName}[{i}]");
//             else
//                 array[i] = Helpers.ParseEnum<IdentifiableId>(food.name).GetPrefab();
//         }
//     }
// }