namespace OceanRange.Managers;

public static class Zones
{
    public static GameObject swirlpoolObject;

    private static GameObject waterSourceBase;

    public static void LoadAllZones(SceneContext context)
    {
        LoadSwirlPool(context);
        
        SceneContext.Instance.RegionRegistry.managedWithSets.Add(Ids.UNDERWATER, new List<GameObject>());
        // Copy HOME settings
        SceneContext.Instance.RegionRegistry.regionsTrees.Add(Ids.UNDERWATER, new BoundsQuadtree<Region>(2000f, Vector3.zero, 250f, 1.2f));
    }

    #region Prep

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
        {
            PrepSpawner(ss);
        }
    }

    /// <summary>
    /// Make sure all water sources in your zone have a number at the end!
    /// Example: _WaterSource.1707111978
    /// The '.' NEEDS to be there.
    /// </summary>
    /// <param name="zone"></param>
    private static void CreateWaterSources(GameObject zone)
    {
        if (!waterSourceBase)
        {
            waterSourceBase = GameObject.Find("/zoneREEF/cellReef_Hub/Sector/Resources/waterFountain01/");
        }

        foreach (var source in zone.GetComponentsInChildren<LiquidSource>())
        {
            var split = source.name.Split('.');

            if (split.Length != 1)
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Invalid ID)");

            if (source.name.Contains("_WaterSource"))
            {
                UObject.Destroy(source.GetComponent<LiquidSource>());
                
                var srcBase = UObject.Instantiate(waterSourceBase);
                srcBase.transform.SetParent(source.transform, false);
                var water = srcBase.GetComponentInChildren<LiquidSource>();
                water.director = zone.GetComponent<IdDirector>();
                water.director.persistenceDict.Add(water, $"{water.IdPrefix()}{split[1]}");
                water.enabled = true;
                water.transform.localPosition = Vector3.zero;
            }
            // todo: add more source types (else if)
            else
            {
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Unknown Name)");
            }
        }

        zone.GetComponentsInChildren<LiquidSource>(true);
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
        
        dest.regionSetId = (RegionId)Enum.Parse(typeof(RegionId), region.name.Replace("_", ""));
        network.Register(dest);

        if (position != Vector3.zero)
        {
            dest.transform.position = position;
        }
    }
    #endregion

    #region Zone Loading
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

        var enterPortal = UObject.Instantiate(Inventory.GetPrefab("TeleporterDevEntrance"));
        PrepTeleporter(enterPortal.gameObject, new Vector3(62.4343f, 15.83f, -137.3158f));
        enterPortal.transform.eulerAngles = Vector3.up * 137f;
        
        swirlpoolObject = UObject.Instantiate(prefab);
    }
    #endregion

    #region Pedia
    // todo: add json pedia

    public static void CreatePedia()
    {

        SlimepediaCreation.CreateZoneSlimePedia(Ids.SWIRLPOOL_ENTRY,
            Ids.SWIRLPOOL,
            "ranch", // Can't make custom zone icons, so use existing ones.
            "Discovering SwirlPool Island",
            "SwirlPool Island",
            "A Distant Land of wonder for those who are curious",
            "<b><u>todo:</b></u> make entire pedia");
        
    }
    #endregion
}