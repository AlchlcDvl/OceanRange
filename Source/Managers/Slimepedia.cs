using AssetsLib;
using OceanRange.Patches;
using OceanRange.Saves;
using SRML;
using SRML.SR.SaveSystem;
using UnityEngine.UI;

namespace OceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
// FIXME: Coco mesh doesn't work atm
public static class Slimepedia
{
    public static Dictionary<IdentifiableId, SlimeData> SlimeDataMap;
    public static SlimeData[] Slimes;
    public static bool MgExists;

    private static bool SamExists;
    private static Transform RocksPrefab;
    private static SlimeExpressionFace Sleeping;

    public static readonly int TopColor = ShaderUtils.GetOrSet("_TopColor");
    public static readonly int MiddleColor = ShaderUtils.GetOrSet("_MiddleColor");
    public static readonly int BottomColor = ShaderUtils.GetOrSet("_BottomColor");

    private static readonly int Gloss = ShaderUtils.GetOrSet("_Gloss");
    private static readonly int StripeTexture = ShaderUtils.GetOrSet("_StripeTexture");
    private static readonly int MouthTop = ShaderUtils.GetOrSet("_MouthTop");
    private static readonly int MouthMiddle = ShaderUtils.GetOrSet("_MouthMid");
    private static readonly int MouthBottom = ShaderUtils.GetOrSet("_MouthBot");
    private static readonly int EyeRed = ShaderUtils.GetOrSet("_EyeRed");
    private static readonly int EyeGreen = ShaderUtils.GetOrSet("_EyeGreen");
    private static readonly int EyeBlue = ShaderUtils.GetOrSet("_EyeBlue");
    private static readonly int FaceAtlas = ShaderUtils.GetOrSet("_FaceAtlas");
    private static readonly int VertexOffset = ShaderUtils.GetOrSet("_VertexOffset");
    // private static readonly int MainTex = ShaderUtils.GetOrSet("_MainTex");
    // private static readonly int Color = ShaderUtils.GetOrSet("_Color");
    private static readonly int ColorMask = ShaderUtils.GetOrSet("_ColorMask");

#if DEBUG
    [TimeDiagnostic("Slimes Preload")]
#endif
    public static void PreloadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        MgExists = SRModLoader.IsModPresent("luckygordo");

        Slimes = Inventory.GetJsonArray<SlimeData>("slimepedia");
        SlimeDataMap = Slimes.ToDictionary(x => x.MainId, Identifiable.idComparer);

        GordoSaveData.Lookup = Slimes.Where(x => x.HasGordo && x.NaturalGordoSpawn).ToDictionary(x => x.GordoId, Identifiable.idComparer);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
        SRCallbacks.OnSaveGameLoaded += OnSaveLoaded;
    }

#if DEBUG
    [TimeDiagnostic("Slime OnSavePreload")]
#endif
    private static void PreOnSaveLoad(SceneContext _)
    {
        var spawners = UObject.FindObjectsOfType<DirectedSlimeSpawner>();

        foreach (var slimeData in Slimes)
        {
            var prefab = slimeData.MainId.GetPrefab();

            foreach (var slimeSpawner in spawners.Where(spawner => Helpers.IsValidZone(spawner, slimeData.Zones, slimeData.ExcludedSpawners)))
            {
                foreach (var constraint in slimeSpawner.constraints)
                {
                    if (slimeData.NightSpawn && constraint.window.timeMode != TimeMode.NIGHT)
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
                Helpers.BuildGordo(slimeData, GameObject.Find("zone" + slimeData.GordoZone + "/cell" + slimeData.GordoCell + "/Sector/Slimes"));
        }
    }

#if DEBUG
    [TimeDiagnostic("Slimes Load")]
#endif
    public static void LoadAllSlimes()
    {
        RocksPrefab = IdentifiableId.ROCK_PLORT.GetPrefab().transform.Find("rocks");

        var blink = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0].Face._expressionToFaceLookup[SlimeExpression.Blink];
        Sleeping = new()
        {
            SlimeExpression = Ids.Sleeping,
            Eyes = blink.Eyes?.Clone(),
            Mouth = blink.Mouth?.Clone()
        };
        Sleeping.Eyes?.SetTexture(FaceAtlas, Inventory.GetTexture2D("sleeping_eyes"));

        Array.ForEach(Slimes, BaseLoadSlime);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void BaseLoadSlime(SlimeData slimeData)
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
    private static void CreateGordo(SlimeData slimeData)
    {
        var prefab = slimeData.BaseGordo.GetPrefab().CreatePrefab();
        prefab.name = "gordo" + slimeData.Name;

        var definition = slimeData.MainId.GetSlimeDefinition();

        var lower = slimeData.Name.ToLowerInvariant();
        var name = slimeData.Name + " Gordo";

        var icon = Inventory.GetSprite($"{lower}_gordo");

        var gordoDisplay = prefab.GetComponent<GordoDisplayOnMap>();
        var markerPrefab = gordoDisplay.markerPrefab.CreatePrefab();
        markerPrefab.name = "Gordo" + slimeData.Name + "Marker";
        markerPrefab.GetComponent<Image>().sprite = icon;
        gordoDisplay.markerPrefab = markerPrefab;

        var isSand = lower == "sand";

        var identifiable = prefab.GetComponent<GordoIdentifiable>();
        identifiable.id = slimeData.GordoId;
        identifiable.nativeZones = isSand ? Helpers.GetEnumValues<Zone>() : [slimeData.GordoZone];

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
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreatePlort(SlimeData slimeData)
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
            filter.mesh = filter.sharedMesh = isNull ? filter.mesh.Clone() : Inventory.GetMesh(meshName);

            if (!isNull)
                rocks.name = meshName;

            var rend = rocks.GetComponent<MeshRenderer>();
            var material = GenerateMaterial(slimeData.PlortMatData[i], slimeData.SlimeMatData, rend.material);
            rend.material = rend.sharedMaterial = material;

            if (i != 0)
                rend.materials = rend.sharedMaterials = [material];
        }

        var definition = slimeData.MainId.GetSlimeDefinition();

        slimeData.InitPlortDetails?.Invoke(null, [prefab, definition]);

        // Registering the prefab and its id along with any other additional stuff
        var icon = Inventory.GetSprite($"{slimeData.Name.ToLowerInvariant()}_plort");
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
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateSlime(SlimeData slimeData)
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
        definition.CanLargofy = Identifiable.LARGO_CLASS.Any(x => x.ToString().ToLowerInvariant().Contains(lower));
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

        appearance.Icon = Inventory.GetSprite($"{lower}_slime");
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

        SlimepediaCreation.PreloadSlimePediaConnection(slimeData.MainEntry, slimeData.MainId, PediaCategory.SLIMES);
        SlimepediaCreation.CreatePediaForSlime(slimeData.MainEntry, slimeData.MainId, slimeData.Name + " Slime", slimeData.MainIntro, slimeData.PediaDiet, slimeData.Fav, slimeData.Slimeology, slimeData.Risks, slimeData.Plortonomics);
        PediaRegistry.RegisterIdEntry(slimeData.MainEntry, appearance.Icon);

        if (Main.ClsExists)
            Main.AddIconBypass(appearance.Icon);
    }

    private static void TypeLoadExceptionBypass(SlimeData slimeData)
    {
        try
        {
            SlimesAndMarket.MarketRegistry.RegisterSlime(slimeData.MainId, slimeData.PlortId, progress: slimeData.Progress); // Since it's a soft dependency but still requires the code from the mod to work, this method was made
        }
        catch (Exception e)
        {
            Main.Console.LogError(e);
        }
    }

    private static void BasicInitSlimeAppearance(SlimeAppearance appearance, SlimeAppearanceApplicator applicator, SlimeData slimeData) => BasicInitSlimeAppearance(appearance, applicator, appearance.Structures[0], slimeData.SlimeMeshes,
        slimeData.SkipNullMesh, slimeData.JiggleAmount, slimeData.SlimeMatData);

    public static void BasicInitSlimeAppearance(SlimeAppearance appearance, SlimeAppearanceApplicator applicator, SlimeAppearanceStructure first, string[] meshes, bool skipNull, float jiggle, MaterialData[] matData)
    {
        var elemPrefab = first.Element.Prefabs[0];

        appearance.Structures = new SlimeAppearanceStructure[meshes.Length];
        appearance.Structures[0] = new(first);

        for (var i = 1; i < meshes.Length; i++)
            appearance.Structures[i] = new(first);

        SlimeAppearanceObject slimeBase = null;
        var prefabsForBoneData = new SlimeAppearanceObject[meshes.Length - 1];

        for (var i = 0; i < appearance.Structures.Length; i++)
        {
            var structure = appearance.Structures[i];

            structure.DefaultMaterials[0] = GenerateMaterial(matData[i], matData, structure.DefaultMaterials[0]);

            var meshName = meshes[i];
            var isNull = meshName == null;

            if (isNull && skipNull)
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
            meshRend.sharedMesh = isNull ? meshRend.sharedMesh.Clone() : Inventory.GetMesh(meshName);

            if (!isNull)
                meshRend.name = meshName;

            prefab2.IgnoreLODIndex = true;
            structure.SupportsFaces = i == 0;

            if (structure.SupportsFaces)
                slimeBase = prefab2;
            else if (i > 0)
                prefabsForBoneData[i - 1] = prefab2;
        }

        applicator.GenerateSlimeBones(slimeBase, jiggle, prefabsForBoneData);
    }

    public static Material GenerateMaterial(MaterialData matData, MaterialData[] mainMatData, Material fallback)
    {
        var setColors = true;
        var clone = false;
        Material material;

        if (matData.CachedMaterial)
        {
            material = matData.CachedMaterial;
            setColors = false;
        }
        // else if (matData.Shader != null)
        //     material = new(Array.Find(Resources.FindObjectsOfTypeAll<Shader>(), x => x.name.EndsWith(matData.Shader, StringComparison.OrdinalIgnoreCase))/* ?? AssetManager.GetShader(matData.Shader) */);
        else if (matData.MatOriginSlime.HasValue)
        {
            material = GetMat(matData.MatOriginSlime.Value, matData.SameAs);
            clone = matData.CloneMatOrigin;
        }
        else if (matData.SameAs.HasValue && mainMatData?.Length is > 0)
        {
            material = mainMatData[matData.SameAs.Value].CachedMaterial;
            setColors = matData.CloneSameAs;
            clone = matData.CloneSameAs;
        }
        else
        {
            material = fallback;
            clone = true;
        }

        if (clone)
                material = material.Clone();

        if (setColors)
            SetMatProperties(matData, material);

        matData.CachedMaterial = material;
        return material;
    }

    private static Material GetMat(IdentifiableId source, int? index) =>Identifiable.IsPlort(source)
        ? source.GetPrefab().GetComponent<MeshRenderer>().material
        : source.GetSlimeDefinition().AppearancesDefault[0].Structures[index ?? 0].DefaultMaterials[0];

    public static void SetMatProperties(MaterialData matData, Material material)
    {
        if (matData.ColorsOrigin.HasValue)
        {
            var temp = GetMat(matData.ColorsOrigin.Value, matData.SameAs);

            if (temp.HasProperty(TopColor))
                matData.TopColor ??= temp.GetColor(TopColor);

            if (temp.HasProperty(MiddleColor))
                matData.MiddleColor ??= temp.GetColor(MiddleColor);

            if (temp.HasProperty(BottomColor))
                matData.BottomColor ??= temp.GetColor(BottomColor);
        }

        if (matData.TopColor.HasValue && material.HasProperty(BottomColor))
            material.SetColor(TopColor, matData.TopColor.Value);

        if (matData.MiddleColor.HasValue && material.HasProperty(BottomColor))
            material.SetColor(MiddleColor, matData.MiddleColor.Value);

        if (matData.BottomColor.HasValue && material.HasProperty(BottomColor))
            material.SetColor(BottomColor, matData.BottomColor.Value);

        if (matData.Gloss.HasValue && material.HasProperty(Gloss))
            material.SetFloat(Gloss, matData.Gloss.Value);

        if (matData.Pattern != null)
        {
            if (material.HasProperty(StripeTexture))
                material.SetTexture(StripeTexture, Inventory.GetTexture2D(matData.Pattern));

            if (material.HasProperty(ColorMask))
                material.SetTexture(ColorMask, Inventory.GetTexture2D(matData.Pattern));
        }

        foreach (var (prop, value) in matData.MiscColorProps)
        {
            if (material.HasProperty(prop))
                material.SetColor(prop, value);
        }
    }

    private static void GenerateGordoBones(this Transform gordo, SlimeData slimeData, SkinnedMeshRenderer prefabRend)
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
            var mesh = isNull ? sharedMesh.Clone() : Inventory.GetMesh(meshName);

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

            var material = GenerateMaterial(slimeData.GordoMatData[i], slimeData.SlimeMatData, meshRend.material);
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

    [UsedImplicitly]
    public static void InitRosiSlimeDetails(GameObject _1, SlimeDefinition definition, SlimeAppearance _2)
    {
        definition.Diet.MajorFoodGroups = IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet.MajorFoodGroups;
        definition.Diet.Favorites = [];

        GordoSnarePatch.Pinks = [IdentifiableId.PINK_GORDO, Helpers.ParseEnum<IdentifiableId>("ROSI_GORDO")];
    }

    [UsedImplicitly]
    public static void InitSandSlimeDetails(GameObject _1, SlimeDefinition _2, SlimeAppearance _3) => SandBehaviour.ProduceFX = IdentifiableId.PUDDLE_SLIME.GetPrefab().GetComponent<SlimeEatWater>().produceFX;

    [UsedImplicitly]
    public static void InitSandPlortDetails(GameObject prefab, SlimeDefinition _1) => SandBehaviour.PlortPrefab = prefab;

    [UsedImplicitly]
    public static void InitSandGordoDetails(GameObject _, SlimeDefinition definition)
    {
        definition.Diet = SlimeDiet.Combine(definition.Diet, IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet);
        IdentifiableId.SILKY_SAND_CRAFT.RegisterAsSnareable();
    }

    [UsedImplicitly]
    public static void InitHermitSlimeDetails(GameObject prefab, SlimeDefinition _, SlimeAppearance appearance)
    {
        var go = new GameObject("Shell");
        go.SetActive(false);
        go.transform.SetParent(prefab.transform);
        go.AddComponent<MeshFilter>().sharedMesh = Inventory.GetMesh("hermit_shell");

        var rend = go.AddComponent<MeshRenderer>();
        var mats = appearance.Structures[1].DefaultMaterials;
        rend.sharedMaterial = mats[0];
        rend.sharedMaterials = mats;
    }

#if DEBUG
    [TimeDiagnostic("Slime Postload")]
#endif
    public static void PostLoadSlimes()
    {
        foreach (var (id, prefab) in GameContext.Instance.LookupDirector.identifiablePrefabDict)
        {
            if (Identifiable.IsSlime(id) && !Largopedia.Mesmers.Contains(id)) // Ensuring that only non-mesmer slimes are affected
                prefab.AddComponent<AweTowardsMesmers>();
        }
    }
}