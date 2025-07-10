// using RichPresence;
using SRML;

namespace TheOceanRange;

public sealed class Main : ModEntryPoint
{
    public static Main Instance { get; private set; }
    // public static Dictionary<Zone, string> ZoneLookup;

    public Main() => Instance = this;

    public override void PreLoad()
    {
        AssetManager.FetchAssetNames();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();

        // ZoneLookup = AccessTools.Field(typeof(Director), "RICH_PRESENCE_ZONE_LOOKUP").GetValue(null) as Dictionary<Zone, string>;

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