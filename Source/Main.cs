// using RichPresence;
using SRML;
using static SRML.Console.Console;

namespace TheOceanRange;

public sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;
    // public static Dictionary<Zone, string> ZoneLookup;

    public override void PreLoad()
    {
        Console = ConsoleInstance;
        Console.Log("Loading Ocean Range!");

        AssetManager.FetchAssetNames();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        // ZoneLookup = AccessTools.Field(typeof(Director), "RICH_PRESENCE_ZONE_LOOKUP").GetValue(null) as Dictionary<Zone, string>;
        // Helpers.DoTryParseHtmlColor = AccessTools.Method(typeof(ColorUtility), "DoTryParseHtmlColor");

        HarmonyInstance.PatchAll();
    }

    public override void Load()
    {
        SlimeManager.LoadAllSlimes();
        FoodManager.LoadFoods();

        SystemContext.IsModded = true;
    }

    public override void PostLoad()
    {
        AssetManager.UnloadBundle();
        Console.Log("Loaded Ocean Range!");
    }
}