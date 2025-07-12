// using RichPresence;
using SRML;
using static SRML.Console.Console;

namespace TheOceanRange;

public sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console { get; private set;}
    // public static Dictionary<Zone, string> ZoneLookup;

    public override void PreLoad()
    {
        Console = ConsoleInstance;

        AssetManager.FetchAssetNames();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();

        // ZoneLookup = AccessTools.Field(typeof(Director), "RICH_PRESENCE_ZONE_LOOKUP").GetValue(null) as Dictionary<Zone, string>;
        // Helpers.DoTryParseHtmlColor = AccessTools.Method(typeof(ColorUtility), "DoTryParseHtmlColor");

        SlimeManager.PreLoadAllSlimes();
        FoodManager.PreLoadFoods();

        HarmonyInstance.PatchAll();
    }

    public override void Load()
    {
        SlimeManager.LoadAllSlimes();
        FoodManager.LoadFoods();

        SystemContext.IsModded = true;
    }
}