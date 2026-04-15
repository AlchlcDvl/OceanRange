using DLCPackage;
using OceanRange.Patches;
using SRML;
using SRML.SR.SaveSystem;
using UnityEngine.UI;

namespace OceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code
[Manager(ManagerType.Slimepedia)]
public static class Slimepedia
{
    public static Dictionary<IdentifiableId, SlimeData> SlimeDataMap;
    public static Dictionary<IdentifiableId, SlimeData> PlortDataMap;
    public static SlimeData[] Slimes;
    public static bool MgExists;
    public static bool MvExists;
    // public static bool SstExists;
    // public static bool MoSsExists;
    private static bool SsExists;

    private static bool SamExists;
    private static bool FixerExists;
    private static Transform RocksPrefab;
    private static SlimeDefinition TarrDef;
    private static SlimeExpressionFace Sleeping;
    private static SlimeAppearanceObject SkinnedPrefab;

    private static readonly Dictionary<RigCacheKey, Mesh> RiggedSlimeMeshCache = [];
    private static readonly Dictionary<RigCacheKey, Mesh> RiggedGordoMeshCache = [];

    private static readonly Dictionary<ElementCacheKey, SlimeAppearanceElement> PrefabElementCache = [];

    public static readonly int TopColor = ShaderUtils.GetOrSet("_TopColor");
    public static readonly int MiddleColor = ShaderUtils.GetOrSet("_MiddleColor");
    public static readonly int BottomColor = ShaderUtils.GetOrSet("_BottomColor");

    private static readonly int Color = ShaderUtils.GetOrSet("_Color");
    private static readonly int Gloss = ShaderUtils.GetOrSet("_Gloss");
    private static readonly int EyeRed = ShaderUtils.GetOrSet("_EyeRed");
    private static readonly int EyeBlue = ShaderUtils.GetOrSet("_EyeBlue");
    // private static readonly int MainTex = ShaderUtils.GetOrSet("_MainTex");
    private static readonly int EyeGreen = ShaderUtils.GetOrSet("_EyeGreen");
    private static readonly int MouthTop = ShaderUtils.GetOrSet("_MouthTop");
    private static readonly int EdgeColor = ShaderUtils.GetOrSet("_EdgeColor");
    private static readonly int ColorMask = ShaderUtils.GetOrSet("_ColorMask");
    private static readonly int FaceAtlas = ShaderUtils.GetOrSet("_FaceAtlas");
    private static readonly int MouthMiddle = ShaderUtils.GetOrSet("_MouthMid");
    private static readonly int MouthBottom = ShaderUtils.GetOrSet("_MouthBot");
    private static readonly int VertexOffset = ShaderUtils.GetOrSet("_VertexOffset");
    private static readonly int StripeTexture = ShaderUtils.GetOrSet("_StripeTexture");

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

    private enum RigType : byte
    {
        Slime,
        Gordo
    }

    private readonly struct RigCacheKey(int sourceMeshId, RigType type, int jiggleBits, int zeroXBits, int zeroYBits, int zeroZBits, int numBits, ulong matrixHash1, ulong matrixHash2)
        : IEquatable<RigCacheKey>
    {
        private readonly int SourceMeshId = sourceMeshId;
        private readonly RigType Type = type;
        private readonly int JiggleBits = jiggleBits;
        private readonly int ZeroXBits = zeroXBits;
        private readonly int ZeroYBits = zeroYBits;
        private readonly int ZeroZBits = zeroZBits;
        private readonly int NumBits = numBits;
        private readonly ulong MatrixHash1 = matrixHash1;
        private readonly ulong MatrixHash2 = matrixHash2;

        public bool Equals(RigCacheKey other) => SourceMeshId == other.SourceMeshId && Type == other.Type && JiggleBits == other.JiggleBits && ZeroXBits == other.ZeroXBits && ZeroYBits == other.ZeroYBits && ZeroZBits == other.ZeroZBits && NumBits == other.NumBits && MatrixHash1 == other.MatrixHash1 && MatrixHash2 == other.MatrixHash2;

        public override bool Equals(object obj) => obj is RigCacheKey other && Equals(other);

        public override int GetHashCode()
        {
            unchecked
            {
                var hash = 17;
                hash = (hash * 31) + SourceMeshId;
                hash = (hash * 31) + (int)Type;
                hash = (hash * 31) + JiggleBits;
                hash = (hash * 31) + ZeroXBits;
                hash = (hash * 31) + ZeroYBits;
                hash = (hash * 31) + ZeroZBits;
                hash = (hash * 31) + NumBits;
                hash = (hash * 31) + (int)(MatrixHash1 ^ (MatrixHash1 >> 32));
                hash = (hash * 31) + (int)(MatrixHash2 ^ (MatrixHash2 >> 32));
                return hash;
            }
        }
    }

    private readonly struct ElementCacheKey(uint meshNameHash, int jiggleBits, bool ignoreLodIndex, int prefabLength)
        : IEquatable<ElementCacheKey>
    {
        private readonly uint MeshNameHash = meshNameHash;
        private readonly int JiggleBits = jiggleBits;
        private readonly bool IgnoreLodIndex = ignoreLodIndex;
        private readonly int PrefabLength = prefabLength;

        public bool Equals(ElementCacheKey other) => MeshNameHash == other.MeshNameHash && JiggleBits == other.JiggleBits && IgnoreLodIndex == other.IgnoreLodIndex && PrefabLength == other.PrefabLength;

        public override bool Equals(object obj) => obj is ElementCacheKey other && Equals(other);

        public override int GetHashCode()
        {
            unchecked
            {
                var hash = 17;
                hash = (hash * 31) + (int)MeshNameHash;
                hash = (hash * 31) + JiggleBits;
                hash = (hash * 31) + (IgnoreLodIndex ? 1 : 0);
                hash = (hash * 31) + PrefabLength;
                return hash;
            }
        }
    }

#if DEBUG
    [TimeDiagnostic("Slimes Preload")]
#endif
    [PreloadMethod]
    public static void PreloadSlimeData()
    {
        SamExists = SRModLoader.IsModPresent("slimesandmarket");
        MgExists = SRModLoader.IsModPresent("luckygordo");
        MvExists = SRModLoader.IsModPresent("more_vaccing");
        // SstExists = SRModLoader.IsModPresent("secretstylethings");
        // MoSsExists = SRModLoader.IsModPresent("mosecretstyles");
        FixerExists = SRModLoader.IsModPresent("appearancefixer");

        Slimes = Inventory.GetJsonArray<SlimeData>("slimepedia");

        SlimeDataMap = new(Identifiable.idComparer);
        PlortDataMap = new(Identifiable.idComparer);

        foreach (var slimeData in Slimes)
        {
            SlimeDataMap[slimeData.MainId] = slimeData;
            PlortDataMap[slimeData.PlortId] = slimeData;
        }

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
        SRCallbacks.OnSaveGameLoaded += OnSaveLoaded;
    }

    private static void HandleSecretStyles(Id id)
    {
        if (id != Id.SECRET_STYLE)
            return;

        if (!SsExists)
        {
            SsExists = true;
        }

        // foreach (var slimeData in Slimes)
        // {
        //     // Something...
        // }
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

            foreach (var slimeSpawner in spawners.Where(spawner => Helpers.IsValidZone(spawner, slimeData.Zones)))
            {
                foreach (var constraint in slimeSpawner.constraints)
                {
                    if (constraint.feral || (slimeData.NightSpawn && constraint.window.timeMode != TimeMode.NIGHT))
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
    [LoadMethod]
    public static void LoadAllSlimes()
    {
        GameContext.Instance.DLCDirector.onPackageInstalled += HandleSecretStyles;

        RocksPrefab = IdentifiableId.ROCK_PLORT.GetPrefab().transform.Find("rocks");

        var pinkAppearance = IdentifiableId.PINK_SLIME.GetSlimeDefinition().AppearancesDefault[0];

        Sleeping = pinkAppearance.Face._expressionToFaceLookup[SlimeExpression.Awe];
        Sleeping.SlimeExpression = Ids.Sleeping;
        Sleeping.Eyes = Sleeping.Eyes.Clone();
        Sleeping.Eyes.SetTexture(FaceAtlas, Inventory.GetTexture2D("sleeping_eyes"));

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
        identifiable.nativeZones = slimeData.NaturalGordoSpawn ? [slimeData.GordoZone] : Helpers.GetEnumValues<Zone>();

        var gordoEat = prefab.GetComponent<GordoEat>();
        var gordoDefinition = gordoEat.slimeDefinition.CloneInstance();
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
        gordoObj.GenerateGordoBones(slimeData.NormalAppearance, prefabRend);

        prefab.AddComponent<PersistentIdHandler>().ID = ModdedStringRegistry.ClaimID("gordo", $"{slimeData.Name}G1{slimeData.GordoZone.ToString().ToTitleCase()}");

        slimeData.InitGordoDetails?.Invoke(prefab, gordoDefinition);

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
        var normal = slimeData.NormalAppearance;

        // Next set up the mesh and material details
        for (var i = 0; i < normal.PlortFeatures.Length; i++)
        {
            var first = i == 0;
            var meshName = normal.PlortFeatures[i].MeshData;
            var rocks = first ? prefab.transform : RocksPrefab.Instantiate(prefab.transform);
            var filter = rocks.GetComponent<MeshFilter>();
            var isNull = meshName.Mesh == null;
            filter.sharedMesh = isNull ? filter.mesh.Clone() : Inventory.GetMesh(meshName.Mesh);

            var rend = rocks.GetComponent<MeshRenderer>();
            var material = GenerateMaterial(normal.PlortFeatures[i].MatData, normal.SlimeFeatures, rend.sharedMaterial);

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

        slimeData.InitPlortDetails?.Invoke(prefab, definition);

        // Registering the prefab and its id along with any other additional stuff
        var lower = slimeData.Name.ToLowerInvariant();
        var icon = Inventory.GetSprite($"{lower}_plort");
        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        PediaRegistry.RegisterIdentifiableMapping(PediaId.PLORTS, slimeData.PlortId);
        AmmoRegistry.RegisterPlayerAmmo(PlayerState.AmmoMode.DEFAULT, slimeData.PlortId);
        LookupRegistry.RegisterVacEntry(slimeData.PlortId, slimeData.NormalAppearance.PlortAmmoColor!.Value, icon);
        PlortRegistry.AddEconomyEntry(slimeData.PlortId, slimeData.BasePrice, slimeData.Saturation);
        PlortRegistry.AddPlortEntry(slimeData.PlortId, slimeData.Progress);
        DroneRegistry.RegisterBasicTarget(slimeData.PlortId);
        var silo = new HashSet<StorageType> { StorageType.NON_SLIMES, StorageType.PLORT };

        if (slimeData.CanBeRefined)
            silo.Add(StorageType.CRAFTING);

        AmmoRegistry.RegisterSiloAmmo(silo.Contains, slimeData.PlortId);

        if (lower != "sand")
            FoodGroup.PLORTS.RegisterId(slimeData.PlortId);

        if (slimeData.CanBeRefined)
            AmmoRegistry.RegisterRefineryResource(slimeData.PlortId);

        if (!slimeData.Vaccable)
            PediaRegistry.RegisterIdentifiableMapping(slimeData.PediaId, slimeData.PlortId);

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
        var definition = baseDefinition.CloneInstance();
        var previousDiet = definition.Diet;
        definition.Diet = new()
        {
            Produces = [slimeData.PlortId],
            AdditionalFoods = [IdentifiableId.SPICY_TOFU],
            EatMap = [],
            MajorFoodGroups = previousDiet.MajorFoodGroups,
            Favorites = previousDiet.Favorites
        };
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

        slimeData.InitSlimeDetails?.Invoke(prefab, definition); // Slime specific details being put here

        var baseAppearance = baseDefinition.AppearancesDefault[0]; // Getting the base appearance
        var appearance = GenerateAppearance(slimeData, slimeData.NormalAppearance, baseAppearance, lower, applicator, definition);
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

        PediaRegistry.RegisterIdEntry(slimeData.PediaId, appearance.Icon);
        FoodGroup.NONTARRGOLD_SLIMES.RegisterId(slimeData.MainId);

        if (Main.ClsExists)
            Main.AddIconBypass(appearance.Icon);
    }

    private static void RegisterSlimeBypass(SlimeData slimeData) => SlimesAndMarket.MarketRegistry.RegisterSlime(slimeData.MainId, slimeData.PlortId, progress: slimeData.Progress);

    private static SlimeAppearance GenerateAppearance(SlimeData slimeData, SlimeAppearanceData data, SlimeAppearance baseAppearance, string lower, SlimeAppearanceApplicator applicator, SlimeDefinition definition)
    {
        var appearance = baseAppearance.Instantiate(); // Cloning our own appearance
        appearance.name = $"{slimeData.Name}Normal";

        if (data.ChangedFace)
        {
            appearance.Face = appearance.Face.CloneInstance();
            appearance.Face._expressionToFaceLookup = new(SlimeFace.DefaultSlimeExpressionComparer);

            // Faces stuff
            foreach (var face in appearance.Face.ExpressionFaces)
                HandleFace(face, data, appearance.Face._expressionToFaceLookup);
        }

        var prevPalette = appearance.ColorPalette;
        appearance.ColorPalette = new()
        {
            Top = data.TopPaletteColor ?? prevPalette.Top,
            Middle = data.MiddlePaletteColor ?? prevPalette.Middle,
            Bottom = data.BottomPaletteColor ?? prevPalette.Bottom,
            Ammo = data.MainAmmoColor
        };

        appearance.Icon = Inventory.GetSprite($"{lower}_slime");

        BasicInitSlimeAppearance(appearance, slimeData.NormalAppearance, baseAppearance);

        applicator.GenerateSlimeBones(appearance.Structures, slimeData.Jiggle);

        slimeData.InitAppearanceDetails?.Invoke(appearance, data);

        if (data.ChangedFace)
            appearance.Face.ExpressionFaces = [.. appearance.Face._expressionToFaceLookup.Values];

        SlimeRegistry.RegisterAppearance(definition, appearance);
        return appearance;
    }

    private static void HandleFace(SlimeExpressionFace face, SlimeAppearanceData data, Dictionary<SlimeExpression, SlimeExpressionFace> expressionToFaceLookup)
    {
        if (face.Mouth && data.HasMouthColors)
        {
            face.Mouth = face.Mouth.Clone();
            face.Mouth.SetColor(MouthTop, data.TopMouthColor);
            face.Mouth.SetColor(MouthMiddle, data.MiddleMouthColor);
            face.Mouth.SetColor(MouthBottom, data.BottomMouthColor);
        }

        if (face.Eyes && data.HasEyeColors)
        {
            face.Eyes = face.Eyes.Clone();
            face.Eyes.SetColor(EyeRed, data.RedEyeColor);
            face.Eyes.SetColor(EyeGreen, data.GreenEyeColor);
            face.Eyes.SetColor(EyeBlue, data.BlueEyeColor);
        }

        expressionToFaceLookup[face.SlimeExpression] = face;
    }

    private static void BasicInitSlimeAppearance(SlimeAppearance appearance, SlimeAppearanceData slimeData, SlimeAppearance baseAppearance)
    {
        var mainStruct = appearance.Structures[0];
        appearance.Structures = new SlimeAppearanceStructure[slimeData.SlimeFeatures.Length];

        for (var i = 0; i < slimeData.SlimeFeatures.Length; i++)
        {
            var modelData = slimeData.SlimeFeatures[i];
            appearance.Structures[i] = GenerateStructure(modelData.MeshData.UseBaseStruct && baseAppearance.Structures.TryGetItem(i, out var structure) ? structure : mainStruct, modelData, modelData.MeshData, slimeData.SlimeFeatures);
        }
    }

    public static SlimeAppearanceStructure GenerateStructure(SlimeAppearanceStructure baseStruct, ModelData modelData, MeshData meshData, ModelData[] modelDatas)
    {
        if (meshData.Skip)
            return null;

        var structure = new SlimeAppearanceStructure(baseStruct);

        if (!structure.DefaultMaterials.IsNullOrEmpty())
            structure.DefaultMaterials[0] = GenerateMaterial(modelData.MatData, modelDatas, structure.DefaultMaterials[0]);

        var cacheKey = new ElementCacheKey(
            (meshData.Mesh ?? baseStruct.Element.Prefabs[0].name).ComputeHashOfString(),
            GetFloatBits(meshData.Jiggle ?? 0),
            meshData.IgnoreLodIndex,
            meshData.PrefabLength ?? (meshData.IsBody ? 4 : 2));

        if (PrefabElementCache.TryGetValue(cacheKey, out var cachedElem))
        {
            structure.Element = cachedElem;
            structure.SupportsFaces = meshData.IsBody;
            return structure;
        }

        var isNull = meshData.Mesh == null;

        if (isNull)
        {
            if (!meshData.Jiggle.HasValue)
                return structure;

            var elemInner = structure.Element = structure.Element.Instantiate();
            var oldPrefabs = elemInner.Prefabs;
            elemInner.Prefabs = new SlimeAppearanceObject[oldPrefabs.Length];

            for (var i = 0; i < oldPrefabs.Length; i++)
            {
                var prefab = oldPrefabs[i].CreatePrefab();
                var handler = prefab.gameObject.AddComponent<ModelDataHandler>();
                handler.Jiggle = meshData.Jiggle;
                elemInner.Prefabs[i] = prefab;
            }

            PrefabElementCache[cacheKey] = elemInner;
            return structure;
        }

        var elem = structure.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        elem.name = elem.Name = meshData.Name?.Replace("(Clone)", string.Empty) ?? (meshData.IsBody ? "Body" : "Structure");
        structure.SupportsFaces = meshData.IsBody;

        if (meshData.IgnoreLodIndex)
        {
            var prefab = SkinnedPrefab.CreatePrefab();
            prefab.IgnoreLODIndex = true;
            var handler = prefab.gameObject.AddComponent<ModelDataHandler>();
            handler.Jiggle = meshData.Jiggle;
            var rend = prefab.GetComponent<SkinnedMeshRenderer>();
            rend.sharedMesh = isNull ? rend.sharedMesh.Clone() : Inventory.GetMesh(meshData.Mesh);
            elem.Prefabs = [prefab];
        }
        else
        {
            var length = meshData.PrefabLength ?? (meshData.IsBody ? 4 : 2);
            elem.Prefabs = new SlimeAppearanceObject[length];

            for (var j = 0; j < length; j++)
            {
                if (!baseStruct.Element.Prefabs.TryGetItem(j, out var prefab))
                    break;

                if (j == 0 || !isNull)
                    prefab = prefab.CreatePrefab();

                if (prefab.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                {
                    rend.sharedMesh = isNull ? rend.sharedMesh.Clone() : Inventory.GetMesh(meshData.Mesh + "_LOD0");
                    var handler = prefab.gameObject.AddComponent<ModelDataHandler>();
                    handler.Jiggle = meshData.Jiggle;
                }
                else if (!isNull && prefab.TryGetComponent<MeshFilter>(out var filter))
                    filter.sharedMesh = Inventory.GetMesh(meshData.Mesh + "_LOD" + j);

                if (!isNull)
                {
                    prefab.name = meshData.Mesh + "_LOD" + j;
                    prefab.transform.localPosition = Vector3.zero;
                    prefab.transform.localEulerAngles = Vector3.zero;
                }

                prefab.LODIndex = j;
                elem.Prefabs[j] = prefab;
            }
        }

        PrefabElementCache[cacheKey] = elem;
        return structure;
    }

    private static Material GenerateMaterial(MatData matData, ModelData[] mainMatData, Material fallback)
    {
        if (matData == null)
            return fallback.Clone();

        var isModified = matData.IsModified;
        Material material;

        if (matData.CachedMaterial)
        {
            material = matData.CachedMaterial;
            isModified = false;
        }
        else if (matData.MatOrigin.HasValue)
            material = GetMat(matData.MatOrigin.Value, matData.MatSameAs, matData.UseSSMat);
        else if (matData.SameAs.HasValue && !mainMatData.IsNullOrEmpty())
            material = mainMatData[matData.SameAs.Value].MatData.CachedMaterial;
        else
            material = fallback;

        if (isModified)
        {
            material = material.Clone();
            SetMatProperties(matData, material);
        }

        matData.CachedMaterial = material;
        return material;
    }

    private static Material GetMat(IdentifiableId source, int? index, bool useSS)
    {
        if (Identifiable.IsSlime(source))
        {
            var def = source.GetSlimeDefinition();
            return (useSS && SsExists ? (def.GetAppearanceForSet(AppearanceSaveSet.SECRET_STYLE) ?? def.AppearancesDefault[0]) : def.AppearancesDefault[0]).Structures[index ?? 0].DefaultMaterials[0];
        }

        var prefab = source.GetPrefab();
        return (prefab.GetComponent<MeshRenderer>() ?? prefab.GetComponentInChildren<MeshRenderer>()).sharedMaterials[index ?? 0];
    }

    public static void SetMatProperties(MatData matData, Material material)
    {
        if (matData.ColorsOrigin.HasValue)
        {
            var temp = GetMat(matData.ColorsOrigin.Value, matData.ColorsSameAs, matData.UseSSMat);

            if (temp.HasProperty(TopColor))
                matData.ColorProps[matData.InvertColorOriginColors ? BottomColor : TopColor] = temp.GetColor(TopColor);

            if (temp.HasProperty(MiddleColor))
                matData.ColorProps[MiddleColor] = temp.GetColor(MiddleColor);

            if (temp.HasProperty(BottomColor))
                matData.ColorProps[matData.InvertColorOriginColors ? TopColor : BottomColor] = temp.GetColor(BottomColor);

            if (temp.HasProperty(Color))
                matData.ColorProps[Color] = temp.GetColor(Color);

            if (temp.HasProperty(EdgeColor))
                matData.ColorProps[EdgeColor] = temp.GetColor(EdgeColor);
        }

        if (matData.Gloss.HasValue && material.HasProperty(Gloss))
            material.SetFloat(Gloss, matData.Gloss.Value);

        if (matData.Pattern != null)
        {
            var tex = Inventory.GetTexture2D(matData.Pattern + "_pattern");

            if (material.HasProperty(StripeTexture))
                material.SetTexture(StripeTexture, tex);

            if (material.HasProperty(ColorMask))
                material.SetTexture(ColorMask, tex);
        }

        foreach (var (prop, value) in matData.ColorProps)
        {
            if (material.HasProperty(prop) && (prop != EdgeColor || !FixerExists))
                material.SetColor(prop, value);
        }
    }

    private static void GenerateGordoBones(this Transform gordo, SlimeAppearanceData slimeData, SkinnedMeshRenderer prefabRend)
    {
        if (slimeData.GordoFeatures.IsNullOrEmpty())
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

        var (zero, num) = GetCenteredValues(sharedMesh.vertices);

        Mesh body = null;

        for (var i = 0; i < slimeData.GordoFeatures.Length; i++)
        {
            var feature = slimeData.GordoFeatures[i];
            var meshName = feature.MeshData;
            var isNull = meshName.Mesh == null;
            var isFirst = i == 0;
            var sourceMesh = isNull
                ? sharedMesh
                : (isFirst || meshName.Mesh.EndsWith("_gordo", StringComparison.Ordinal)
                    ? Inventory.GetMesh(meshName.Mesh)
                    : Inventory.GetMesh(meshName.Mesh + "_LOD0"));
            var jiggle = meshName.Jiggle ?? 0.25f;
            var mesh = GetRiggedMesh(RiggedGordoMeshCache, RigType.Gordo, sourceMesh, jiggle, zero, num, poses);

            var meshRend = isFirst ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = parent;

            if (!isNull && !isFirst)
                meshRend.name = meshName.Mesh;
            else if (isFirst)
                body = mesh;

            var material = GenerateMaterial(feature.MatData, slimeData.SlimeFeatures, meshRend.sharedMaterial);

            if (isFirst)
                meshRend.sharedMaterial = material;
            else
                meshRend.sharedMaterials = [material];
        }

        Helpers.UpdateMeshCollider(gordo.gameObject, body);
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
            var isBody = structure.Element.Name.IndexOf("body", StringComparison.OrdinalIgnoreCase) >= 0;

            foreach (var appearanceObject in structure.Element.Prefabs)
            {
                applicator.name.LogIf(!appearanceObject);

                if (!appearanceObject || !appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                    continue;

                appearanceObject.AttachedBones = AttachedBones;

                var mesh = rend.sharedMesh;
                var handler = appearanceObject.GetComponent<ModelDataHandler>();
                list.Add((rend, mesh, handler?.Jiggle));
                handler?.Destroy();

                if (isBody && !sharedMesh)
                    sharedMesh = mesh;

                break;
            }
        }

        if (list.IsNullOrEmpty() || !sharedMesh)
            return;

        var rootMatrix = applicator.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
        var poses = new Matrix4x4[AttachedBones.Length];

        for (var i = 0; i < AttachedBones.Length; i++)
        {
            var bone = AttachedBones[i];
            poses[i] = applicator.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
        }

        var (zero, num) = GetCenteredValues(sharedMesh.vertices);

        foreach (var (rend, mesh, jiggleFactor) in list)
        {
            if (!mesh || !rend)
                Debug.LogWarning("One of the meshes or mesh rends provided is null");
            else
                rend.sharedMesh = GetRiggedMesh(RiggedSlimeMeshCache, RigType.Slime, mesh, jiggleFactor ?? jiggleAmount, zero, num, poses);
        }
    }

    private static (Vector3, float) GetCenteredValues(Vector3[] vertices)
    {
        var count = vertices.Length;
        var invCount = 1f / count;
        var center = Vector3.zero;

        for (var i = 0; i < count; i++)
            center += vertices[i];

        center *= invCount;

        var totalDistance = 0f;

        for (var i = 0; i < count; i++)
            totalDistance += Vector3.Distance(vertices[i], center);

        totalDistance *= invCount;

        return (center, totalDistance);
    }

    private static Mesh GetRiggedMesh(Dictionary<RigCacheKey, Mesh> cache, RigType rigType, Mesh sourceMesh, float jiggle, Vector3 zero, float num, Matrix4x4[] poses)
    {
        var key = GetRigCacheKey(rigType, sourceMesh, jiggle, zero, num, poses);

        if (cache.TryGetValue(key, out var cached))
            return cached;

        var mesh = sourceMesh.Clone();
        var vertices = mesh.vertices;
        var weights = new BoneWeight[vertices.Length];

        for (var i = 0; i < vertices.Length; i++)
            weights[i] = HandleBoneWeight(vertices[i] - zero, num, jiggle);

        mesh.boneWeights = weights;
        mesh.bindposes = poses;
        cache[key] = mesh;
        return mesh;
    }

    private static RigCacheKey GetRigCacheKey(RigType rigType, Mesh sourceMesh, float jiggle, Vector3 zero, float num, Matrix4x4[] poses)
    {
        var (matrixHash1, matrixHash2) = GetMatrixHash(poses);

        return new(
            sourceMesh.GetInstanceID(),
            rigType,
            GetFloatBits(jiggle),
            GetFloatBits(zero.x),
            GetFloatBits(zero.y),
            GetFloatBits(zero.z),
            GetFloatBits(num),
            matrixHash1,
            matrixHash2);
    }

    private static (ulong, ulong) GetMatrixHash(Matrix4x4[] poses)
    {
        const ulong prime = 1099511628211UL;

        var hash1 = 1469598103934665603UL;
        var hash2 = prime;

        foreach (var matrix in poses)
        {
            for (var i = 0; i < 16; i++)
            {
                var bits = unchecked((ulong)GetFloatBits(matrix[i]));

                hash1 ^= bits;
                hash1 *= prime;

                hash2 ^= bits + 0x9E3779B97F4A7C15UL + (hash2 << 6) + (hash2 >> 2);
            }
        }

        return (hash1, hash2);
    }

    private static unsafe int GetFloatBits(float value) => *(int*)&value;

    [UsedImplicitly]
    public static void InitRosiGordoDetails(GameObject _, SlimeDefinition definition) => GordoSnarePatch.Pinks = [IdentifiableId.PINK_GORDO, definition.IdentifiableId];

    [UsedImplicitly]
    public static void InitLanternAppearanceDetails(SlimeAppearance appearance, SlimeAppearanceData data)
    {
        var prefab = appearance.Structures[3].Element.Prefabs[0];
        prefab.transform.localScale /= 3f;
        prefab.transform.localPosition = new(0f, 0.4f, 1.03f);

        var rend = prefab.GetComponentInChildren<MeshRenderer>();
        var material = rend.sharedMaterial.Clone();
        material.SetColor(Color, "#EBDB6A".HexToColor());
        rend.sharedMaterial = material;

        HandleFace(Sleeping, data, appearance.Face._expressionToFaceLookup);

        data.ChangedFace = true;
    }

    [UsedImplicitly]
    public static void InitSandSlimeDetails(GameObject _1, SlimeDefinition _2) => SandBehaviour.ProduceFX = IdentifiableId.PUDDLE_SLIME.GetPrefab().GetComponent<SlimeEatWater>().produceFX;

    [UsedImplicitly]
    public static void InitSandPlortDetails(GameObject prefab, SlimeDefinition _) => SandBehaviour.PlortPrefab = prefab;

    [UsedImplicitly]
    public static void InitSandGordoDetails(GameObject _, SlimeDefinition definition)
    {
        definition.Diet = SlimeDiet.Combine(definition.Diet, IdentifiableId.PINK_SLIME.GetSlimeDefinition().Diet);
        IdentifiableId.SILKY_SAND_CRAFT.RegisterAsSnareable();
    }

    [UsedImplicitly]
    public static void InitMesmerSlimeDetails(GameObject _, SlimeDefinition definition) => Largopedia.Mesmers.Add(definition.IdentifiableId);

    [UsedImplicitly]
    public static void InitGoldfishPlortDetails(GameObject prefab, SlimeDefinition definition) => definition.IdentifiableId.GetPrefab().GetComponent<GoldSlimeProducePlorts>().plortPrefab = prefab;

    [UsedImplicitly]
    public static void InitGoldfishAppearanceDetails(SlimeAppearance appearance, SlimeAppearanceData _) => appearance.ColorPalette = IdentifiableId.GOLD_SLIME.GetSlimeDefinition().AppearancesDefault[0].ColorPalette;

#if DEBUG
    [TimeDiagnostic("Slime Postload")]
#endif
    [PostloadMethod]
    public static void PostLoadSlimes()
    {
        AweTowardsMesmers.InitCalculator();

        foreach (var (id, prefab) in GameContext.Instance.LookupDirector.identifiablePrefabDict)
        {
            if (Identifiable.IsSlime(id) && !Largopedia.Mesmers.Contains(id)) // Ensuring that only non-mesmer slimes are affected
                prefab.AddComponent<AweTowardsMesmers>();
        }
    }
}