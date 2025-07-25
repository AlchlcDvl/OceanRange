#if DEBUG
namespace OceanRange.Patches;

[HarmonyPatch(typeof(MainMenuUI), nameof(MainMenuUI.Quit))]
public static class DumpDebugStuff
{
    public static void Prefix() => File.WriteAllText(Path.Combine(AssetManager.DumpPath, "Positions.json"), JsonConvert.SerializeObject(Main.SavePos.SavedPositions, AssetManager.JsonSettings));
}
#endif