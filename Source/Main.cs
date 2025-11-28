using SRML;
using static SRML.Console.Console;

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;
    public static bool ClsExists;
    public static Transform PrefabParent;

#if DEBUG
    private static readonly SavePositionCommand SavePos = new(); // Keeping the instance of the command because it stores saved positions
#endif

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

        SystemContext.IsModded = true; // I don't know what this does fully, but it's better have this one than not, although it'd be better if SRML did this

        ClsExists = SRModLoader.IsModPresent("custom.loading"); // Checks if Custom Loading Screens is present in the mods folder

        Inventory.InitialiseAssets(); // Initialises everything relating to the assets by creating the handles and setting up the json settings

        BootStrapper.RegisterManagers(Inventory.Core); // Handles the registration of the various manager classes
        BootStrapper.ExecuteLoadState(LoadState.Preload); // Executes the preload methods of all of the manager classes

        Helpers.CategoriseIds();

        var gameObject = new GameObject("OceanPrefabs").DontDestroy();
        gameObject.SetActive(false);
        PrefabParent = gameObject.transform;

#if DEBUG
        // Debug stuff for the special commands
        RegisterCommand(SavePos);
        RegisterCommand(new EchoCommand());
        RegisterCommand(new TeleportCommand());
        RegisterCommand(new TesterUnlockProgressCommand());

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

        // Inventory.Bundle.Unload(false);
        Inventory.ReleaseHandles("cookbook", "mailbox", "slimepedia", "modinfo", "largopedia", "atlas", "contacts"/*, "ocean_range", "blueprints"*/); // Release handles

        if (!ClsExists) // Conditionally release the splash art handles if they're not used
            Inventory.ReleaseHandles("loading_1", "loading_2", "loading_3", "loading_4", "loading_5");

        GC.Collect(); // Free up temp memory
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Unload")]
    public override void Unload()
    {
        File.WriteAllText(Path.Combine(Inventory.DumpPath, "Positions.json"), JsonConvert.SerializeObject(SavePos.SavedPositions, Inventory.JsonSettings));
#else
    public override void Unload()
    {
#endif
        foreach (var mesh in Helpers.ClonedMeshes)
            mesh.Destroy();

        Helpers.ClonedMeshes.Clear();
        Inventory.ReleaseHandles();
    }

    public static void AddIconBypass(Sprite icon) => CLS.AddToLoading.AddIcon(icon);

    private static void AddSplashesBypass(IEnumerable<Sprite> splashes) => CLS.AddToLoading.AddSplashes(splashes);
}