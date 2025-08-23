using AssetsLib;
using OceanRange.Patches;
using OceanRange.Saves;
using SRML;
using SRML.SR.SaveSystem;
using SRML.Utils;
using UnityEngine.UI;

namespace OceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// TODO: Finish largo setup; relegated to next update most likely
// FIXME: Coco mesh doesn't work atm
public static class SlimeManager
{
    public static readonly Dictionary<string, HashSet<string>> PlortTypesToSlimesMap = new()
    {
        ["Plort"] = ["PINK", "SABER", "QUANTUM", "HONEY", "PHOSPHOR", "MOSAIC", "TANGLE", "BOOM", "RAD", "ROCK", "TABBY", "HUNTER", "CRYSTAL", "DERVISH"],
        ["Pearl"] = [],
    };

    public static readonly HashSet<IdentifiableId> MesmerLargos = new(Identifiable.idComparer)
    {
        /*Ids.PINK_MESMER_LARGO,
        Ids.COCO_MESMER_LARGO,
        Ids.SABER_MESMER_LARGO,
        Ids.QUANTUM_MESMER_LARGO,
        Ids.HONEY_MESMER_LARGO,
        Ids.PHOSPHOR_MESMER_LARGO,
        Ids.MOSAIC_MESMER_LARGO,
        Ids.TANGLE_MESMER_LARGO,
        Ids.BOOM_MESMER_LARGO,
        Ids.RAD_MESMER_LARGO,
        Ids.ROCK_MESMER_LARGO,
        Ids.TABBY_MESMER_LARGO,
        Ids.HUNTER_MESMER_LARGO,
        Ids.CRYSTAL_MESMER_LARGO,
        Ids.DERVISH_MESMER_LARGO,
        Ids.MESMER_HERMIT_LARGO*/
    };

    public static CustomSlimeData[] Slimes;
    public static bool MgExists;

    private static bool SamExists;
    private static Transform RocksPrefab;
    private static SlimeExpressionFace Sleeping;

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
    private static readonly int MainTex = Shader.PropertyToID("_MainTex");
    private static readonly int Color1 = Shader.PropertyToID("_Color");

#if DEBUG
    [TimeDiagnostic("Slimes Preload")]
#endif
    public static void PreLoadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        MgExists = SRModLoader.IsModPresent("luckygordo");

        Slimes = AssetManager.GetJsonArray<CustomSlimeData>("slimepedia");

        GordoSnarePatch.Pinks = [IdentifiableId.PINK_GORDO, Ids.ROSI_GORDO];
        GordoSaveData.Lookup = Slimes.Where(x => x.HasGordo && x.NaturalGordoSpawn).ToDictionary(x => x.GordoId);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
        SRCallbacks.OnSaveGameLoaded += OnSaveLoaded;
    }

#if DEBUG
    [TimeDiagnostic("Slime OnSavePreLoad")]
#endif
    private static void PreOnSaveLoad(SceneContext _)
    {
        var spawners = UObject.FindObjectsOfType<DirectedSlimeSpawner>();

        foreach (var slimeData in Slimes)
        {
            var prefab = slimeData.MainId.GetPrefab();

            foreach (var slimeSpawner in spawners.Where(spawner => Helpers.IsValidZone(spawner, slimeData.Zones)))
            {
                foreach (var constraint in slimeSpawner.constraints)
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
        }
    }

#if DEBUG
    [TimeDiagnostic("Slime OnSaveLoad")]
#endif
    private static void OnSaveLoaded(SceneContext _)
    {
        foreach (var slimeData in Slimes)
        {
            if (slimeData.HasGordo && slimeData.NaturalGordoSpawn)
                Helpers.BuildGordo(slimeData, GameObject.Find("zone" + slimeData.GordoZone + "/cell" + slimeData.GordoLocation + "/Sector/Slimes"));
        }
    }

#if DEBUG
    [TimeDiagnostic("Slimes Load")]
#endif
    public static void LoadAllSlimes()
    {
        RocksPrefab = IdentifiableId.ROCK_PLORT.GetPrefab().transform.Find("rocks");
        var blink = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Face._expressionToFaceLookup[SlimeFace.SlimeExpression.Blink];
        Sleeping = new SlimeExpressionFace()
        {
            SlimeExpression = Ids.Sleeping,
            Eyes = blink.Eyes?.Clone(),
            Mouth = blink.Mouth?.Clone()
        };
        Sleeping.Eyes?.SetTexture(FaceAtlas, AssetManager.GetTexture2D("sleeping_eyes"));

        Array.ForEach(Slimes, BaseLoadSlime);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseLoadSlime(CustomSlimeData slimeData)
    {
        CreateSlime(slimeData);
        CreatePlort(slimeData);

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

        var lower = slimeData.Name.ToLowerInvariant();
        var name = slimeData.Name + " Gordo";

        var icon = AssetManager.GetSprite($"{lower}_gordo");

        var gordoDisplay = prefab.GetComponent<GordoDisplayOnMap>();
        var markerPrefab = gordoDisplay.markerPrefab.CreatePrefab();
        markerPrefab.name = "Gordo" + slimeData.Name + "Marker";
        markerPrefab.GetComponent<Image>().sprite = icon;
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

        var appearance = definition.AppearancesDefault[0];
        var material = appearance.Structures[0].DefaultMaterials[0].Clone();

        if (isSand)
        {
            material.SetFloat(VertexOffset, 0f);

            var face = prefab.GetComponent<GordoFaceComponents>();
            face.chompOpenMouth = face.happyMouth = face.strainMouth = material;
        }

        var rewards = prefab.GetComponent<GordoRewards>();
        rewards.rewardPrefabs = [.. slimeData.GordoRewards.Select(x => x.GetPrefab())];
        rewards.slimePrefab = slimeData.MainId.GetPrefab();
        rewards.rewardOverrides = [];

        var gordoObj = prefab.transform.Find("Vibrating/slime_gordo");
        var prefabRend = gordoObj.GetComponent<SkinnedMeshRenderer>();
        prefabRend.material = prefabRend.sharedMaterial = material;
        gordoObj.GenerateGordoBones(slimeData, prefabRend);

        prefab.AddComponent<PersistentId>().ID = ModdedStringRegistry.ClaimID("gordo", $"{slimeData.Name}G1{slimeData.GordoZone.ToString().ToTitleCase()}");

        slimeData.InitGordoDetails?.Invoke(null, [prefab, gordoDefinition]);

        TranslationPatcher.AddPediaTranslation("t." + gordoDefinition.name, name);
        TranslationPatcher.AddActorTranslation("l." + slimeData.GordoId.ToString().ToLowerInvariant(), name);
        LookupRegistry.RegisterGordo(prefab);
        SlimeRegistry.RegisterSlimeDefinition(gordoDefinition);

        if (Main.ClsExists)
            Main.AddIconBypass(icon);
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
        for (var i = 0; i < slimeData.PlortMeshes.Length; i++)
        {
            var meshName = slimeData.PlortMeshes[i];
            var rocks = i == 0 ? prefab.transform : RocksPrefab.Instantiate(prefab.transform);
            var filter = rocks.GetComponent<MeshFilter>();
            var isNull = meshName == null;
            filter.mesh = filter.sharedMesh = isNull ? filter.mesh.Clone() : AssetManager.GetMesh(meshName);

            if (!isNull)
                rocks.name = meshName;

            var rend = rocks.GetComponent<MeshRenderer>();
            var material = GenerateMaterial(i, slimeData.SlimeMatData, slimeData.PlortMatData, rend.material, slimeData.Name);
            rend.material = rend.sharedMaterial = material;

            if (i != 0)
                rend.materials = rend.sharedMaterials = [material];
        }

        var definition = slimeData.MainId.GetSlimeDefinition();

        slimeData.InitPlortDetails?.Invoke(null, [prefab, definition]);

        // Registering the prefab and its id along with any other additional stuff
        var icon = AssetManager.GetSprite($"{slimeData.Name.ToLowerInvariant()}_plort");
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, slimeData.PlortId);
        TranslationPatcher.AddActorTranslation("l." + slimeData.PlortId.ToString().ToLowerInvariant(), $"{slimeData.Name} {slimeData.PlortType}");
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.PlortId);
        LookupRegistry.RegisterVacEntry(slimeData.PlortId, slimeData.PlortAmmoColor!.Value, icon);
        PlortRegistry.AddEconomyEntry(slimeData.PlortId, slimeData.BasePrice, slimeData.Saturation);
        PlortRegistry.AddPlortEntry(slimeData.PlortId, slimeData.Progress);
        DroneRegistry.RegisterBasicTarget(slimeData.PlortId);
        Helpers.CreateRanchExchangeOffer(slimeData.PlortId, slimeData.PlortExchangeWeight, slimeData.Progress);
        var silo = new List<StorageType> { StorageType.NON_SLIMES, StorageType.PLORT };

        if (slimeData.CanBeRefined)
            silo.Add(StorageType.CRAFTING);

        AmmoRegistry.RegisterSiloAmmo(silo.Contains, slimeData.PlortId);

        if (slimeData.CanBeRefined)
            AmmoRegistry.RegisterRefineryResource(slimeData.PlortId);

        if (Main.ClsExists)
            Main.AddIconBypass(icon);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateSlime(CustomSlimeData slimeData)
    {
        var baseDefinition = slimeData.BaseSlime.GetSlimeDefinition(); // Finding the base slime definition to go off of
        var lower = slimeData.Name.ToLowerInvariant();

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

        // Try to remove pink slime food tracker, skip if there's no such component
        if (prefab.TryGetComponent<PinkSlimeFoodTypeTracker>(out var tracker))
            tracker.Destroy();

        var baseAppearance = baseDefinition.AppearancesDefault[0]; // Getting the base appearance
        var appearance = baseAppearance.DeepCopy(); // Cloning our own appearance
        appearance.name = $"{slimeData.Name}Normal";

        appearance.Face.ExpressionFaces = [.. appearance.Face.ExpressionFaces, Sleeping.Clone()];

        // Faces stuff
        foreach (var face in appearance.Face.ExpressionFaces)
        {
            if (face.Mouth)
            {
                if (slimeData.TopMouthColor.HasValue)
                    face.Mouth.SetColor(MouthTop, slimeData.TopMouthColor.Value);

                if (slimeData.MiddleMouthColor.HasValue)
                    face.Mouth.SetColor(MouthMiddle, slimeData.MiddleMouthColor.Value);

                if (slimeData.BottomMouthColor.HasValue)
                    face.Mouth.SetColor(MouthBottom, slimeData.BottomMouthColor.Value);
            }

            if (face.Eyes)
            {
                if (slimeData.RedEyeColor.HasValue)
                    face.Eyes.SetColor(EyeRed, slimeData.RedEyeColor.Value);

                if (slimeData.GreenEyeColor.HasValue)
                    face.Eyes.SetColor(EyeGreen, slimeData.GreenEyeColor.Value);

                if (slimeData.BlueEyeColor.HasValue)
                    face.Eyes.SetColor(EyeBlue, slimeData.BlueEyeColor.Value);
            }
        }

        appearance.Face.OnEnable();
        var prevPalette = appearance.ColorPalette;
        appearance.ColorPalette = new()
        {
            Top = slimeData.TopPaletteColor ?? prevPalette.Top,
            Middle = slimeData.MiddlePaletteColor ?? prevPalette.Middle,
            Bottom = slimeData.BottomPaletteColor ?? prevPalette.Bottom,
            Ammo = slimeData.MainAmmoColor
        };

        appearance.Icon = AssetManager.GetSprite($"{lower}_slime");
        applicator.Appearance = appearance;

        if (slimeData.ComponentsToAdd != null)
        {
            foreach (var type in slimeData.ComponentsToAdd)
                prefab.AddComponent(type);
        }

        if (slimeData.ComponentsToRemove != null)
        {
            foreach (var type in slimeData.ComponentsToRemove)
                prefab.RemoveComponent(type);
        }

        BasicInitSlimeAppearance(appearance, applicator, slimeData);
        SlimeRegistry.RegisterAppearance(definition, appearance);

        slimeData.InitSlimeDetails?.Invoke(null, [prefab, definition, appearance]); // Slime specific details being put here

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
        Helpers.CreateRanchExchangeOffer(slimeData.MainId, slimeData.ExchangeWeight, slimeData.Progress);

        var title = slimeData.Name + " Slime";
        var slimeIdName = slimeData.MainId.ToString().ToLowerInvariant();
        TranslationPatcher.AddPediaTranslation("t." + slimeIdName, title);
        TranslationPatcher.AddActorTranslation("l." + slimeIdName, title);

        SlimePediaCreation.PreLoadSlimePediaConnection(slimeData.MainEntry, slimeData.MainId, PediaCategory.SLIMES);
        SlimePediaCreation.CreatePediaForSlime(slimeData.MainEntry, title, slimeData.MainIntro, slimeData.PediaDiet, slimeData.Fav, slimeData.Slimeology, slimeData.Risks, slimeData.Plortonomics);
        PediaRegistry.RegisterIdEntry(slimeData.MainEntry, appearance.Icon);

        if (Main.ClsExists)
            Main.AddIconBypass(appearance.Icon);
    }

    private static void TypeLoadExceptionBypass(CustomSlimeData slimeData)
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

    private static void BasicInitSlimeAppearance(SlimeAppearance appearance, SlimeAppearanceApplicator applicator, CustomSlimeData slimeData)
    {
        var firstStructure = appearance.Structures[0];
        var elemPrefab = firstStructure.Element.Prefabs[0];

        appearance.Structures = new SlimeAppearanceStructure[slimeData.SlimeMeshes.Length];
        appearance.Structures[0] = firstStructure;

        for (var i = 1; i < slimeData.SlimeMeshes.Length; i++)
            appearance.Structures[i] = new(firstStructure);

        SlimeAppearanceObject slimeBase = null;
        var prefabsForBoneData = new SlimeAppearanceObject[slimeData.SlimeMeshes.Length - 1];

        for (var i = 0; i < appearance.Structures.Length; i++)
        {
            var structure = appearance.Structures[i];

            structure.DefaultMaterials[0] = GenerateMaterial(i, slimeData.SlimeMatData, slimeData.SlimeMatData, structure.DefaultMaterials[0], slimeData.Name);

            var meshName = slimeData.SlimeMeshes[i];
            var isNull = meshName == null;

            if (isNull && slimeData.SkipNullMesh)
            {
                if (i == 0)
                    slimeBase = structure.Element.Prefabs[0];

                continue;
            }

            var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
            var prefab2 = elemPrefab.CreatePrefab();
            elem.Prefabs = [prefab2];
            elem.name = elem.Name = i == 0 ? "Body" : "Structure";
            var meshRend = prefab2.GetComponent<SkinnedMeshRenderer>();
            meshRend.sharedMesh = isNull ? meshRend.sharedMesh.Clone() : AssetManager.GetMesh(meshName);

            if (!isNull)
                meshRend.name = meshName;

            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            if (structure.SupportsFaces)
                slimeBase = prefab2;
            else if (i > 0)
                prefabsForBoneData[i - 1] = prefab2;
        }

        applicator.GenerateSlimeBones(slimeBase, slimeData.JiggleAmount, prefabsForBoneData);
    }

    private static Material GenerateMaterial(int i, MaterialData[] slimeMatData, MaterialData[] currMatData, Material fallback, string name)
    {
        var matData = currMatData[i];
        var setColors = true;
        Material material;

        if (matData.CachedMaterial)
        {
            material = matData.CachedMaterial;
            setColors = false;
        }
        else if (matData.OrShaderName != null)
        {
            var isTextured = matData.OrShaderName == "textured_overlay";

            if (isTextured && matData.Pattern == null)
                throw new MissingComponentException($"Missing associated pattern for {name}!");

            material = new(AssetManager.GetShader(matData.OrShaderName));

            if (isTextured)
                material.SetTexture(MainTex, AssetManager.GetTexture2D(matData.Pattern));
        }
        else if (matData.MatOriginSlime != null)
        {
            var isTabby = matData.MatOriginSlime is IdentifiableId.TABBY_SLIME or IdentifiableId.TABBY_PLORT;

            if (matData.Pattern == null && isTabby) // Only the tabby slime has an easily changeable pattern
                throw new MissingComponentException($"Missing associated pattern for {name}!");

            material =
            (
                Identifiable.IsPlort(matData.MatOriginSlime.Value)
                ? matData.MatOriginSlime.Value.GetPrefab().GetComponent<MeshRenderer>().material
                : matData.MatOriginSlime.Value.GetSlimeDefinition().AppearancesDefault[0].Structures[0].DefaultMaterials[0]
            ).Clone();

            if (isTabby)
                material.SetTexture(StripeTexture, AssetManager.GetTexture2D(matData.Pattern));
        }
        else if (matData.SameAs != null)
        {
            material = slimeMatData[matData.SameAs.Value].CachedMaterial;
            setColors = matData.CloneSameAs;

            if (matData.CloneSameAs)
                material = material.Clone();
        }
        else
            material = fallback.Clone();

        if (setColors)
        {
            if (matData.OrShaderName == null)
            {
                if (matData.TopColor.HasValue)
                    material.SetColor(TopColor, matData.TopColor.Value);

                if (matData.MiddleColor.HasValue)
                    material.SetColor(MiddleColor, matData.MiddleColor.Value);

                if (matData.BottomColor.HasValue)
                    material.SetColor(BottomColor, matData.BottomColor.Value);
            }
            else if (matData.TopColor.HasValue)
                material.SetColor(Color1, matData.TopColor.Value);

            if (matData.Gloss.HasValue)
                material.SetFloat(Gloss, matData.Gloss.Value);
        }

        matData.CachedMaterial = material;
        return material;
    }

    private static void GenerateGordoBones(this Transform gordo, CustomSlimeData slimeData, SkinnedMeshRenderer prefabRend)
    {
        if (slimeData.GordoMeshes.Length == 0)
            return;

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
        var poses = new Matrix4x4[bones.Length];

        for (var k = 0; k < bones.Length; k++)
            poses[k] = bones[k].worldToLocalMatrix * rootMatrix;

        var sharedMesh = prefabRend.sharedMesh;
        var vertices = sharedMesh.vertices;
        var zero = Vector3.zero;

        foreach (var vector in vertices)
            zero += vector;

        zero /= vertices.Length;
        var num = 0f;

        foreach (var vector in vertices)
            num += (vector - zero).magnitude;

        num /= vertices.Length;

        for (var i = 0; i < slimeData.GordoMeshes.Length; i++)
        {
            var meshName = slimeData.GordoMeshes[i];
            var isNull = meshName == null;
            Mesh mesh;

            if (isNull)
                mesh = sharedMesh.Clone();
            else if (meshName.Contains("_clone"))
                mesh = AssetManager.GetMesh(meshName.Replace("_clone", "")).Clone();
            else
                mesh = AssetManager.GetMesh(meshName);

            var vertices2 = mesh.vertices;
            var weights = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
                weights[n] = HandleBoneWeight(vertices2[n] - zero, num);

            mesh.boneWeights = weights;
            mesh.bindposes = poses;
            mesh.RecalculateBounds();

            var meshRend = i == 0 ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = parent;

            if (!isNull && i != 0)
                meshRend.name = meshName;

            var material = GenerateMaterial(i, slimeData.SlimeMatData, slimeData.GordoMatData, meshRend.material, slimeData.Name);
            meshRend.material = meshRend.sharedMaterial = material;

            if (i == 0)
                meshRend.materials[0] = meshRend.sharedMaterials[0] = material;
            else
                meshRend.materials = meshRend.sharedMaterials = [material];
        }
    }

    private static BoneWeight HandleBoneWeight(Vector3 diff, float num)
    {
        var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f));
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

    private static void GenerateSlimeBones(this SlimeAppearanceApplicator slimePrefab, SlimeAppearanceObject bodyApp, float jiggleAmount, SlimeAppearanceObject[] appearanceObjects)
    {
        bodyApp.AttachedBones =
        [
            SlimeAppearance.SlimeBone.Slime,
            SlimeAppearance.SlimeBone.JiggleRight,
            SlimeAppearance.SlimeBone.JiggleLeft,
            SlimeAppearance.SlimeBone.JiggleTop,
            SlimeAppearance.SlimeBone.JiggleBottom,
            SlimeAppearance.SlimeBone.JiggleFront,
            SlimeAppearance.SlimeBone.JiggleBack
        ];

        var meshRend = bodyApp.GetComponent<SkinnedMeshRenderer>();
        var sharedMesh = meshRend.sharedMesh;

        var list = new List<(SkinnedMeshRenderer, Mesh)> { (meshRend, sharedMesh) };

        foreach (var appearanceObject in appearanceObjects)
        {
            if (!appearanceObject)
                throw new NullReferenceException("One or more of the SlimeAppearanceObjects are null");

            appearanceObject.AttachedBones = bodyApp.AttachedBones;

            if (appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                list.Add((rend, rend.sharedMesh));
            else
                Debug.LogWarning("One of the SlimeAppearanceObjects provided does not use a SkinnedMeshRenderer");
        }

        var rootMatrix = slimePrefab.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
        var poses = new Matrix4x4[bodyApp.AttachedBones.Length];

        for (var i = 0; i < bodyApp.AttachedBones.Length; i++)
        {
            var bone = bodyApp.AttachedBones[i];
            poses[i] = slimePrefab.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
        }

        var vertices = sharedMesh.vertices;
        var zero = Vector3.zero;

        foreach (var vector in vertices)
            zero += vector;

        zero /= vertices.Length;
        var num = 0f;

        foreach (var vector in vertices)
            num += (vector - zero).magnitude;

        num /= vertices.Length;

        foreach (var (rend, mesh) in list)
        {
            if (!mesh || !rend)
            {
                Debug.LogWarning("One of the meshes or mesh rends provided is null");
                continue;
            }

            var vertices2 = mesh.vertices;
            var weights = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
            {
                var diff = vertices2[n] - zero;
                var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
                var weight = new BoneWeight
                {
                    m_Weight0 = 1f - jiggle,
                    m_BoneIndex0 = 0
                };

                if (jiggle > 0f)
                {
                    weight.m_BoneIndex1 = diff.x >= 0f ? 1 : 2;
                    weight.m_BoneIndex2 = diff.y >= 0f ? 3 : 4;
                    weight.m_BoneIndex3 = diff.z >= 0f ? 5 : 6;

                    var value = diff.ToPower(3).Abs();
                    var normal = value.Sum();

                    if (normal > 0f)
                        value /= normal;

                    value *= jiggle;

                    weight.m_Weight1 = value.x;
                    weight.m_Weight2 = value.y;
                    weight.m_Weight3 = value.z;
                }

                weights[n] = weight;
            }

            mesh.boneWeights = weights;
            mesh.bindposes = poses;
            mesh.RecalculateBounds();

            rend.localBounds = mesh.bounds;
        }
    }

    public static void InitRosiSlimeDetails(GameObject _1, SlimeDefinition definition, SlimeAppearance _2)
    {
        definition.Diet.MajorFoodGroups = IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet.MajorFoodGroups;
        definition.Diet.Favorites = [];
    }

    public static void InitSandSlimeDetails(GameObject _1, SlimeDefinition _2, SlimeAppearance _3) => SandBehaviour.ProduceFX = IdentifiableId.PUDDLE_SLIME.GetPrefab().GetComponent<SlimeEatWater>().produceFX;

    public static void InitSandPlortDetails(GameObject prefab, SlimeDefinition _1) => SandBehaviour.PlortPrefab = prefab;

    public static void InitSandGordoDetails(GameObject prefab, SlimeDefinition _)
    {
        var eat = prefab.GetComponent<GordoEat>();
        eat.slimeDefinition.Diet = SlimeDiet.Combine(eat.slimeDefinition.Diet, IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet);
        IdentifiableId.SILKY_SAND_CRAFT.RegisterAsSnareable();
    }

#if DEBUG
    [TimeDiagnostic("Slime Postload")]
#endif
    public static void PostLoadSlimes()
    {
        foreach (var (id, prefab) in GameContext.Instance.LookupDirector.identifiablePrefabDict)
        {
            if (Identifiable.IsSlime(id) && id != Ids.MESMER_SLIME && !MesmerLargos.Contains(id)) // Ensuring that only non-mesmer slimes are affected
                prefab.AddComponent<AweTowardsMesmers>();
        }
    }
}