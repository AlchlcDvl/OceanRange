using System.Diagnostics;
using SRML;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;
using TheOceanRange.Patches;
using static SRML.Console.Console;

namespace TheOceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;

    private Stopwatch Watch;

    public Main() => Watch = new();

    public override void PreLoad() => TimeDiagnostic(InternalPreLoad, "Preload");

    public override void Load() => TimeDiagnostic(InternalLoad, "Load");

    public override void PostLoad() => TimeDiagnostic(InternalPostLoad, "Postload");

    private void InternalPreLoad()
    {
        Console = ConsoleInstance;

        AssetManager.InitialiseAssets();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        SaveRegistry.RegisterWorldDataLoadDelegate(ReadData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteData);

        SystemContext.IsModded = true;

        RegisterCommand(new EchoCommand());

        HarmonyInstance.PatchAll();
    }

    private static void InternalLoad()
    {
        FoodManager.LoadFoods();
        SlimeManager.LoadAllSlimes();
    }

    private static void InternalPostLoad() => AssetManager.UnloadBundle();

    private void TimeDiagnostic(Action action, string stage)
    {
        Watch.Start();
        action();
        Watch.Stop();
        Console.Log($"{stage}ed in {Watch.ElapsedMilliseconds}ms!");
        Watch.Restart();
    }

    public static void ReadData(CompoundDataPiece piece)
    {
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

    public static void WriteData(CompoundDataPiece piece)
    {
        FixAndProperlyShowMailPatch.IsLoaded = false;

        piece.SetValue("mailCount", MailManager.Mail.Count);

        foreach (var mail in MailManager.Mail)
        {
            piece.SetValue("mailId", mail.Id);
            piece.SetValue("mailSent", mail.Sent);
            piece.SetValue("mailRead", mail.Read);
        }
    }
}