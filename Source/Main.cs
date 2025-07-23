using SRML;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;
using OceanRange.Patches;
using static SRML.Console.Console;

#if DEBUG
using System.Diagnostics;
#endif

namespace OceanRange;

internal sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;

#if DEBUG
    public static readonly SavePositionCommand SavePos = new();

    private static readonly Stopwatch Watch = new();
#endif

    public override void PreLoad()
#if DEBUG
        => TimeDiagnostic(InternalPreLoad, "Preload");

    private void InternalPreLoad()
#endif
    {
        Console = ConsoleInstance;

        AssetManager.InitialiseAssets();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        SaveRegistry.RegisterWorldDataLoadDelegate(ReadData);
        SaveRegistry.RegisterWorldDataSaveDelegate(WriteData);

        SystemContext.IsModded = true;

        var type = typeof(IdentifiableId);

        foreach (var id in AccessTools.GetDeclaredFields(typeof(Ids)).Where(x => x.FieldType == type).Select(x => (IdentifiableId)x.GetValue(null)))
        {
            id.Uncategorize();
            IdentifiableRegistry.CategorizeId(id);
        }

#if DEBUG
        RegisterCommand(SavePos);
        RegisterCommand(new EchoCommand());
        RegisterCommand(new TeleportCommand());
#endif

        HarmonyInstance.PatchAll();
    }

    public override void Load()
#if DEBUG
        => TimeDiagnostic(InternalLoad, "Load");

    private static void InternalLoad()
#endif
    {
        FoodManager.LoadFoods();
        SlimeManager.LoadAllSlimes();
    }

    public override void PostLoad()
#if DEBUG
        => TimeDiagnostic(InternalPostLoad, "Postload");

    private static void InternalPostLoad()
#endif
        => AssetManager.UnloadBundle();

#if DEBUG
    private static void TimeDiagnostic(Action action, string stage)
    {
        Watch.Start();
        action();
        Watch.Stop();
        Console.Log($"{stage}ed in {Watch.ElapsedMilliseconds}ms!");
        Watch.Restart();
    }
#endif

    public static void ReadData(CompoundDataPiece piece)
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

        FixAndProperlyShowMailPatch.IsLoaded = true;
    }
}