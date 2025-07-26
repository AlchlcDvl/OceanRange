using SRML;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;
using OceanRange.Patches;
using static SRML.Console.Console;

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;

#if DEBUG
    public static readonly SavePositionCommand SavePos = new();
#endif

    public override void PreLoad()
    {
#if DEBUG
        // This method is already running, so the time diagnostic patch doesn't work for it
        var watch = new System.Diagnostics.Stopwatch();
        watch.Start();
#endif
        Console = ConsoleInstance;

        HarmonyInstance.PatchAll(AssetManager.Core);

        AssetManager.InitialiseAssets();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        SaveRegistry.RegisterWorldDataLoadDelegate(ReadData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteData);

        SystemContext.IsModded = true;

#if DEBUG
        RegisterCommand(SavePos);
        RegisterCommand(new EchoCommand());
        RegisterCommand(new TeleportCommand());

        watch.Stop();
        ConsoleInstance.Log($"Mod Preloaded in {watch.ElapsedMilliseconds}ms!");
        watch.Restart();
#endif
    }

#if DEBUG
    [TimeDiagnostic("Mod Load")]
#endif
    public override void Load()
    {
        FoodManager.LoadFoods();
        SlimeManager.LoadAllSlimes();
    }

    private static void ReadData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        var mailCount = piece.GetValue<int>("mailCount");

        while (mailCount-- > 0)
        {
            var mailId = piece.GetValue<string>("mailId");
            var mail = MailManager.Mail.Find(x => x.Id == mailId);
            mail.Sent = piece.GetValue<bool>("mailSent");
            mail.Read = piece.GetValue<bool>("mailRead");
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }

    private static void WriteData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        piece.SetValue("mailCount", MailManager.Mail.Count);

        foreach (var mail in MailManager.Mail)
        {
            piece.SetValue("mailId", mail.Id);
            piece.SetValue("mailSent", mail.Sent);
            piece.SetValue("mailRead", mail.Read);
        }

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }
}