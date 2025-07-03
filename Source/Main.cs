using System.Reflection;
using SRML;

namespace TheOceanRange;

public class Main : ModEntryPoint
{
    public static Main Instance { get; private set; }
    public static Transform Prefab;

    public override void PreLoad()
    {
        Instance = this;

        AssetManager.FetchAssetNames();

        Prefab = AccessTools.Field(AccessTools.GetTypesFromAssembly(Assembly.GetCallingAssembly()).First(x => x.Namespace == "SRML" && x.Name == "Main"), "prefabParent").GetValue(null) as Transform;

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