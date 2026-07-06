namespace OceanRange.Managers;

[Manager(ManagerType.Refinery)]
public static class Refinery
{
//     private static ScienceItemData[] ScienceItems;

// #if DEBUG
//     [TimeDiagnostic("Refinery Preload")]
// #endif
//     [PreloadMethod]
//     public static void PreloadRefineryData() => ScienceItems = Inventory.GetJsonArray<ScienceItemData>("refinery");

// #if DEBUG
//     [TimeDiagnostic("Refinery Load")]
// #endif
//     [LoadMethod]
//     public static void LoadAllRefineryItems()
//     {
//         Array.ForEach(ScienceItems, CreateScienceItem);
//     }

    private static void CreateScienceItem(ScienceItemData itemData)
    {
        var basePrefab = itemData.BaseItemId.GetPrefab();
        var prefab = basePrefab.CreatePrefabCopy();

        prefab.name = "resource" + itemData.Name;
        prefab.GetComponent<Identifiable>().id = itemData.MainId;

        ApplyMaterialOverrides(prefab, itemData);

        var icon = Inventory.GetSprite(itemData.Name!.ToLowerInvariant());
        var vacColor = itemData.MainAmmoColor ?? Color.white;

        LookupRegistry.RegisterIdentifiablePrefab(prefab);
        AmmoRegistry.RegisterSiloAmmo(x => x is StorageType.NON_SLIMES or StorageType.CRAFTING, itemData.MainId);
        AmmoRegistry.RegisterAmmoPrefab(PlayerState.AmmoMode.DEFAULT, prefab);
        AmmoRegistry.RegisterRefineryResource(itemData.MainId);
        LookupRegistry.RegisterVacEntry(itemData.MainId, vacColor, icon);

        prefab.GetComponent<Vacuumable>().size = 0;

        if (!itemData.ExtractorDrops.IsNullOrEmpty())
            Array.ForEach(itemData.ExtractorDrops, drop => AddExtractorDrop(itemData.MainId, drop));
    }

    private static void ApplyMaterialOverrides(GameObject prefab, ScienceItemData itemData)
    {
        if (itemData.MaterialOverrides.IsNullOrEmpty())
            return;

        foreach (var overrideData in itemData.MaterialOverrides)
        {
            var targetObj = prefab;

            foreach (var childIndex in overrideData.ChildPath)
                targetObj = targetObj.transform.GetChild(childIndex).gameObject;

            var renderer = targetObj.GetComponent<MeshRenderer>();
            var mat = UObject.Instantiate(renderer.sharedMaterial);
            mat.name = itemData.Name + "_" + targetObj.name + "_mat";

            if (!overrideData.ColorProperties.IsNullOrEmpty())
            {
                foreach (var (key, color) in overrideData.ColorProperties)
                    mat.SetColor(key, color);
            }

            if (!overrideData.FloatProperties.IsNullOrEmpty())
            {
                foreach (var (key, value) in overrideData.FloatProperties)
                    mat.SetFloat(key, value);
            }

            renderer.sharedMaterial = mat;
        }
    }

    private static void AddExtractorDrop(IdentifiableId itemId, ExtractorDropData dropData)
    {
        var gadgetDef = dropData.ExtractorId.GetGadgetDefinition();
        var extractor = gadgetDef.prefab.GetComponentInChildren<Extractor>();

        if (extractor == null)
        {
            Main.Console.LogError($"Failed to find Extractor component on Gadget {dropData.ExtractorId}");
            return;
        }

        var entry = new Extractor.ProduceEntry
        {
            id = itemId,
            weight = dropData.Chance,
            zone = dropData.Zone,
            restrictZone = dropData.RestrictZone,
            spawnFX = extractor.produces[dropData.SpawnFxIndex].spawnFX
        };

        extractor.produces = [.. extractor.produces, entry];
    }
}