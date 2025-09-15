using SRML.SR.Utils;

namespace OceanRange.Managers;

// All hail the json gods, for they look upon me favourably
// TODO: Finish largo setup
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

    private static Material QuantumMat;
    private static float DefaultRadius;

    private static LargoData[] Largos;
    private static readonly int GhostToggle = ShaderUtils.GetOrSet("_GhostToggle");

#if DEBUG
    [TimeDiagnostic("Largos Preload")]
#endif
    public static void PreloadLargoData() => Largos = Inventory.GetJsonArray<LargoData>("largopedia");

#if DEBUG
    [TimeDiagnostic("Largos Load")]
#endif
    public static void LoadAllLargos()
    {
        QuantumMat = IdentifiableId.QUANTUM_SLIME.GetSlimeDefinition().AppearancesDefault[0].QubitAppearance.Structures[0].DefaultMaterials[0];
        DefaultRadius = IdentifiableId.PINK_SLIME.GetPrefab().GetComponent<SphereCollider>().radius;

        Array.ForEach(Largos, CreateLargo);
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
        definition.Sounds = largoData.Props.HasFlag(LargoProps.UseSlime2ForSound) ? slime2.Sounds : slime1.Sounds;
        definition.LoadLargoDiet();
        definition.FavoriteToys = [];

        var props = largoData.Props;
        var useSlime2Body = props.HasFlag(LargoProps.UseSlime2ForBody);

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

        if (slime1.FavoriteToys != null)
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime1.FavoriteToys, Identifiable.idComparer)];

        if (slime2.FavoriteToys != null)
            definition.FavoriteToys = [.. definition.FavoriteToys.Union(slime2.FavoriteToys, Identifiable.idComparer)];

        var appearance1 = slime1.AppearancesDefault[0];
        var appearance2 = slime2.AppearancesDefault[0];

        var appearance = ScriptableObject.CreateInstance<SlimeAppearance>();
        appearance.AnimatorOverride = appearance1.AnimatorOverride ?? appearance2.AnimatorOverride;
        appearance.DependentAppearances = [appearance1, appearance2];
        appearance.Face = appearance1.Face.DeepCopy();
        appearance.Face._expressionToFaceLookup.Clear();

        var eyes = props.HasFlag(LargoProps.UseSlime2ForEyes) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;
        var mouth = props.HasFlag(LargoProps.UseSlime2ForMouth) ? appearance2.Face._expressionToFaceLookup : appearance1.Face._expressionToFaceLookup;

        foreach (var expression in appearance1.Face._expressionToFaceLookup.Keys.Union(appearance2.Face._expressionToFaceLookup.Keys, SlimeFace.DefaultSlimeExpressionComparer))
        {
            appearance.Face._expressionToFaceLookup.Add(expression, new()
            {
                SlimeExpression = expression,
                Eyes = eyes.TryGetValue(expression, out var eyesInner) ? eyesInner.Eyes : null,
                Mouth = mouth.TryGetValue(expression, out var mouthInner) ? mouthInner.Mouth : null
            });
        }

        appearance.Face.ExpressionFaces = [.. appearance.Face._expressionToFaceLookup.Values];
        appearance.NameXlateKey = appearance1.NameXlateKey;
        appearance.SaveSet = SlimeAppearance.AppearanceSaveSet.CLASSIC;

        var applicator = prefab.GetComponent<SlimeAppearanceApplicator>();
        applicator.SlimeDefinition = definition;

        var slime1Body = appearance1.Structures.FirstOrDefault(x => x.Element.Name.Contains("Body"));
        var slime2Body = appearance2.Structures.FirstOrDefault(x => x.Element.Name.Contains("Body"));
        var baseBody = useSlime2Body ? slime2Body : slime1Body;

        var modelMap = new Dictionary<int, ModelData>();

        if (props.HasFlag(LargoProps.CustomStructures))
        {
            Slimepedia.BasicInitSlimeAppearance(appearance, applicator, baseBody, largoData.LargoStructData, largoData.Jiggle.Value);

            for (var i = 0; i < largoData.LargoStructData.Length; i++)
                modelMap[i] = largoData.LargoStructData[i];
        }
        else
        {
            SlimeAppearanceStructure body;

            if (props.HasFlag(LargoProps.CustomBody))
            {
                body = Slimepedia.GenerateStructure(baseBody, largoData.BodyStructData, null, true);
                modelMap[0] = largoData.BodyStructData;
            }
            else
            {
                body = new SlimeAppearanceStructure(baseBody);
                body.DefaultMaterials[0] = (props.HasFlag(LargoProps.UseSlime2ForBodyMaterial) ? slime2Body : slime1Body).DefaultMaterials[0].Clone();
            }

            var list = new List<SlimeAppearanceStructure>(appearance1.Structures.Length + appearance2.Structures.Length - 1) { body };

            GenerateStructures(appearance1.Structures, largoData.Slime1StructData, props.HasFlag(LargoProps.CustomSlime1Structures), list, slime1Body, modelMap);
            GenerateStructures(appearance2.Structures, largoData.Slime2StructData, props.HasFlag(LargoProps.CustomSlime2Structures), list, slime2Body, modelMap);

            appearance.Structures = [.. list];
            applicator.GenerateSlimeBones(appearance.Structures, largoData.Jiggle.Value);
        }

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
            var qubitAppearance = appearance.QubitAppearance = appearance.DeepCopy();
            var material = QuantumMat.Clone();
            material.SetFloat(GhostToggle, 1f);

            for (var i = 0; i < appearance.Structures.Length; i++)
            {
                var structure = qubitAppearance.Structures[i] = new(appearance.Structures[i]);
                var mat = material.Clone();

                if (modelMap.TryGetValue(i, out var modelData))
                    Slimepedia.SetMatProperties(modelData, mat);
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

        definition.AppearancesDefault = [appearance];

        if (!LargoMaps.TryGetValue(largoData.Slime1Id, out var slime1Values))
            LargoMaps[largoData.Slime1Id] = slime1Values = [];

        if (!LargoMaps.TryGetValue(largoData.Slime2Id, out var slime2Values))
            LargoMaps[largoData.Slime2Id] = slime2Values = [];

        slime1Values.Add((largoData.MainId, largoData.Slime2Id));
        slime2Values.Add((largoData.MainId, largoData.Slime1Id));

        if (prefab.TryGetComponent<PlayWithToys>(out var toys))
            toys.slimeDefinition = definition;

        if (prefab.TryGetComponent<ReactToToyNearby>(out var react))
            react.slimeDefinition = definition;

        foreach (var component in slime2Prefab.GetComponents<Component>())
        {
            var type = component.GetType();

            if (!prefab.HasComponent(type))
                prefab.AddComponent(type).GetCopyOf(component);
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

        if (largoData.Slime1Data?.ComponentsToRemove != null)
        {
            foreach (var component in largoData.Slime1Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (largoData.Slime2Data?.ComponentsToRemove != null)
        {
            foreach (var component in largoData.Slime2Data.ComponentsToRemove)
                prefab.RemoveComponent(component);
        }

        if (prefab.TryGetComponent<MineBehaviour>(out var mine))
            mine.IsLargo = true;

        largoData.InitLargoDetails?.Invoke(null, [prefab, definition, appearance]);
        largoData.InitSlime1Details?.Invoke(null, [prefab, definition, appearance]);
        largoData.InitSlime2Details?.Invoke(null, [prefab, definition, appearance]);

        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        SlimeRegistry.RegisterAppearance(definition, appearance);
        SlimeRegistry.RegisterSlimeDefinition(definition);
        TranslationPatcher.AddActorTranslation("l." + largoData.MainId.ToString().ToLowerInvariant(), SlimeRegistry.GenerateLargoName(largoData.MainId));
    }

    private static void GenerateStructures(SlimeAppearanceStructure[] baseStructs, ModelData[] modelDatas, bool customMats, List<SlimeAppearanceStructure> list, SlimeAppearanceStructure avoid, Dictionary<int, ModelData> modelMap)
    {
        var num = baseStructs.IndexOfItem(avoid);

        if (customMats)
        {
            var j = 0;

            for (var i = 0; i < baseStructs.Length; i++)
            {
                if (i == num)
                    continue;

                var modelData = modelDatas[j];

                if (modelData.Skip)
                    continue;

                var structure = Slimepedia.GenerateStructure(baseStructs[i], modelData, modelDatas, false);

                if (structure == null)
                    continue;

                j++;
                modelMap[list.Count] = modelData;
                list.Add(structure);
            }
        }
        else
        {
            for (var i = 0; i < baseStructs.Length; i++)
            {
                if (i != num)
                    list.Add(new(baseStructs[i]));
            }
        }
    }

    [UsedImplicitly]
    public static void InitMesmerSlimeDetails(GameObject _1, SlimeDefinition definition, SlimeAppearance _2) => Mesmers.Add(definition.IdentifiableId);
}