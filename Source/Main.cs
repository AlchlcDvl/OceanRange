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
        HarmonyInstance.PatchAll();

        Prefab = AccessTools.Field(AccessTools.GetTypesFromAssembly(Assembly.GetCallingAssembly()).First(x => x.Namespace == "SRML" && x.Name == "Main"), "prefabParent").GetValue(null) as Transform;

        Slimes.Slimes.PreLoadAllSlimes();
        Foods.PreLoadFoods();
    }

    public override void Load()
    {
        Slimes.Slimes.LoadAllSlimes();
        Foods.LoadFoods();
    }
}