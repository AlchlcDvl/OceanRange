namespace OceanRange.Patches;

[HarmonyPatch(typeof(Application), nameof(Application.Quit), [])]
public static class DumpDebugStuff
{
    public static void Prefix()
    {
#if DEBUG
        File.WriteAllText(Path.Combine(AssetManager.DumpPath, "Positions.json"), JsonConvert.SerializeObject(Main.SavePos.SavedPositions, AssetManager.JsonSettings));
#endif
        AssetManager.ReleaseHandles();
    }
}