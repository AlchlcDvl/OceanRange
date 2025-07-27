using AssetsLib;
using SRML;
using SRML.SR.SaveSystem;
using SRML.Utils;
using UnityEngine.UI;

namespace OceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// TODO: Finish largo setup; relegated to next update most likely
public static class SlimeManager
{
    public static readonly List<CustomSlimeData> Slimes = [];
    // public static readonly string[] VanillaSlimes = ["PINK", "ROCK", "PHOSPHOR", "CRYSTAL", "RAD", "BOOM", "TANGLE", "DERVISH", "TABBY", "HUNTER", "SABER", "HONEY", "MOSAIC", "QUANTUM"]; // WIP
    public static bool MgExists;

    private static bool SamExists;
    private static Transform RocksPrefab;

    private static readonly int TopColor = Shader.PropertyToID("_TopColor");
    private static readonly int MiddleColor = Shader.PropertyToID("_MiddleColor");
    private static readonly int BottomColor = Shader.PropertyToID("_BottomColor");
    private static readonly int Gloss = Shader.PropertyToID("_Gloss");
    private static readonly int StripeTexture = Shader.PropertyToID("_StripeTexture");
    private static readonly int MouthTop = Shader.PropertyToID("_MouthTop");
    private static readonly int MouthMiddle = Shader.PropertyToID("_MouthMid");
    private static readonly int MouthBottom = Shader.PropertyToID("_MouthBot");
    private static readonly int EyeRed = Shader.PropertyToID("_EyeRed");
    private static readonly int EyeGreen = Shader.PropertyToID("_EyeGreen");
    private static readonly int EyeBlue = Shader.PropertyToID("_EyeBlue");
    private static readonly int FaceAtlas = Shader.PropertyToID("_FaceAtlas");
    private static readonly int VertexOffset = Shader.PropertyToID("_VertexOffset");

#if DEBUG
    [TimeDiagnostic("Slimes Preload")]
#endif
    public static void PreLoadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        MgExists = SRModLoader.IsModPresent("luckygordo");

        Slimes.AddRange(AssetManager.GetJson<CustomSlimeData[]>("slimepedia"));

        AssetManager.UnloadAsset<JsonAsset>("slimepedia");

        TranslationPatcher.AddUITranslation("m.foodgroup.dirt", "Dirt");
        TranslationPatcher.AddUITranslation("m.foodgroup.dirt_gordo", "Silky Sand");

        SRCallbacks.PreSaveGameLoad += _ =>
        {
            var spawners = UObject.FindObjectsOfType<DirectedSlimeSpawner>();

            foreach (var slimeData in Slimes)
            {
                var prefab = slimeData.MainId.GetPrefab();

                foreach (var item in spawners.Where(spawner => Helpers.IsValidZone(spawner, slimeData.Zones)))
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

                if (slimeData.HasGordo && slimeData.MainId != Ids.SAND_SLIME)
                    Helpers.BuildGordo(slimeData, AssetManager.GetResource<GameObject>("cell" + slimeData.GordoLocation).FindChild("Sector/Slimes"));
            }
        };

        // var modded = Slimes.Select(x => x.Name.ToUpper()).ToArray(); // WIP
        // Slimes.ForEach(x => x.GenerateLargos(modded));
    }

#if DEBUG
    [TimeDiagnostic("Slimes Load")]
#endif
    public static void LoadAllSlimes()
    {
        RocksPrefab = IdentifiableId.ROCK_PLORT.GetPrefab().transform.Find("rocks");

        Slimes.ForEach(BaseLoadSlime);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseLoadSlime(CustomSlimeData slimeData)
    {
        CreatePlort(slimeData);
        CreateSlime(slimeData);

        if (slimeData.HasGordo)
            CreateGordo(slimeData);

        if (SamExists)
            TypeLoadExceptionBypass(slimeData);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateGordo(CustomSlimeData slimeData)
    {
        var prefab = slimeData.BaseGordo.GetPrefab().CreatePrefab();
        prefab.name = "gordo" + slimeData.Name;

        var definition = slimeData.MainId.GetSlimeDefinition();
        var appearance = definition.AppearancesDefault[0];
        var material = appearance.Structures[0].DefaultMaterials[0].Clone();

        var lower = slimeData.Name.ToLower();
        var name = slimeData.Name + " Gordo";

        var gordoDisplay = prefab.GetComponent<GordoDisplayOnMap>();
        var markerPrefab = gordoDisplay.markerPrefab.CreatePrefab();
        markerPrefab.name = "Gordo" + slimeData.Name + "Marker";
        markerPrefab.GetComponent<Image>().sprite = AssetManager.GetSprite($"{lower}gordo");
        gordoDisplay.markerPrefab = markerPrefab;

        var isSand = slimeData.MainId == Ids.SAND_SLIME;

        var identifiable = prefab.GetComponent<GordoIdentifiable>();
        identifiable.id = slimeData.GordoId;
        identifiable.nativeZones = isSand ? EnumUtils.GetAll(Zone.RANCH) : [slimeData.GordoZone];

        var gordoEat = prefab.GetComponent<GordoEat>();
        var gordoDefinition = gordoEat.slimeDefinition.DeepCopy();
        gordoDefinition.AppearancesDefault = definition.AppearancesDefault;
        gordoDefinition.Diet = definition.Diet;
        gordoDefinition.IdentifiableId = slimeData.GordoId;
        gordoDefinition.Name = name;
        gordoDefinition.name = lower + "_gordo";
        gordoEat.slimeDefinition = gordoDefinition;
        gordoEat.targetCount = 50;

        if (slimeData.SpecialDiet)
            gordoEat.allEats = [slimeData.FavFood];

        if (isSand)
        {
            material.SetFloat(VertexOffset, 0f);

            var face = prefab.GetComponent<GordoFaceComponents>();
            face.blinkEyes = appearance.Face.GetExpressionFace(SlimeFace.SlimeExpression.Blink).Eyes;
            face.strainEyes = appearance.Face.GetExpressionFace(SlimeFace.SlimeExpression.Scared).Eyes;
            face.chompOpenMouth = material;
            face.happyMouth = material;
            face.strainMouth = material;
        }

        var rewards = prefab.GetComponent<GordoRewards>();
        rewards.rewardPrefabs = [..slimeData.GordoRewards.Select(x => x.GetPrefab())];
        rewards.slimePrefab = slimeData.MainId.GetPrefab();
        rewards.rewardOverrides = [];

        var gordoObj = prefab.transform.Find("Vibrating/slime_gordo");

        var meshRend = gordoObj.GetComponent<SkinnedMeshRenderer>();
        meshRend.sharedMaterial = material;
        meshRend.sharedMaterials[0] = material;
        meshRend.material = material;
        meshRend.materials[0] = material;

        prefab.AddComponent<CustomGordo>().ID = ModdedStringRegistry.ClaimID("gordo", $"{slimeData.Name}G1{slimeData.GordoZone.ToString().ToTitleCase()}");

        slimeData.InitGordoDetails?.Invoke(null, [prefab, gordoDefinition, gordoObj]);

        TranslationPatcher.AddPediaTranslation("t." + gordoDefinition.name, name);
        TranslationPatcher.AddActorTranslation("l." + slimeData.GordoId.ToString().ToLower(), name);
        LookupRegistry.RegisterGordo(prefab);
        SlimeRegistry.RegisterSlimeDefinition(gordoDefinition);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreatePlort(CustomSlimeData slimeData)
    {
        // First create a prefab and set details
        var prefab = slimeData.BasePlort.GetPrefab().CreatePrefab();
        prefab.name = "plort" + slimeData.Name;
        prefab.GetComponent<Identifiable>().id = slimeData.PlortId;
        prefab.GetComponent<Vacuumable>().size = 0;

        // Next set up the mesh and material details
        var meshRend = prefab.GetComponent<MeshRenderer>();
        var material = meshRend.material = meshRend.material.Clone();

        var topMatColor = slimeData.TopPlortColor?.HexToColor();
        var middleMatColor = slimeData.MiddlePlortColor?.HexToColor();
        var bottomMatColor = slimeData.BottomPlortColor?.HexToColor();

        if (topMatColor.HasValue)
            material.SetColor(TopColor, topMatColor.Value);

        if (middleMatColor.HasValue)
            material.SetColor(MiddleColor, middleMatColor.Value);

        if (bottomMatColor.HasValue)
            material.SetColor(BottomColor, bottomMatColor.Value);

        var nameLower = slimeData.Name.ToLower();
        var plortLower = slimeData.PlortType.ToLower();

        if (plortLower != "plort") // Plort (crystal) is the original shape of a plort, so skip if the plort type is that
        {
            var filter = prefab.GetComponent<MeshFilter>();
            filter.mesh = filter.sharedMesh = AssetManager.GetMesh(plortLower);
        }

        // Add any slime specific plort details (which is almost all slimes)
        var plortDetails = $"{nameLower}_{plortLower}";

        if (AssetManager.AssetExists(plortDetails))
        {
            var rocks = RocksPrefab.Instantiate(prefab.transform);
            var filter = rocks.GetComponent<MeshFilter>();
            filter.mesh = filter.sharedMesh = AssetManager.GetMesh(plortDetails);
            rocks.GetComponent<MeshRenderer>().material = material.Clone();
            rocks.name = plortDetails;
        }

        slimeData.InitPlortDetails?.Invoke(null, [prefab]);

        // Registering the prefab and its id along with any other additional stuff
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, slimeData.PlortId);
        TranslationPatcher.AddActorTranslation("l." + slimeData.PlortId.ToString().ToLower(), $"{slimeData.Name} {slimeData.PlortType}");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.PlortId);
        LookupRegistry.RegisterVacEntry(slimeData.PlortId, slimeData.PlortAmmoColor.HexToColor(), AssetManager.GetSprite($"{nameLower}plort"));
        PlortRegistry.AddEconomyEntry(slimeData.PlortId, slimeData.BasePrice, slimeData.Saturation);
        PlortRegistry.AddPlortEntry(slimeData.PlortId, slimeData.Progress);
        DroneRegistry.RegisterBasicTarget(slimeData.PlortId);
        var silo = new List<StorageType> { StorageType.NON_SLIMES, StorageType.PLORT };

        if (slimeData.CanBeRefined)
            silo.Add(StorageType.CRAFTING);

        AmmoRegistry.RegisterSiloAmmo(silo.Contains, slimeData.PlortId);

        if (slimeData.CanBeRefined)
            AmmoRegistry.RegisterRefineryResource(slimeData.PlortId);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateSlime(CustomSlimeData slimeData)
    {
        var baseDefinition = slimeData.BaseSlime.GetSlimeDefinition(); // Finding the base slime definition to go off of
        var lower = slimeData.Name.ToLower();

        // Create a copy for our slimes and populate with info
        var definition = baseDefinition.DeepCopy();
        definition.Diet.Produces = [slimeData.PlortId];
        definition.Diet.MajorFoodGroups = slimeData.SpecialDiet ? [] : [slimeData.Diet];
        definition.Diet.AdditionalFoods = slimeData.MainId == Ids.SAND_SLIME ? [] : [IdentifiableId.SPICY_TOFU];
        definition.Diet.Favorites = slimeData.SpecialDiet ? [] : [slimeData.FavFood];
        definition.Diet.EatMap?.Clear();
        definition.CanLargofy = slimeData.CanLargofy;
        definition.FavoriteToys = [slimeData.FavToy];
        definition.Name = slimeData.Name + " Slime";
        definition.IdentifiableId = slimeData.MainId;
        definition.name = lower + "_slime";

        // Finding the base prefab, copying it and setting our own component values
        var prefab = slimeData.BaseSlime.GetPrefab().CreatePrefab();
        prefab.name = "slime" + slimeData.Name;
        prefab.GetComponent<PlayWithToys>().slimeDefinition = definition;
        prefab.GetComponent<SlimeEat>().slimeDefinition = definition;
        prefab.GetComponent<Identifiable>().id = slimeData.MainId;
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
        var topMatColor = slimeData.TopSlimeColor?.HexToColor();
        var middleMatColor = slimeData.MiddleSlimeColor?.HexToColor();
        var bottomMatColor = slimeData.BottomSlimeColor?.HexToColor();

        // Creating a material for each structure
        foreach (var structure in appearance.Structures)
        {
            if (structure.DefaultMaterials?.Length is null or 0)
                continue;

            var material = structure.DefaultMaterials[0] = structure.DefaultMaterials[0].Clone();

            if (topMatColor.HasValue)
                material.SetColor(TopColor, topMatColor.Value);

            if (middleMatColor.HasValue)
                material.SetColor(MiddleColor, middleMatColor.Value);

            if (bottomMatColor.HasValue)
                material.SetColor(BottomColor, bottomMatColor.Value);

            material.SetFloat(Gloss, slimeData.Gloss);
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
                face.Mouth.SetColor(MouthMiddle, middleMouth);
                face.Mouth.SetColor(MouthBottom, bottomMouth);
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
            Bottom = slimeData.BottomPaletteColor.HexToColor(),
            Ammo = slimeData.MainAmmoColor.HexToColor()
        };

        appearance.Icon = AssetManager.GetSprite($"{lower}slime");
        applicator.Appearance = appearance;

        slimeData.InitSlimeDetails?.Invoke(null, [prefab, definition, appearance, applicator, slimeData.JiggleAmount]); // Slime specific details being put here

        definition.AppearancesDefault = [appearance];

        // Tarrs should love these guys
        IdentifiableId.TARR_SLIME.GetSlimeDefinition().Diet.EatMap.Add(new()
        {
            eats = slimeData.MainId,
            becomesId = IdentifiableId.TARR_SLIME,
            driver = SlimeEmotions.Emotion.NONE,
            extraDrive = 999999f
        });

        // Register everything
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterSlimeDefinition(definition);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.MainId);
        LookupRegistry.RegisterVacEntry(slimeData.MainId, appearance.ColorPalette.Ammo, appearance.Icon);
        var title = slimeData.Name + " Slime";
        var slimeIdName = slimeData.MainId.ToString().ToLower();
        TranslationPatcher.AddPediaTranslation("t." + slimeIdName, title);
        TranslationPatcher.AddActorTranslation("l." + slimeIdName, title);

        SlimePediaCreation.PreLoadSlimePediaConnection(slimeData.MainEntry, slimeData.MainId, PediaCategory.SLIMES);
        SlimePediaCreation.CreateSlimePediaForSlimeWithName(slimeData.MainEntry, title, slimeData.MainIntro, slimeData.PediaDiet, slimeData.Fav, slimeData.Slimeology, slimeData.Risks, slimeData.Plortonomics);
        PediaRegistry.RegisterIdEntry(slimeData.MainEntry, appearance.Icon);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void TypeLoadExceptionBypass(CustomSlimeData slimeData)
#if DEBUG
        => TypeLoadExceptionBypass2(slimeData);

    private static void TypeLoadExceptionBypass2(CustomSlimeData slimeData)
#endif
    {
        try
        {
            SlimesAndMarket.ExtraSlimes.RegisterSlime(slimeData.MainId, slimeData.PlortId, progress: slimeData.Progress); // Since it's a soft dependency but still requires the code from the mod to work, this method was made
        }
        catch (Exception e)
        {
            Main.Console.LogError(e);
        }
    }

    private static void BasicInitSlimeAppearance
    (
        GameObject prefab,
        SlimeAppearance appearance, SlimeAppearanceApplicator applicator,
        string[] meshes,
        Action<int, SlimeAppearanceStructure> materialHandler,
        Type[] toAdd, Type[] toRemove,
        float jiggleAmount,
        bool skipNull = false
    )
    {
        toAdd?.Do(x => prefab.AddComponent(x));
        toRemove?.Do(prefab.RemoveComponent);

        if (meshes?.Length is null or 0 || (meshes.Length == 1 && meshes[0] == null && skipNull))
            return;

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
            var meshName = meshes[i];
            var isNull = meshName == null;
            var structure = appearance.Structures[i];

            if (isNull && skipNull)
            {
                if (i == 0)
                    slimeBase = structure.Element.Prefabs[0];

                continue;
            }

            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab();
            elem.Prefabs = [prefab2];
            var meshRend = prefab2.GetComponent<SkinnedMeshRenderer>();
            meshRend.sharedMesh = isNull ? meshRend.sharedMesh.Clone() : AssetManager.GetMesh(meshName);
            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            materialHandler?.Invoke(i, structure);

            if (structure.SupportsFaces)
                slimeBase = prefab2;
            else if (i > 0)
                prefabsForBoneData[i - 1] = prefab2;
        }

        MeshUtils.GenerateBoneData(applicator, slimeBase, jiggleAmount, 1f, prefabsForBoneData);
    }

    private static void GenerateBones(this Transform gordo, float jiggleAmount, Action<int, SkinnedMeshRenderer> materialHandler, params string[] meshNames)
    {
        if (meshNames.Length == 0)
            return;

        var prefabRend = gordo.GetComponent<SkinnedMeshRenderer>();
        var sharedMesh = prefabRend.sharedMesh;
        var vertices = sharedMesh.vertices;
        var zero = vertices.Aggregate(Vector3.zero, (current, vector) => current + vector) / vertices.Length;
        var num = vertices.Sum(vector => (vector - zero).magnitude) / vertices.Length;
        var parent = gordo.parent;
        var parentObj = parent.gameObject.FindChild("bone_root");

        var bones = new[]
        {
            parentObj.FindChild("bone_slime").transform,
            parentObj.FindChild("bone_skin_rig", true).transform,
            parentObj.FindChild("bone_skin_lef", true).transform,
            parentObj.FindChild("bone_skin_top", true).transform,
            parentObj.FindChild("bone_skin_bot", true).transform,
            parentObj.FindChild("bone_skin_fro", true).transform,
            parentObj.FindChild("bone_skin_bac", true).transform,
        };

        var rootMatrix = parent.localToWorldMatrix;

        for (var i = 0; i < meshNames.Length; i++)
        {
            var meshName = meshNames[i];
            var isNull = meshName == null;
            var mesh = isNull ? sharedMesh.Clone() : AssetManager.GetMesh(meshName);

            var vertices2 = mesh.vertices;
            var weights = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
                weights[n] = HandleBoneWeight(vertices2[n] - zero, num, jiggleAmount);

            mesh.boneWeights = weights;
            var poses = new Matrix4x4[bones.Length];

            for (var k = 0; k < bones.Length; k++)
                poses[k] = bones[k].worldToLocalMatrix * rootMatrix;

            mesh.bindposes = poses;
            mesh.RecalculateBounds();

            var meshRend = i == 0 ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = meshRend.bones[0];

            if (!isNull && i != 0)
                meshRend.name = meshName;

            materialHandler?.Invoke(i, meshRend);
        }
    }

    private static BoneWeight HandleBoneWeight(Vector3 diff, float num, float jiggleAmount)
    {
        var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
        var weight = new BoneWeight
        {
            m_Weight0 = 1f - jiggle,
            m_BoneIndex0 = 0
        };

        if (jiggle == 0f)
            return weight;

        weight.m_BoneIndex1 = diff.x >= 0f ? 1 : 2;
        weight.m_BoneIndex2 = diff.y >= 0f ? 3 : 4;
        weight.m_BoneIndex3 = diff.z >= 0f ? 5 : 6;

        var value = diff.Multiply(diff);
        var normal = value.Sum();

        if (normal > 0f)
            value /= normal;

        value *= jiggle;

        weight.m_Weight1 = value.x;
        weight.m_Weight2 = value.y;
        weight.m_Weight3 = value.z;

        return weight;
    }

    public static void InitRosiSlimeDetails(GameObject prefab, SlimeDefinition definition, SlimeAppearance appearance, SlimeAppearanceApplicator applicator, float jiggleAmount)
    {
        definition.Diet.MajorFoodGroups = IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet.MajorFoodGroups;
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
            },
            [typeof(RosiBehaviour)],
            null,
            jiggleAmount
        );
    }

    public static void InitRosiGordoDetails(GameObject _, SlimeDefinition definition, Transform gordoObj)
    {
        var structs = definition.AppearancesDefault[0].Structures;
        gordoObj.GenerateBones(1f, (i, meshRend) =>
        {
            if (i == 0)
                return;

            meshRend.material = meshRend.sharedMaterial = structs[i].DefaultMaterials[0];
            meshRend.materials = meshRend.sharedMaterials = [meshRend.material];
        }, "rosi_body_gordo", "rosi_stalk_gordo", "rosi_frills_gordo");
    }

    public static void InitCocoSlimeDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator, float jiggleAmount) => BasicInitSlimeAppearance
    (
        prefab, appearance, applicator,
        null,
        null,
        // FIXME: Coco mesh doesn't work atm
        // ["coco_body", "coco_brows"],
        // (i, structure) =>
        // {
        //     if (i == 0)
        //         return;

        //     var color = "#633C00".HexToColor();
        //     var material = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        //     material.SetColor(TopColor, color);
        //     material.SetColor(MiddleColor, color);
        //     material.SetColor(BottomColor, color);
        //     material.SetFloat(Gloss, 1f);
        //     structure.DefaultMaterials[0] = material;
        // },
        [typeof(CocoBehaviour)],
        null,
        jiggleAmount
    );

    public static void InitMineSlimeDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator, float jiggleAmount)
    {
        var color = "#445660".HexToColor();
        var color2 = "#9ea16f".HexToColor();
        var color3 = "#212A2F".HexToColor();

        var material = IdentifiableId.TABBY_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color2);
        material.SetColor(MiddleColor, color2);
        material.SetColor(BottomColor, color);
        material.SetFloat(Gloss, 1f);

        var material2 = material.Clone();
        material2.SetColor(TopColor, color3);
        material2.SetColor(MiddleColor, color3);
        material2.SetColor(BottomColor, color3);

        material.SetTexture(StripeTexture, AssetManager.GetTexture2D("minepattern"));

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, [null, "mine_spikes", "mine_ring"],
            (_, structure) => structure.DefaultMaterials[0] = structure.SupportsFaces ? material : material2,
            [typeof(MineBehaviour)],
            [typeof(BoomSlimeExplode), typeof(BoomMaterialAnimator)],
            jiggleAmount
        );
    }

    public static void InitMineGordoDetails(GameObject _, SlimeDefinition definition, Transform gordoObj)
    {
        var material = definition.AppearancesDefault[0].Structures[1].DefaultMaterials[0];

        var color = "#445660".HexToColor();
        var material2 = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material2.SetColor(TopColor, color);
        material2.SetColor(MiddleColor, color);
        material2.SetColor(BottomColor, color);
        material2.SetFloat(Gloss, 1f);

        gordoObj.GenerateBones(1f, (i, meshRend) =>
        {
            meshRend.material = meshRend.sharedMaterial = i == 0 ? material2 : material;

            if (i == 0)
                meshRend.materials[0] = meshRend.sharedMaterials[0] = material2;
            else
                meshRend.materials = meshRend.sharedMaterials = [material];
        }, null, "mine_ring_gordo", "mine_spikes_gordo");
    }

    public static void InitLanternSlimeDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator, float jiggleAmount)
    {
        var color = "#752C86".HexToColor();
        var color2 = "#B15EC8".HexToColor();

        var material = appearance.Structures[0].DefaultMaterials[0].Clone();
        material.SetColor(TopColor, color);
        material.SetColor(MiddleColor, "#9445A7".HexToColor());
        material.SetColor(BottomColor, color2);
        material.SetFloat(Gloss, 1f);

        var material2 = IdentifiableId.TABBY_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material2.SetColor(TopColor, color);
        material2.SetColor(MiddleColor, color);
        material2.SetColor(BottomColor, color2);
        material2.SetFloat(Gloss, 1f);
        material2.SetTexture(StripeTexture, AssetManager.GetTexture2D("lanternpattern"));

        var color3 = "#EBDB6A".HexToColor();
        var material3 = IdentifiableId.PHOSPHOR_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
        material3.SetColor(TopColor, color3);
        material3.SetColor(MiddleColor, color3);
        material3.SetColor(BottomColor, color3);

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, [null, "lantern_fins", "lantern_stalk", "lantern_lure"],
            (i, structure) => structure.DefaultMaterials[0] = i switch
            {
                1 => material2,
                3 => material3,
                _ => material
            },
            [typeof(LanternBehaviour)],
            null,
            jiggleAmount
        );

        var blink = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Face._expressionToFaceLookup[SlimeFace.SlimeExpression.Blink];
        var sleeping = new SlimeExpressionFace()
        {
            SlimeExpression = Ids.Sleeping,
            Eyes = blink.Eyes?.Clone(),
            Mouth = blink.Mouth?.Clone()
        };
        sleeping.Eyes?.SetTexture(FaceAtlas, AssetManager.GetTexture2D("sleepingeyes"));
        appearance.Face.ExpressionFaces = [.. appearance.Face.ExpressionFaces, sleeping];
        appearance.Face._expressionToFaceLookup[Ids.Sleeping] = sleeping;
    }

    public static void InitLanternGordoDetails(GameObject _, SlimeDefinition definition, Transform gordoObj)
    {
        var structs = definition.AppearancesDefault[0].Structures;

        gordoObj.GenerateBones(1f, (i, meshRend) =>
        {
            if (i == 0)
                return;

            meshRend.material = meshRend.sharedMaterial = structs[i].DefaultMaterials[0];
            meshRend.materials = meshRend.sharedMaterials = [meshRend.material];
        }, null, "lantern_fins", "lantern_stalk", "lantern_lure");
    }

    public static void InitSandSlimeDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance, SlimeAppearanceApplicator applicator, float jiggleAmount)
    {
        SandBehaviour.ProduceFX = prefab.GetComponent<SlimeEatWater>().produceFX;

        BasicInitSlimeAppearance
        (
            prefab, appearance, applicator, [null, "sand_shells"],
            (i, structure) =>
            {
                if (i == 0)
                    return;

                var color = "#F4E2CC".HexToColor();
                var material = structure.DefaultMaterials[0] = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0].Clone();
                material.SetColor(TopColor, color);
                material.SetColor(MiddleColor, color);
                material.SetColor(BottomColor, color);
                material.SetFloat(Gloss, 1f);
            },
            [typeof(SandBehaviour)],
            [typeof(GotoWater), typeof(GotoConsumable), typeof(DestroyOnTouching), typeof(SlimeEatWater)],
            jiggleAmount,
            true
        );
    }

    public static void InitSandPlortDetails(GameObject prefab) => SandBehaviour.PlortPrefab = prefab;
}