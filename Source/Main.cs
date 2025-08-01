using SRML;
using SRML.SR.SaveSystem;
using OceanRange.Patches;
using static SRML.Console.Console;
using SRML.SR.SaveSystem.Registry;
using SRML.SR.SaveSystem.Data;

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;
    public static bool ClsExists;

#if DEBUG
    public static readonly SavePositionCommand SavePos = new(); // Keeping the instance of the command because it stores saved positions
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

        SystemContext.IsModded = true; // I don't what this does fully, but it's better have this one than not, although it'd be better if SRML did this

        ClsExists = SRModLoader.IsModPresent("custom.loading"); // Checks if Custom Loading Screens is present in the mods folder

        AssetManager.InitialiseAssets(); // Initialises everything relating to the assets by creating the handles and setting up the json settings

        // Preloads the various forms of data the mod uses
        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        // Helpers to avoid the eventual lag with custom mail when there's a ton added
        SaveRegistry.RegisterWorldDataLoadDelegate(ReadData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteData);

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
        FoodManager.LoadFoods();
        SlimeManager.LoadAllSlimes();

        if (ClsExists) // If Custom Loading Screens is loaded, then add the splash art for the background
            AddSplashesBypass(AssetManager.GetSprites("loading", "loading2", "loading3"));
    }

    /// <inheritdoc/>
#if DEBUG
    [TimeDiagnostic("Mod Postload")]
#endif
    public override void PostLoad()
    {
        AssetManager.ReleaseHandles("chimkenpedia", "plantpedia", "mailbox", "slimepedia", "modinfo"); // Release handles

        if (!ClsExists) // Conditionally release the splash art handles if they're not used
            AssetManager.ReleaseHandles("loading", "loading2", "loading3");


        GC.Collect(); // Free up temp memory
    }

    // Configuring the modded mail data
    private static readonly WorldDataLoadDelegate ReadData = ReadDataMethod;

    private static void ReadDataMethod(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        var mailCount = piece.GetValue<int>("mailCount");

        while (mailCount-- > 0)
        {
            var mailId = piece.GetValue<string>("mailId");
            var mail = Array.Find(MailManager.Mail, x => x.Id == mailId);
            mail.Sent = piece.GetValue<bool>("mailSent");
            mail.Read = piece.GetValue<bool>("mailRead");
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }

    private static readonly WorldDataSaveDelegate WriteData = WriteDataMethod;

    private static void WriteDataMethod(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        piece.SetValue("mailCount", MailManager.Mail.Length);

        foreach (var mail in MailManager.Mail)
        {
            piece.SetValue("mailId", mail.Id);
            piece.SetValue("mailSent", mail.Sent);
            piece.SetValue("mailRead", mail.Read);
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }

    public static void AddIconBypass(Sprite icon)
    {
        try
        {
            CLS.AddToLoading.AddIcon(icon);
        } catch {}
    }

    private static void AddSplashesBypass(IEnumerable<Sprite> splashes)
    {
        try
        {
            CLS.AddToLoading.AddSplashes(splashes);
        } catch {}
    }
}