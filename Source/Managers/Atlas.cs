using RichPresence;

namespace OceanRange.Managers;

public static class Atlas
{
    public static Dictionary<Zone, ZoneData> ZoneToDataMap;

    private static ZoneData[] Zones;
    private static RegionData[] Regions;

    public static GameObject SwirlpoolObject;

    private static GameObject WaterSourceBase;

#if DEBUG
    [TimeDiagnostic("Atlas Preload")]
#endif
    public static void PreloadMapData()
    {
        var world = Inventory.GetJson<World>("atlas");

        Regions = world.Regions;
        Zones = world.Zones;

        ZoneToDataMap = Zones.ToDictionary(x => x.Zone, ZoneDirector.zoneComparer);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
    }

#if DEBUG
    [TimeDiagnostic("Atlas PreOnSaveLoad")]
#endif
    private static void PreOnSaveLoad(SceneContext context)
    {
        // Load regions before the zones or the game implodes

        if (!WaterSourceBase)
            WaterSourceBase = GameObject.Find("/zoneREEF/cellReef_Hub/Sector/Resources/waterFountain01/");

        foreach (var region in Regions)
            PreLoadRegion(context, region);

        LoadSwirlPool(context);

        // foreach (var zone in Zones)
        //     PreLoadZone(context, zone);
    }

    private static void PreLoadRegion(SceneContext context, RegionData region)
    {
        context.RegionRegistry.managedWithSets.Add(region.Region, []);
        context.RegionRegistry.regionsTrees.Add(region.Region, new(region.InitialWorldSize, region.InitialWorldPos, region.MinNodeSize, region.LoosenessVal));
    }

    // private static void PreLoadZone(SceneContext context, ZoneData zone)
    // {

    // }

#if DEBUG
    [TimeDiagnostic("Atlas Load")]
#endif
    public static void LoadMap()
    {
        Array.ForEach(Zones, LoadZoneData);
    }

    private static void LoadZoneData(ZoneData zone)
    {
        PediaRegistry.RegisterIdEntry(zone.PediaId, null);
        Director.RICH_PRESENCE_ZONE_LOOKUP.Add(zone.Zone, "ranch");
    }

    private static void PrepMaterials(params Renderer[] renderers)
    {
        foreach (var renderer in renderers)
        {
            var mat = renderer.material;
            var shader = ShaderUtils.FindShader(mat.shader.name);

            if (shader != null)
                mat.shader = shader;
        }
    }

    private static void PrepSpawner(DirectedSlimeSpawner ss)
    {
        foreach (var constraint in ss.constraints)
        {
            foreach (var member in constraint.slimeset.members)
            {
                try
                {
                    member.prefab = Helpers.ParseEnum<IdentifiableId>(member.prefab.name).GetPrefab();
                }
                catch { }
            }
        }
    }

    private static void PrepSpawners(GameObject zone)
    {
        foreach (var ss in zone.GetComponentsInChildren<DirectedSlimeSpawner>(true))
            PrepSpawner(ss);
    }

    /// <summary>
    /// Make sure all water sources in your zone have a number at the end!
    /// Example: _WaterSource.1707111978
    /// The '.' NEEDS to be there.
    /// </summary>
    /// <param name="zone">The zone.</param>
    private static void PrepWaterSources(GameObject zone)
    {
        foreach (var source in zone.GetComponentsInChildren<LiquidSource>())
        {
            var split = source.name.TrueSplit('.');

            if (split.Count != 1)
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Invalid ID)");

            if (source.name.Contains("_WaterSource"))
            {
                source.GetComponent<LiquidSource>().Destroy();

                WaterSourceBase.SetActive(false);

                var srcBase = WaterSourceBase.Instantiate();
                srcBase.transform.SetParent(source.transform, false);

                var water = srcBase.GetComponentInChildren<LiquidSource>();
                water.director = zone.GetComponent<IdDirector>();
                water.director.persistenceDict.Add(water, water.IdPrefix() + split[1]);
                water.enabled = true;

                srcBase.transform.localPosition = Vector3.zero;
                srcBase.SetActive(true);

                WaterSourceBase.SetActive(true);
            }
            // todo: add more source types (else if)
            else
            {
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Unknown Name)");
            }
        }
    }

    private static void PrepTeleporter(SceneContext context, GameObject teleporter, Vector3 position)
    {
        var dest = teleporter.GetComponent<TeleportDestination>();

        if (dest.transform.childCount < 2)
        {
            Main.Console.LogError($"Failed to register teleport destination {teleporter.name}. (Invalid Teleporter Child Count)");
            return;
        }

        var region = teleporter.transform.GetChild(1);

        if (!region.name.StartsWith('_'))
        {
            Main.Console.LogError($"Failed to register teleport destination {teleporter.name}. (Invalid Teleporter _Region: {region.name})");
            return;
        }

        dest.regionSetId = Helpers.ParseEnum<RegionId>(region.name.Replace("_", ""));
        context.TeleportNetwork.Register(dest);

        if (position != Vector3.zero)
            dest.transform.position = position;
    }

    private static void LoadSwirlPool(SceneContext context)
    {
        PrepSwirlpoolPrefab();

        context.AmbianceDirector.zoneDict.Add(Ids.SWIRLPOOL_ISLAND_AMBIANCE, SwirlpoolSettings);
        context.AmbianceDirector.zoneSettings =
            context.AmbianceDirector.zoneSettings.AddToArray(SwirlpoolSettings);

        SwirlpoolObject = SwirlpoolPrefab.Instantiate();

        var enterPortal = Inventory.GetPrefab("TeleporterDevEntrance").Instantiate(GameObject.Find("zoneRANCH/cellRanch_Home/Sector/Ranch Features/").transform);
        enterPortal.transform.eulerAngles = Vector3.up * 137f;
        PrepTeleporter(context, enterPortal.gameObject, new Vector3(62.4343f, 15.83f, -137.3158f));
        PrepMaterials(enterPortal.GetComponent<MeshRenderer>());

        foreach (var tp in SwirlpoolObject.GetComponentsInChildren<TeleportDestination>())
            PrepTeleporter(context, tp.gameObject, Vector3.zero);

        SwirlpoolObject.SetActive(true);
    }

    private static bool Prepped;
    public static GameObject SwirlpoolPrefab;
    private static AmbianceDirectorZoneSetting SwirlpoolSettings;

    private static void PrepSwirlpoolPrefab()
    {
        if (Prepped)
            return;

        SwirlpoolSettings = Inventory.GetScriptable<AmbianceDirectorZoneSetting>("SWIRLPOOLAmb");
        SwirlpoolSettings.zone = Ids.SWIRLPOOL_ISLAND_AMBIANCE;

        SwirlpoolPrefab = Inventory.GetPrefab("zoneSWIRLPOOL");
        SwirlpoolPrefab.SetActive(false);

        SwirlpoolPrefab.GetComponent<ZoneDirector>().zone = Ids.SWIRLPOOL_ISLAND;

        PrepWaterSources(SwirlpoolPrefab);
        PrepSpawners(SwirlpoolPrefab);

        foreach (var cell in SwirlpoolPrefab.GetComponentsInChildren<CellDirector>())
        {
            var reg = cell.GetComponent<Region>();
            cell.ambianceZone = Ids.SWIRLPOOL_ISLAND_AMBIANCE;
            reg.bounds.center += cell.transform.position;
        }

        PrepMaterials(SwirlpoolPrefab.GetComponentsInChildren<Renderer>());
        Prepped = true;
    }
}