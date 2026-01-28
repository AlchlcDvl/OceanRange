using SRML;

using static SRML.Console.Console;

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static bool ClsExists;
    public static Transform PrefabParent;
    public static ConsoleInstance Console;

    /// <inheritdoc/>
    public override void PreLoad()
    {
#if DEBUG
        // This method is already running, so the time diagnostic patch doesn't work for it
        var watch = new System.Diagnostics.Stopwatch();
        watch.Start();

        var harmonyWatch = new System.Diagnostics.Stopwatch();
        harmonyWatch.Start();
#endif

        Console = ConsoleInstance; // Passing the console so that every other class can log things as well

        HarmonyInstance.PatchAll(Inventory.Core); // Patch methods

#if DEBUG
        harmonyWatch.Stop();
        ConsoleInstance.Log($"Game Patched in {harmonyWatch.ElapsedMilliseconds}ms!");
#endif

        SystemContext.IsModded = true; // I don't know what this does fully, but it's better have this one than not, although it'd be better if the mod loader did this

        ClsExists = SRModLoader.IsModPresent("custom.loading"); // Checks if Custom Loading Screens is present in the mods folder

        Inventory.InitialiseAssets(); // Initialises everything relating to the assets by creating the handles and setting up the json settings

        var gameObject = new GameObject("OceanPrefabs").DontDestroy();
        gameObject.SetActive(false);
        PrefabParent = gameObject.transform;

        BootStrapper.RegisterAttributes(Inventory.Core); // Handles the registration of the various manager classes
        BootStrapper.ExecuteLoadState(LoadState.Preload); // Executes the preload methods of all of the manager classes

        Helpers.CategoriseIds();

#if DEBUG
        BootStrapper.RegisterCommands();

        watch.Stop();
        ConsoleInstance.Log($"Mod Preloaded in {watch.ElapsedMilliseconds}ms!");
#endif
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Load")]
#endif
    public override void Load()
    {
        // Loads the various forms of data the mod uses
        BootStrapper.ExecuteLoadState(LoadState.Load); // Executes the load methods of all of the manager classes

        if (ClsExists) // If Custom Loading Screens is loaded, then add the splash art for the background
            AddSplashesBypass(Inventory.GetSprites("loading_1", "loading_2", "loading_3", "loading_4", "loading_5"));
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Postload")]
#endif
    public override void PostLoad()
    {
        BootStrapper.ExecuteLoadState(LoadState.Postload); // Executes the postload methods of all of the manager classes

        // Unload assets that are no longer needed
        // Inventory.Bundle.Unload(false);
        Inventory.ReleaseHandles("cookbook", "mailbox", "slimepedia", "modinfo", "largopedia", "contacts"/*, "atlas", "ocean_range", "blueprints"*/);
        Inventory.ReleaseUnusedHandles();
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Unload")]
#endif
    public override void Unload()
    {
#if DEBUG
        File.WriteAllText(Path.Combine(Inventory.DumpPath, "Positions.json"), JsonConvert.SerializeObject(Commands.SavedPositions, Inventory.JsonSettings));
#endif
        BootStrapper.ExecuteLoadState(LoadState.Unload); // Executes the unload methods of all of the manager classes

        // Cleanup resources generated via code without actual assets backing them
        CleanupResources(Helpers.ClonedMeshes);
        CleanupResources(Helpers.ClonedMats);
        // CleanupResources(Helpers.CreatedRamps);

        Inventory.ReleaseHandles();
    }

    private static void CleanupResources<T>(ICollection<T> collection) where T : UObject
    {
        foreach (var obj in collection)
        {
            if (obj)
                obj.Destroy();
        }

        collection.Clear();
    }

    public static void AddIconBypass(Sprite icon) => CLS.AddToLoading.AddIcon(icon);

    private static void AddSplashesBypass(IEnumerable<Sprite> splashes) => CLS.AddToLoading.AddSplashes(splashes);
}