#if DEBUG
namespace OceanRange.Modules;

[HarmonyPatch(typeof(MainMenuUI), nameof(MainMenuUI.Quit))]
public static class DumpDebugStuff
{
    public static void Prefix()
    {
        var path = Path.Combine(Path.GetDirectoryName(Application.dataPath), "SRML", "Positions.json");
        File.WriteAllText(path, JsonConvert.SerializeObject(Main.SavePos.SavedPositions, AssetManager.JsonSettings));
    }
}
#endif