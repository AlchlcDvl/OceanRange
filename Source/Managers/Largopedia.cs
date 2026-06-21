using SRML.SR.Utils;
using DLCPackage;

namespace OceanRange.Managers;

// All hail the JSON gods, for they look upon me favourably
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

    private static Material QuantumMat;
    private static float DefaultRadius;
    private static bool SSGenerated;

    private static LargoData[] Largos;
    private static readonly int GhostToggle = ShaderUtils.GetOrSet("_GhostToggle");
    // private static readonly int MiddleColor = ShaderUtils.GetOrSet("_MiddleColor");

    private static readonly Dictionary<int, SlimeAppearanceElement> LargoElementCache = [];

    private static readonly Func<SlimeAppearanceStructure, bool> FindBody = x => x.Element.Name.IndexOf("body", StringComparison.OrdinalIgnoreCase) >= 0;

#if DEBUG
    [TimeDiagnostic("Largos Preload")]
#endif
    [PreloadMethod]
    public static void PreloadLargoData() => Largos = Inventory.GetJsonArray<LargoData>("largopedia");

#if DEBUG
    [TimeDiagnostic("Largos Load")]
#endif
    [LoadMethod]
    public static void LoadAllLargos()
    {
        QuantumMat = IdentifiableId.QUANTUM_SLIME.GetSlimeDefinition().AppearancesDefault[0].QubitAppearance.Structures[0].DefaultMaterials[0];
        DefaultRadius = IdentifiableId.PINK_SLIME.GetPrefab().GetComponent<SphereCollider>().radius;

        Array.ForEach(Largos, CreateLargo);

        GameContext.Instance.DLCDirector.onPackageInstalled += CreateSecretStyles;
    }

#if DEBUG
    [TimeDiagnostic("Largos SS Load")]
#endif
    private static void CreateSecretStyles(Id id)
    {
        // TODO: Implement largo secret styles
        if (id != Id.SECRET_STYLE)
            return;

        if (!SSGenerated)
        {
            Array.ForEach(Largos, CreateSSLargo);
            SSGenerated = true;
        }

        Array.ForEach(Largos, RegisterAppearances);
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

        var appearance = GenerateAppearance(appearance1, appearance2, largoData.Appearances[0], applicator, largoData, AppearanceSaveSet.CLASSIC);
        definition.AppearancesDefault = [appearance];
        SlimeRegistry.RegisterAppearance(definition, appearance);

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

        if (prefab.TryGetComponent<SphereCollider>(out var collider)
            && slime2Prefab.TryGetComponent<SphereCollider>(out var collider2)
            && Mathf.Approximately(collider.radius, DefaultRadius)
            && !Mathf.Approximately(collider2.radius, DefaultRadius))
        {
            collider.radius = collider2.radius;
            collider.center = collider2.center;
        }

        foreach (Transform item in slime2Prefab.transform)
        {
            if (!prefab.transform.Find(item.name))
                slime2Prefab.GetChildCopy(item.name).transform.SetParent(prefab.transform);
        }

        if (largoData.Slime1Data?.ComponentsToRemove.IsNullOrEmpty() == false)
        {
            foreach (var component in largoData.Slime1Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (largoData.Slime2Data?.ComponentsToRemove.IsNullOrEmpty() == false)
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

        var ss1 = slime1.GetAppearanceForSet(AppearanceSaveSet.SECRET_STYLE);
        var ss2 = slime2.GetAppearanceForSet(AppearanceSaveSet.SECRET_STYLE);

        var defAppearanceData = largoData.Appearances[0];
        var ssAppearance1Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS1) && !x.AppProps.HasFlagFast(AppearanceType.SS2)) ?? defAppearanceData;
        var ssAppearance2Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS2) && !x.AppProps.HasFlagFast(AppearanceType.SS1)) ?? defAppearanceData;
        var ssAppearance3Data = largoData.Appearances.FirstOrDefault(x => x.AppProps.HasFlagFast(AppearanceType.SS2) && x.AppProps.HasFlagFast(AppearanceType.SS1)) ?? defAppearanceData;

        var appearance1 = slime1.AppearancesDefault[0];
        var appearance2 = slime2.AppearancesDefault[0];

        if (ss1 && ss2)
            largoData.SSBothAppearance = CreateContent(GenerateAppearance(ss1, ss2, ssAppearance3Data, applicator, largoData), definition);

        if (ss1)
            largoData.SS1Appearance = CreateContent(GenerateAppearance(ss1, appearance2, ssAppearance1Data, applicator, largoData), definition);

        if (ss2)
            largoData.SS2Appearance = CreateContent(GenerateAppearance(appearance1, ss2, ssAppearance2Data, applicator, largoData), definition);
    }

    private static DLCContentMetadata_SlimeAppearance CreateContent(SlimeAppearance appearance, SlimeDefinition definition)
    {
        var content = ScriptableObject.CreateInstance<DLCContentMetadata_SlimeAppearance>();
        content.definition = definition;
        content.appearance = appearance;
        return content;
    }

    private static void RegisterAppearances(LargoData largoData)
    {
        RegisterAppearance(largoData.SS1Appearance);
        RegisterAppearance(largoData.SS2Appearance);
        RegisterAppearance(largoData.SSBothAppearance);
    }

    private static void RegisterAppearance(DLCContentMetadata_SlimeAppearance content)
    {
        if (!content)
            return;

        content.Register();
        SceneContext.Instance.SlimeAppearanceDirector.UpdateChosenSlimeAppearance(content.definition, content.appearance);
    }

    private static SlimeAppearance GenerateAppearance(SlimeAppearance appearance1, SlimeAppearance appearance2, LargoAppearanceData appearanceData, SlimeAppearanceApplicator applicator, LargoData largoData,
        AppearanceSaveSet set = AppearanceSaveSet.SECRET_STYLE)
    {
        var appearance = ScriptableObject.CreateInstance<SlimeAppearance>();
        appearance.AnimatorOverride = appearance1.AnimatorOverride ?? appearance2.AnimatorOverride;
        appearance.DependentAppearances = [appearance1, appearance2];
        appearance.Face = ScriptableObject.CreateInstance<SlimeFace>();
        appearance.Face._expressionToFaceLookup = new(SlimeFace.DefaultSlimeExpressionComparer);
        appearance.name = largoData.Slime1 + largoData.Slime2 +
                            (appearanceData.AppProps.HasFlagFast(AppearanceType.SS1) ? "Exotic" : "Normal") +
                            (appearanceData.AppProps.HasFlagFast(AppearanceType.SS2) ? "Exotic" : "Normal");

        var props = appearanceData.LargoProps;

        var slime1Faces = appearance1.Face._expressionToFaceLookup;
        var slime2Faces = appearance2.Face._expressionToFaceLookup;

        var useEyesFully = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForEyes);
        var useEyeShape = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForEyeShape);
        var useEyeColor = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForEyeColor);

        var useMouthsFully = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForMouth);
        var useMouthShape = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForMouthShape);
        var useMouthColor = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForMouthColor);

        foreach (var key in appearance1.Face._expressionToFaceLookup.Keys.Union(appearance2.Face._expressionToFaceLookup.Keys, SlimeFace.DefaultSlimeExpressionComparer))
        {
            var finalEye = GetMixedMaterial(key, slime1Faces, slime2Faces, useEyesFully, useEyeShape, useEyeColor, true);
            var finalMouth = GetMixedMaterial(key, slime1Faces, slime2Faces, useMouthsFully, useMouthShape, useMouthColor, false);

            appearance.Face._expressionToFaceLookup[key] = new()
            {
                SlimeExpression = key,
                Eyes = finalEye,
                Mouth = finalMouth
            };
        }

        appearance.Face.ExpressionFaces = [.. appearance.Face._expressionToFaceLookup.Values];
        appearance.NameXlateKey = appearance1.NameXlateKey;
        appearance.SaveSet = set;

        var slime1Body = appearance1.Structures.FirstOrDefault(FindBody);
        var slime2Body = appearance2.Structures.FirstOrDefault(FindBody);
        var baseBody = props.HasFlagFast(LargoAppearanceProps.UseSlime2ForBodyShape) ? slime2Body : slime1Body;

        var modelMap = new Dictionary<int, ModelData>();
        SlimeAppearanceStructure body;

        if (appearanceData.BodyStruct != null)
        {
            body = Slimepedia.GenerateStructure(baseBody, appearanceData.BodyStruct, appearanceData.BodyStruct.MeshData, null!)!;
            modelMap[0] = appearanceData.BodyStruct;
            // Main.Console.Log($"[BodyStruct was null!] Body Color for {appearance1.name}{appearance2.name} is {(Color32)body.DefaultMaterials[0].GetColor(MiddleColor)}");
        }
        else
        {
            body = new(baseBody)
            {
                DefaultMaterials =
                {
                    [0] = (props.HasFlagFast(LargoAppearanceProps.UseSlime2ForBodyMaterial) ? slime2Body : slime1Body)!.DefaultMaterials[0].Clone()
                }
            };
            // Main.Console.Log($"Body Color for {appearance1.name}{appearance2.name} is {(Color32)body.DefaultMaterials[0].GetColor(MiddleColor)}");
        }

        var list = new List<SlimeAppearanceStructure>(appearance1.Structures.Length + appearance2.Structures.Length - 1) { body };

        GenerateStructures(appearance1.Structures, appearanceData.Slime1Structs, props, LargoAppearanceProps.ExcludeSlime1Structures, list, slime1Body, modelMap);
        GenerateStructures(appearance2.Structures, appearanceData.Slime2Structs, props, LargoAppearanceProps.ExcludeSlime2Structures, list, slime2Body, modelMap);

        appearance.Structures = [.. list];
        applicator.GenerateSlimeBones(appearance.Structures, appearanceData.Jiggle!.Value);

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

        return appearance;
    }

    private static Material GetMixedMaterial(SlimeExpression key, Dictionary<SlimeExpression, SlimeExpressionFace> slime1Faces, Dictionary<SlimeExpression, SlimeExpressionFace> slime2Faces, bool useSlime2Entirely,
        bool useSlime2Shape, bool useSlime2Color, bool isEye)
    {
        if (useSlime2Entirely)
            return GetMat(slime2Faces);

        if (!useSlime2Shape && !useSlime2Color)
            return GetMat(slime1Faces);

        var shapeBase = GetMat(useSlime2Shape ? slime2Faces : slime1Faces)
                        ?? GetMat(useSlime2Shape ? slime1Faces : slime2Faces);

        var colorBase = GetMat(useSlime2Color ? slime2Faces : slime1Faces)
                        ?? GetMat(useSlime2Color ? slime1Faces : slime2Faces);

        if (!shapeBase || !colorBase)
            return null!;

        if (shapeBase == colorBase)
            return shapeBase;

        var result = shapeBase.Clone();

        if (isEye)
        {
            result.SetColor(Slimepedia.EyeRed, colorBase.GetColor(Slimepedia.EyeRed));
            result.SetColor(Slimepedia.EyeBlue, colorBase.GetColor(Slimepedia.EyeBlue));
            result.SetColor(Slimepedia.EyeGreen, colorBase.GetColor(Slimepedia.EyeGreen));
        }
        else
        {
            result.SetColor(Slimepedia.MouthTop, colorBase.GetColor(Slimepedia.MouthTop));
            result.SetColor(Slimepedia.MouthMiddle, colorBase.GetColor(Slimepedia.MouthMiddle));
            result.SetColor(Slimepedia.MouthBottom, colorBase.GetColor(Slimepedia.MouthBottom));
        }

        return result;

        Material GetMat(Dictionary<SlimeExpression, SlimeExpressionFace> dict) =>
            dict.TryGetValue(key, out var face) ? (isEye ? face.Eyes : face.Mouth) : null!;
    }

    private static void GenerateStructures(SlimeAppearanceStructure[] baseStructs, ModelData[]? modelDatas, LargoAppearanceProps props, LargoAppearanceProps exclude, List<SlimeAppearanceStructure> list, SlimeAppearanceStructure? body,
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

                var modelData = modelDatas![j];
                var meshData = modelData.MeshData;
                j++;

                if (meshData.Skip)
                    continue;

                var structure = Slimepedia.GenerateStructure(baseStructs.TryGetItem(i, out var baseStruct) ? baseStruct! : baseStructs[0], modelData, meshData, modelDatas);

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
                if (i != avoid)
                    list.Add(GetOrCreateLargoElement(baseStructs[i]));
            }
        }
    }

    private static SlimeAppearanceStructure GetOrCreateLargoElement(SlimeAppearanceStructure baseStruct)
    {
        var cacheKey = baseStruct.Element.GetInstanceID();

        if (LargoElementCache.TryGetValue(cacheKey, out var cachedElem))
            return new SlimeAppearanceStructure(baseStruct) { Element = cachedElem };

        var newStruct = new SlimeAppearanceStructure(baseStruct);
        var formerPrefabs = newStruct.Element.Prefabs;
        var formerName = newStruct.Element.Name;
        var elem = ScriptableObject.CreateInstance<SlimeAppearanceElement>();
        elem.Prefabs = new SlimeAppearanceObject[formerPrefabs.Length];
        elem.name = elem.Name = formerName;

        for (var j = 0; j < formerPrefabs.Length; j++)
        {
            var prefab = formerPrefabs[j].CreatePrefab();

            if (prefab.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                rend.sharedMesh = rend.sharedMesh.Clone();

            elem.Prefabs[j] = prefab;
        }

        LargoElementCache[cacheKey] = elem;
        newStruct.Element = elem;
        return newStruct;
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
    public static void InitTangleHermitAppearanceDetails(SlimeAppearance appearance, AppearanceType _) => appearance.Structures[1].Element.Prefabs[0].transform.localPosition = new Vector3(0f, -0.15f, 0f);

    [UsedImplicitly]
    public static void InitPhosphorHermitDetails(GameObject prefab, SlimeDefinition _) => prefab.AddComponent<PhosphorHermitAppearanceFixer>();

    [UsedImplicitly]
    public static void InitMimicDetails(GameObject prefab, SlimeDefinition _)
    {
        if (prefab.TryGetComponent<MimicBehaviour>(out var component))
            component.Destroy();
    }

#if DEBUG
    [TimeDiagnostic("Largos Postload")]
#endif
    [PostloadMethod]
    public static void PostloadLargos() => LargoElementCache.Clear();
}