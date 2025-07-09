using SRML;

namespace TheOceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// TODO: Create Rosi gordo at -10.6085 4.6748 17.2529
public static class SlimeManager
{
    public static readonly List<CustomSlimeData> SlimesMap = [];
    public static SlimeExpressionFace SleepingFace;

    private static bool SamExists;

    private static readonly int TopColor = Shader.PropertyToID("_TopColor");
    private static readonly int MiddleColor = Shader.PropertyToID("_MiddleColor");
    private static readonly int BottomColor = Shader.PropertyToID("_BottomColor");
    private static readonly int SpecColor = Shader.PropertyToID("_SpecColor");
    private static readonly int Shininess = Shader.PropertyToID("_Shininess");
    private static readonly int Gloss = Shader.PropertyToID("_Gloss");
    private static readonly int StripeTexture = Shader.PropertyToID("_StripeTexture");
    private static readonly int MouthTop = Shader.PropertyToID("_MouthTop");
    private static readonly int MouthMid = Shader.PropertyToID("_MouthMid");
    private static readonly int MouthBot = Shader.PropertyToID("_MouthBot");
    private static readonly int EyeRed = Shader.PropertyToID("_EyeRed");
    private static readonly int EyeGreen = Shader.PropertyToID("_EyeGreen");
    private static readonly int EyeBlue = Shader.PropertyToID("_EyeBlue");

    public static void PreLoadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        SlimesMap.AddRange(AssetManager.GetJson<CustomSlimeData[]>("Slimepedia"));
    }

    public static void PreLoadAllSlimes() => SlimesMap.ForEach(BasePreLoadSlime);

    private static void BasePreLoadSlime(CustomSlimeData slimeData)
    {
        Identifiable.PLORT_CLASS.Add(slimeData.PlortId);
        Identifiable.NON_SLIMES_CLASS.Add(slimeData.PlortId);
        Identifiable.SLIME_CLASS.Add(slimeData.SlimeId);

        SRCallbacks.PreSaveGameLoad += delegate
        {
            var prefab = GameContext.Instance.LookupDirector.GetPrefab(slimeData.SlimeId);

            foreach (var item in UObject.FindObjectsOfType<DirectedSlimeSpawner>().Where(spawner =>
            {
                var zoneId = spawner.GetComponentInParent<Region>(true).GetZoneId();
                return zoneId == Zone.NONE || slimeData.Zones.Contains(zoneId);
            }))
            {
                foreach (var constraint in item.constraints)
                {
                    if (slimeData.NightSpawn && constraint.window.timeMode != DirectedActorSpawner.TimeMode.NIGHT)
                        continue;

                    constraint.slimeset.members =
                    [
                        .. constraint.slimeset.members,
                        new()
                        {
                            prefab = prefab,
                            weight = slimeData.SpawnAmount
                        }
                    ];
                }
            }
        };
    }

    public static void LoadAllSlimes()
    {
        SlimesMap.ForEach(BaseLoadSlime);

        var blink = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).AppearancesDefault[0].Face.ExpressionFaces.First(x => x.SlimeExpression ==
            SlimeFace.SlimeExpression.Blink);
        SleepingFace = new()
        {
            SlimeExpression = Ids.Sleeping,
            Eyes = blink.Eyes?.Clone(),
            Mouth = blink.Mouth?.Clone()
        };
        SleepingFace.Eyes.SetTexture("_FaceAtlas", AssetManager.GetTexture2D("SleepingEyes"));
    }

    private static void BaseLoadSlime(CustomSlimeData slimeData)
    {
        CreatePlort(slimeData);
        CreateSlime(slimeData);

        if (SamExists)
            TypeLoadExceptionBypass(slimeData.SlimeId, slimeData.PlortId, slimeData.Progress);
    }

    private static void CreatePlort(CustomSlimeData slimeData)
    {
        // First create a prefab and set details
        var prefab = GameContext.Instance.LookupDirector.GetPrefab(slimeData.BasePlort).CreatePrefab();
        prefab.name = "plort" + slimeData.Name;
        prefab.GetComponent<Identifiable>().id = slimeData.PlortId;
        prefab.GetComponent<Vacuumable>().size = 0;

        // Next set up the mesh and material details
        var meshRend = prefab.GetComponent<MeshRenderer>();
        var material = meshRend.material = meshRend.material.Clone();
        material.SetColor(TopColor, slimeData.TopPlortColor.HexToColor());
        material.SetColor(MiddleColor, slimeData.MiddlePlortColor.HexToColor());
        material.SetColor(BottomColor, slimeData.BottomPlortColor.HexToColor());
        material.SetColor(SpecColor, slimeData.SpecialPlortColor.HexToColor());

        if (slimeData.PlortType != "Crystal") // Crystal is the original shape of a plort, so skip if the plort type is that
            prefab.GetComponent<MeshFilter>().mesh = AssetManager.GetMesh(slimeData.PlortType);

        // Registering the prefab and its id along with any other additional stuff
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, slimeData.PlortId);
        TranslationPatcher.AddActorTranslation("l." + slimeData.PlortId.ToString().ToLower(), $"{slimeData.Name} {slimeData.PlortType}");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.PlortId);
        LookupRegistry.RegisterVacEntry(slimeData.PlortId, slimeData.PlortAmmoColor.HexToColor(), AssetManager.GetSprite($"{slimeData.Name}Plort"));
        AmmoRegistry.RegisterSiloAmmo(x => x is SiloStorage.StorageType.NON_SLIMES or SiloStorage.StorageType.PLORT, slimeData.PlortId);
        PlortRegistry.AddEconomyEntry(slimeData.PlortId, slimeData.BasePlortPrice, slimeData.Saturation);
        PlortRegistry.AddPlortEntry(slimeData.PlortId, slimeData.Progress);
        DroneRegistry.RegisterBasicTarget(slimeData.PlortId);

        if (slimeData.CanBeRefined)
            AmmoRegistry.RegisterRefineryResource(slimeData.PlortId);
    }

    private static void CreateSlime(CustomSlimeData slimeData)
    {
        var baseDefinition = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(slimeData.BaseSlime); // Finding the base slime definition to go off of

        // Create a copy for our slimes and populate with info
        var definition = baseDefinition.DeepCopy();
        definition.Diet.Produces = [slimeData.PlortId];
        definition.Diet.MajorFoodGroups = [slimeData.Diet];
        definition.Diet.AdditionalFoods = [IdentifiableId.SPICY_TOFU];
        definition.Diet.Favorites = [slimeData.FavFood];
        definition.Diet.EatMap?.Clear();
        definition.CanLargofy = slimeData.CanLargofy;
        definition.FavoriteToys = [slimeData.FavToy];
        definition.Name = slimeData.Name + " Slime";
        definition.IdentifiableId = slimeData.SlimeId;

        // Finding the base prefab, copying it and setting our own component values
        var prefab = GameContext.Instance.LookupDirector.GetPrefab(slimeData.BaseSlime).CreatePrefab();
        prefab.name = "slime" + slimeData.Name;
        prefab.GetComponent<PlayWithToys>().slimeDefinition = definition;
        prefab.GetComponent<SlimeEat>().slimeDefinition = definition;
        prefab.GetComponent<Identifiable>().id = slimeData.SlimeId;
        prefab.GetComponent<Vacuumable>().size = 0;

        // Fetching applicator
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();
        applicator.SlimeDefinition = definition;

        // Try to remove pink slime food tracker, skip there's no such component
        if (prefab.TryGetComponent<PinkSlimeFoodTypeTracker>(out var tracker))
            tracker.Destroy();

        var baseAppearance = baseDefinition.AppearancesDefault[0]; // Getting the base appearance

        var appearance = baseAppearance.DeepCopy(); // Cloning our own appearance

        // Caching colors to avoid excessive implicit conversions and creations
        var topMatColor = slimeData.TopSlimeColor.HexToColor();
        var middleMatColor = slimeData.MiddleSlimeColor.HexToColor();
        var bottomMatColor = slimeData.BottomSlimeColor.HexToColor();
        var specialMatColor = slimeData.SpecialSlimeColor.HexToColor();

        // Creating a material for each structure
        foreach (var structure in appearance.Structures)
        {
            if (structure.DefaultMaterials?.Length is null or 0)
                continue;

            var material = structure.DefaultMaterials[0] = structure.DefaultMaterials[0].Clone();
            material.SetColor(TopColor, topMatColor);
            material.SetColor(MiddleColor, middleMatColor);
            material.SetColor(BottomColor, bottomMatColor);
            material.SetColor(SpecColor, specialMatColor);
            material.SetFloat(Shininess, slimeData.Shininess);
            material.SetFloat(Gloss, slimeData.Glossiness);
        }

        // Caching colors again for the same reason
        var topMouth = slimeData.TopMouthColor.HexToColor();
        var middleMouth = slimeData.MiddleMouthColor.HexToColor();
        var bottomMouth = slimeData.BottomMouthColor.HexToColor();
        var redEye = slimeData.RedEyeColor.HexToColor();
        var greenEye = slimeData.GreenEyeColor.HexToColor();
        var blueEye = slimeData.BlueEyeColor.HexToColor();

        // Faces stuff
        foreach (var face in appearance.Face.ExpressionFaces)
        {
            if (face.Mouth)
            {
                face.Mouth.SetColor(MouthTop, topMouth);
                face.Mouth.SetColor(MouthMid, middleMouth);
                face.Mouth.SetColor(MouthBot, bottomMouth);
            }

            if (face.Eyes)
            {
                face.Eyes.SetColor(EyeRed, redEye);
                face.Eyes.SetColor(EyeGreen, greenEye);
                face.Eyes.SetColor(EyeBlue, blueEye);
            }
        }

        appearance.Face.OnEnable();
        appearance.ColorPalette = new()
        {
            Top = slimeData.TopPaletteColor.HexToColor(),
            Middle = slimeData.MiddlePaletteColor.HexToColor(),
            Bottom = slimeData.BottomPaletteColor.HexToColor()
        };

        appearance.Icon = AssetManager.GetSprite($"{slimeData.Name}Slime");
        appearance.ColorPalette.Ammo = slimeData.SlimeAmmoColor.HexToColor();
        applicator.Appearance = appearance;

        slimeData.InitSlimeDetails?.Invoke(null, [prefab, definition, appearance, applicator]); // Slime specific details being put here

        definition.AppearancesDefault = [appearance];

        // Tarrs should love these guys
        var tarr = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TARR_SLIME);
        tarr.Diet.EatMap.Add(new()
        {
            eats = slimeData.SlimeId,
            becomesId = IdentifiableId.TARR_SLIME,
            driver = SlimeEmotions.Emotion.NONE,
            extraDrive = 999999f
        });

        // Register everything
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterSlimeDefinition(definition);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.SlimeId);
        LookupRegistry.RegisterVacEntry(slimeData.SlimeId, appearance.ColorPalette.Ammo, appearance.Icon);
        var title = slimeData.Name + " Slime";
        var slimeIdName = slimeData.SlimeId.ToString().ToLower();
        TranslationPatcher.AddPediaTranslation("t." + slimeIdName, title);
        TranslationPatcher.AddActorTranslation("l." + slimeIdName, title);

        SlimePediaCreation.PreLoadSlimePediaConnection(slimeData.Entry, slimeData.SlimeId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(slimeData.Entry, title, slimeData.Intro, slimeData.PediaDiet, slimeData.Fav, slimeData.Slimeology, slimeData.Risks,
            slimeData.Plortonomics);
        PediaRegistry.RegisterIdEntry(slimeData.Entry, appearance.Icon);
    }

    private static void TypeLoadExceptionBypass(IdentifiableId slimeId, IdentifiableId plortId, ProgressType[] progress)
    {
        try
        {
            SlimesAndMarket.ExtraSlimes.RegisterSlime(slimeId, plortId, progress: progress); // Since it's a soft dependency but still requires the code from the mod to work, this method was made
        }
        catch (Exception e)
        {
            Main.Instance.ConsoleInstance.LogError(e);
        }
    }

    private static void BasicInitSlimeAppearance
    (
        GameObject prefab,
        SlimeAppearance appearance,
        SlimeAppearanceApplicator applicator,
        string[] meshes,
        Action<int, SlimeAppearanceStructure> materialHandler,
        Action<GameObject> behaviourAdder,
        Action<GameObject> behaviourRemover
    )
    {
        behaviourRemover?.Invoke(prefab);

        var firstStructure = appearance.Structures[0];
        var elemPrefab = firstStructure.Element.Prefabs[0];

        appearance.Structures = new SlimeAppearanceStructure[meshes.Length];
        appearance.Structures[0] = firstStructure;

        for (var i = 1; i < meshes.Length; i++)
            appearance.Structures[i] = new(firstStructure);

        SlimeAppearanceObject slimeBase = null;
        var prefabsForBoneData = new SlimeAppearanceObject[meshes.Length - 1];

        for (var i = 0; i < appearance.Structures.Length; i++)
        {
            var structure = appearance.Structures[i];
            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab();
            elem.Prefabs = [prefab2];
            var meshRend = prefab2.GetComponent<SkinnedMeshRenderer>();
            var meshName = meshes[i];
            meshRend.sharedMesh = meshName == null ? meshRend.sharedMesh.Instantiate() : AssetManager.GetMesh(meshName);
            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            materialHandler?.Invoke(i, structure);

            if (structure.SupportsFaces)
                slimeBase = prefab2;
            else if (i > 0)
                prefabsForBoneData[i - 1] = prefab2;
        }

        AssetsLib.MeshUtils.GenerateBoneData(applicator, slimeBase, 0.25f, 1f, prefabsForBoneData);

        behaviourAdder?.Invoke(prefab);
    }

    public static void InitRosiDetails(GameObject prefab, SlimeDefinition definition, SlimeAppearance appearance, SlimeAppearanceApplicator applicator)
    {
        definition.Diet.MajorFoodGroups = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).Diet.MajorFoodGroups;
        definition.Diet.Favorites = [];

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, ["rosi_body", "rosi_stalk", "rosi_frills"],
            (i, structure) =>
            {
                if (i != 2)
                    return;

                var mat = structure.DefaultMaterials[0] = structure.DefaultMaterials[0].Clone();
                var color = "#F46CB7".HexToColor();
                mat.SetColor(TopColor, color);
                mat.SetColor(MiddleColor, color);
                mat.SetColor(BottomColor, color);
                mat.SetColor(SpecColor, color);
            },
            p => p.AddComponent<RosiBehaviour>(),
            null
        );
    }

    // Cocoa mesh doesn't work atm
    // public static void InitCocoDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator) => BasicInitSlimeAppearance
    // (
    //     prefab, appearance, applicator, ["coco_body", "coco_brows"],
    //     (i, structure) =>
    //     {
    //         if (i == 0)
    //             return;

    //         var color = "#966F33".HexToColor();
    //         var material = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
    //         material.SetColor("_TopColor", color);
    //         material.SetColor("_MiddleColor", color);
    //         material.SetColor("_BottomColor", color);
    //         material.SetColor("_SpecColor", color);
    //         material.SetFloat("_Shininess", 1f);
    //         material.SetFloat("_Gloss", 1f);
    //         structure.DefaultMaterials[0] = material;
    //     },
    //     p => p.AddComponent<CocoBehaviour>(),
    //     null
    // );

    public static void InitMineDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator)
    {
        var color = "#445660".HexToColor();
        var color2 = "#9ea16f".HexToColor();
        var color3 = "#212A2F".HexToColor();

        var material = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TABBY_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color2);
        material.SetColor(MiddleColor, color2);
        material.SetColor(BottomColor, color);
        material.SetColor(SpecColor, color);
        material.SetFloat(Shininess, 1f);
        material.SetFloat(Gloss, 1f);

        var material2 = material.Clone();
        material2.SetColor(TopColor, color3);
        material2.SetColor(MiddleColor, color3);
        material2.SetColor(BottomColor, color3);
        material2.SetColor(SpecColor, color2);

        material.SetTexture(StripeTexture, AssetManager.GetTexture2D("MinePattern"));

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, [null, "mine_spikes", "mine_ring"],
            (_, structure) => structure.DefaultMaterials[0] = structure.SupportsFaces ? material : material2,
            p => p.AddComponent<MineBehaviour>(),
            p =>
            {
                p.RemoveComponent<BoomSlimeExplode>();
                p.RemoveComponent<BoomMaterialAnimator>();
            }
        );
    }

    public static void InitLanternDetails(GameObject prefab, SlimeDefinition definition, SlimeAppearance appearance, SlimeAppearanceApplicator applicator)
    {
        var color = "#752C86".HexToColor();
        var color2 = "#B15EC8".HexToColor();

        var material = appearance.Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color);
        material.SetColor(MiddleColor, "#9445A7".HexToColor());
        material.SetColor(BottomColor, color2);
        material.SetColor(SpecColor, color);
        material.SetFloat(Shininess, 1f);
        material.SetFloat(Gloss, 1f);

        var material2 = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.TABBY_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material2.SetColor(TopColor, color);
        material2.SetColor(MiddleColor, color);
        material2.SetColor(BottomColor, color2);
        material2.SetColor(SpecColor, color);
        material2.SetFloat(Shininess, 1f);
        material2.SetFloat(Gloss, 1f);
        material2.SetTexture(StripeTexture, AssetManager.GetTexture2D("LanternPattern"));

        var color3 = "#EBDB6A".HexToColor();
        var material3 = GameContext.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PHOSPHOR_SLIME).AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material3.SetColor(TopColor, color3);
        material3.SetColor(MiddleColor, color3);
        material3.SetColor(BottomColor, color3);
        material3.SetColor(SpecColor, color);
        material3.SetFloat(Shininess, 5f);

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, [null, "lantern_fins", "lantern_stalk", "lantern_lure"],
            (i, structure) => structure.DefaultMaterials[0] = i switch
            {
                1 => material2,
                3 => material3,
                _ => material
            },
            p => p.AddComponent<LanternBehaviour>(),
            null
        );
    }
}