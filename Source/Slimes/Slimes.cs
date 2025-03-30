using SRML.Utils;

namespace TheOceanRange.Slimes;

public static class Slimes
{
    private static readonly int EyeRed = Shader.PropertyToID("_EyeRed");
    private static readonly int EyeGreen = Shader.PropertyToID("_EyeGreen");
    private static readonly int EyeBlue = Shader.PropertyToID("_EyeBlue");
    private static readonly int MouthTop = Shader.PropertyToID("_MouthTop");
    private static readonly int MouthMid = Shader.PropertyToID("_MouthMid");
    private static readonly int MouthBot = Shader.PropertyToID("_MouthBot");
    private static readonly int TopColor = Shader.PropertyToID("_TopColor");
    private static readonly int BottomColor = Shader.PropertyToID("_BottomColor");
    private static readonly int MiddleColor = Shader.PropertyToID("_MiddleColor");
    private static readonly int SpecColor = Shader.PropertyToID("_SpecColor");
    private static readonly int Shininess = Shader.PropertyToID("_Shininess");
    private static readonly int Gloss = Shader.PropertyToID("_Gloss");

    public static void CreateBaseSlime(
        string name,
        IdentifiableId slimeId,
        IdentifiableId gordoId,
        IdentifiableId baitId,
        IdentifiableId[] productIds,
        FoodGroup[] dietIds,
        IdentifiableId[] additionalFoodIds,
        bool canLargofy)
    {
        var customSlimeData = new CustomSlimeData
        {
            Id = slimeId,
            GordoId = gordoId,
            BaitId = baitId,
        };
        SlimeManager.SlimesMap[slimeId] = customSlimeData;
        SlimeManager.BaitToGordoMap[baitId] = gordoId;

        var slimeByIdentifiableId = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME);

        var val = slimeByIdentifiableId.DeepCopy();
        var diet = val.Diet;
        diet.Produces = productIds;
        diet.MajorFoodGroups = dietIds;
        diet.AdditionalFoods = additionalFoodIds;

        val.CanLargofy = canLargofy;

        var pinkPrefab = GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.PINK_SLIME);

        var val2 = pinkPrefab.CreatePrefab();
    }

    public static void CreateRosaSlime()
    {
        var slimeByIdentifiableId = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME);

        var val = slimeByIdentifiableId.DeepCopy();
        val.Diet.Produces = [ Ids.ROSA_PLORT ];
        val.Diet.MajorFoodGroups =
        [
            FoodGroup.MEAT,
            FoodGroup.FRUIT,
            FoodGroup.VEGGIES
        ];
        val.Diet.AdditionalFoods = [ IdentifiableId.SPICY_TOFU ];
        val.Diet.Favorites = [];
        val.Diet.EatMap?.Clear();
        val.CanLargofy = false;
        val.FavoriteToys = [ IdentifiableId.OCTO_BUDDY_TOY ];
        val.Name = "RosaSlime";
        val.IdentifiableId = Ids.ROSA_SLIME;
        Identifiable.SLIME_CLASS.Add(Ids.ROSA_SLIME);

        var val2 = PrefabUtils.CopyPrefab(GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.PINK_SLIME));
        val2.name = "RosaSlime";
        val2.GetComponent<PlayWithToys>().slimeDefinition = val;

        var val2App = val2.GetComponent<SlimeAppearanceApplicator>();
        val2App.SlimeDefinition = val;
        val2.GetComponent<SlimeEat>().slimeDefinition = val;
        val2.GetComponent<Identifiable>().id = Ids.ROSA_SLIME;
        UObject.Destroy(val2.GetComponent<PinkSlimeFoodTypeTracker>());

        var val3 = slimeByIdentifiableId.AppearancesDefault[0].DeepCopy();
        val.AppearancesDefault = [ val3 ];
        val3.Structures =
        [
            val3.Structures[0],
            new(val3.Structures[0]),
            new(val3.Structures[0])
        ];

        var val4 = val3.Structures[0].DefaultMaterials[0].Clone();
        val4.SetColor(TopColor, new Color32(230, 199, 210, 255));
        val4.SetColor(MiddleColor, new Color32(230, 199, 210, 255));
        val4.SetColor(BottomColor, new Color32(230, 199, 210, 255));
        val4.SetColor(SpecColor, new Color32(230, 199, 210, 255));
        val4.SetFloat(Shininess, 1f);
        val4.SetFloat(Gloss, 1f);
        val3.Structures[0].DefaultMaterials = val3.Structures[1].DefaultMaterials = [ val4 ];

        var val4Clone = val4.Clone();
        val4Clone.SetColor(TopColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(MiddleColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(BottomColor, new Color32(178, 62, 101, 255));
        val4Clone.SetColor(SpecColor, new Color32(178, 62, 101, 255));
        val3.Structures[2].DefaultMaterials = [ val4Clone ];

        foreach (var val5 in val3.Face.ExpressionFaces)
        {
            if (val5.Mouth)
            {
                val5.Mouth.SetColor(MouthBot, Color.black);
                val5.Mouth.SetColor(MouthMid, Color.black);
                val5.Mouth.SetColor(MouthTop, Color.black);
            }

            if (!val5.Eyes)
                continue;
            val5.Eyes.SetColor(EyeRed, Color.black);
            val5.Eyes.SetColor(EyeGreen, Color.black);
            val5.Eyes.SetColor(EyeBlue, Color.black);
        }

        val3.Face.OnEnable();
        val3.ColorPalette = new()
        {
            Top = new Color32(249, 229, 240, 255),
            Middle = new Color32(249, 229, 240, 255),
            Bottom = new Color32(249, 229, 240, 255)
        };

        val2App.Appearance = val3;

        var val6 = GameInstance.Instance.SlimeDefinitions.GetSlimeByIdentifiableId(IdentifiableId.PINK_SLIME).AppearancesDefault[0].Structures[0].Element.Prefabs[0];
        var elem1 = val3.Structures[0].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab1 = val6.gameObject.CreatePrefabCopy().GetComponent<SlimeAppearanceObject>();
        elem1.Prefabs = [ prefab1 ];
        var mesh1 = prefab1.GetComponent<SkinnedMeshRenderer>().sharedMesh = Main.AssetsBundle.LoadAsset<Mesh>("slime_rosa");

        if (!mesh1)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa mesh");

        var elem2 = val3.Structures[1].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab2 = val6.CreatePrefab();
        elem2.Prefabs = [ prefab2 ];
        var mesh2 = prefab2.GetComponent<SkinnedMeshRenderer>().sharedMesh = Main.AssetsBundle.LoadAsset<Mesh>("slime_tendrals");
        val3.Structures[1].SupportsFaces = false;

        if (!mesh2)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa tendril mesh");

        var elem3 = val3.Structures[2].Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        var prefab3 = val6.CreatePrefab();
        elem3.Prefabs = [ prefab3 ];
        var mesh3 = prefab3.GetComponent<SkinnedMeshRenderer>().sharedMesh = Main.AssetsBundle.LoadAsset<Mesh>("slime_frills");
        val3.Structures[2].SupportsFaces = false;

        if (!mesh3)
            Main.Instance.ConsoleInstance.Log("Couldn't load rosa frill mesh");

        var val7 = slimeByIdentifiableId.AppearancesDefault[0].Structures[0].Element.Prefabs[0].CreatePrefab();
        val7.GetComponent<SkinnedMeshRenderer>().sharedMesh = UObject.Instantiate(val7.GetComponent<SkinnedMeshRenderer>().sharedMesh);
        AssetsLib.MeshUtils.GenerateBoneData(val2App, val7, 0.25f, 1f, [ prefab1, prefab2, prefab3 ]);

        var val8 = PrefabUtils.CopyPrefab(GameInstance.Instance.LookupDirector.GetPrefab(IdentifiableId.PINK_PLORT));
        val8.name = "RosaPlort";
        val8.GetComponent<Identifiable>().id = Ids.ROSA_PLORT;
        val8.GetComponent<Vacuumable>().size = 0;

        var meshRend = val8.GetComponent<MeshRenderer>();
        meshRend.material = UObject.Instantiate(meshRend.material);
        meshRend.material.SetColor(TopColor, new Color32(237, 169, 96, 255));
        meshRend.material.SetColor(MiddleColor, new Color32(237, 169, 96, 255));
        meshRend.material.SetColor(BottomColor, new Color32(237, 169, 96, 255));

        LookupRegistry.RegisterIdentifiablePrefab(val2);
        SlimeRegistry.RegisterSlimeDefinition(val);
        AmmoRegistry.RegisterAmmoPrefab(0, GameInstance.Instance.LookupDirector.GetPrefab(Ids.ROSA_SLIME));

        var val9 = Main.AssetsBundle.LoadAsset<Sprite>("rosaicon");
        val3.Icon = val9;
        val3.ColorPalette.Ammo = new Color32(80, 0, 0, 255);
        LookupRegistry.RegisterVacEntry(Ids.ROSA_SLIME, val3.ColorPalette.Ammo, val9);
        GameInstance.Instance.LookupDirector.GetPrefab(Ids.ROSA_SLIME).GetComponent<Vacuumable>().size = 0;
        TranslationPatcher.AddActorTranslation("l.rosa_slime", "Rosa Slime");
        LookupRegistry.RegisterIdentifiablePrefab(val8);
        TranslationPatcher.AddActorTranslation("l.rosa_plort", "Rosa Plort");
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, Ids.ROSA_PLORT);
        Identifiable.PLORT_CLASS.Add(Ids.ROSA_PLORT);
        Identifiable.NON_SLIMES_CLASS.Add(Ids.ROSA_PLORT);
        AmmoRegistry.RegisterAmmoPrefab(0, val8);

        var val10 = Main.AssetsBundle.LoadAsset<Sprite>("rosaplort");
        LookupRegistry.RegisterVacEntry(VacItemDefinition.CreateVacItemDefinition(Ids.ROSA_PLORT, Color.white, val10));
        AmmoRegistry.RegisterSiloAmmo(x => x is 0 or SiloStorage.StorageType.PLORT, Ids.ROSA_PLORT);
        PlortRegistry.AddEconomyEntry(Ids.ROSA_PLORT, 12f, 4f);
        PlortRegistry.AddPlortEntry(Ids.ROSA_PLORT);
        DroneRegistry.RegisterBasicTarget(Ids.ROSA_PLORT);
        AmmoRegistry.RegisterRefineryResource(Ids.ROSA_PLORT);
        val2.AddComponent<RosaBehaviour>();
    }
}