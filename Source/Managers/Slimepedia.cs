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
    public static bool MvExists;

    private static bool SamExists;
    private static Transform RocksPrefab;
    private static SlimeDefinition TarrDef;
    private static SlimeExpressionFace Sleeping;
    private static SlimeAppearanceObject SkinnedPrefab;

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

    private static readonly SlimeAppearance.SlimeBone[] AttachedBones =
    [
        SlimeAppearance.SlimeBone.Slime,
        SlimeAppearance.SlimeBone.JiggleRight,
        SlimeAppearance.SlimeBone.JiggleLeft,
        SlimeAppearance.SlimeBone.JiggleTop,
        SlimeAppearance.SlimeBone.JiggleBottom,
        SlimeAppearance.SlimeBone.JiggleFront,
        SlimeAppearance.SlimeBone.JiggleBack
    ];

#if DEBUG
    [TimeDiagnostic("Slimes Preload")]
#endif
    public static void PreloadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        MgExists = SRModLoader.IsModPresent("luckygordo");
        MvExists = SRModLoader.IsModPresent("more_vaccing");

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

        var pinkAppearance = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0];

        var blink = pinkAppearance.Face._expressionToFaceLookup[SlimeExpression.Blink];
        Sleeping = new()
        {
            SlimeExpression = Ids.Sleeping,
            Eyes = blink.Eyes?.Clone(),
            Mouth = blink.Mouth?.Clone()
        };
        Sleeping.Eyes?.SetTexture(FaceAtlas, Inventory.GetTexture2D("sleeping_eyes"));

        SkinnedPrefab = pinkAppearance.Structures[0].Element.Prefabs[0];

        TarrDef = IdentifiableId.TARR_SLIME.GetSlimeDefinition();

        Array.ForEach(Slimes, BaseLoadSlime);
    }

    private static void BaseLoadSlime(SlimeData slimeData)
    {
        CreateSlime(slimeData);
        CreatePlort(slimeData);

        if (slimeData.HasGordo)
            CreateGordo(slimeData);

        if (SamExists)
            RegisterSlimeBypass(slimeData);
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

        var identifiable = prefab.GetComponent<GordoIdentifiable>();
        identifiable.id = slimeData.GordoId;
        identifiable.nativeZones = !slimeData.NaturalGordoSpawn ? Helpers.GetEnumValues<Zone>() : [slimeData.GordoZone];

        var gordoEat = prefab.GetComponent<GordoEat>();
        var gordoDefinition = gordoEat.slimeDefinition.DeepCopy();
        gordoDefinition.AppearancesDefault = definition.AppearancesDefault;
        gordoDefinition.Diet = definition.Diet;
        gordoDefinition.IdentifiableId = slimeData.GordoId;
        gordoDefinition.Name = name;
        gordoDefinition.name = lower + "_gordo";
        gordoEat.slimeDefinition = gordoDefinition;
        gordoEat.targetCount = slimeData.GordoEatAmount;

        var appearance = definition.AppearancesDefault[0];
        var material = appearance.Structures[0].DefaultMaterials[0].Clone();

        if (lower == "sand")
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
        prefabRend.sharedMaterial = material;
        gordoObj.GenerateGordoBones(slimeData, prefabRend);

        prefab.AddComponent<PersistentIdHandler>().ID = ModdedStringRegistry.ClaimID("gordo", $"{slimeData.Name}G1{slimeData.GordoZone.ToString().ToTitleCase()}");

        slimeData.InitGordoDetails?.Invoke(null, [prefab, gordoDefinition]);

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
        for (var i = 0; i < slimeData.PlortFeatures.Length; i++)
        {
            var first = i == 0;
            var meshName = slimeData.PlortFeatures[i];
            var rocks = first ? prefab.transform : RocksPrefab.Instantiate(prefab.transform);
            var filter = rocks.GetComponent<MeshFilter>();
            var isNull = meshName.Mesh == null;
            filter.sharedMesh = isNull ? filter.mesh.Clone() : Inventory.GetMesh(meshName.Mesh);

            var rend = rocks.GetComponent<MeshRenderer>();
            var material = GenerateMaterial(slimeData.PlortFeatures[i], slimeData.SlimeFeatures, rend.sharedMaterial);

            if (first)
                rend.sharedMaterial = material;
            else
            {
                rend.sharedMaterials = [material];

                if (!isNull)
                    rocks.name = meshName.Mesh;
            }
        }

        var definition = slimeData.MainId.GetSlimeDefinition();

        slimeData.InitPlortDetails?.Invoke(null, [prefab, definition]);

        // Registering the prefab and its id along with any other additional stuff
        var icon = Inventory.GetSprite($"{slimeData.Name.ToLowerInvariant()}_plort");
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, slimeData.PlortId);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.PlortId);
        LookupRegistry.RegisterVacEntry(slimeData.PlortId, slimeData.PlortAmmoColor!.Value, icon);
        PlortRegistry.AddEconomyEntry(slimeData.PlortId, slimeData.BasePrice, slimeData.Saturation);
        PlortRegistry.AddPlortEntry(slimeData.PlortId, slimeData.Progress);
        DroneRegistry.RegisterBasicTarget(slimeData.PlortId);
        var silo = new List<StorageType> { StorageType.NON_SLIMES, StorageType.PLORT };

        if (slimeData.CanBeRefined)
            silo.Add(StorageType.CRAFTING);

        AmmoRegistry.RegisterSiloAmmo(silo.Contains, slimeData.PlortId);

        if (slimeData.CanBeRefined)
            AmmoRegistry.RegisterRefineryResource(slimeData.PlortId);

        if (!slimeData.Vaccable)
            PediaRegistry.RegisterIdentifiableMapping(Helpers.ParseEnum<PediaId>(slimeData.Name.ToUpperInvariant() + "_SLIME_ENTRY"), slimeData.PlortId);

        if (slimeData.Exchangeable)
            Helpers.CreateRanchExchangeOffer(slimeData.PlortId, slimeData.PlortExchangeWeight, slimeData.Progress);
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
        definition.Diet.AdditionalFoods = [IdentifiableId.SPICY_TOFU];
        definition.Diet.EatMap?.Clear();
        definition.CanLargofy = Identifiable.LARGO_CLASS.Any(x => x.ToString().ToLowerInvariant().IndexOf(lower, StringComparison.Ordinal) >= 0);
        definition.FavoriteToys = [slimeData.FavToy];
        definition.Name = slimeData.Name + " Slime";
        definition.IdentifiableId = slimeData.MainId;
        definition.name = slimeData.Name;

        if (slimeData.Diet.HasValue)
            definition.Diet.MajorFoodGroups = [slimeData.Diet.Value];

        if (slimeData.FavFood.HasValue)
            definition.Diet.Favorites = [slimeData.FavFood.Value];

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

        if (slimeData.ComponentBase.HasValue)
        {
            foreach (var component in slimeData.ComponentBase.Value.GetPrefab().GetComponents<Component>())
            {
                var type = component.GetType();

                if (!prefab.HasComponent(type))
                    prefab.AddComponent(type).CopyValuesFrom(component);
            }
        }

        BasicInitSlimeAppearance(appearance, applicator, slimeData);
        SlimeRegistry.RegisterAppearance(definition, appearance);

        slimeData.InitSlimeDetails?.Invoke(null, [prefab, definition, appearance]); // Slime specific details being put here

        definition.AppearancesDefault = [appearance];

        // Tarrs should love these guys
        TarrDef.Diet.EatMap.Add(new()
        {
            eats = slimeData.MainId,
            becomesId = IdentifiableId.TARR_SLIME,
            driver = SlimeEmotions.Emotion.NONE,
            extraDrive = 999999f
        });

        // Register everything
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterSlimeDefinition(definition);

        if (slimeData.Exchangeable)
            Helpers.CreateRanchExchangeOffer(slimeData.MainId, slimeData.ExchangeWeight, slimeData.Progress);

        if (slimeData.Vaccable)
        {
            AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.MainId);
            LookupRegistry.RegisterVacEntry(slimeData.MainId, appearance.ColorPalette.Ammo, appearance.Icon);
        }

        PediaRegistry.RegisterIdEntry(Helpers.ParseEnum<PediaId>(slimeData.Name.ToUpperInvariant() + "_SLIME_ENTRY"), appearance.Icon);

        if (Main.ClsExists)
            Main.AddIconBypass(appearance.Icon);
    }

    private static void RegisterSlimeBypass(SlimeData slimeData) => SlimesAndMarket.MarketRegistry.RegisterSlime(slimeData.MainId, slimeData.PlortId, progress: slimeData.Progress);

    private static void BasicInitSlimeAppearance(SlimeAppearance appearance, SlimeAppearanceApplicator applicator, SlimeData slimeData)
    {
        var baseStruct = appearance.Structures[0];
        appearance.Structures = new SlimeAppearanceStructure[slimeData.SlimeFeatures.Length];

        for (var i = 0; i < slimeData.SlimeFeatures.Length; i++)
            appearance.Structures[i] = GenerateStructure(baseStruct, slimeData.SlimeFeatures[i], slimeData.SlimeFeatures);

        applicator.GenerateSlimeBones(appearance.Structures, slimeData.Jiggle);
    }

    public static SlimeAppearanceStructure GenerateStructure(SlimeAppearanceStructure baseStruct, ModelData modelData, ModelData[] modelDatas)
    {
        if (modelData.Skip)
            return null;

        var structure = new SlimeAppearanceStructure(baseStruct);

        if (structure.DefaultMaterials.Length > 0)
            structure.DefaultMaterials[0] = GenerateMaterial(modelData, modelDatas, structure.DefaultMaterials[0]);

        var isNull = modelData.Mesh == null;

        if (isNull && modelData.SkipNull)
        {
            if (modelData.InstantiatePrefabs)
            {
                var elemInner = structure.Element = structure.Element.DeepCopy();

                for (var i = 0; i < structure.Element.Prefabs.Length; i++)
                    elemInner.Prefabs[i] = elemInner.Prefabs[i].DeepCopy();
            }

            return structure;
        }

        var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        elem.name = elem.Name = modelData.Name?.Replace("(Clone)", "") ?? (modelData.IsBody ? "Body" : "Structure");
        structure.SupportsFaces = modelData.IsBody;

        if (modelData.IgnoreLodIndex)
        {
            var prefab = SkinnedPrefab.CreatePrefab();
            prefab.IgnoreLODIndex = true;
            prefab.gameObject.AddComponent<ModelDataHandler>().Jiggle = modelData.Jiggle;
            var rend = prefab.GetComponent<SkinnedMeshRenderer>();
            rend.sharedMesh = isNull ? rend.sharedMesh.Clone() : Inventory.GetMesh(modelData.Mesh);
            elem.Prefabs = [prefab];
        }
        else
        {
            var length = modelData.IsBody ? 4 : 2;
            elem.Prefabs = new SlimeAppearanceObject[length];

            for (var j = 0; j < length; j++)
            {
                if (!baseStruct.Element.Prefabs.TryGetItem(j, out var prefab))
                    break;

                var isFirst = j == 0;

                if (isFirst || !isNull)
                    prefab = prefab.CreatePrefab();

                if (prefab.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                    rend.sharedMesh = isNull ? rend.sharedMesh.Clone() : Inventory.GetMesh(modelData.Mesh + "_LOD0");
                else if (!isNull && prefab.TryGetComponent<MeshFilter>(out var filter))
                    filter.sharedMesh = Inventory.GetMesh(modelData.Mesh + "_LOD" + j);

                if (!isNull)
                {
                    prefab.name = modelData.Mesh + "_LOD" + j;
                    prefab.transform.localPosition = Vector3.zero;
                    prefab.transform.localEulerAngles = Vector3.zero;
                }

                if (isFirst)
                    prefab.gameObject.AddComponent<ModelDataHandler>().Jiggle = modelData.Jiggle;

                prefab.LODIndex = j;
                elem.Prefabs[j] = prefab;
            }
        }

        return structure;
    }

    private static Material GenerateMaterial(ModelData matData, ModelData[] mainMatData, Material fallback)
    {
        if (matData == null)
            return fallback.Clone();

        // ReSharper disable once RedundantAssignment
        var setProps = true;
        var cloneMat = false;
        Material material;

        if (matData.CachedMaterial)
        {
            material = matData.CachedMaterial;
            setProps = false;
        }
        // else if (matData.Shader != null)
        //     material = new(Inventory.GetShader(matData.Shader));
        else if (matData.MatOrigin.HasValue)
        {
            material = GetMat(matData.MatOrigin.Value, matData.MatSameAs);
            setProps = cloneMat = matData.CloneMatOrigin;
        }
        else if (matData.SameAs.HasValue && mainMatData?.Length is > 0)
        {
            material = mainMatData[matData.SameAs.Value].CachedMaterial;
            setProps = cloneMat = matData.CloneSameAs;
        }
        else
        {
            material = fallback;
            setProps = cloneMat = matData.CloneFallback;
        }

        if (cloneMat)
        {
            material = material.Clone();

            if (matData.Name != null)
                material.name = matData.Name;
        }

        if (setProps)
            SetMatProperties(matData, material);

        matData.CachedMaterial = material;
        return material;
    }

    private static Material GetMat(IdentifiableId source, int? index) => Identifiable.IsPlort(source)
        ? source.GetPrefab().GetComponent<MeshRenderer>().sharedMaterials[index ?? 0]
        : source.GetSlimeDefinition().AppearancesDefault[0].Structures[index ?? 0].DefaultMaterials[0];

    public static void SetMatProperties(ModelData modelData, Material material)
    {
        if (modelData.ColorsOrigin.HasValue)
        {
            var temp = GetMat(modelData.ColorsOrigin.Value, modelData.ColorsSameAs);

            if (temp.HasProperty(TopColor))
                modelData.ColorProps[modelData.InvertColorOriginColors ? BottomColor : TopColor] = temp.GetColor(TopColor);

            if (temp.HasProperty(MiddleColor))
                modelData.ColorProps[MiddleColor] = temp.GetColor(MiddleColor);

            if (temp.HasProperty(BottomColor))
                modelData.ColorProps[modelData.InvertColorOriginColors ? TopColor : BottomColor] = temp.GetColor(BottomColor);
        }

        if (modelData.Gloss.HasValue && material.HasProperty(Gloss))
            material.SetFloat(Gloss, modelData.Gloss.Value);

        if (modelData.Pattern != null)
        {
            if (material.HasProperty(StripeTexture))
                material.SetTexture(StripeTexture, Inventory.GetTexture2D(modelData.Pattern));

            if (material.HasProperty(ColorMask))
                material.SetTexture(ColorMask, Inventory.GetTexture2D(modelData.Pattern));
        }

        foreach (var (prop, value) in modelData.ColorProps)
        {
            if (material.HasProperty(prop))
                material.SetColor(prop, value);
        }
    }

    private static void GenerateGordoBones(this Transform gordo, SlimeData slimeData, SkinnedMeshRenderer prefabRend)
    {
        if (slimeData.GordoFeatures.Length == 0)
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

        for (var i = 0; i < slimeData.GordoFeatures.Length; i++)
        {
            var meshName = slimeData.GordoFeatures[i];
            var isNull = meshName.Mesh == null;
            var isFirst = i == 0;
            var mesh = isNull
                ? sharedMesh.Clone()
                : (isFirst || meshName.Mesh.EndsWith("_gordo", StringComparison.Ordinal)
                    ? Inventory.GetMesh(meshName.Mesh)
                    : Inventory.GetMesh(meshName.Mesh + "_LOD0"));

            var vertices2 = mesh.vertices;
            var weights = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
                weights[n] = HandleBoneWeight(vertices2[n] - zero, num, meshName.Jiggle ?? 1f);

            mesh.boneWeights = weights;
            mesh.bindposes = poses;

            mesh.RecalculateBounds();
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();

            var meshRend = isFirst ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = parent;

            if (!isNull && !isFirst)
                meshRend.name = meshName.Mesh;

            var material = GenerateMaterial(slimeData.GordoFeatures[i], slimeData.SlimeFeatures, meshRend.sharedMaterial);

            if (isFirst)
                meshRend.sharedMaterial = material;
            else
                meshRend.sharedMaterials = [material];
        }
    }

    private static BoneWeight HandleBoneWeight(Vector3 diff, float num, float jiggleFactor)
    {
        var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleFactor);
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

    public static void GenerateSlimeBones(this SlimeAppearanceApplicator applicator, SlimeAppearanceStructure[] structures, float jiggleAmount)
    {
        Mesh sharedMesh = null;
        var list = new List<(SkinnedMeshRenderer, Mesh, float?)>(structures.Length);

        foreach (var structure in structures)
        {
            var rendHandled = false;

            foreach (var appearanceObject in structure.Element.Prefabs)
            {
                if (!appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var rend) || rendHandled)
                    continue;

                appearanceObject.AttachedBones = AttachedBones;

                var mesh = rend.sharedMesh;
                list.Add((rend, mesh, appearanceObject.GetComponent<ModelDataHandler>()?.Jiggle));

                if (structure.Element.Name.IndexOf("body", StringComparison.OrdinalIgnoreCase) >= 0 && !sharedMesh)
                    sharedMesh = mesh;

                rendHandled = true;
            }
        }

        if (list.Count == 0 || !sharedMesh)
            return;

        var rootMatrix = applicator.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
        var poses = new Matrix4x4[AttachedBones.Length];

        for (var i = 0; i < AttachedBones.Length; i++)
        {
            var bone = AttachedBones[i];
            poses[i] = applicator.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
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

        foreach (var (rend, mesh, jiggleFactor) in list)
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
                var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * (jiggleFactor ?? jiggleAmount));
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
            mesh.RecalculateNormals();
            mesh.RecalculateTangents();

            rend.localBounds = mesh.bounds;
        }
    }

    [UsedImplicitly]
    public static void InitRosiGordoDetails(GameObject _, SlimeDefinition definition) => GordoSnarePatch.Pinks = [IdentifiableId.PINK_GORDO, definition.IdentifiableId];

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
        go.AddComponent<MeshFilter>().sharedMesh = Inventory.GetMesh("hermit_shell_LOD1");
        go.AddComponent<MeshRenderer>().sharedMaterials = appearance.Structures[1].DefaultMaterials;
    }

    [UsedImplicitly]
    public static void InitMesmerSlimeDetails(GameObject _1, SlimeDefinition definition, SlimeAppearance _2) => Largopedia.Mesmers.Add(definition.IdentifiableId);

    [UsedImplicitly]
    public static void InitGoldfishPlortDetails(GameObject prefab, SlimeDefinition definition) => definition.IdentifiableId.GetPrefab().GetComponent<GoldSlimeProducePlorts>().plortPrefab = prefab;

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