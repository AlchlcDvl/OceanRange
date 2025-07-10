using System.Reflection;
// using RichPresence;
using SRML;

namespace TheOceanRange;

public sealed class Main : ModEntryPoint
{
    public static Main Instance { get; private set; }
    public static Transform Prefab;
    // public static Dictionary<Zone, string> ZoneLookup;

    public Main() => Instance = this;

    public override void PreLoad()
    {
        AssetManager.FetchAssetNames();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();

        Prefab = AccessTools.Field(AccessTools.GetTypesFromAssembly(Assembly.GetCallingAssembly()).First(x => x.Namespace == "SRML" && x.Name == "Main"), "prefabParent").GetValue(null) as Transform;
        // ZoneLookup = AccessTools.Field(typeof(Director), "RICH_PRESENCE_ZONE_LOOKUP").GetValue(null) as Dictionary<Zone, string>;

        SlimeManager.PreLoadAllSlimes();
        FoodManager.PreLoadFoods();

        HarmonyInstance.PatchAll();
    }

    public override void Load()
    {
        SlimeManager.LoadAllSlimes();
        FoodManager.LoadFoods();
    }
}