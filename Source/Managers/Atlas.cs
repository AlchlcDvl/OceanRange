namespace OceanRange.Managers;

public static class Atlas
{
    private static ZoneData[] Zones;
    private static RegionData[] Regions;

    public static GameObject SwirlpoolObject;

    private static GameObject WaterSourceBase;

#if DEBUG
    [TimeDiagnostic("Atlas Preload")]
#endif
    public static void PreloadMapData()
    {
        var map = Inventory.GetJson<World>("map");

        Regions = map.Regions;
        Zones = map.Zones;

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
    }

    private static void PreOnSaveLoad(SceneContext context)
    {
        if (!WaterSourceBase)
            WaterSourceBase = GameObject.Find("/zoneREEF/cellReef_Hub/Sector/Resources/waterFountain01/");

        LoadSwirlPool(context);

        foreach (var region in Regions)
            PreLoadRegion(context, region);

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

    public static void LoadMapData()
    {
        Array.ForEach(Zones, LoadZoneData);
    }

    private static void LoadZoneData(ZoneData zone)
    {
        SlimepediaCreation.CreateZoneSlimePedia(zone.PediaId, zone.Zone, "ranch", zone.Presence, zone.PediaName, zone.Intro, zone.Description);
    }

    private static void PrepMaterials(Renderer[] renderers)
    {
        foreach (var renderer in renderers)
        {
            var mat = renderer.material;
            var shader = Shader.Find(mat.shader.name);

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

    private static void Spawners(GameObject zone)
    {
        foreach (var ss in zone.GetComponentsInChildren<DirectedSlimeSpawner>(true))
            PrepSpawner(ss);
    }

    /// <summary>
    /// Make sure all water sources in your zone have a number at the end!
    /// Example: _WaterSource.1707111978
    /// The '.' NEEDS to be there.
    /// </summary>
    /// <param name="zone"></param>
    private static void CreateWaterSources(GameObject zone)
    {
        foreach (var source in zone.GetComponentsInChildren<LiquidSource>())
        {
            var split = source.name.TrueSplit('.');

            if (split.Count != 1)
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Invalid ID)");

            if (source.name.Contains("_WaterSource"))
            {
                source.GetComponent<LiquidSource>().Destroy();

                var srcBase = WaterSourceBase.Instantiate();
                srcBase.transform.SetParent(source.transform, false);
                var water = srcBase.GetComponentInChildren<LiquidSource>();
                water.director = zone.GetComponent<IdDirector>();
                water.director.persistenceDict.Add(water, water.IdPrefix() + split[1]);
                water.enabled = true;
                water.transform.localPosition = Vector3.zero;
            }
            // todo: add more source types (else if)
            else
            {
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Unknown Name)");
            }
        }
    }

    private static void PrepTeleporter(GameObject teleporter, Vector3 position)
    {
        var network = SceneContext.Instance.TeleportNetwork;
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
        network.Register(dest);

        if (position != Vector3.zero)
        {
            dest.transform.position = position;
        }
    }

    private static void LoadSwirlPool(SceneContext context)
    {
        var amb = Inventory.GetScriptable<AmbianceDirectorZoneSetting>("SWIRLPOOLAmb");
        amb.zone = Ids.SWIRLPOOL_AMBIANCE;

        context.AmbianceDirector.zoneDict.Add(Ids.SWIRLPOOL_AMBIANCE, amb);
        context.AmbianceDirector.zoneSettings =
            context.AmbianceDirector.zoneSettings.AddToArray(amb);

        var prefab =  Inventory.GetPrefab("zoneSWIRLPOOL");

        context.AmbianceDirector.zoneSettings.AddItem(amb);
        prefab.GetComponent<ZoneDirector>().zone = Ids.SWIRLPOOL;

        CreateWaterSources(prefab);
        Spawners(prefab);

        foreach (var cell in prefab.GetComponentsInChildren<CellDirector>())
        {
            var reg = cell.GetComponent<Region>();
            cell.ambianceZone = Ids.SWIRLPOOL_AMBIANCE;
            reg.bounds.center += cell.transform.position;
        }

        foreach (var tp in prefab.GetComponentsInChildren<TeleportDestination>())
            PrepTeleporter(tp.gameObject, Vector3.zero);

        PrepMaterials(prefab.GetComponentsInChildren<Renderer>());

        var enterPortal = Inventory.GetPrefab("TeleporterDevEntrance").Instantiate();
        PrepTeleporter(enterPortal.gameObject, new Vector3(62.4343f, 15.83f, -137.3158f));
        enterPortal.transform.eulerAngles = Vector3.up * 137f;

        SwirlpoolObject = prefab.Instantiate();
    }
}