using SRML;
using static SRML.Console.Console;

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;
    public static bool ClsExists;

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
#endif
        Console = ConsoleInstance; // Passing the console so that every other class can log things as well

        HarmonyInstance.PatchAll(AssetManager.Core); // Patch methods

        SystemContext.IsModded = true; // I don't know what this does fully, but it's better have this one than not, although it'd be better if SRML did this

        ClsExists = SRModLoader.IsModPresent("custom.loading"); // Checks if Custom Loading Screens is present in the mods folder

        AssetManager.InitialiseAssets(); // Initialises everything relating to the assets by creating the handles and setting up the json settings

        // Preloads the various forms of data the mod uses
        SaveManager.PreLoadSaveData();
        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

#if DEBUG
        // Debug stuff for the special commands
        RegisterCommand(SavePos);
        RegisterCommand(new EchoCommand());
        RegisterCommand(new TeleportCommand());

        watch.Stop();
        ConsoleInstance.Log($"Mod Preloaded in {watch.ElapsedMilliseconds}ms!");
        watch.Restart();
#endif
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Load")]
#endif
    public override void Load()
    {
        // Loads slimes and food
        FoodManager.LoadAllFoods();
        SlimeManager.LoadAllSlimes();

        if (ClsExists) // If Custom Loading Screens is loaded, then add the splash art for the background
            AddSplashesBypass(AssetManager.GetSprites("loading_1", "loading_2", "loading_3"));
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Postload")]
#endif
    public override void PostLoad()
    {
        SlimeManager.PostLoadSlimes();

        AssetManager.ReleaseHandles("chimkenpedia", "plantpedia", "mailbox", "slimepedia", "modinfo"); // Release handles

        if (!ClsExists) // Conditionally release the splash art handles if they're not used
            AssetManager.ReleaseHandles("loading_1", "loading_2", "loading_3");

        GC.Collect(); // Free up temp memory
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Unload")]
    public override void Unload()
    {
        File.WriteAllText(Path.Combine(AssetManager.DumpPath, "Positions.json"), JsonConvert.SerializeObject(SavePos.SavedPositions, AssetManager.JsonSettings));
        AssetManager.ReleaseHandles();
    }
#else
    public override void Unload() => AssetManager.ReleaseHandles();
#endif

    public static void AddIconBypass(Sprite icon)
    {
        try
        {
            CLS.AddToLoading.AddIcon(icon);
        }
        catch { }
    }

    private static void AddSplashesBypass(IEnumerable<Sprite> splashes)
    {
        try
        {
            CLS.AddToLoading.AddSplashes(splashes);
        }
        catch { }
    }
}