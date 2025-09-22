namespace OceanRange.Managers;

public static class Zones
{
    public static GameObject swirlpoolObject;

    private static GameObject waterSourceBase;

    public static void LoadAllZones(SceneContext context)
    {
        LoadSwirlPool(context);
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
                var water = UObject.Instantiate(waterSourceBase, source.transform).GetComponentInChildren<LiquidSource>();
                water.director = zone.GetComponent<IdDirector>();
                water.director.persistenceDict.Add(water, $"{water.IdPrefix()}{split[1]}");
            }
            // todo: add more source types (else if)
            else
            {
                Main.Console.Log($"Invalid LiquidSource in zone '{zone.name}' make sure you name your water source correctly! (Unknown Name)");
            }
        }

        zone.GetComponentsInChildren<LiquidSource>(true);
    }

    #endregion

    private static void LoadSwirlPool(SceneContext context)
    {
        var amb = Inventory.GetScriptable<AmbianceDirectorZoneSetting>("swirlpoolamb");
        amb.zone = Ids.SWIRLPOOL_AMBIANCE;

        context.AmbianceDirector.zoneDict.Add(Ids.SWIRLPOOL_AMBIANCE, amb);
        context.AmbianceDirector.zoneSettings =
            context.AmbianceDirector.zoneSettings.AddToArray(amb);

        var prefab =  Inventory.GetPrefab("zoneswirlpool");

        context.AmbianceDirector.zoneSettings.AddItem(amb);
        prefab.GetComponent<ZoneDirector>().zone = Ids.SWIRLPOOL;

        CreateWaterSources(prefab);
        Spawners(prefab);
        foreach (var cell in prefab.GetComponentsInChildren<CellDirector>())
        {
            cell.ambianceZone = Ids.SWIRLPOOL_AMBIANCE;
            cell.GetComponent<Region>().bounds.center += cell.transform.position;
        }

        PrepMaterials(prefab.GetComponentsInChildren<Renderer>());

        swirlpoolObject = UObject.Instantiate(prefab);
    }

    #region Pedia
    // todo: add json pedia

    public static void CreatePedia()
    {
        PediaUI.WORLD_ENTRIES = PediaUI.WORLD_ENTRIES.AddToArray(Ids.SWIRLPOOL_ENTRY);

        TranslationPatcher.AddPediaTranslation("t.swirlpool_entry", "The Swirlpool");
        TranslationPatcher.AddPediaTranslation("m.intro.swirlpool_entry", "A Distant Land of wonder for those who are curious");
        TranslationPatcher.AddPediaTranslation("m.desc.swirlpool_entry", "The Swirlpool is distant land, not managed by 7Zee. Unlike the Far Far Range, The Swirlpool and some other locations are managed by S.P.L.A.S.H. It is one of the few locations on the Far Far Range that is underwater. Only some Slime Scientists ever get the chance to see this place, such as Viktor Humphries.");
    }
    #endregion
}