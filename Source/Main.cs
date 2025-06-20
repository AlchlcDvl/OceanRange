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
        Slimes.Slimes.PreLoadAllSlimes();
    }

    public override void Load()
    {
        var gameObject = new GameObject("PrefabParent");
        gameObject.SetActive(value: false);
        UObject.DontDestroyOnLoad(gameObject);
        Prefab = gameObject.transform;

        Slimes.Slimes.LoadAllSlimes();
    }
}