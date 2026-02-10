using SRML.SR.Utils;
using DLCPackage;

namespace OceanRange.Managers;

// All hail the json gods, for they look upon me favourably
[Manager(ManagerType.Largopedia)]
public static class Largopedia
{
    /*
        Largo Naming Hierarchy:

        PLORT:
        Pink
        Saber
        Quantum
        Honey
        Phosphor
        Mosaic
        Tangle
        Boom
        Rad
        Rock
        Tabby
        Hunter
        Crystal
        Dervish
        Mesmer
        Hermit
        Coco

        PEARL:
        Rosi
        Mine
        Lantern
    */

    public static readonly HashSet<IdentifiableId> Mesmers = new(Identifiable.idComparer);
    public static readonly Dictionary<IdentifiableId, List<(IdentifiableId, IdentifiableId)>> LargoMaps = new(Identifiable.idComparer);

    private static readonly Func<List<(IdentifiableId, IdentifiableId)>> Create = () => [];

    private static Material QuantumMat;
    private static float DefaultRadius;
    private static bool SSGenerated;

    private static LargoData[] Largos;
    private static readonly int GhostToggle = ShaderUtils.GetOrSet("_GhostToggle");

#if DEBUG
    [TimeDiagnostic("Largos Preload")]
#endif
    [PreloadMethod, UsedImplicitly]
    public static void PreloadLargoData() => Largos = Inventory.GetJsonArray<LargoData>("largopedia");

#if DEBUG
    [TimeDiagnostic("Largos Load")]
#endif
    [LoadMethod, UsedImplicitly]
    public static void LoadAllLargos()
    {
        QuantumMat = IdentifiableId.QUANTUM_SLIME.GetSlimeDefinition().AppearancesDefault[0].QubitAppearance.Structures[0].DefaultMaterials[0];
        DefaultRadius = IdentifiableId.PINK_SLIME.GetPrefab().GetComponent<SphereCollider>().radius;

        Array.ForEach(Largos, CreateLargo);

        // TODO: Implement and test the invisible largos bug fix
        GameContext.Instance.DLCDirector.onPackageInstalled += CreateSecretStyles;
    }

#if DEBUG
    [TimeDiagnostic("Largos SS Load")]
#endif
    private static void CreateSecretStyles(Id id)
    {
        if (id != Id.SECRET_STYLE || SSGenerated)
            return;

        SSGenerated = true;
        Array.ForEach(Largos, CreateSSLargo);
    }

#if DEBUG
    [TimeDiagnostic]
#endif
    private static void CreateLargo(LargoData largoData)
    {
        var slime1 = largoData.Slime1Id.GetSlimeDefinition();
        var slime2 = largoData.Slime2Id.GetSlimeDefinition();

        var definition = ScriptableObject.CreateInstance<SlimeDefinition>();
        definition.BaseSlimes = [slime1, slime2];
        definition.CanLargofy = false;
        definition.IdentifiableId = largoData.MainId;
        definition.IsLargo = true;
        definition.Name = slime1.Name + " " + slime2.Name;
        definition.PrefabScale = 2f;
        definition.Sounds = largoData.DefProps.HasFlagFast(DefinitionProps.UseSlime2ForSound) ? slime2.Sounds : slime1.Sounds;
        definition.LoadLargoDiet();
        definition.FavoriteToys = [];
        definition.name = largoData.Slime1 + largoData.Slime2;

        var useSlime2Body = largoData.DefProps.HasFlagFast(DefinitionProps.UseSlime2ForBody);

        var slime1Prefab = (useSlime2Body ? largoData.Slime2Id : largoData.Slime1Id).GetPrefab();
        var slime2Prefab = (useSlime2Body ? largoData.Slime1Id : largoData.Slime2Id).GetPrefab();

        var prefab = slime1Prefab.CreatePrefab();
        prefab.name = "slime" + largoData.Slime1 + largoData.Slime2;
        prefab.transform.localScale = Vector3.one * definition.PrefabScale;
        prefab.GetComponent<SlimeEat>().slimeDefinition = definition;
        prefab.GetComponent<Identifiable>().id = definition.IdentifiableId;
        prefab.GetComponent<Vacuumable>().size = Vacuumable.Size.LARGE;
        prefab.GetComponent<Rigidbody>().mass += slime2Prefab.GetComponent<Rigidbody>().mass;
        prefab.GetComponent<AweTowardsLargos>().Destroy();

        if (prefab.TryGetComponent<PinkSlimeFoodTypeTracker>(out var tracker))
            tracker.Destroy();

        if (!slime1.FavoriteToys.IsNullOrEmpty())
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime1.FavoriteToys, Identifiable.idComparer)];

        if (!slime2.FavoriteToys.IsNullOrEmpty())
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime2.FavoriteToys, Identifiable.idComparer)];

        var appearance1 = slime1.AppearancesDefault[0];
        var appearance2 = slime2.AppearancesDefault[0];

        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();
        applicator.SlimeDefinition = definition;

        var appearance = GenerateAppearance(appearance1, appearance2, largoData.Appearances[0], applicator, SlimeAppearance.AppearanceSaveSet.CLASSIC, largoData, definition, false);
        definition.AppearancesDefault = [appearance];
        SlimeRegistry.RegisterAppearance(definition, appearance);

        LargoMaps.GetOrAdd(largoData.Slime1Id, Create).Add((largoData.MainId, largoData.Slime2Id));
        LargoMaps.GetOrAdd(largoData.Slime2Id, Create).Add((largoData.MainId, largoData.Slime1Id));

        if (prefab.TryGetComponent<PlayWithToys>(out var toys))
            toys.slimeDefinition = definition;

        if (prefab.TryGetComponent<ReactToToyNearby>(out var react))
            react.slimeDefinition = definition;

        foreach (var component in slime2Prefab.GetComponents<Component>())
        {
            var type = component.GetType();

            if (!prefab.HasComponent(type))
                prefab.AddComponent(type).CopyValuesFrom(component);
        }

        if (definition.Sounds)
            prefab.GetComponent<SlimeAudio>().slimeSounds = definition.Sounds;

        if (prefab.TryGetComponent<SphereCollider>(out var collider) && slime2Prefab.TryGetComponent<SphereCollider>(out var collider2) && collider.radius == DefaultRadius && collider2.radius != DefaultRadius)
        {
            collider.radius = collider2.radius;
            collider.center = collider2.center;
        }

        foreach (Transform item in slime2Prefab.transform)
        {
            if (!prefab.transform.Find(item.name))
                slime2Prefab.GetChildCopy(item.name).transform.SetParent(prefab.transform);
        }

        if (largoData.Slime1Data?.ComponentsToRemove?.IsNullOrEmpty() == false)
        {
            foreach (var component in largoData.Slime1Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (largoData.Slime2Data?.ComponentsToRemove?.IsNullOrEmpty() == false)
        {
            foreach (var component in largoData.Slime2Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        largoData.InitLargoDetails?.Invoke(prefab, definition);
        largoData.InitSlime1Details?.Invoke(prefab, definition);
        largoData.InitSlime2Details?.Invoke(prefab, definition);

        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterSlimeDefinition(definition);
    }

    private static void CreateSSLargo(LargoData largoData)
    {
        var slime1 = largoData.Slime1Id.GetSlimeDefinition();
        var slime2 = largoData.Slime2Id.GetSlimeDefinition();
        var definition = largoData.MainId.GetSlimeDefinition();

        var prefab = largoData.MainId.GetPrefab();
        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();

        var ss1 = slime1.GetAppearanceForSet(SlimeAppearance.AppearanceSaveSet.SECRET_STYLE);
        var ss2 = slime2.GetAppearanceForSet(SlimeAppearance.AppearanceSaveSet.SECRET_STYLE);

        var ssAppearance1Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS1) && !x.AppProps.HasFlagFast(AppearanceType.SS2));
        var ssAppearance2Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS2) && !x.AppProps.HasFlagFast(AppearanceType.SS1));
        var ssAppearance3Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS2) && x.AppProps.HasFlagFast(AppearanceType.SS1));

        var appearance1 = slime1.AppearancesDefault[0];
        var appearance2 = slime2.AppearancesDefault[0];

        if (ss1 != null && ss2 != null && ssAppearance3Data != null)
            GenerateAppearance(ss1, ss2, ssAppearance3Data, applicator, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, largoData, definition);
        else if (ss1 != null && ssAppearance1Data != null)
            GenerateAppearance(ss1, appearance2, ssAppearance1Data, applicator, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, largoData, definition);
        else if (ss2 != null && ssAppearance2Data != null)
            GenerateAppearance(appearance1, ss2, ssAppearance2Data, applicator, SlimeAppearance.AppearanceSaveSet.SECRET_STYLE, largoData, definition);
    }

    private static SlimeAppearance GenerateAppearance(SlimeAppearance appearance1, SlimeAppearance appearance2, LargoAppearanceData appearanceData, SlimeAppearanceApplicator applicator, SlimeAppearance.AppearanceSaveSet set, LargoData largoData,
        SlimeDefinition definition, bool register = true)
    {
        var useSlime2Body = appearanceData.LargoProps.HasFlagFast(LargoAppearanceProps.UseSlime2ForBody);

        var appearance = ScriptableObject.CreateInstance<SlimeAppearance>();
        appearance.AnimatorOverride = appearance1.AnimatorOverride ?? appearance2.AnimatorOverride;
        appearance.DependentAppearances = [appearance1, appearance2];
        appearance.Face = appearance1.Face.CloneInstance();
        appearance.Face._expressionToFaceLookup = new(SlimeFace.DefaultSlimeExpressionComparer);
        appearance.name = largoData.Slime1 + largoData.Slime2 + (appearanceData.AppProps.HasFlagFast(AppearanceType.SS1) ? "Exotic" : "Normal") + (appearanceData.AppProps.HasFlagFast(AppearanceType.SS2) ? "Exotic" : "Normal");

        var props = appearanceData.LargoProps;
        var eyes = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForEyes) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;
        var mouth = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForMouth) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;

        foreach (var expression in appearance1.Face._expressionToFaceLookup.Keys.Union(appearance2.Face._expressionToFaceLookup.Keys, SlimeFace.DefaultSlimeExpressionComparer))
        {
            appearance.Face._expressionToFaceLookup[expression] = new()
            {
                SlimeExpression = expression,
                Eyes = eyes.TryGetValue(expression, out var eyesInner) ? eyesInner.Eyes : null,
                Mouth = mouth.TryGetValue(expression, out var mouthInner) ? mouthInner.Mouth : null
            };
        }

        appearance.Face.ExpressionFaces = [.. appearance.Face._expressionToFaceLookup.Values];
        appearance.NameXlateKey = appearance1.NameXlateKey;
        appearance.SaveSet = set;

        var slime1Body = appearance1.Structures.FirstOrDefault(x => x.Element.Name.IndexOf("body", StringComparison.OrdinalIgnoreCase) >= 0);
        var slime2Body = appearance2.Structures.FirstOrDefault(x => x.Element.Name.IndexOf("body", StringComparison.OrdinalIgnoreCase) >= 0);
        var baseBody = useSlime2Body ? slime2Body : slime1Body;

        var modelMap = new Dictionary<int, ModelData>();
        SlimeAppearanceStructure body;

        if (appearanceData.BodyStruct != null)
        {
            body = Slimepedia.GenerateStructure(baseBody, appearanceData.BodyStruct, appearanceData.BodyStruct.MeshData, null);
            modelMap[0] = appearanceData.BodyStruct;
        }
        else
        {
            body = new(baseBody)
            {
                DefaultMaterials =
                {
                    [0] = (props.HasFlagFast(LargoAppearanceProps.UseSlime2ForBodyMaterial) ? slime2Body : slime1Body).DefaultMaterials[0].Clone()
                }
            };
        }

        var list = new List<SlimeAppearanceStructure>(appearance1.Structures.Length + appearance2.Structures.Length - 1) { body };

        GenerateStructures(appearance1.Structures, appearanceData.Slime1Structs, props, LargoAppearanceProps.ExcludeSlime1Structures, list, slime1Body, modelMap);
        GenerateStructures(appearance2.Structures, appearanceData.Slime2Structs, props, LargoAppearanceProps.ExcludeSlime2Structures, list, slime2Body, modelMap);

        appearance.Structures = [.. list];
        applicator.GenerateSlimeBones(appearance.Structures, appearanceData.Jiggle.Value);

        appearance.ColorPalette = SlimeAppearance.Palette.FromMaterial(appearance.Structures[0].DefaultMaterials[0]);
        appearance.CrystalAppearance = appearance1.CrystalAppearance ?? appearance2.CrystalAppearance;
        appearance.DeathAppearance = appearance1.DeathAppearance ?? appearance2.DeathAppearance;
        appearance.ExplosionAppearance = appearance1.ExplosionAppearance ?? appearance2.ExplosionAppearance;
        appearance.GlintAppearance = appearance1.GlintAppearance ?? appearance2.GlintAppearance;
        appearance.ShockedAppearance = appearance1.ShockedAppearance ?? appearance2.ShockedAppearance;
        appearance.TornadoAppearance = appearance1.TornadoAppearance ?? appearance2.TornadoAppearance;
        appearance.VineAppearance = appearance1.VineAppearance ?? appearance2.VineAppearance;

        if (appearance1.QubitAppearance != null || appearance2.QubitAppearance != null)
        {
            var qubitAppearance = appearance.QubitAppearance = appearance.Instantiate();
            var material = QuantumMat.Clone();
            material.SetFloat(GhostToggle, 1f);

            for (var i = 0; i < appearance.Structures.Length; i++)
            {
                var structure = qubitAppearance.Structures[i] = new(appearance.Structures[i]);
                var mat = material.Clone();

                if (modelMap.TryGetValue(i, out var modelData))
                    Slimepedia.SetMatProperties(modelData.MatData, mat);
                else
                {
                    var og = structure.DefaultMaterials[0];
                    mat.SetColor(Slimepedia.TopColor, og.GetColor(Slimepedia.TopColor));
                    mat.SetColor(Slimepedia.MiddleColor, og.GetColor(Slimepedia.MiddleColor));
                    mat.SetColor(Slimepedia.BottomColor, og.GetColor(Slimepedia.BottomColor));
                }

                structure.DefaultMaterials[0] = mat;
            }
        }

        largoData.InitLargoAppearanceDetails?.Invoke(appearance, appearanceData.AppProps);
        largoData.InitSlime1AppearanceDetails?.Invoke(appearance, appearanceData.AppProps);
        largoData.InitSlime2AppearanceDetails?.Invoke(appearance, appearanceData.AppProps);

        if (register) // SSRML patches this method, and the AppearancesDefault array needs to be initialised before registering
            SlimeRegistry.RegisterAppearance(definition, appearance);

        return appearance;
    }

    private static void GenerateStructures(SlimeAppearanceStructure[] baseStructs, ModelData[] modelDatas, LargoAppearanceProps props, LargoAppearanceProps exclude, List<SlimeAppearanceStructure> list, SlimeAppearanceStructure body,
        Dictionary<int, ModelData> modelMap)
    {
        var avoid = baseStructs.IndexOfItem(body);

        if (!modelDatas.IsNullOrEmpty())
        {
            var j = 0;

            for (var i = 0; i < baseStructs.Length; i++)
            {
                if (i == avoid)
                    continue;

                var modelData = modelDatas[j];
                var meshData = modelData.MeshData;
                j++;

                if (meshData.Skip)
                    continue;

                var structure = Slimepedia.GenerateStructure(baseStructs[i], modelData, meshData, modelDatas);

                if (structure == null)
                    continue;

                modelMap[list.Count] = modelData;
                list.Add(structure);
            }
        }
        else if (!props.HasFlagFast(exclude))
        {
            for (var i = 0; i < baseStructs.Length; i++)
            {
                if (i == avoid)
                    continue;

                var newStruct = new SlimeAppearanceStructure(baseStructs[i]);
                var formerPrefabs = newStruct.Element.Prefabs;
                var formerName = newStruct.Element.Name;
                newStruct.Element = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
                newStruct.Element.Prefabs = new SlimeAppearanceObject[formerPrefabs.Length];
                newStruct.Element.name = newStruct.Element.Name = formerName;

                for (var j = 0; j < formerPrefabs.Length; j++)
                {
                    var prefab = formerPrefabs[j].CreatePrefab();

                    if (prefab.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                        rend.sharedMesh = rend.sharedMesh.Clone();

                    newStruct.Element.Prefabs[j] = prefab;
                }

                list.Add(newStruct);
            }
        }
    }

    [UsedImplicitly]
    public static void InitMineDetails(GameObject prefab, SlimeDefinition _) => prefab.GetComponent<MineBehaviour>().IsLargo = true;

    [UsedImplicitly]
    public static void InitMesmerDetails(GameObject _, SlimeDefinition definition) => Mesmers.Add(definition.IdentifiableId);

    [UsedImplicitly]
    public static void InitHunterDetails(GameObject prefab, SlimeDefinition _)
    {
        prefab.RemoveComponent<SlimeStealth>();
        prefab.AddComponent<StealthFixer>();
    }

    [UsedImplicitly]
    public static void InitTangleHermitAppearanceDetails(SlimeAppearance appearance, AppearanceType _) => appearance.Structures[1].Element.Prefabs[0].transform.localPosition -= new Vector3(0f, 0.2f, 0f);

    [UsedImplicitly]
    public static void InitPhosphorHermitDetails(GameObject prefab, SlimeDefinition _) => prefab.AddComponent<PhosphorHermitAppearanceFixer>();
}